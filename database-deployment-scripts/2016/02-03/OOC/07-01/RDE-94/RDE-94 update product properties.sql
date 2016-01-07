-- Run
UPDATE ctm.product_properties pp
JOIN ctm.product_master pm ON pp.productId = pm.productId
SET pp.Text = "Budget Direct Roadside Assistance service provided by Ultra Tune Roadside Assistance ensures that you won't be left stranded in the event of a breakdown. For just under $1.50 a week and with no joining fee, you will have access to an extensive national roadside assistance fleet."
WHERE productCat = 'ROADSIDE'
AND SequenceNo = 0
AND ProviderId = 54
AND PropertyId = 'infoDes';

UPDATE ctm.product_properties pp
JOIN ctm.product_master pm ON pp.productId = pm.productId
SET pp.value = '125', pp.Text = 'Up to $125.00'
WHERE productCat = 'ROADSIDE'
AND SequenceNo = 0
AND ProviderId = 54
AND PropertyId = 'keyService';

UPDATE ctm.product_properties pp
JOIN ctm.product_master pm ON pp.productId = pm.productId
SET pp.value = '1000000000', pp.Text = 'Unlimited (conditions apply)'
WHERE productCat = 'ROADSIDE'
AND SequenceNo = 0
AND ProviderId = 54
AND PropertyId = 'roadCall';

UPDATE ctm.product_properties pp
JOIN ctm.product_master pm ON pp.productId = pm.productId
SET pp.value = '15', pp.Text = '15 KM'
WHERE productCat = 'ROADSIDE'
AND SequenceNo = 0
AND ProviderId = 54
AND PropertyId = 'towing';

UPDATE ctm.product_properties pp
JOIN ctm.product_master pm ON pp.productId = pm.productId
SET pp.value = '50', pp.Text = '50 KM Round Trip'
WHERE productCat = 'ROADSIDE'
AND SequenceNo = 0
AND ProviderId = 54
AND PropertyId = 'towingCountry';

UPDATE ctm.product_properties pp
JOIN ctm.product_master pm ON pp.productId = pm.productId
SET pp.value = '3.5', pp.Text = 'Up to 3.5 tonne'
WHERE productCat = 'ROADSIDE'
AND SequenceNo = 0
AND ProviderId = 54
AND PropertyId = 'vehCoverage';

-- Rollback
/*
UPDATE ctm.product_properties pp
JOIN ctm.product_master pm ON pp.productId = pm.productId
SET pp.Text = "Budget Direct Roadside Assistance service provided by Ultra Tune Roadside Assistance ensures that you won't be left stranded in the event of a breakdown. For just over $1 a week and no joining fee, you will have access to an extensive national roadside assistance fleet."
WHERE productCat = 'ROADSIDE'
AND SequenceNo = 0
AND ProviderId = 54
AND PropertyId = 'infoDes';

UPDATE ctm.product_properties pp
JOIN ctm.product_master pm ON pp.productId = pm.productId
SET pp.value = '55', pp.Text = 'Up to $55.00'
WHERE productCat = 'ROADSIDE'
AND SequenceNo = 0
AND ProviderId = 54
AND PropertyId = 'keyService';

UPDATE ctm.product_properties pp
JOIN ctm.product_master pm ON pp.productId = pm.productId
SET pp.value = '4', pp.Text = '4'
WHERE productCat = 'ROADSIDE'
AND SequenceNo = 0
AND ProviderId = 54
AND PropertyId = 'roadCall';

UPDATE ctm.product_properties pp
JOIN ctm.product_master pm ON pp.productId = pm.productId
SET pp.value = '10', pp.Text = '10 KM'
WHERE productCat = 'ROADSIDE'
AND SequenceNo = 0
AND ProviderId = 54
AND PropertyId = 'towing';

UPDATE ctm.product_properties pp
JOIN ctm.product_master pm ON pp.productId = pm.productId
SET pp.value = '40', pp.Text = '40 KM Round Trip'
WHERE productCat = 'ROADSIDE'
AND SequenceNo = 0
AND ProviderId = 54
AND PropertyId = 'towingCountry';

UPDATE ctm.product_properties pp
JOIN ctm.product_master pm ON pp.productId = pm.productId
SET pp.value = '2.5', pp.Text = 'Up to 2.5 tonne'
WHERE productCat = 'ROADSIDE'
AND SequenceNo = 0
AND ProviderId = 54
AND PropertyId = 'vehCoverage';
*/