package com.ctm.router.core;

import com.ctm.exceptions.CrudValidationException;
import com.ctm.exceptions.DaoException;
import com.ctm.services.simples.admin.CrudService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

import static com.ctm.utils.ResponseUtils.write;
import static com.ctm.utils.ResponseUtils.writeErrors;
import static javax.servlet.http.HttpServletResponse.SC_NOT_FOUND;

public class CrudRouter {

    public static final String CREATE ="create" ;
    public static final String UPDATE = "update" ;
    public static final String DELETE =  "delete";
    public static final String LIST =  "getAllRecords";

    private final HttpServletRequest request;
    private final HttpServletResponse response;

    public CrudRouter(HttpServletRequest request , HttpServletResponse response) {
        this.request = request;
        this.response= response;
    }

    public void routGetRequest(PrintWriter writer, String action, final CrudService crudService) throws DaoException, IOException {
        if(LIST.equals(action)){
            write(writer, crudService.getAll());
        }else  if(request.getParameterMap().size() > 0){
            route(writer, new Action() {
                @Override
                public Object perform() throws DaoException, CrudValidationException {
                    return crudService.get(request);
                }
            });
        } else {
            write(writer, crudService.getAll());
        }
    }


    public void routePostRequest(PrintWriter writer, String action, final CrudService crudService) throws IOException, DaoException {
        switch (action) {
            case UPDATE:
                route(writer, new Action() {
                    @Override
                    public Object perform() throws DaoException, CrudValidationException {
                        return crudService.update(request);
                    }
                });
                break;
            case CREATE:
                route(writer, new Action() {
                    @Override
                    public Object perform() throws DaoException, CrudValidationException {
                        return crudService.create(request);
                    }
                });
                break;
            case DELETE:
                route(writer, new Action() {
                    @Override
                    public Object perform() throws DaoException, CrudValidationException {
                        return crudService.delete(request);
                    }
                });
                break;
            default:
                response.sendError(SC_NOT_FOUND);
                break;
        }
    }

    private interface Action {
        Object perform() throws DaoException, CrudValidationException;
    }

    private void route(PrintWriter writer, Action action) throws IOException, DaoException {
        try {
            write(writer, action.perform());
        } catch (CrudValidationException e) {
            writeErrors(writer, response, e.getValidationErrors());
        }
    }

}
