package com.ctm.web.core.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.Vertical;
import org.springframework.stereotype.Component;

@Component
public class ServiceConfigurationServiceBean {


    /**
     * Get the service configuration for a specific code, vertical and brand - only call this directly if you are not able to rely on F5 rewriting rules.
     * @param code 'serviceCode' key in ctm.service_master
     * @param verticalId
     * @return
     * @throws DaoException
     * @throws ServiceConfigurationException
     */
    public ServiceConfiguration getServiceConfiguration(String code, Vertical vertical) throws DaoException, ServiceConfigurationException {
        return  ServiceConfigurationService.getServiceConfiguration( code, vertical.getId());
    }

    /**
     * Get the service configuration for a specific code, vertical and brand - only call this directly if you are not able to rely on F5 rewriting rules.
     * @param code 'serviceCode' key in ctm.service_master
     * @param verticalId
     * @return
     * @throws DaoException
     * @throws ServiceConfigurationException
     */
    public ServiceConfiguration getServiceConfiguration(String code, int verticalId) throws DaoException, ServiceConfigurationException {
            return ServiceConfigurationService.getServiceConfiguration( code, verticalId);
    }

}