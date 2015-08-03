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
    public static final String EMPTY =  "";

    private final HttpServletRequest request;
    private final HttpServletResponse response;

    public CrudRouter(HttpServletRequest request , HttpServletResponse response) {
        this.request = request;
        this.response= response;
    }

    /**
     * Based on action value this router function will call the curd service method to service GET request
     * @param writer
     * @param action
     * @param crudService
     * @throws DaoException
     * @throws IOException
     */
    public void routGetRequest(PrintWriter writer, String action, final CrudService crudService) throws DaoException, IOException {
        try{
            switch (action) {
                case LIST:
                    write(writer, crudService.getAll());
                    break;
                case EMPTY:
                    write(writer, crudService.get(request));
                    break;
                default:
                    response.sendError(SC_NOT_FOUND);
                    break;
            }
        } catch(CrudValidationException e) {
            writeErrors(writer, response, e.getValidationErrors());
        }
    }


    /**
     * Based on action value this router function will call the curd service method to service POST request
     * @param writer
     * @param action
     * @param crudService
     * @throws DaoException
     * @throws IOException
     */
    public void routePostRequest(PrintWriter writer, String action, final CrudService crudService) throws IOException, DaoException {
        try {
            switch (action) {
                case UPDATE:
                    write(writer, crudService.update(request));
                    break;
                case CREATE:
                    write(writer, crudService.create(request));
                    break;
                case DELETE:
                    write(writer, crudService.delete(request));
                    break;
                default:
                    response.sendError(SC_NOT_FOUND);
                    break;
            }
        } catch (CrudValidationException e) {
            writeErrors(writer, response, e.getValidationErrors());
        }
    }
}
