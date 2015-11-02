package com.ctm.web.core.router;

import com.ctm.web.core.results.services.ResultsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

import static com.ctm.web.core.logging.LoggingArguments.kv;

@WebServlet(urlPatterns = {
        "/features/getStructure.json"
})
public class FeaturesRouter extends HttpServlet {
    private static final Logger LOGGER = LoggerFactory.getLogger(FeaturesRouter.class);

    private static final long serialVersionUID = 18L;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        String uri = request.getRequestURI();
        PrintWriter writer = response.getWriter();
        // Automatically set content type based on request extension ////////////////////////////////////////
        if (uri.endsWith(".json")) {
            response.setContentType("application/json");
        }

        // Route the requests ///////////////////////////////////////////////////////////////////////////////
        if (uri.endsWith("/features/getStructure.json")) {

            ResultsService resultsService = new ResultsService();
            String results = null;
            final String vertical = request.getParameter("vertical");
            try {
                results = resultsService.getPageStructureAsJsonString(vertical);
                writer.print(results);
            } catch (Exception e) {
                LOGGER.error("Features couldn't be retrieved {}", kv("vertical", vertical), e);
            }

        }
    }
}
