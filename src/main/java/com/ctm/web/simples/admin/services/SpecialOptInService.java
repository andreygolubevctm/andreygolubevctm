package com.ctm.web.simples.admin.services;

import com.ctm.web.core.exceptions.CrudValidationException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.simples.admin.dao.SpecialOptInDao;
import com.ctm.web.simples.admin.model.SpecialOptIn;
import com.ctm.web.simples.helper.SpecialOptInHelper;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

public class SpecialOptInService {
    private final SpecialOptInDao specialOptInDao = new SpecialOptInDao();
    private final SpecialOptInHelper specialOptInHelper = new SpecialOptInHelper();
    private final IPAddressHandler ipAddressHandler;

    public SpecialOptInService() {
        ipAddressHandler = IPAddressHandler.getInstance();
    }

    public List<SchemaValidationError> validateSpecialOptInData(HttpServletRequest request, AuthenticatedData authenticatedData) {
        try {
            SpecialOptIn specialOptIn = new SpecialOptIn();
            specialOptIn = RequestUtils.createObjectFromRequest(request, specialOptIn);
            return specialOptInHelper.validateSpecialOptInRowData(specialOptIn);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    public List<SpecialOptIn> getAllSpecialOptIn() {
        try {
            List<SpecialOptIn> SpecialOptInList;
            SpecialOptInList = specialOptInDao.fetchSpecialOptIn( 0,"","",-1);
            return SpecialOptInList;
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    public SpecialOptIn updateSpecialOptIn(HttpServletRequest request, AuthenticatedData authenticatedData) throws CrudValidationException {
        try {
            SpecialOptIn specialOptIn = new SpecialOptIn();
            specialOptIn = RequestUtils.createObjectFromRequest(request, specialOptIn);
            final String userName = authenticatedData.getUid();
            final String ipAddress = ipAddressHandler.getIPAddress(request);

            checkSpecialOptInValidation(specialOptIn);

            return specialOptInDao.updateSpecialOptIn(specialOptIn, userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    private List<SchemaValidationError> checkSpecialOptInValidation(SpecialOptIn specialOptIn) throws DaoException, CrudValidationException {
        List<SpecialOptIn> SpecialOptInList = specialOptInDao.fetchSpecialOptIn(0, specialOptIn.getEffectiveStart(), specialOptIn.getEffectiveEnd(), specialOptIn.styleCodeId);
        List<SchemaValidationError> validationErrors = new ArrayList<>();
        Boolean addValidation = false;

        if (!SpecialOptInList.isEmpty()) {
            // loop through found helpBox and if there's one that is not the updated record.. add the validation
            for (SpecialOptIn soi : SpecialOptInList) {
                if (specialOptIn.getSpecialOptInId() != soi.getSpecialOptInId()) {
                    addValidation = true;
                }
            }
        }

        if (addValidation) {
            SchemaValidationError error = new SchemaValidationError();
            error.setElements("effectiveStart , effectiveEnd");
            error.setMessage("Special opt in effective date range invalid");
            validationErrors.add(error);
        }

        if (!validationErrors.isEmpty()) {
            throw new CrudValidationException(validationErrors);
        }

        return validationErrors;
    }
}
