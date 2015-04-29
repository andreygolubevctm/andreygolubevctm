package com.ctm.router.exceptionhandlers;

import com.ctm.exceptions.ServiceException;
import org.apache.commons.lang3.exception.ExceptionUtils;

import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;

public class ServiceExceptionHandler implements ExceptionMapper<ServiceException> {

    @Override
    public Response toResponse(ServiceException e) {
        ResponseError responseError = new ResponseError();
        responseError.addError(e.getMessage());
        return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(responseError).build();
    }
}
