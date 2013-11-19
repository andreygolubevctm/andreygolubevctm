delimiter $$
CREATE TABLE `aggregator`.`ranking_details_data` (
`TransactionId` int(11) NOT NULL,
`CalcSequence` int(11) NOT NULL,
`RankSequence` int(11) NOT NULL,
`RankPosition` int(11) NOT NULL,
`property` varchar(255) NOT NULL,
`value` varchar(255) NOT NULL,
PRIMARY KEY  (`TransactionId`,`CalcSequence`,`RankSequence`,`RankPosition`,`property`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$