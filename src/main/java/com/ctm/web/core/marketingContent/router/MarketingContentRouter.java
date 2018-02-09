package com.ctm.web.core.marketingContent.router;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.marketingContent.model.request.MarketingContentRequest;
import com.ctm.web.core.marketingContent.services.MarketingContentService;
import com.ctm.web.core.model.Error;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.web.go.Data;
import org.json.JSONObject;
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
        "/marketingContent/get.json"
})

public class MarketingContentRouter extends HttpServlet {
    private static final Logger LOGGER = LoggerFactory.getLogger(MarketingContentRouter.class);
    private final MarketingContentService marketingContentService = new MarketingContentService();

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String uri = request.getRequestURI();
        PrintWriter writer = response.getWriter();

        if (uri.endsWith(".json")) {
            response.setContentType("application/json");
        }

        MarketingContentRequest marketingContentRequest = new MarketingContentRequest();

        try {
            long transactionId = RequestUtils.getTransactionIdFromRequest(request);
            Data data = RequestUtils.getValidDataBucket(request, transactionId);

            PageSettings pageSettings = SettingsService.getPageSettingsByCode(ApplicationService.getBrandCodeFromTransactionSessionData(data), ApplicationService.getVerticalCodeFromTransactionSessionData(data));

            marketingContentRequest.transactionId = transactionId;
            marketingContentRequest.styleCodeId = pageSettings.getBrandId();
            marketingContentRequest.verticalId = pageSettings.getVertical().getId();
            marketingContentRequest.effectiveDate = ApplicationService.getApplicationDate(request);

            if (uri.endsWith("/marketingContent/get.json")) {
                getMarketingContent(marketingContentRequest, writer, request, response);
            }

        } catch (Exception e) {
            LOGGER.error("Coupon request failed {}", kv("uri", request.getRequestURI()), e);
            writeErrors(e, writer, response);
        }
    }

    private void getMarketingContent(MarketingContentRequest marketingContentRequest, final PrintWriter writer, final HttpServletRequest request, final HttpServletResponse response) {
        try {
            writer.print(marketingContentService.getMarketingContent(marketingContentRequest).toJson());
        } catch (DaoException e) {
            LOGGER.error("Coupon fetch failed {}", kv("marketingContentUrl", marketingContentRequest.url), e);
            writeErrors(e, writer, response);
        }
    }

    private void writeErrors(final Exception e, final PrintWriter writer, final HttpServletResponse response) {
        final Error error = new Error();
        error.addError(new Error(e.getMessage()));
        JSONObject json = error.toJsonObject(true);
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        writer.print(json.toString());
    }
}
