CREATE OR REPLACE VIEW `simples`.`message_queue_available` AS

	SELECT msg.*, stat.status
		, IF(msg.postponeCount < src.maxPostpones, 1, 0) AS canPostpone
	FROM simples.message msg

	-- Join is for source settings like delay and expiry
	INNER JOIN simples.message_source src ON src.id = msg.sourceId
	-- Join for status text
	LEFT JOIN simples.message_status stat ON stat.id = msg.statusId

	WHERE
		-- Have we reached a time to action this message?
		(NOW() >= whenToAction)

		-- Has the message expired? (created + source expiry)
		AND (
			NOW() < ADDTIME(created, SEC_TO_TIME(src.messageExpiry * 60))
			OR statusId = 4 /*Postponed*/
			OR statusId = 31 /*Completed as PM*/
			OR statusId = 32 /*Changed Time for PM*/
		)

		-- Is the source available at the current time?
		-- Timezone checks (see AGG-1961 for notes/research on this)
		AND (
			-- No need to convert QLD time because that's our local time!
			   (state = 'QLD' AND CURRENT_TIME() BETWEEN src.availableFrom AND src.availableTo)
			-- These can be hardcoded timezones because they don't have daylight saving:
			OR (state = 'WA' AND TIME(CONVERT_TZ(NOW(), '+10:00', '+08:00')) BETWEEN src.availableFrom AND src.availableTo)
			OR (state = 'NT' AND TIME(CONVERT_TZ(NOW(), '+10:00', '+09:30')) BETWEEN src.availableFrom AND src.availableTo)
			-- These require daylight savings support:
			OR (state = 'SA' AND TIME(CONVERT_TZ(NOW(), '+10:00', 'Australia/Adelaide')) BETWEEN src.availableFrom AND src.availableTo)
			OR (state = 'NSW' AND TIME(CONVERT_TZ(NOW(), '+10:00', 'Australia/Sydney')) BETWEEN src.availableFrom AND src.availableTo)
			OR (state = 'TAS' AND TIME(CONVERT_TZ(NOW(), '+10:00', 'Australia/Hobart')) BETWEEN src.availableFrom AND src.availableTo)
			OR (state = 'VIC' AND TIME(CONVERT_TZ(NOW(), '+10:00', 'Australia/Melbourne')) BETWEEN src.availableFrom AND src.availableTo)
			OR (state = 'ACT' AND TIME(CONVERT_TZ(NOW(), '+10:00', 'Australia/Canberra')) BETWEEN src.availableFrom AND src.availableTo)
		)

		-- Have too many attempts been made?
		AND callAttempts < src.maxAttempts

		AND postponeCount <= src.maxPostpones

		-- Status check 2=Completed 7=Abandoned 33=Removed from PM
		AND msg.statusId NOT IN (2, 7, 33)

		AND (
			simples.isInAntiHawkingTimeframe(NOW(), state) < 1 /* If customer's timezone is not in hawking time frame, okToCall */
			OR (
				msg.hawkingOptin = 'Y' /* user has to tick the hawkingOptin */
				AND simples.isInAntiHawkingTimeframe(created, state) = 1 /* message has to be created during hawking time frame */
				AND YEARWEEK(created, 1) = YEARWEEK(NOW(), 1) /* message has to be created in current week */
			)
		)
