package com.ctm.web.simples.admin.services;

import com.ctm.web.core.exceptions.CrudValidationException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.utils.common.utils.DateUtils;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.simples.admin.dao.HelpBoxDao;
import com.ctm.web.simples.admin.model.HelpBox;
import com.ctm.web.simples.helper.HelpBoxHelper;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class HelpBoxService {
    private final HelpBoxDao helpBoxDao = new HelpBoxDao();
    private final HelpBoxHelper helpBoxHelper = new HelpBoxHelper();
    private final IPAddressHandler ipAddressHandler;
    private final SimpleDateFormat sdf = new SimpleDateFormat("EEE MMM d HH:mm:ss Z yyyy");

    public HelpBoxService() {
        ipAddressHandler =  IPAddressHandler.getInstance();
    }

    public List<SchemaValidationError> validateHelpBoxData(HttpServletRequest request, AuthenticatedData authenticatedData) {
        try {
            HelpBox helpBox = new HelpBox();
            helpBox = RequestUtils.createObjectFromRequest(request, helpBox);
            helpBox.setOperatorId(authenticatedData.getSimplesUid());
            return helpBoxHelper.validateHelpBoxRowData(helpBox);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    public List<HelpBox> getAllHelpBox() {
        try {
            List<HelpBox> helpBoxList;
            helpBoxList = helpBoxDao.fetchHelpBox( 0, "","", -1);
            return helpBoxList;
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    public HelpBox getCurrentHelpBox(int styleCodeId, Date applicationDate) {
        try {
            java.sql.Date serverDate = new java.sql.Date(DateUtils.setTimeInDate(sdf.parse(applicationDate.toString()), 0, 0, 1).getTime());
            return helpBoxDao.fetchSingleRecHelpBox(serverDate.toString(),"", styleCodeId);
        } catch (DaoException | ParseException d) {
            throw new RuntimeException(d);
        }
    }

    public HelpBox createHelpBox(HttpServletRequest request, AuthenticatedData authenticatedData) throws CrudValidationException {
        try {
            HelpBox helpBox = new HelpBox();
            helpBox = RequestUtils.createObjectFromRequest(request, helpBox);
            helpBox.setOperatorId(authenticatedData.getSimplesUid());
            final String userName = authenticatedData.getUid();
            final String ipAddress = ipAddressHandler.getIPAddress(request);

            List<SchemaValidationError> validationErrors = new ArrayList<>();

            HelpBox helpBox1 = helpBoxDao.fetchSingleRecHelpBox(helpBox.getEffectiveStart(), helpBox.getEffectiveEnd(), helpBox.getStyleCodeId());

            if (helpBox1 != null) {
                SchemaValidationError error = new SchemaValidationError();
                error.setElements("effectiveStart , effectiveEnd");
                error.setMessage("Help Box effective date range invalid");
                validationErrors.add(error);
            }

            if (!validationErrors.isEmpty()) {
                throw new CrudValidationException(validationErrors);
            } else {
                return helpBoxDao.createHelpBox(helpBox, userName, ipAddress);
            }
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    public HelpBox updateHelpBox(HttpServletRequest request, AuthenticatedData authenticatedData) {
        try {
            HelpBox helpBox = new HelpBox();
            helpBox = RequestUtils.createObjectFromRequest(request, helpBox);
            helpBox.setOperatorId(authenticatedData.getSimplesUid());
            final String userName = authenticatedData.getUid();
            final String ipAddress = ipAddressHandler.getIPAddress(request);

            return helpBoxDao.updateHelpBox(helpBox, userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    public String deleteHelpBox(HttpServletRequest request, AuthenticatedData authenticatedData) {
        try {
            final String userName = authenticatedData.getUid();
            final String ipAddress = ipAddressHandler.getIPAddress(request);
            return helpBoxDao.deleteHelpBox(request.getParameter("helpBoxId"), userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }
}
