package com.ctm.services.health;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.FatalErrorService;
import com.ctm.services.SettingsService;
import com.ctm.web.URLUtils;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

public class BrochureService {
    private final static Logger logger = Logger.getLogger(BrochureService.class.getName());
    /**
     * This function will download the brochure for health
     * @param request
     * @param pdfName
     * @param transactionId
     * @throws ConfigSettingException
     * @throws DaoException
     * @throws IOException
     */
    public String downloadBrochure(HttpServletRequest request, String pdfName, String transactionId) throws ConfigSettingException, DaoException, IOException, SessionException {
        PageSettings pageSettings =SettingsService.setVerticalAndGetSettingsForPage(request, Vertical.VerticalType.HEALTH.getCode());
        int brand = pageSettings.getBrandId();
        String downloadLink = createBrochureDownloadLInk(pdfName,pageSettings);
        if(!URLUtils.exists(downloadLink) && pdfName!=null && !pdfName.isEmpty()){
            String message ="Brochure not found";
            String description ="Brochure is missing from the server :"+pdfName +" brandID : "+brand ;
            FatalErrorService.logFatalError(brand, request.getRequestURI(), request.getSession().getId(), false, message, description, transactionId + "");
            logger.error(description +" TransactionID : "+transactionId );
            return null;
        }else if(pdfName==null || pdfName.isEmpty()){
            return null;
        }
        return downloadLink;
    }

    /**
     * Create Brochure link base on hasBrandedProductBrochures flag value
     * @param pdfName
     * @param  pageSettings
     * @return
     * @throws ConfigSettingException
     */
    private String createBrochureDownloadLInk(String pdfName ,PageSettings pageSettings) throws ConfigSettingException, DaoException {
        String urlPrefix;
        int brand;
        brand = pageSettings.getBrandId();
        urlPrefix = pageSettings.getSetting("staticAssetUrl")+"health/brochures/";
        if(!urlPrefix.startsWith("http") && !urlPrefix.startsWith("//")){
            urlPrefix = pageSettings.getRootUrl() + urlPrefix;
        }
        if(pageSettings.getSetting("hasBrandedProductBrochures").equalsIgnoreCase("Y")){
            return urlPrefix + brand + pdfName;
        }else{
            return urlPrefix + "0" + pdfName;
        }
    }
}