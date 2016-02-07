package com.ctm.web.core.router;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ApplicationService;

import javax.servlet.http.HttpServletRequest;

public abstract class CommonRouter {

    protected static Brand initRouter(HttpServletRequest httpServletRequest, Vertical.VerticalType vertical){
        // - Start common -- taken from Carlos' car branch
        ApplicationService.setVerticalCodeOnRequest(httpServletRequest, vertical.getCode());

        try {
            return ApplicationService.getBrandFromRequest(httpServletRequest);

        } catch (DaoException e) {
            throw new RouterException(e);
        }

    }

}
