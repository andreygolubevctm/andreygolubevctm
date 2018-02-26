package com.ctm.web.simples.admin.services;

import com.ctm.web.core.exceptions.CrudValidationException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.services.CrudService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.health.model.request.CappingLimit;
import com.ctm.web.simples.admin.dao.CappingLimitsDao;
import com.ctm.web.simples.admin.helper.CappingLimitsHelper;
import com.ctm.web.simples.admin.helper.ValidationHelper;
import com.ctm.web.simples.admin.model.request.CappingLimitDeleteRequest;
import com.ctm.web.simples.admin.model.response.CappingLimitInformation;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

public class CappingLimitsService implements CrudService<CappingLimit> {

    private final CappingLimitsDao cappingLimitsDao;
    private final CappingLimitsHelper cappingLimitsHelper;

    public CappingLimitsService(CappingLimitsDao cappingLimitsDao) {
        this.cappingLimitsDao = cappingLimitsDao;
        cappingLimitsHelper = new CappingLimitsHelper();
    }

    @Override
    public List<CappingLimitInformation> getAll(HttpServletRequest request) throws DaoException {
        return cappingLimitsDao.fetchCappingLimits();
    }

    @Override
    public CappingLimit update(HttpServletRequest request) throws DaoException, CrudValidationException {
        CappingLimit requestObj = RequestUtils.createObjectFromRequest(request, new CappingLimit());
        ValidationHelper.validate(requestObj);
        List<SchemaValidationError> validationErrors = new ArrayList<>();
        cappingLimitsHelper.validateCappingLimitCategory(requestObj, validationErrors);
        List<CappingLimit> clashingCappingLimit = cappingLimitsDao.fetchCappingLimitsWithMatchingFields(requestObj);
        if (clashingCappingLimit.size() > 0) {
            SchemaValidationError error = new SchemaValidationError();
            error.setElements("effectiveStart , effectiveEnd");
            error.setMessage("Capping Limit will clash with existing limit. Existing Capping limit: EffectiveStart " +
                    clashingCappingLimit.get(0).getEffectiveStart() + " EffectiveEnd " + clashingCappingLimit.get(0).getEffectiveEnd());
            validationErrors.add(error);
        }
        if (!validationErrors.isEmpty()) {
            throw new CrudValidationException(validationErrors);
        } else {
            requestObj = cappingLimitsDao.updateCappingLimits(requestObj);
            return cappingLimitsDao.fetchCappingInformation(requestObj);
        }
    }

    @Override
    public CappingLimit create(HttpServletRequest request) throws DaoException, CrudValidationException {
        CappingLimit requestObj = RequestUtils.createObjectFromRequest(request, new CappingLimit());
        ValidationHelper.validate(requestObj);
        List<SchemaValidationError> validationErrors = new ArrayList<>();
        cappingLimitsHelper.validateCappingLimitCategory(requestObj, validationErrors);
        List<CappingLimit> clashingCappingLimit = cappingLimitsDao.fetchCappingLimits(requestObj);
        if (clashingCappingLimit.size() > 0) {
            SchemaValidationError error = new SchemaValidationError();
            error.setElements("providerId , effectiveStart , effectiveEnd");
            error.setMessage("Capping Limit already exists");
            validationErrors.add(error);
        }
        if (!validationErrors.isEmpty()) {
            throw new CrudValidationException(validationErrors);
        } else {
            requestObj = cappingLimitsDao.createCappingLimits(requestObj);
            return cappingLimitsDao.fetchCappingInformation(requestObj);
        }
    }

    @Override
    public String delete(HttpServletRequest request) throws DaoException, CrudValidationException {
        CappingLimitDeleteRequest requestObj = RequestUtils.createObjectFromRequest(request, new CappingLimitDeleteRequest());
        ValidationHelper.validate(requestObj);
        return cappingLimitsDao.deleteCappingLimits(requestObj);
    }

    @Override
    public CappingLimit get(HttpServletRequest request) throws DaoException, CrudValidationException {
        CappingLimit requestObj = RequestUtils.createObjectFromRequest(request, new CappingLimit());
        ValidationHelper.validate(request);
        return cappingLimitsDao.fetchCappingInformation(requestObj);
    }

}
