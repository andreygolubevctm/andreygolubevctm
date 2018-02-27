package com.ctm.web.simples.admin.router;

import com.ctm.web.core.router.core.CrudRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.CrudService;
import com.ctm.web.simples.admin.dao.CappingLimitsDao;
import com.ctm.web.simples.admin.services.AdminProviderContentService;
import com.ctm.web.simples.admin.services.CappingLimitsService;
import com.ctm.web.simples.admin.services.HealthProductCappingService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.utils.ResponseUtils.writeError;
import static javax.servlet.http.HttpServletResponse.SC_NOT_FOUND;

/**
 * This class will only be used by CMS stuff in simples for update/create/delete and fetch records from database
 */
public class AdminRouter {
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminRouter.class);
    private final HttpServletResponse response;
    private final CrudRouter crudRouter;
    private final IPAddressHandler ipAddressHandler;
    private ObjectMapper objectMapper;
    CrudService crudService = null;
    //mention your Interface name here that has been used in CMS URL
    private static final String PRODUCT_CAPPING_LIMIT = "productCappingLimits";
    private static final String CAPPING_LIMIT = "cappingLimits";
    private static final String PROVIDER_CONTENT = "providerContent";

    public AdminRouter(HttpServletRequest request, HttpServletResponse response, IPAddressHandler ipAddressHandler, ObjectMapper objectMapper) {
        this.response= response;
        this.ipAddressHandler = ipAddressHandler;
        this.objectMapper = objectMapper;
        this.crudRouter = new CrudRouter(request ,  response);
    }

    /**
     * Call this function from your servlet doGet method to service GET request
     * @param uri
     * @throws IOException
     */
    public void doPost(String uri) throws IOException {
        PrintWriter writer = response.getWriter();
        try {
            switch(getInterfaceName(uri)){
                case PRODUCT_CAPPING_LIMIT:
                    HealthProductCappingService productCappingService = new HealthProductCappingService(writer, objectMapper, crudRouter);
                    productCappingService.routePostRequest(getAction(uri));
                    break;
                case CAPPING_LIMIT:
                        crudService = new CappingLimitsService(new CappingLimitsDao());
                        crudRouter.routePostRequest(writer, getAction(uri), crudService);
                        break;
                case PROVIDER_CONTENT:
                        crudService = new AdminProviderContentService( ipAddressHandler);
                        crudRouter.routePostRequest(writer, getAction(uri), crudService);
                        break;
                default:
                        response.sendError(SC_NOT_FOUND);
            }
        } catch (Exception e) {
            LOGGER.error("Admin post request failed {}", kv("uri", uri), e);
            writeError(writer, response, e);
        }
    }

    /**
     * Call this function from your servlet doGet method to service GET request
     * @param uri
     * @throws IOException
     */
    public void doGet(String uri) throws IOException {
        PrintWriter writer = response.getWriter();
        try {
            switch(getInterfaceName(uri)){
                case PRODUCT_CAPPING_LIMIT:
                    HealthProductCappingService productCappingService = new HealthProductCappingService(writer, objectMapper, crudRouter);
                    productCappingService.routeGetRequest(getAction(uri));
                    break;
                case CAPPING_LIMIT:
                    crudService = new CappingLimitsService(new CappingLimitsDao());
                    crudRouter.routGetRequest(writer, getAction(uri), crudService);
                    break;
                case PROVIDER_CONTENT:
                    crudService = new AdminProviderContentService(ipAddressHandler);
                    crudRouter.routGetRequest(writer, getAction(uri), crudService);
                    break;
                default:
                    response.sendError(SC_NOT_FOUND );
            }
        } catch (Exception e) {
            LOGGER.error("Admin get request failed", kv("uri", uri), e);
            writeError(writer,response, e);
        }
    }

    /** this method will return name of interface from URI
     * Example : if your URI is : /cappingLimits/action.json then returns "cappingLimits"
     * @param uri
     * @return
     */

    private String getInterfaceName(String uri) {
        String[] components = uri.split("/");
        return components[0].replaceAll(".json","");
    }
    /** this method will return name of action from URI
     * Example : if your URI is : /cappingLimits/delete.json then returns "delete"
     * @param uri
     * @return
     */
    private String getAction(String uri) {
        return uri.split("/").length > 1 ? uri.split("/")[1].replace(".json" , "") : "";
    }
}
