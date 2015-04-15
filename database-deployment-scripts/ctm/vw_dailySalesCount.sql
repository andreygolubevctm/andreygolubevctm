USE `ctm`;

CREATE
OR REPLACE ALGORITHM = UNDEFINED
  DEFINER = `server`@`%`
  SQL SECURITY DEFINER
VIEW `ctm`.`vw_dailySalesCount` AS
  SELECT
    `pm`.`ProviderId` AS `providerId`,
    COUNT(`j`.`rootId`) AS `currentJoinCount`,
    `pp`.`Text` AS `maxJoins`,
    'STATE' AS `limitType`,
    `pps`.`state` AS `limitValue`,
    `pm`.`ProductCat` AS `vertical`
  FROM
    (((`ctm`.`joins` `j`
      JOIN `ctm`.`product_properties_search` `pps` ON ((`pps`.`productId` = `j`.`productId`)))
      JOIN `ctm`.`product_master` `pm` ON ((`pps`.`productId` = `pm`.`ProductId`)))
      JOIN `ctm`.`provider_properties` `pp` ON (((`pp`.`PropertyId` = CONCAT('DailyLimit', `pps`.`state`))
                                                 AND (`pp`.`EffectiveStart` <= CURDATE())
                                                 AND (`pp`.`EffectiveEnd` >= CURDATE())
                                                 AND (`pp`.`ProviderId` = `pm`.`ProviderId`))))
  WHERE
    (`j`.`joinDate` = CURDATE())
    AND j.productId NOT IN (
      SELECT pce.productId
      FROM ctm.product_capping_exclusions pce
      WHERE `j`.`joinDate`  between pce.effectiveStart and pce.effectiveEnd
    )
  GROUP BY `pm`.`ProviderId` , `pps`.`state` , `pm`.`ProductCat`
  UNION SELECT
          `pm`.`ProviderId` AS `providerId`,
          COUNT(`j`.`rootId`) AS `currentJoinCount`,
          `pp`.`Text` AS `maxJoins`,
          'GENERAL' AS `limitType`,
          '' AS `limitValue`,
          `pm`.`ProductCat` AS `vertical`
        FROM
          (((`ctm`.`joins` `j`
            JOIN `ctm`.`product_properties_search` `pps` ON ((`pps`.`productId` = `j`.`productId`)))
            JOIN `ctm`.`product_master` `pm` ON ((`pps`.`productId` = `pm`.`ProductId`)))
            JOIN `ctm`.`provider_properties` `pp` ON (((`pp`.`PropertyId` = 'DailyLimit')
                                                       AND (`pp`.`ProviderId` = `pm`.`ProviderId`)
                                                       AND (`pp`.`EffectiveStart` <= CURDATE())
                                                       AND (`pp`.`EffectiveEnd` >= CURDATE()))))
        WHERE
          (`j`.`joinDate` = CURDATE())
          AND j.productId NOT IN (
            SELECT pce.productId
            FROM ctm.product_capping_exclusions pce
            WHERE `j`.`joinDate`  between pce.effectiveStart and pce.effectiveEnd
          )
        GROUP BY `pm`.`ProviderId` , `pm`.`ProductCat`;