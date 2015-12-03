UPDATE `aggregator`.`help` SET `des`='Please review the following extended descriptions to see which of these apply to you:<br><br><b>Private and/or Commuting</b><br>Is use for social, domestic and pleasure purposes and also travelling between home and a regular place of work.<br><br><b>Private and Occasional Business</b><br>Is use for social, domestic and pleasure purposes travelling between home and a regular place of work. Also includes occasional business use by the regular driver or spouse only. Occasional business means the car is not registered for business use and not an essential part of earning income from such business.<br><br><b>Private and Business</b><br>Is use for social, domestic and pleasure purposes travelling between home and a regular place of work. Also includes use for the business of the regular driver or spouse by any driver listed on the policy.<br><br><b>Carry Goods for Reward</b><br><br><b>USE NEVER COVERED</b><br><br><b>Do you carry passengers or hire your car for reward or use your car for paid driving instruction? </b><br>Is use for carrying passengers for payment, driving tuition for payment or hiring the car to other people. Unfortunately the providers on our panel do not provide cover for this use.' WHERE `id`='8' and`styleCodeId`='0';

-- TEST 
-- BEFORE: 0
-- AFTER : 1
-- SELECT * FROM `aggregator`.`help` WHERE `des`='Please review the following extended descriptions to see which of these apply to you:<br><br><b>Private and/or Commuting</b><br>Is use for social, domestic and pleasure purposes and also travelling between home and a regular place of work.<br><br><b>Private and Occasional Business</b><br>Is use for social, domestic and pleasure purposes travelling between home and a regular place of work. Also includes occasional business use by the regular driver or spouse only. Occasional business means the car is not registered for business use and not an essential part of earning income from such business.<br><br><b>Private and Business</b><br>Is use for social, domestic and pleasure purposes travelling between home and a regular place of work. Also includes use for the business of the regular driver or spouse by any driver listed on the policy.<br><br><b>Carry Goods for Reward</b><br><br><b>USE NEVER COVERED</b><br><br><b>Do you carry passengers or hire your car for reward or use your car for paid driving instruction? </b><br>Is use for carrying passengers for payment, driving tuition for payment or hiring the car to other people. Unfortunately the providers on our panel do not provide cover for this use.' AND `id`='8' and`styleCodeId`='0';

-- ROLLBACK
/* UPDATE `aggregator`.`help` SET `des`='Please review the following extended descriptions to see which of these apply to you:<br><br><b>Private and/or Commuting</b><br>Is use for social, domestic and pleasure purposes and also travelling between home and a regular place of work.<br><br><b>Private and Occasional Business</b><br>Is use for social, domestic and pleasure purposes  travelling between home and a regular place of work. Also includes occasional business use by the regular driver or spouse only. Occasional business means the car is not registered for business use and not an essential part of earning income from such business.<br><br><b>Private and Business</b><br>Is use for social, domestic and pleasure purposes  travelling between home and a regular place of work. Also includes use for the business of the regular driver or spouse by any driver listed on the policy.<br><br><b>USE NEVER COVERED</b><br><b>Carry Goods/Passengers for Reward</b><br>Is use for carrying passengers or other people's goods for payment, driving tuition for payment or hiring the car to other people. Unfortunately the providers on our panel do not provide cover for this use.' WHERE `id`='8' and`styleCodeId`='0'; */