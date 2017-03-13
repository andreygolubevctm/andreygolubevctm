package com.ctm.web.core.router;

import com.ctm.web.core.model.IpAddressCheck;
import com.ctm.web.core.services.IPCheckService;
import org.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import static com.ctm.commonlogging.common.LoggingArguments.kv;

@WebServlet(urlPatterns = {
        "/ip/check.json"
})
public class IPCheckRouter extends HttpServlet {

    private static final Logger LOGGER = LoggerFactory.getLogger(CronRouter.class);

    private static final long serialVersionUID = 666L;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        PrintWriter writer = response.getWriter();

        IpAddressCheck model = new IpAddressCheck();
        model.setSuccess(false);

        String ip  = request.getParameter("ip");

        if(ip != null) {
            try {
                model.setIP(ip);
                IPCheckService service = new IPCheckService();
                boolean isLocalIP = service.isIPAddressLocal(ip);
                model.setSuccess(true);
                model.setIsLocal(isLocalIP);
            } catch(Exception e) {
                model.setError(e.getMessage());
                LOGGER.error("IPCheckService failed {}", kv("ip", ip), e);
            }
        } else {
            model.setError("No IP address provided to request");
        }

        response.setContentType("application/json");
        try {
            writer.print(model.getJsonObject().toString());
        } catch(JSONException exception) {
            LOGGER.error("IpAddressCheck model failed to render {}", kv("ip", ip), exception);
            throw new ServletException(exception.getMessage(),exception.getCause());
        }
    }
}
