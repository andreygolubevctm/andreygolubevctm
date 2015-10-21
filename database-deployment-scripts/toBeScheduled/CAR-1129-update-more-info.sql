SET @Dodo = (SELECT carProductId FROM ctm.car_product WHERE code = 'EXDD-05-04');
SET @AusPost = (SELECT carProductId FROM ctm.car_product WHERE code = 'EXPO-05-16');

SET @AusPostUpdate = '<ul>  <li>24 months or 40,000km new for old car replacement cover</li>  <li>No excess to pay when third party is identified and at fault</li>  <li>No claim discount preserved when third party is identified and at fault</li>  <li>Personal effects cover in the event of a collision (up to $500)</li>  <li>Key and remote replacement cover ($1,000)</li>  <li>Child safety seats replacement (for damage to or theft of child seats/baby capsule in your car, up to $500)</li>  <li>Hire car cover when vehicle stolen (up to 14 days or $1000)</li>  <li>Damage to trailer and caravan if attached to your car (belonging to you, up to $1000)</li>  <li>Death benefit ($5000)</li>  <li>Emergency transport and accommodation cover ($100 per day, $850 in total)</li>  <li>Removal of debris in the event of a collision ($500)</li> </ul>';
SET @DodoUpdate = '<ul>  <li>24 months or 40,000km new for old car replacement cover</li>  <li>No excess to pay when third party is identified and at fault</li>  <li>Key &amp; remote replacement cover ($1,000)</li>  <li>Child safety seats replacement (for damage to or theft of child seats/baby capsule in your car) ($500)</li>  <li>Hire Car Cover when vehicle stolen (up to 14 days) ($1000)</li>  <li>Damage to Trailer and Caravan if attached to your car (belonging to you) ($1000)</li>  <li>Death benefit ($5000)</li>  <li>Emergency Transport &amp; Accommodation cover ($100 per day, $850 in total)</li> </ul>';

-- ============== Tests BEFORE Update ==============
-- AusPost
-- SELECT count(*) FROM `ctm`.`car_product_content` WHERE `inclusions`= @AusPostUpdate AND `carProductId`= @AusPost;
-- TEST BEFORE RESULT : 0

-- Dodo
-- SELECT count(*) FROM `ctm`.`car_product_content` WHERE `inclusions`= @DodoUpdate AND `carProductId`= @Dodo;
-- TEST BEFORE RESULT : 0

UPDATE `ctm`.`car_product_content` SET `inclusions`= @AusPostUpdate WHERE `carProductId`= @AusPost LIMIT 1;
UPDATE `ctm`.`car_product_content` SET `inclusions`= @DodoUpdate WHERE `carProductId`=@Dodo LIMIT 1;


-- ============== Tests AFTER Update ==============
-- AusPost
-- SELECT count(*) FROM `ctm`.`car_product_content` WHERE `inclusions`= @AusPostUpdate AND `carProductId`= @AusPost;
-- TEST BEFORE RESULT : 1

-- Dodo
-- SELECT count(*) FROM `ctm`.`car_product_content` WHERE `inclusions`= @DodoUpdate AND `carProductId`= @Dodo;
-- TEST BEFORE RESULT : 1


-- ============== ROLLBACK ==============
-- SET @AusPostOLDContent = '<ul>  <li>24 months or 40,000km new for old car replacement cover</li>  <li>No excess to pay when third party is identified as at fault</li>  <li>No claim discount preserved when third party is identified and at fault</li>  <li>Personal effects cover in the event of a collision (up to $500)</li>  <li>Key and remote replacement cover ($1,000)</li>  <li>Child safety seats replacement (for damage to or theft of child seats/baby capsule in your car, up to $500)</li>  <li>Hire car cover when vehicle stolen (up to 14 days or $1000)</li>  <li>Damage to trailer and caravan if attached to your car (belonging to you, up to $1000)</li>  <li>Death benefit ($5000)</li>  <li>Emergency transport and accommodation cover ($100 per day, $850 in total)</li>  <li>Removal of debris in the event of a collision ($500)</li> </ul>';
-- SET @DodOLDContent = '<ul>  <li>24 months or 40,000km new for old car replacement cover</li>  <li>No excess to pay when third party is identified as at fault</li>  <li>Key &amp; remote replacement cover ($1,000)</li>  <li>Child safety seats replacement (for damage to or theft of child seats/baby capsule in your car) ($500)</li>  <li>Hire Car Cover when vehicle stolen (up to 14 days) ($1000)</li>  <li>Damage to Trailer and Caravan if attached to your car (belonging to you) ($1000)</li>  <li>Death benefit ($5000)</li>  <li>Emergency Transport &amp; Accommodation cover ($100 per day, $850 in total)</li> </ul>';

-- AustPost
-- UPDATE `ctm`.`car_product_content` SET `inclusions`= @AusPostOLDContent WHERE `carProductId`= @AusPost LIMIT 1;

-- Dodo
-- UPDATE `ctm`.`car_product_content` SET `inclusions`= @DodOLDContent WHERE `carProductId`= @Dodo LIMIT 1;

-- ============== Tests AFTER Rollback Update ==============
-- AusPost
-- SELECT count(*) FROM `ctm`.`car_product_content` WHERE `inclusions`= @AusPostOLDContent AND `carProductId`= @AusPost;
-- TEST BEFORE RESULT : 1

-- Dodo
-- SELECT count(*) FROM `ctm`.`car_product_content` WHERE `inclusions`= @DodOLDContent AND `carProductId`= @Dodo;
-- TEST BEFORE RESULT : 1