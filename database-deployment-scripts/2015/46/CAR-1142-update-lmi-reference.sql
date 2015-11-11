UPDATE `aggregator`.`features_product_mapping` SET `lmi_Ref`='059_0915_24071' WHERE `lmi_Ref`='054_0412_13251' AND ctm_ProductId = 'REIN-01-02' LIMIT 1;

-- SELECT count(*) AS total FROM `aggregator`.`features_product_mapping` WHERE `lmi_Ref`='059_0915_24071' AND ctm_ProductId = 'REIN-01-02';
-- TEST AFTER UPDATE: 1


-- ROLLBACK
-- UPDATE `aggregator`.`features_product_mapping` SET `lmi_Ref`='054_0412_13251' WHERE `lmi_Ref`='059_0915_24071' AND ctm_ProductId = 'REIN-01-02' LIMIT 1;

-- SELECT count(*) AS total FROM `aggregator`.`features_product_mapping` WHERE `lmi_Ref`='059_0915_24071' AND ctm_ProductId = 'REIN-01-02';
-- TEST AFTER UPDATE: 0