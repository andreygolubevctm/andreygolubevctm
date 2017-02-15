package com.ctm.web.health.services;

import com.ctm.web.core.confirmation.model.Confirmation;
import com.ctm.web.core.confirmation.services.ConfirmationService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceException;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.apply.model.request.payment.details.Frequency;
import com.ctm.web.health.apply.model.response.HealthApplicationResponse;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.providerInfo.ProviderInfo;
import com.ctm.web.health.router.ConfirmationData;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.utils.common.utils.LocalDateUtils.AUS_FORMAT;
import static com.ctm.web.reward.services.RewardService.XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID;

@Component
public class HealthConfirmationService {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthConfirmationService.class);

    private final ProviderContentService providerContentService;
    private final ConfirmationService confirmationService;

    @Autowired
    public HealthConfirmationService(ProviderContentService providerContentService, ConfirmationService confirmationService) {
        this.providerContentService = providerContentService;
        this.confirmationService = confirmationService;
    }

    public void createAndSaveConfirmation(HttpServletRequest request, HealthRequest data, HealthApplicationResponse response,
                                          String confirmationId, Data dataBucket) throws ServiceException {
        try {
            LocalDate startDate = LocalDate.parse(data.getQuote().getPayment().getDetails().getStart(), AUS_FORMAT);
            String providerName = data.getQuote().getApplication().getProviderName();
            final String productSelected = StringUtils.removeEnd(
                    StringUtils.removeStart(dataBucket.getString("confirmation/health"), "<![CDATA["),
                    "]]>");
            String frequency = Frequency.findByDescription(data.getQuote().getPayment().getDetails().getFrequency()).getCode();
            String next = getContent(request, providerName, "NXT");
            String about = getContent(request, providerName, "ABT");
            String firstName = data.getQuote().getApplication().getPrimary().getFirstname();
            String surname = data.getQuote().getApplication().getPrimary().getSurname();
            String paymentType =  data.getQuote().getPayment().getDetails().getType();
            ProviderInfo providerInfo = providerContentService.getProviderInfo(request, providerName);
            final ConfirmationData confirmationData = ConfirmationData.newConfirmationData()
                    .about(about)
                    .transID(data.getTransactionId().toString())
                    .startDate(startDate)
                    .frequency(frequency).firstName(firstName)
                    .lastName(surname)
                    .providerInfo(providerInfo)
                    .whatsNext(next).product(productSelected)
                    .policyNo(response.getProductId())
                    .paymentType(paymentType)
                    .redemptionId(Optional.ofNullable((String) dataBucket.get(XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID)).orElse(""))
                    .build();

            Confirmation confirmation = new Confirmation();
            confirmation.setKey(confirmationId);
            confirmation.setTransactionId(data.getTransactionId());
            confirmation.setXmlData(ObjectMapperUtil.getXmlMapper().writeValueAsString(confirmationData));
            confirmationService.addConfirmation(confirmation);
        } catch (ConfigSettingException | DaoException | JsonProcessingException e) {
            LOGGER.warn("Failed to add confirmation {}", kv("confirmationId", confirmationId), e);
            throw new ServiceException("Failed to add confirmation", e);
        }
    }

    private String getContent(HttpServletRequest request, String providerName, String key) throws ConfigSettingException, DaoException {
        return providerContentService.getProviderContentText(request,
                providerName, key);
    }
}