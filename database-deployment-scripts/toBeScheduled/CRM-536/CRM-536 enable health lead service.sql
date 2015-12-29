INSERT INTO `ctm`.`service_master` (`verticalId`, `serviceCode`) VALUES ('4', 'leadService');

INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES
((SELECT serviceMasterId FROM ctm.service_master WHERE verticalId = '4' AND serviceCode = 'leadService'), '0', '0', '0', 'enabled', 'false', '2014-01-01 00:00:00', '2040-01-01 00:00:00', 'SERVICE'),
((SELECT serviceMasterId FROM ctm.service_master WHERE verticalId = '4' AND serviceCode = 'leadService'), 'LOCALHOST', '0', '0', 'url', 'http://localhost:9040/lead/', '2014-01-01 00:00:00', '2040-01-01 00:00:00', 'SERVICE'),
((SELECT serviceMasterId FROM ctm.service_master WHERE verticalId = '4' AND serviceCode = 'leadService'), 'NXI', '0', '0', 'url', 'http://127.0.0.1:8080/ctm-leads/lead/', '2014-01-01 00:00:00', '2040-01-01 00:00:00', 'SERVICE'),
((SELECT serviceMasterId FROM ctm.service_master WHERE verticalId = '4' AND serviceCode = 'leadService'), 'NXQ', '0', '0', 'url', 'http://127.0.0.1:8080/ctm-leads/lead/', '2014-01-01 00:00:00', '2040-01-01 00:00:00', 'SERVICE'),
((SELECT serviceMasterId FROM ctm.service_master WHERE verticalId = '4' AND serviceCode = 'leadService'), 'NXS', '0', '0', 'url', 'http://127.0.0.1:8080/ctm-leads/lead/', '2014-01-01 00:00:00', '2040-01-01 00:00:00', 'SERVICE'),
((SELECT serviceMasterId FROM ctm.service_master WHERE verticalId = '4' AND serviceCode = 'leadService'), 'PRO', '0', '0', 'url', 'http://ecommerce.disconline.com.au:8080/ctm-leads/lead/', '2014-01-01 00:00:00', '2040-01-01 00:00:00', 'SERVICE');
