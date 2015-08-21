package com.ctm.services.simples;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.PageSettings;
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
    private static final Logger logger = Logger.getLogger(StartQuoteService.class.getName());
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
            phoneDetails = CallCentreService.getInboundPhoneDetails(request);
        } catch (DaoException | ConfigSettingException | RuntimeException e) {
            logger.error("ERROR While get inbound phone details : "+e.getMessage());
            response.sendRedirect(pageSettings.getBaseUrl()+"simples/selectBrand.jsp?verticalCode=" + verticalCode);

        }
        try {
            if (phoneDetails == null) {
                response.sendRedirect(pageSettings.getBaseUrl()+"simples/selectBrand.jsp?verticalCode=" + verticalCode);
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
