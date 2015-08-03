package com.ctm.services.simples;

import com.ctm.dao.simples.FundWarningDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.CrudValidationException;
import com.ctm.exceptions.DaoException;
import com.ctm.helper.simples.FundWarningHelper;
import com.ctm.model.FundWarningMessage;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.services.ApplicationService;
import com.ctm.services.SessionDataService;
import com.ctm.services.simples.admin.CrudService;
import com.ctm.utils.RequestUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

public class FundWarningService implements CrudService{

    private final FundWarningDao fundWarningDao = new FundWarningDao();
    private final FundWarningHelper fundWarningHelper = new FundWarningHelper();

    public FundWarningService() {
    }

    public String getFundWarningMessage(HttpServletRequest request) throws DaoException, ConfigSettingException {
        int providerId = Integer.parseInt(request.getParameter("providerId"));
        Date currDate = ApplicationService.getApplicationDate(request);
        return fundWarningDao.getFundWarningMessage(providerId, "HEALTH", currDate);
    }

    @Override
    public List<?> getAll() throws DaoException {
        try {
            List<FundWarningMessage> fundWarningMessage;
            fundWarningMessage = fundWarningDao.fetchFundWarningMessage(0);
            return fundWarningMessage;
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    @Override
    public Object update(HttpServletRequest request) throws DaoException, CrudValidationException {
        try {
            FundWarningMessage fundWarningMessage = RequestUtils.createObjectFromRequest(request, new FundWarningMessage());
            fundWarningHelper.validate(fundWarningMessage);
            fundWarningMessage = RequestUtils.createObjectFromRequest(request, fundWarningMessage);
            final String userName = getAuthenticatedData(request).getUid();
            final String ipAddress = request.getRemoteAddr();
            return fundWarningDao.updateFundWarningMessage(fundWarningMessage, userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    @Override
    public Object create(HttpServletRequest request) throws DaoException, CrudValidationException {
        try {
            FundWarningMessage fundWarningMessage = RequestUtils.createObjectFromRequest(request, new FundWarningMessage());
            fundWarningHelper.validate(fundWarningMessage);
            fundWarningMessage = RequestUtils.createObjectFromRequest(request, fundWarningMessage);
            final String userName = getAuthenticatedData(request).getUid();
            final String ipAddress = request.getRemoteAddr();
            return fundWarningDao.createFundWarningMessage(fundWarningMessage, userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    @Override
    public String delete(HttpServletRequest request) throws DaoException, CrudValidationException {
        try {
            final String userName = getAuthenticatedData(request).getUid();
            final String ipAddress = request.getRemoteAddr();
            return fundWarningDao.deleteFundWarningMessage(Integer.parseInt(request.getParameter("messageId")), userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    @Override
    public Object get(HttpServletRequest request) throws DaoException, CrudValidationException {
        try {
            if(request.getParameter("messageId")==null)
                return null;
            return fundWarningDao.fetchSingleRecFundWarningMessage(Integer.parseInt(request.getParameter("messageId")));
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }
    
    public AuthenticatedData getAuthenticatedData(HttpServletRequest request) throws DaoException {
        SessionDataService sessionDataService = new SessionDataService();
        if (request.getSession() != null) {
            return sessionDataService.getAuthenticatedSessionData(request);
        } else {
            throw new  DaoException("Session expired");
        }
    }

}
