package com.ctm.web.core.leadfeed.utils;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadType;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ProviderService;
import com.ctm.web.core.services.ServiceConfigurationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope.SERVICE;
import static java.lang.Boolean.FALSE;

public class LeadFeedUtil {

    private static final Logger LOGGER = LoggerFactory.getLogger(LeadFeedUtil.class);

    public static boolean isServiceEnabled(LeadType leadType, LeadFeedData leadData) {
        Optional<String> serviceEnabled = Optional.empty();
        try {
            Provider provider = ProviderService.getProvider(leadData.getPartnerBrand(), ApplicationService.getServerDate());
            final ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration(leadType.getServiceUrlFlag(), leadData.getVerticalId());
            serviceEnabled = Optional.ofNullable(serviceConfig.getPropertyValueByKey("serviceEnabled", leadData.getBrandId(), provider.getId(), SERVICE));
        } catch (ServiceConfigurationException | DaoException e) {
            LOGGER.warn("[Lead feed] Failed checking getServiceEnabled {}", kv("leadData", leadData), e);
        }
        return serviceEnabled.map("TRUE"::equalsIgnoreCase).orElse(FALSE);
    }
}
