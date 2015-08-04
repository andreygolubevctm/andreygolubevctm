package com.ctm.services.home;

import com.ctm.dao.home.HomeProductDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceException;
import com.ctm.model.home.HomeProduct;
import com.ctm.model.home.HomeRequest;
import com.ctm.model.settings.Vertical;
import com.ctm.services.RequestService;
import com.ctm.utils.home.HomeRequestParser;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

/**
 * Created by voba on 18/06/2015.
 */
public class HomeService {

    private static Logger logger = Logger.getLogger(HomeService.class);

    private boolean valid = false;
    private String vertical = Vertical.VerticalType.HOME.getCode();

    public String validate(HttpServletRequest request, Data data) {
        RequestService fromFormService = new RequestService(request, vertical, data);

        HomeRequest homeRequest = HomeRequestParser.parseRequest(data, vertical);
        List<SchemaValidationError> errors = validate(homeRequest);
        if(!valid) {
            return outputErrors(fromFormService, errors);
        }
        return "";
    }

    private List<SchemaValidationError> validate(HomeRequest homeRequest) {
        List<SchemaValidationError> errors = FormValidation.validate(homeRequest, "");
        valid = errors.isEmpty();
        return errors;
    }

    private String outputErrors(RequestService fromFormService, List<SchemaValidationError> errors) {
        String response;
        FormValidation.logErrors(fromFormService.sessionId, fromFormService.transactionId, fromFormService.styleCodeId, errors, "HomeService.java:validate");
        response = FormValidation.outputToJson(fromFormService.transactionId, errors).toString();
        return response;
    }

    public boolean isValid() {
        return valid;
    }

    public static HomeProduct getHomeProduct(Date date, String productId, String type, int styleCodeId) {
        HomeProductDao dao = new HomeProductDao();
        try {
            return dao.getHomeProduct(date, productId, type, styleCodeId);
        } catch (DaoException e) {
            String message = "Could not get HomeProduct for productId:" + productId;
            logger.error(message, e);
            throw new ServiceException(message, e);
        }

    }
}
