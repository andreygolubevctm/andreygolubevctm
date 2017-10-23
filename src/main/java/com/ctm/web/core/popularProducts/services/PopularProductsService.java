package com.ctm.web.core.popularProducts.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.services.SettingsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by pgopisetty on 26/09/2017.
 */
public class PopularProductsService {

    private static final Logger LOGGER = LoggerFactory.getLogger(PopularProductsService.class);

    public PopularProductsService() {
    }

    /**
     * Used in popular_products_settings.jsp
     */
    @SuppressWarnings("unused")
    public Boolean showPopularProducts(final HttpServletRequest request, final String vertical) throws DaoException, ConfigSettingException {
        return SettingsService.getPageSettingsForPage(request, vertical)
                .getSettingAsBoolean("showPopularProducts");
    }
}
