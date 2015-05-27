-- Default / Production
UPDATE `ctm`.`service_properties` SET `servicePropertyValue` = 'https://services.ecommerce.disconline.com.au/services/3.2/getCarQuotes'
WHERE `environmentCode` = '0'
AND `servicePropertyKey` = 'soapUrl'
AND `servicePropertyValue` = 'https://services.ecommerce.disconline.com.au/services/3.1/getCarQuotes';

-- Localhost
UPDATE `ctm`.`service_properties` SET `servicePropertyValue` = 'https://nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes'
WHERE `environmentCode` = 'LOCALHOST'
AND `servicePropertyKey` = 'soapUrl'
AND `servicePropertyValue` = 'https://nxq.ecommerce.disconline.com.au/services/3.1/getCarQuotes';

-- NXI, NXS and NXQ
UPDATE `ctm`.`service_properties` SET `servicePropertyValue` = 'https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes'
WHERE `environmentCode` IN ('NXI', 'NXS', 'NXQ')
AND `servicePropertyKey` = 'soapUrl'
AND `servicePropertyValue` = 'https://services-nxq.ecommerce.disconline.com.au/services/3.1/getCarQuotes';

-- Rollback
/*
-- Default / Production
UPDATE `ctm`.`service_properties` SET `servicePropertyValue` = 'https://services.ecommerce.disconline.com.au/services/3.1/getCarQuotes'
WHERE `environmentCode` = '0'
AND `servicePropertyKey` = 'soapUrl'
AND `servicePropertyValue` = 'https://services.ecommerce.disconline.com.au/services/3.2/getCarQuotes';

-- Localhost
UPDATE `ctm`.`service_properties` SET `servicePropertyValue` = 'https://nxq.ecommerce.disconline.com.au/services/3.1/getCarQuotes'
WHERE `environmentCode` = 'LOCALHOST'
AND `servicePropertyKey` = 'soapUrl'
AND `servicePropertyValue` = 'https://nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes';

-- NXI, NXS and NXQ
UPDATE `ctm`.`service_properties` SET `servicePropertyValue` = 'https://services-nxq.ecommerce.disconline.com.au/services/3.1/getCarQuotes'
WHERE `environmentCode` IN ('NXI', 'NXS', 'NXQ')
AND `servicePropertyKey` = 'soapUrl'
AND `servicePropertyValue` = 'https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes';
*/