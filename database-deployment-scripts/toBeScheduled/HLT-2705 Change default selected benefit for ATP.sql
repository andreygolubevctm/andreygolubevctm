-- RUN
UPDATE ctm.content_supplementary cs
JOIN ctm.content_control cc ON cs.contentControlId = cc.contentControlId
SET cs.supplementaryValue = 'Hospital,PrHospital'
WHERE cc.contentCode = 'Benefits'
AND cs.supplementaryKey = 'ATP';

-- ROLLBACK
UPDATE ctm.content_supplementary cs
JOIN ctm.content_control cc ON cs.contentControlId = cc.contentControlId
SET cs.supplementaryValue = 'Hospital,PuHospital'
WHERE cc.contentCode = 'Benefits'
AND cs.supplementaryKey = 'ATP';