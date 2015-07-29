package com.ctm.services.simples;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.Brand;
import com.ctm.model.simples.InboundPhoneNumber;
import com.ctm.services.ApplicationService;
import com.ctm.services.CallCentreService;
import com.ctm.services.SettingsService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;

public class StartQuoteService {
    private static Logger logger = Logger.getLogger(StartQuoteService.class.getName());
    SettingsService settingsService;
    ApplicationService applicationService;
    CallCentreService callCentreService;
    HttpServletRequest request;
    HttpServletResponse response;
    String verticalCode;

    public void init(PageContext context) {
        settingsService = new SettingsService();
        response = (HttpServletResponse) context.getResponse();
        request = (HttpServletRequest) context.getRequest();
        verticalCode = request.getParameter("verticalCode");
    }

    public void startQuote() throws Exception {
        Brand brand = null;
        InboundPhoneNumber phoneDetails = null;
        try {

            settingsService.setVerticalAndGetSettingsForPage(request, StringUtils.isEmpty(verticalCode) ? "SIMPLES" : verticalCode.toUpperCase());
            phoneDetails = callCentreService.getInboundPhoneDetails(request);

        } catch (DaoException | ConfigSettingException | RuntimeException e) {
            logger.error("ERROR While get inbound phone details : "+e.getMessage());
            response.sendRedirect("selectBrand.jsp?verticalCode=" + verticalCode);

        }
        try {
            if (phoneDetails == null) {
                response.sendRedirect("selectBrand.jsp?verticalCode=" + verticalCode);
            }
            if (phoneDetails != null) {
                brand = applicationService.getBrandById(phoneDetails.getStyleCodeId());
                if(StringUtils.isEmpty(verticalCode))
                    verticalCode = brand.getVerticalById(phoneDetails.getVerticalId()).getCode();
            }
            if (StringUtils.isEmpty(verticalCode)) {
                response.getWriter().write("Unable to determine vertical from your phone call details.<br>Please choose <kbd>New > XXX quote</kbd> from the menu.");
            } else if (brand == null) {
                response.sendRedirect("selectBrand.jsp?verticalCode=" + verticalCode + "&vdn=" + phoneDetails.getVdn());
            } else {
                response.sendRedirect(callCentreService.createHandoverUrl(request, phoneDetails.getStyleCodeId(), verticalCode, null, phoneDetails.getVdn() + ""));
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("<center><br/><br/><br/><h4>Please try again... " +
                    "If the error keeps happening, please get your team leader to report to the IT department and provide below information:</h4> " + e.getLocalizedMessage()+"</center>");
        }
    }
}
