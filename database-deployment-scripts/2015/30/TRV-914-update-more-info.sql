-- [TEST] SELECT count(productId) AS total FROM `ctm`.`product_properties` WHERE `ProductId` IN (22, 37, 38, 185, 186) AND Text = 'Australian owned & operated, authorised QBE agent 0012131. 21 day cooling off period, 24/7 QBE Assist, instant cover, online certificate issue & claims.' AND propertyid = 'infodes' AND SequenceNo = 0;
-- RESULT BEFORE UPDATE: 0

UPDATE `ctm`.`product_properties` SET `Text`='Australian owned & operated, authorised QBE agent 0012131. 21 day cooling off period, 24/7 QBE Assist, instant cover, online certificate issue & claims.' WHERE `ProductId` IN (22, 37, 38, 185, 186) AND propertyid = 'infodes' AND SequenceNo = 0 LIMIT 5;
-- RESULT AFTER  UPDATE: 5

-- =============================================================
-- ====================== ROLLBACK SCRIPT ======================
-- =============================================================


-- UPDATE `ctm`.`product_properties` SET `Text`='100% Australian owned &amp; operated, authorised QBE agent. 21 day cooling off period, 24/7 QBE Assist, instant cover, online certificate issue &amp; claims. Comprehensive plans include cover for dependant kids under 25, cruising &amp; most sporting activities free of charge.' WHERE `ProductId` IN (22, 37, 38, 185, 186) AND propertyid = 'infodes' AND SequenceNo = 0 LIMIT 5 LIMIT 5;