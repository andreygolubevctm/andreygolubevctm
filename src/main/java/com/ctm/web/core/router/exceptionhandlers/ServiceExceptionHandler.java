package com.ctm.web.core.router.exceptionhandlers;

import com.ctm.web.core.exceptions.ServiceException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;

public class ServiceExceptionHandler implements ExceptionMapper<ServiceException> {

    private static final Logger LOGGER = LoggerFactory.getLogger(ServiceExceptionHandler.class);

    @Override
    public Response toResponse(ServiceException e) {

        LOGGER.error("Request failed: ", e);

        ResponseError responseError = new ResponseError();
        responseError.addError(e.getMessage());
        return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(responseError).build();
    }
}
