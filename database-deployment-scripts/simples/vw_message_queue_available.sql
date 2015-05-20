CREATE OR REPLACE VIEW `simples`.`message_queue_available` AS

	SELECT msg.*, stat.status
		, ( msg.callAttempts + msg.postponeCount) AS TotalCalls
		, IF(msg.postponeCount < src.maxPostpones, 1, 0) AS canPostpone
	FROM simples.message msg

	-- Join is for source settings like delay and expiry
	INNER JOIN simples.message_source src ON src.id = msg.sourceId
	-- Join for state based availability
	INNER JOIN simples.message_source_availability src_avail ON (src_avail.source_id = msg.sourceId AND src_avail.state = msg.state)
	-- Join for status text
	LEFT JOIN simples.message_status stat ON stat.id = msg.statusId

	WHERE
		-- Have we reached a time to action this message?
		(NOW() >= whenToAction)

		-- Has the message expired? (created + source expiry)
		AND (
			NOW() <  DATE_ADD(created,INTERVAL src.messageExpiry DAY)
			OR statusId = 4 /*Postponed*/
			OR statusId = 31 /*Completed as PM*/
			OR statusId = 32 /*Changed Time for PM*/
		)

		-- Is the source available at the current time?
		-- Timezone checks (see AGG-1961 for notes/research on this)
		AND (
			-- No need to convert QLD time because that's our local time!
			(msg.state = 'QLD' AND CURRENT_TIME() BETWEEN `src_avail`.`availableFrom` AND `src_avail`.`availableTo`)
			-- These can be hardcoded timezones because they don't have daylight saving:
			OR (msg.state = 'WA' AND TIME(CONVERT_TZ(NOW(), '+10:00', '+08:00')) BETWEEN `src_avail`.`availableFrom` AND `src_avail`.`availableTo`)
			OR (msg.state = 'NT' AND TIME(CONVERT_TZ(NOW(), '+10:00', '+09:30')) BETWEEN `src_avail`.`availableFrom` AND `src_avail`.`availableTo`)
			-- These require daylight savings support:
			OR (msg.state = 'SA' AND TIME(CONVERT_TZ(NOW(), '+10:00', 'Australia/Adelaide')) BETWEEN `src_avail`.`availableFrom` AND `src_avail`.`availableTo`)
			OR (msg.state = 'NSW' AND TIME(CONVERT_TZ(NOW(), '+10:00', 'Australia/Sydney')) BETWEEN `src_avail`.`availableFrom` AND `src_avail`.`availableTo`)
			OR (msg.state = 'TAS' AND TIME(CONVERT_TZ(NOW(), '+10:00', 'Australia/Hobart')) BETWEEN `src_avail`.`availableFrom` AND `src_avail`.`availableTo`)
			OR (msg.state = 'VIC' AND TIME(CONVERT_TZ(NOW(), '+10:00', 'Australia/Melbourne')) BETWEEN `src_avail`.`availableFrom` AND `src_avail`.`availableTo`)
			OR (msg.state = 'ACT' AND TIME(CONVERT_TZ(NOW(), '+10:00', 'Australia/Canberra')) BETWEEN `src_avail`.`availableFrom` AND `src_avail`.`availableTo`)
		)

		-- Have too many attempts been made?
		AND callAttempts < src.maxAttempts

		AND postponeCount <= src.maxPostpones

		-- Status check 2=Completed 7=Abandoned 33=Removed from PM
		AND msg.statusId NOT IN (2, 7, 33)