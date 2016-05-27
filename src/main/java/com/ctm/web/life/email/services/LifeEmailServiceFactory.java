package com.ctm.web.life.email.services;

import com.ctm.web.core.email.mapping.EmailDetailsMappings;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.EmailDetailsFactory;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.web.go.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class LifeEmailServiceFactory  {

	private final EmailDetailsFactory emailDetailsFactory;
    private final ApplicationService applicationService;
    private final LifeEmailDataService lifeEmailDataService;
	private final IPAddressHandler ipAddressHandler;
	protected TransactionDao transactionDao;
    private ServiceConfigurationServiceBean serviceConfigurationService;

    @Autowired
	public LifeEmailServiceFactory( EmailDetailsFactory emailDetailsFactory,
								   TransactionDao transactionDao,
								   LifeEmailDataService lifeEmailDataService,
									ServiceConfigurationServiceBean serviceConfigurationService,
								   ApplicationService applicationService, IPAddressHandler ipAddressHandler) {
		this.emailDetailsFactory = emailDetailsFactory;
        this.transactionDao = transactionDao;
        this.serviceConfigurationService = serviceConfigurationService;
        this.applicationService = applicationService;
        this.lifeEmailDataService = lifeEmailDataService;
		this.ipAddressHandler = ipAddressHandler;
	}

	public LifeEmailService getInstance(PageSettings pageSettings,
										EmailMode emailMode, Data data, String brandCode,
										String vertical, EmailDetailsMappings emailDetailMappings)  {
		return new LifeEmailService( pageSettings,
				 emailMode,
				emailDetailsFactory.getInstance( data,
						 brandCode,
						 vertical,
						 emailDetailMappings),
				 lifeEmailDataService,
				 serviceConfigurationService,
				 applicationService,
				ipAddressHandler);
	}
	
}
