package com.ctm.web.core.router;

import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ApplicationService;

import javax.servlet.http.HttpServletRequest;

public abstract class CommonRouter {

    private final ApplicationService applicationService;

    public CommonRouter(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    public Brand initRouter(HttpServletRequest httpServletRequest, Vertical.VerticalType vertical) {
        return applicationService.getBrand(httpServletRequest, vertical);
    }
}
