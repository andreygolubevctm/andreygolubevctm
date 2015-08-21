-- validate
SELECT * FROM ctm.service_properties WHERE serviceMasterId = (SELECT serviceMasterId FROM ctm.service_master WHERE serviceCode = 'carServiceBER')
AND environmentCode = 'PRO' AND servicePropertyValue = 'https://services.ecommerce.disconline.com.au/services/3.2/getCarQuotes';

-- update
UPDATE ctm.service_properties SET servicePropertyValue = 'https://services.ecommerce.disconline.com.au/services/3.2/getCarQuotes'
WHERE serviceMasterId = (SELECT serviceMasterId FROM ctm.service_master WHERE serviceCode = 'carServiceBER')
AND environmentCode = 'PRO' AND servicePropertyValue = 'https://ecommerce.disconline.com.au/services/3.2/getCarQuotes';