package com.ctm.web.core.competition.services;

import com.ctm.web.core.competition.dao.CompetitionDao;
import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.dao.StampingDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.services.EmailDetailsService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceException;
import com.ctm.web.core.model.CompetitionEntry;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class CompetitionService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CompetitionService.class);
    private final SessionDataServiceBean sessionDataServiceBean;

    @Deprecated
    public CompetitionService() {
        this.sessionDataServiceBean = new SessionDataServiceBean();
    }

	@Autowired
    public CompetitionService(SessionDataServiceBean sessionDataServiceBean) {
        this.sessionDataServiceBean = sessionDataServiceBean;
    }

    /**
	 * isActive - returns whether the nominated competition exists and is active
	 *
	 * @param request
	 * @param competitionId
	 * @return
	 */
	public static Boolean isActive(HttpServletRequest request, Integer competitionId) {
		Boolean compActive = false;
		Date serverDate = ApplicationService.getApplicationDate(request);

		try {
			Brand brand = ApplicationService.getBrandFromRequest(request);
			compActive = CompetitionDao.isActive(brand.getId(), competitionId, serverDate);
		} catch (DaoException e) {
			LOGGER.error("Failed to determine if competition is active competitionId={},{}", kv("competitionId", competitionId), kv("serverDate", serverDate), e);
		}

		return compActive;
	}

	public static boolean addCompetitionEntry(Integer competitionId, Integer emailId, List<Pair<String, String>> items) {
		try {
			CompetitionDao.addCompetitionEntry(competitionId, emailId, items);
			return true;
		} catch (DaoException e) {
			return false;
		}
	}
	public void addToCompetitionEntry(MessageContext context, Long transactionId, CompetitionEntry entry) throws ConfigSettingException, DaoException, EmailDetailsException {
		addToCompetitionEntry(context.getHttpServletRequest(),  transactionId,  entry);
	}

    public void addToCompetitionEntry(HttpServletRequest request, Long transactionId, CompetitionEntry entry) throws ServiceException {
        PageSettings pageSettings;
        try {
            pageSettings = SettingsService.getPageSettingsForPage(request);
        } catch (DaoException | ConfigSettingException e) {
            throw new ServiceException("Failed to get page settings", e);
        }
        String brandCode = pageSettings.getBrandCode();
		Integer brandId = pageSettings.getBrandId();
		String verticalCode = pageSettings.getVerticalCode();

		// STEP 1: Validate the input received before proceeding
		List<SchemaValidationError> errors = FormValidation.validate(entry, verticalCode);

		if (entry.getCompetitionId() == 2 && StringUtils.isBlank(entry.getLastName())) {
			SchemaValidationError e = new SchemaValidationError();
			e.setMessage("Your last name is required.");
			errors.add(e);
		}

		if (entry.isPhoneNumberRequired() && StringUtils.isBlank(entry.getPhoneNumber())) {
			SchemaValidationError e = new SchemaValidationError();
			e.setMessage("Your phone number is required.");
			errors.add(e);
		}

		if (errors.isEmpty()) {

			// STEP 2: Write email data to aggregator.email_master and get the EmailID
			StampingDao stampingDao = new StampingDao(pageSettings.getBrandId(), pageSettings.getBrandCode(), verticalCode);
			EmailMasterDao emailMasterDao = new EmailMasterDao(brandId, brandCode, verticalCode);
			EmailDetailsService emailDetailsService = new EmailDetailsService(emailMasterDao, new TransactionDao(), null, brandCode,
					null, stampingDao, verticalCode);

			String operator = "ONLINE";
			AuthenticatedData authenticatedSessionData = sessionDataServiceBean.getAuthenticatedSessionData(request);
			if (authenticatedSessionData != null) {
				operator = authenticatedSessionData.getUid();
			}


			EmailMaster emailDetailsRequest = new EmailMaster();
			emailDetailsRequest.setEmailAddress(entry.getEmail());
			emailDetailsRequest.setFirstName(entry.getFirstName());
			emailDetailsRequest.setLastName(entry.getLastName());
			emailDetailsRequest.setOptedInMarketing(true, verticalCode);
			emailDetailsRequest.setSource(entry.getSource());
            EmailMaster emailMaster = null;
            try {
                emailMaster = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetailsRequest, operator, request.getRemoteAddr());
            } catch (EmailDetailsException e) {
                throw new ServiceException("Failed to handleReadAndWriteEmailDetails", e);
            }

            if (emailMaster == null) {
				SchemaValidationError e = new SchemaValidationError();
				e.setMessage("Failed to retrieve the emailId to make the entry.");
				errors.add(e);
			}

			if (errors.isEmpty()) {

				// STEP 3: Write competition details to ctm.competition_data

				List<Pair<String, String>> items = new ArrayList<>();
				items.add(Pair.of("firstname", entry.getFirstName()));
				String lastname = entry.getLastName();
				items.add(Pair.of("lastname", StringUtils.isNotEmpty(lastname) ? lastname : ""));
				items.add(Pair.of("phone", entry.getPhoneNumber()));

				boolean added = CompetitionService.addCompetitionEntry(entry.getCompetitionId(), emailMaster.getEmailId(), items);

				if (!added) {
					SchemaValidationError e = new SchemaValidationError();
					e.setMessage("Failed to create entry in database.");
					errors.add(e);
				}
			}
		}

		if (!errors.isEmpty()) {

			String sessionId = StringUtils.left(request.getSession().getId(), 64);
			String page = request.getServletPath();

			String errorMessage = errors.stream()
					.map(s -> "error:" + s.getMessage())
					.collect(Collectors.joining(","));

			LOGGER.error("ENTRY ERRORS: {}", errorMessage);

			String data = "competition_id:" + entry.getCompetitionId() +
					" email:" + entry.getEmail() +
					" firstname:" + entry.getFirstName() +
					" lastname:" + entry.getLastName() +
					" phone:" + entry.getPhoneNumber();


			// add errors using FatalErrorService
			FatalErrorService.logFatalError(brandId, page, sessionId, false, "Competition error", errorMessage,
					transactionId.toString(), data, brandCode);
		}
	}


}
