package com.ctm.web.life.occupation;

import com.ctm.life.occupation.model.response.Occupation;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.router.CommonRouter;
import com.ctm.web.life.services.LifeOccupationService;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.LIFE;

public class LifeOccupationUtils extends CommonRouter {

    public static List<Occupation> occupations(HttpServletRequest request) throws DaoException, IOException, ServiceConfigurationException {
        final WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(request.getServletContext());
        return applicationContext.getBean(LifeOccupationService.class).getOccupations(initRouter(request, LIFE));
    }

}
