# SELECT * FROM simples.role_rule_set;
# Delete association between role "Consultant Outbound (Bottom Performer)" and the "expired leads" ruleset
DELETE FROM simples.role_rule_set WHERE roleId = 3 and ruleSetId = 2;

# SELECT * FROM simples.role;
# Delete old role called "Consultant Outbound (Bottom Performer)"
DELETE FROM simples.role WHERE id = 3;

# SELECT * FROM simples.rule_rule_set;
# Delete associations between "expired" ruleset and its rules
DELETE FROM simples.rule_rule_set WHERE ruleSetId = 2;
# Fix up the duplicate same rule to use the initial one
UPDATE simples.rule_rule_set SET effectiveEnd = "2039-12-31" WHERE id = 4; # extend again the initial one
DELETE FROM simples.rule_rule_set WHERE ruleId = 17; # remove the duplicate

# SELECT * FROM simples.rule_set;
# Delete "expired" ruleset
DELETE FROM simples.rule_set WHERE id = 2;

# SELECT * FROM simples.rule;
# Delete "expired" ruleset
DELETE FROM simples.rule WHERE description IN(
"Expired - Messages assigned to users, (InProgress, Postponed, Assigned, Unsuccessful), deal with your current message", #id 5
"Expired - CTM fail joins/WHITELABEL fail joins, last in first out", #id 6
"Expired - Messages assigned to users, (Personal Messages)", #id 7
"Expired - All other messages, Sort by dates THEN new THEN Postponed THEN Unsuccessful and Last In Last Out", #id 8
"Copy of rule 4 (All other messages, Sort by dates THEN new THEN Postponed THEN Unsuccessful and Last In Last Out)" #id 17
);

# Drop the current "expired" view
DROP VIEW simples.message_queue_expired;