package com.ctm.router;

import com.ctm.dao.simples.CappingLimitsDao;
import com.ctm.router.core.CrudRouter;
import com.ctm.services.simples.admin.CappingLimitsService;
import com.ctm.services.simples.admin.CrudService;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

import static com.ctm.utils.ResponseUtils.writeError;
import static javax.servlet.http.HttpServletResponse.SC_NOT_FOUND;

public class AdminRouter {
    private static Logger logger = Logger.getLogger(AdminRouter.class.getName());
    private final HttpServletResponse response;
    private final CrudRouter crudRouter;

    public AdminRouter(HttpServletRequest request , HttpServletResponse response) {
        this.response= response;
        this.crudRouter = new CrudRouter(request ,  response);
    }

    public void doPost(String uri) throws IOException {
        PrintWriter writer = response.getWriter();
        if(isCappingLimits(uri)){
            CrudService cappingLimitsService = new CappingLimitsService(new CappingLimitsDao());
            try {
                crudRouter.routePostRequest(writer, getAction(uri), cappingLimitsService);
            } catch (Exception e) {
                logger.error(e);
                writeError(writer,response, e);
            }
        } else {
            response.sendError(SC_NOT_FOUND);
        }
    }

    private String getAction(String uri) {
        return uri.split("/").length > 1 ? uri.split("/")[1].replace(".json" , "") : "";
    }

    public void doGet(String uri) throws IOException {
        PrintWriter writer = response.getWriter();
        if(isCappingLimits(uri)){
            CrudService crudService = new CappingLimitsService(new CappingLimitsDao());
            try {
                crudRouter.routGetRequest(writer, getAction(uri), crudService);
            } catch (Exception e) {
                logger.error(e);
                writeError(response.getWriter(), response, e);
            }
        } else {
            response.sendError(SC_NOT_FOUND);
        }
    }

    private boolean isCappingLimits(String uri) {
        String[] components = uri.split("/");
        return components.length > 0 && components[0].startsWith("cappingLimits");
    }

}
