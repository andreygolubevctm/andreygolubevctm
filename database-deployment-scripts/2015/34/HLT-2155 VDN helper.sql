-- New helper content for VDN input
INSERT INTO `aggregator`.`help` (`id`, `styleCodeId`, `header`, `des`) VALUES ('540', '0', 'VDN', 'the 4 digit number on the phone\'s screen after the word \"to\" <br />e.g. 0431000222 to xxxx CTM <br />OR <br />Optus lvl1 to xxxx CTM');

-- Register the new xpath
INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('2469', '0', '10', 'health/tracking/vdnInput', '4', '1', '0', '0', '0', '0', '2040-12-31 00:00:00');