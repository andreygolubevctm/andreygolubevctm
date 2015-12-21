
UPDATE ctm.content_control SET effectiveEnd='2015-12-15 06:59:59' WHERE verticalId IN (6,8) AND contentkey='footerParticipatingSuppliers' AND effectiveEnd='2038-01-19 00:00:00';

INSERT INTO ctm.content_control (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `contentStatus`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES
  (1, 6, 'Footer', 'footerParticipatingSuppliers', '', '2015-12-15 07:00:00', '2038-01-19 00:00:00', 'Zurich, AIA, OnePath, TAL, AMP, Asteron Life, CommInsure, Macquarie and Ozicare'),
  (1, 8, 'Footer', 'footerParticipatingSuppliers', '', '2015-12-15 07:00:00', '2038-01-19 00:00:00', 'Zurich, AIA, OnePath, TAL, AMP, Asteron Life, CommInsure, Macquarie and Ozicare');