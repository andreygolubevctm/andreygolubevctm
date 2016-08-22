package com.ctm.web.health.router;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.health.model.form.HealthRegisterPaymentRequest;
import com.ctm.web.health.model.results.HealthResultWrapper;
import com.ctm.web.health.services.HealthRegisterPaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

@RestController
@RequestMapping("/rest/health")
public class HealthRegisterPaymentController extends CommonQuoteRouter {

    @Autowired
    private HealthRegisterPaymentService healthRegisterPaymentService;

    @Autowired
    public HealthRegisterPaymentController(SessionDataServiceBean sessionDataServiceBean ,
                                           IPAddressHandler ipAddressHandler) {
        super(sessionDataServiceBean, ipAddressHandler);
    }

    @RequestMapping(value = "/payment/register.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8", MediaType.MULTIPART_FORM_DATA_VALUE},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public HealthResultWrapper authorise(HttpServletRequest request, @ModelAttribute final HealthRegisterPaymentRequest data) throws
            DaoException, IOException, ServiceConfigurationException, ConfigSettingException {

        Vertical.VerticalType vertical = HEALTH;

        // Initialise request
        Brand brand = initRouter(request, vertical);
        updateTransactionIdAndClientIP(request, data);

        HealthResultWrapper wrapper = new HealthResultWrapper();
        wrapper.setResult(healthRegisterPaymentService.register(brand, data));

        return wrapper;
    }

}
