call `aggregator`.`aggregator.update_productCode_hlt_touchTable_procedure()`;
/*TEst
  If below query returns any record then let me know the o/p via comment
*/
select * from logging.sp_error_log where logmsg like 'upd_tch%' ;


DROP PROCEDURE IF EXISTS `aggregator`.`update_productCode_hlt_touchTable_procedure`;
DROP function IF EXISTS `aggregator`.`update_productCode_hlt_touchTable_function`;