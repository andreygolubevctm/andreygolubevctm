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
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope.SERVICE;
import static java.lang.Boolean.FALSE;
import static java.util.Collections.emptyList;

public class LeadFeedUtil {

    private static final Logger LOGGER = LoggerFactory.getLogger(LeadFeedUtil.class);

    public static boolean isServiceEnabled(final LeadType leadType, final LeadFeedData leadData) {
        try {
            final Provider provider = ProviderService.getProvider(leadData.getPartnerBrand(), ApplicationService.getServerDate());
            final ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration(leadType.getServiceUrlFlag(), leadData.getVerticalId());
            final Boolean serviceEnabled = Optional.ofNullable(serviceConfig.getPropertyValueByKey("serviceEnabled", leadData.getBrandId(), provider.getId(), SERVICE))
                                .map("TRUE"::equalsIgnoreCase)
                                .orElse(FALSE);
            if (serviceEnabled) {
                // Check for excluded products
                final List<String> excludeProductIds = Optional.ofNullable(serviceConfig.getPropertyValueByKey("excludeProductIds", leadData.getBrandId(), provider.getId(), SERVICE))
                                                            .map(v -> StringUtils.split(v, ","))
                                                            .map(Arrays::asList)
                                                            .orElse(emptyList());
                // Check if the leadData productId needs to be excluded
                if (excludeProductIds.contains(leadData.getProductId())) {
                    return false;
                }
            }
            return serviceEnabled;
        } catch (ServiceConfigurationException | DaoException e) {
            LOGGER.warn("[Lead feed] Failed checking getServiceEnabled {}", kv("leadData", leadData), e);
        }
        return false;
    }
}
