package com.ctm.web.simples.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.simples.model.InboundPhoneNumber;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;

public class StartQuoteService {
	private static final Logger LOGGER = LoggerFactory.getLogger(StartQuoteService.class);
    private HttpServletRequest request;
    private HttpServletResponse response;
    private String verticalCode;

    public void init(PageContext context) {
        response = (HttpServletResponse) context.getResponse();
        request = (HttpServletRequest) context.getRequest();
        verticalCode = request.getParameter("verticalCode");
    }

    /**
     * Redirects consultant to proper URL on clicking StartQuote button
     * @throws Exception
     */
    public void startQuote() throws Exception {
        Brand brand = null;
        InboundPhoneNumber phoneDetails = null;
        PageSettings pageSettings =  SettingsService.setVerticalAndGetSettingsForPage(request, StringUtils.isEmpty(verticalCode) ? "SIMPLES" : verticalCode.toUpperCase());
        try {
            // only get phone details when InIn is not enabled
            if (!Boolean.valueOf(pageSettings.getSetting("inInEnabled"))) {
                phoneDetails = CallCentreService.getInboundPhoneDetails(request);
            }
        } catch (ConfigSettingException | RuntimeException e) {
            LOGGER.error("Error getting inbound phone details", e);
            response.sendRedirect(pageSettings.getBaseUrl()+"simples/selectBrand.jsp?verticalCode=" + verticalCode);

        }
        try {
            if (phoneDetails == null) {
                String brandString = CallCentreService.getConsultantStyleCodeId(request);

                if (brandString.contains(",")) {
                    response.sendRedirect(pageSettings.getBaseUrl()+"simples/selectBrand.jsp?verticalCode=" + verticalCode);
                } else {
                    response.sendRedirect(CallCentreService.createHandoverUrl(request, Integer.parseInt(brandString), verticalCode, null, null));
                }
            }
            if (phoneDetails != null) {
                brand = ApplicationService.getBrandById(phoneDetails.getStyleCodeId());
                if(StringUtils.isEmpty(verticalCode) && brand!=null)
                    verticalCode = brand.getVerticalById(phoneDetails.getVerticalId()).getCode();
            }
            if (StringUtils.isEmpty(verticalCode)) {
                response.getWriter().write("Unable to determine vertical from your phone call details.<br>Please choose <kbd>New > XXX quote</kbd> from the menu.");
            } else if (brand == null) {
                response.sendRedirect(pageSettings.getBaseUrl()+"simples/selectBrand.jsp?verticalCode=" + verticalCode + "&vdn=" + phoneDetails.getVdn());
            } else {
                response.sendRedirect(CallCentreService.createHandoverUrl(request, phoneDetails.getStyleCodeId(), verticalCode, null, phoneDetails.getVdn() + ""));
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("<center><br/><br/><br/><h4>Please try again... " +
                    "If the error keeps happening, please get your team leader to report to the IT department and provide below information:</h4> " + e.getLocalizedMessage()+"</center>");
        }
    }
}
