package com.ctm.web.simples.admin.services;

import com.ctm.web.core.exceptions.CrudValidationException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.router.core.CrudRouter;
import com.ctm.web.core.services.CrudService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.simples.admin.dao.ProviderSummaryDao;
import com.ctm.web.simples.admin.helper.ValidationHelper;
import com.ctm.web.simples.admin.model.capping.product.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.elasticsearch.common.collect.ImmutableList;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class HealthProductCappingService implements CrudService<ProductCappingLimit> {

    public static final String SUMMARY_ACTION = "getSummary";
    private final ProviderSummaryDao providerSummaryDao;
    private final ProductCappingLimitDao productCappingLimitDao;
    private PrintWriter writer;
    private ObjectMapper objectMapper;
    private CrudRouter crudRouter;

    public HealthProductCappingService(PrintWriter writer, ObjectMapper objectMapper, CrudRouter crudRouter) {
        this.writer = writer;
        this.objectMapper = objectMapper;
        this.crudRouter = crudRouter;
        this.providerSummaryDao = new ProviderSummaryDao();
        this.productCappingLimitDao = new ProductCappingLimitDao();
    }

    public void findProviderSummaryData() throws IOException, DaoException {
        objectMapper.writeValue(writer, providerSummaryDao.findProviderSummary());
    }

    public void routeGetRequest(String action) throws IOException, DaoException {
        switch (action) {
            case SUMMARY_ACTION:
                findProviderSummaryData();
                break;
            default:
                crudRouter.routGetRequest(writer, action, this);
        }
    }

    public void routePostRequest(String action) throws IOException, DaoException {
        switch (action) {
            case SUMMARY_ACTION:
                routeGetRequest(action);
                break;
            case CrudRouter.LIST:
                routeGetRequest(action);
                break;
            default:
                crudRouter.routePostRequest(writer, action, this);
        }
    }


    @Override
    public List<?> getAll(HttpServletRequest request) throws DaoException {
        GetAllRequestDTO requestObj = RequestUtils.createObjectFromRequest(request, new GetAllRequestDTO());
        return productCappingLimitDao.findAllByProviderId(requestObj.getProviderId());
    }

    @Override
    public ProductCappingLimit update(HttpServletRequest request) throws DaoException, CrudValidationException {
        UpdateProductCappingLimitDTO fromRequest = RequestUtils.createObjectFromRequest(request, new UpdateProductCappingLimitDTO());
        ValidationHelper.validate(fromRequest);

        ProductCappingLimit byId = productCappingLimitDao.findById(fromRequest.getCappingLimitId());
        Optional<String> productCode = productCappingLimitDao.findProductCode(byId.getProviderId(), byId.getProductName(), byId.getState(), byId.getHealthCvr(), fromRequest.getEffectiveStart(), fromRequest.getEffectiveEnd());

        List<SchemaValidationError> validationErrors = new ArrayList<>();
        if (!productCode.isPresent()) {
            SchemaValidationError schemaValidationError = new SchemaValidationError();
            schemaValidationError.setElements("effectiveStart, effectiveEnd");
            schemaValidationError.setMessage("The capping limit cannot be updated because the product is not current for those dates.");
            validationErrors.add(schemaValidationError);
        }

        List<ProductCappingLimit> overlappingProductLimits = productCappingLimitDao.findOverlappingProductLimits(fromRequest);

        if (!overlappingProductLimits.isEmpty()) {
            SchemaValidationError error = new SchemaValidationError();
            error.setElements("effectiveStart , effectiveEnd");
            error.setMessage("Capping Limit will clash with existing limit. Existing Capping limit: EffectiveStart " +
                    overlappingProductLimits.get(0).getEffectiveStart() + " EffectiveEnd " + overlappingProductLimits.get(0).getEffectiveEnd());
            validationErrors.add(error);
        }
        if (!validationErrors.isEmpty()) {
            throw new CrudValidationException(validationErrors);
        } else {
            return productCappingLimitDao.update(fromRequest);
        }
    }

    @Override
    public ProductCappingLimit create(HttpServletRequest request) throws DaoException, CrudValidationException {
        CreateProductCappingLimitDTO fromRequest = RequestUtils.createObjectFromRequest(request, new CreateProductCappingLimitDTO());
        ValidationHelper.validate(fromRequest);
        Optional<String> productCode = productCappingLimitDao.findProductCode(fromRequest.getProviderId(), fromRequest.getProductName(), fromRequest.getState(), fromRequest.getHealthCvr(), fromRequest.getEffectiveStart(), fromRequest.getEffectiveEnd());
        List<SchemaValidationError> validationErrors = new ArrayList<>();

        if (!productCode.isPresent()) {
            SchemaValidationError schemaValidationError = new SchemaValidationError();
            schemaValidationError.setElements("providerId, state, effectiveStart, effectiveEnd, healthCvr, productName");
            schemaValidationError.setMessage("No product can be found for the provided values and dates");
            validationErrors.add(schemaValidationError);
        } else {
            List<ProductCappingLimit> overlappingProductLimits = productCappingLimitDao.findOverlappingProductLimits(fromRequest);
            if (!overlappingProductLimits.isEmpty()) {
                SchemaValidationError error = new SchemaValidationError();
                error.setElements("providerId , limitType, effectiveStart , effectiveEnd");
                error.setMessage("A capping limit for those dates already exists");
                validationErrors.add(error);
            }
        }

        if (!validationErrors.isEmpty()) {
            throw new CrudValidationException(validationErrors);
        } else {
            return productCappingLimitDao.create(fromRequest);
        }
    }

    @Override
    public String delete(HttpServletRequest request) throws DaoException, CrudValidationException {
        CappingLimitIdDTO requestObj = RequestUtils.createObjectFromRequest(request, new CappingLimitIdDTO());
        ValidationHelper.validate(requestObj);
        return productCappingLimitDao.delete(requestObj.getCappingLimitId());
    }

    @Override
    public ProductCappingLimit get(HttpServletRequest request) throws DaoException {
        CappingLimitIdDTO requestObj = RequestUtils.createObjectFromRequest(request, new CappingLimitIdDTO());
        return productCappingLimitDao.findById(requestObj.getCappingLimitId());
    }

}
