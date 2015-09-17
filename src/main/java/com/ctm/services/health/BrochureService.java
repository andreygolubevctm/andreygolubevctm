package com.ctm.services.health;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.SettingsService;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

import static com.ctm.logging.LoggingArguments.v;

public class BrochureService {
    /**
     * This function will download the brochure for health
     * @param request
     * @param pdfName
     * @throws ConfigSettingException
     * @throws DaoException
     * @throws IOException
     */
    public String downloadBrochure(HttpServletRequest request, String pdfName) throws ConfigSettingException, DaoException, IOException, SessionException {
        PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, Vertical.VerticalType.HEALTH.getCode());
        return createBrochureDownloadLInk(pdfName,pageSettings);
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