-- TEST
SELECT * from `test`.`help`
WHERE `id`='413';

-- UPDATE
UPDATE `test`.`help` SET `des`='<div><!--spacer--></div>No - I am already living at this address and want to change my energy company<div><!--spacer--></div>Yes - I need to set up energy accounts as I am going to move into this property (or have recently moved in and not yet set up accounts)' WHERE `id`='413';