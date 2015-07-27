-- PRE TEST
SELECT * FROM ctm.dialogue WHERE dialogueId = 21;

UPDATE ctm.dialogue SET text = 'This call is recorded for quality and training purposes only' WHERE dialogueId = 21;

-- TEST
SELECT * FROM ctm.dialogue WHERE dialogueId = 21;