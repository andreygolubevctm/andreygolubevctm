package com.ctm.router;

import com.ctm.services.results.ResultsService;
import org.apache.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(urlPatterns = {
        "/features/getStructure.json"
})
public class FeaturesRouter extends HttpServlet {

    private static Logger logger = Logger.getLogger(FeaturesRouter.class.getName());

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
            try {
                results = resultsService.getPageStructureAsJsonString(request.getParameter("vertical"));
                writer.print(results);
            } catch (Exception e) {
                logger.error(e);
            }

        }
    }
}
