-- Update ctm.product_properties_search
-- Check 1806 before update
SELECT * FROM ctm.product_properties_search WHERE situationFilter='Y' LIMIT 999999;
-- Update ctm.product_properties_search
UPDATE ctm.product_properties_search SET situationFilter='N' WHERE situationFilter='Y' LIMIT 999999;
-- Check 0 after update
SELECT * FROM ctm.product_properties_search WHERE situationFilter='Y' LIMIT 999999;

-- Update ctm.product_properties
-- Check 1806 before update
SELECT * FROM ctm.product_properties WHERE PropertyId='situationFilter' AND Text='Y' LIMIT 999999;
-- Update ctm.product_properties
UPDATE ctm.product_properties SET Text='N' WHERE PropertyId='situationFilter' AND Text='Y' LIMIT 999999;
-- Check 0 after update
SELECT * FROM ctm.product_properties WHERE PropertyId='situationFilter' AND Text='Y' LIMIT 999999;