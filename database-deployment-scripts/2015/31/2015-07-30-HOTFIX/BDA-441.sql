USE aggregator;

--
-- Alter table "fuel_updates"
--
ALTER TABLE fuel_updates
 CHANGE COLUMN UpdateId UpdateId SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT;