USE `ctm`;

CREATE
OR REPLACE ALGORITHM = UNDEFINED
  DEFINER = `server`@`%`
  SQL SECURITY DEFINER
VIEW `ctm`.`vw_monthlySalesCount` AS
  select `pm`.`ProviderId` AS `providerId`,count(`j`.`rootId`)
                           AS `currentJoinCount`,`pp`.`Text` AS `maxJoins`,'STATE' AS `limitType`,`pps`.`state`
                           AS `limitValue`,`pm`.`ProductCat` AS `vertical` from (((`ctm`.`joins` `j`
    join `ctm`.`product_properties_search` `pps` on((`pps`.`productId` = `j`.`productId`)))
    join `ctm`.`product_master` `pm` on((`pps`.`productId` = `pm`.`ProductId`)))
    join `ctm`.`provider_properties` `pp` on(((`pp`.`PropertyId` = concat('MonthlyLimit',`pps`.`state`))

                                              and (`pp`.`EffectiveStart` <= curdate()) and (`pp`.`EffectiveEnd` >= curdate())
                                              and (`pp`.`ProviderId` = `pm`.`ProviderId`))))
  where ((month(`j`.`joinDate`) = month(curdate()))
         and (year(`j`.`joinDate`) = year(curdate())))
        AND j.productId NOT IN (
    SELECT pce.productId
    FROM ctm.product_capping_exclusions pce
    WHERE `j`.`joinDate`  between pce.effectiveStart and pce.effectiveEnd
  )
  group by `pm`.`ProviderId`,`pps`.`state`,`pm`.`ProductCat`
  union select `pm`.`ProviderId` AS `providerId`,count(`j`.`rootId`) AS `currentJoinCount`,`pp`.`Text`
                                 AS `maxJoins`,'GENERAL' AS `limitType`,'' AS `limitValue`,`pm`.`ProductCat` AS `vertical`
        from (((`ctm`.`joins` `j` join `ctm`.`product_properties_search` `pps`
            on((`pps`.`productId` = `j`.`productId`))) join `ctm`.`product_master` `pm`
            on((`pps`.`productId` = `pm`.`ProductId`))) join `ctm`.`provider_properties` `pp`
            on(((`pp`.`PropertyId` = 'MonthlyLimit') and (`pp`.`ProviderId` = `pm`.`ProviderId`)
                and (`pp`.`EffectiveStart` <= curdate()) and (`pp`.`EffectiveEnd` >= curdate()))))
        where ((month(`j`.`joinDate`) = month(curdate()))
               and (year(`j`.`joinDate`) = year(curdate())))
              AND j.productId NOT IN (
          SELECT pce.productId
          FROM ctm.product_capping_exclusions pce
          WHERE `j`.`joinDate` between pce.effectiveStart and pce.effectiveEnd
        )
        group by `pm`.`ProviderId`,`pm`.`ProductCat`;