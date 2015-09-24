-- PRE TEST
SELECT * FROM ctm.dialogue WHERE dialogueId = 21;

UPDATE ctm.dialogue SET text = 'This call and all future calls will be recorded for quality and training purposes' WHERE dialogueId = 21;

-- TEST
SELECT * FROM ctm.dialogue WHERE dialogueId = 21;