package com.ctm.services.simples.admin;

import com.ctm.dao.simples.CappingLimitsDao;
import com.ctm.exceptions.CrudValidationException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.request.CappingLimitDeleteRequest;
import com.ctm.model.request.health.CappingLimit;
import com.ctm.model.response.CappingLimitInformation;
import com.ctm.utils.RequestUtils;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

public class CappingLimitsService implements CrudService<CappingLimit> {

    private final CappingLimitsDao cappingLimitsDao;

    public CappingLimitsService(CappingLimitsDao cappingLimitsDao) {
        this.cappingLimitsDao = cappingLimitsDao;
    }

    @Override
    public List<CappingLimitInformation> getAll() throws DaoException {
        return cappingLimitsDao.fetchCappingLimits();
    }

    @Override
    public CappingLimit update(HttpServletRequest request) throws DaoException, CrudValidationException {
        CappingLimit requestObj = RequestUtils.createObjectFromRequest(request, new CappingLimit());
        validate(requestObj);
        List<CappingLimit> clashingCappingLimit = cappingLimitsDao.fetchCappingLimitsWithMatchingFields(requestObj);
        if(clashingCappingLimit.size() > 0) {
            List<SchemaValidationError> validationErrors = new ArrayList<>();
            SchemaValidationError error = new SchemaValidationError();
            error.setElements("effectiveStart , effectiveEnd");
            error.setMessage("Capping Limit will clash with existing limit. Existing Capping limit: EffectiveStart " + clashingCappingLimit.get(0).getEffectiveStart() + " EffectiveEnd " + clashingCappingLimit.get(0).getEffectiveEnd());
            validationErrors.add(error);
            throw new CrudValidationException(validationErrors);
        } else {
            requestObj =  cappingLimitsDao.updateCappingLimits(requestObj);
            return cappingLimitsDao.fetchCappingInformation(requestObj);
        }
    }

    @Override
    public CappingLimit create(HttpServletRequest request) throws DaoException, CrudValidationException {
        CappingLimit requestObj = RequestUtils.createObjectFromRequest(request, new CappingLimit());
        validate(requestObj);
        List<CappingLimit> clashingCappingLimit = cappingLimitsDao.fetchCappingLimits(requestObj);
        if(clashingCappingLimit.size() > 0) {
            List<SchemaValidationError> validationErrors = new ArrayList<>();
            SchemaValidationError error = new SchemaValidationError();
            error.setElements("providerId , effectiveStart , effectiveEnd");
            error.setMessage("Capping Limit already exists");
            validationErrors.add(error);
            throw new CrudValidationException(validationErrors);
        } else {
            requestObj =  cappingLimitsDao.createCappingLimits(requestObj);
            return cappingLimitsDao.fetchCappingInformation(requestObj);
        }
    }

    @Override
    public String delete(HttpServletRequest request) throws DaoException, CrudValidationException {
        CappingLimitDeleteRequest requestObj = RequestUtils.createObjectFromRequest(request, new CappingLimitDeleteRequest());
        validate(requestObj);
        return cappingLimitsDao.deleteCappingLimits(requestObj);
    }

    @Override
    public CappingLimit get(HttpServletRequest request) throws DaoException, CrudValidationException {
        CappingLimit requestObj = RequestUtils.createObjectFromRequest(request, new CappingLimit());
        validate(request);
        return cappingLimitsDao.fetchCappingInformation(requestObj);
    }

    private void validate(Object request) throws CrudValidationException {
        List<SchemaValidationError> validationErrors = FormValidation.validate(request, "");
        if(!validationErrors.isEmpty()) {
            throw new CrudValidationException(validationErrors);
        }
    }

}
