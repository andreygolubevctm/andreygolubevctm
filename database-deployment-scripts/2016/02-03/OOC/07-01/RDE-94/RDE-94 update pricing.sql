-- Run
UPDATE ctm.roadside_rates rr
JOIN ctm.product_master pm ON rr.ProductId = pm.ProductId
SET Value = '74.95', Text = '$74.95'
WHERE ProviderId = 54
AND PropertyId IN ('NSW-ACT', 'QLD', 'SA', 'TAS', 'VIC', 'WA');

-- Rollback
/*
UPDATE ctm.roadside_rates rr
JOIN ctm.product_master pm ON rr.ProductId = pm.ProductId
SET Value = '69.95', Text = '$69.95'
WHERE ProviderId = 54
AND PropertyId IN ('NSW-ACT', 'QLD', 'SA', 'TAS', 'VIC', 'WA');
*/