<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/ctm" />

<security:populateDataFromParams rootPath="request" />

<c:set var="errors" value="" />

<go:log>
THE PARAMS FOR DIARY:
${param}

THE DATA:
${data.request}

AUTHOR D? ${data.request['/*/author']}
COMMSID D? ${data.request['/*/commsId']}
</go:log>

<%-- Setting the appropriate dates --%>
<c:set var="startDate" value="" />
<c:set var="endTime" value="" />

<c:if test="${not empty data.request['/*/dateStart']}">
	<c:set var="startDate" value="${data.request['/*/dateStart']}" />
	<c:if test="${not empty data.request['/*/timeStart']}">
		<c:set var="startDate" value="${startDate}, ${data.request['/*/timeStart']}" />
	</c:if>
</c:if>

<c:choose>
	<c:when test="${not empty data.request['/*/dateEnd']}">
		<c:set var="endDate" value="${data.request['/*/dateEnd']}" />
		<c:if test="${not empty data.request['/*/timeEnd']}">
			<c:set var="endDate" value="${endDate}, ${data.request['/*/timeEnd']}" />
		</c:if>
	</c:when>
	<c:otherwise>
		<c:set var="endDate" value="${data.request['/*/dateStart']}" />
		<c:choose>
			<c:when test="${not empty data.request['/*/timeEnd']}">
				<c:set var="endDate" value="${endDate}, ${data.request['/*/timeEnd']}" />
			</c:when>
			<c:when test="${not empty data.request['/*/timeStart']}">
				<c:set var="endDate" value="${endDate}, ${data.request['/*/timeStart']}" />
			</c:when>
		</c:choose>
	</c:otherwise>
</c:choose>

<c:if test="${empty data.request['/*/author']}">
	<go:setData dataVar="data" xpath="request/diary/form/author" value="${data['login/user/uid']}" />

</c:if>
<c:if test="${empty data.request['/*/owner']}">
	<go:setData dataVar="data" xpath="request/diary/form/owner" value="${data['login/user/uid']}" />

</c:if>


<%-- UPDATE or INSERT --%>
<c:choose>
	<%-- INSERT: a new message --%>
	<c:when test="${empty data.request['/*/commsId'] || data.request['/*/commsId'] == 0}">

		<go:log>
				FIRST INSERT
				<sql-update var="update">
					INSERT INTO `ctm`.`comms`
					SET `parentId` = ?, `type` = 'd', `title` = ?, `author` = ?, `owner` = ?, `message` = ?, `createTime` = now();
					<sql- param value="${data.request['/*/parentId']}" />
					<sql- param value="${data.request['/*/title']}" />
					<sql- param value="${data.request['/*/author']}" />
					<sql- param value="${data.request['/*/owner']}" />
					<sql- param value="${data.request['/*/message']}" />
				</sql-update>
		</go:log>

		<sql:transaction>
			<%-- INSERT: part 1 --%>
			<c:catch var="error">
				<sql:update var="update">
					INSERT INTO `ctm`.`comms`
					SET `parentId` = ?, `type` = 'd', `title` = ?, `author` = ?, `owner` = ?, `message` = ?, `createTime` = now();
					<sql:param value="${data.request['/*/parentId']}" />
					<sql:param value="${data.request['/*/title']}" />
					<sql:param value="${data.request['/*/author']}" />
					<sql:param value="${data.request['/*/owner']}" />
					<sql:param value="${data.request['/*/message']}" />
				</sql:update>
			</c:catch>

			<c:catch var="test1">
				<sql:query var="result">
					SELECT max(commsId) as lastinserted from `ctm`.`comms`;
				</sql:query>
			</c:catch>

			<go:log>
						SECOND INSERT
						<sql- update var="update2">
							INSERT INTO `ctm`.`diaries`
							SET `commsId` = ?, `allDay` = ?, `url` = ?, `startTime` = ?, `endTime` = ?;
							<sql- param value="${result.rows[0]['lastinserted']}" />
							<sql- param value="${data.request['/*/allDay']}" />
							<sql- param value="${data.request['/*/url']}" />
							<sql- param value="${startDate}" />
							<sql- param value="${endDate}" />
						</sql- update>
			</go:log>


			<%-- INSERT: part 2 --%>
			<c:choose>
				<c:when test="${result.rowCount > 0 && empty error}">
					<c:catch var="error2">
						<sql:update var="update2">
							INSERT INTO `ctm`.`diaries`
							SET `commsId` = ?, `allDay` = ?, `url` = ?, `startTime` = ?, `endTime` = ?;
							<sql:param value="${result.rows[0]['lastinserted']}" />
							<sql:param value="${data.request['/*/allDay']}" />
							<sql:param value="${data.request['/*/url']}" />
							<sql:param value="${startDate}" />
							<sql:param value="${endDate}" />
						</sql:update>
					</c:catch>
				</c:when>
				<c:otherwise>
					<c:set var="errors">${errors}"error":"DB-Insert: ${error.rootCause}"</c:set>
				</c:otherwise>
			</c:choose>

			<%-- CHECK: for errors --%>
			<c:if test="${not empty error2}">
				<%-- DELETE AND MANUALLY ROLLBACK THE TABLE --%>
				<sql:update var="rollback">
					DELETE FROM `ctm`.`comms` WHERE `commsId` = ?;
					<sql:param value="${result.rows[0]['lastinserted']}" />
				</sql:update>
				<sql:update>
					ALTER TABLE `ctm`.`comms` AUTO_INCREMENT = 1
				</sql:update>
				<c:set var="errors">${errors}"error":"DB-Insert-2: ${error2.rootCause}"</c:set>
			</c:if>
		</sql:transaction>

	</c:when>

	<%-- UPDATE: a diary entry --%>
	<c:otherwise>

		<go:log>
			THIS IS AN UPDATE
			<sql-query var="result">
				SELECT `commsId` FROM `ctm`.`comms`
				WHERE `commsId` = ?
				AND `owner` = ?;
				<sql-param value="${data.request['/*/commsId']}" />
				<sql-param value="${data.login.user.uid}" />
			</sql-query>
		</go:log>


		<%-- SECURITY CHECK: for existing comms --%>
		<c:catch var="error1">
			<sql:query var="result">
				SELECT `commsId` FROM `ctm`.`comms`
				WHERE `commsId` = ?
				AND `owner` = ?;
				<sql:param value="${data.request['/*/commsId']}" />
				<sql:param value="${data.login.user.uid}" />
			</sql:query>
		</c:catch>

		<go:log>
			RC = ${result.rowCount}
			ER = ${error1}
		</go:log>

		<go:log>
					UPDATE
					<sql- update var="update">
						UPDATE ctm.comms cm, ctm.diaries di
						SET `cm`.`owner` = ?, `cm`.`message` = ?, `di`.`allDay` = ?, `di`.`url` = ?, `di`.`startTime` = ?, `di`.`endTime` = ?
						WHERE `cm`.`commsId` = ? AND `di`.`commsId` = ?;
						<sql- param value="${data.request['/*/owner']}" />
						<sql- param value="${data.request['/*/message']}" />
						<sql- param value="${data.request['/*/allDay']}" />
						<sql- param value="${data.request['/*/url']}" />
						<sql- param value="${startDate}" />
						<sql- param value="${endDate}" />
						<sql- param value="${data.request['/*/commsId']}" />
						<sql- param value="${data.request['/*/commsId']}" />
					</sql-update>
		</go:log>

		<c:choose>
			<c:when test="${result.rowCount > 0 && empty error1}">
				<c:catch var="error">
					<sql:update var="update">
						UPDATE ctm.comms cm, ctm.diaries di
						SET `cm`.`owner` = ?, `cm`.`message` = ?, `di`.`allDay` = ?, `di`.`url` = ?, `di`.`startTime` = ?, `di`.`endTime` = ?
						WHERE `cm`.`commsId` = ? AND `di`.`commsId` = ?;
						<sql:param value="${data.request['/*/owner']}" />
						<sql:param value="${data.request['/*/message']}" />
						<sql:param value="${data.request['/*/allDay']}" />
						<sql:param value="${data.request['/*/url']}" />
						<sql:param value="${startDate}" />
						<sql:param value="${endDate}" />
						<sql:param value="${data.request['/*/commsId']}" />
						<sql:param value="${data.request['/*/commsId']}" />
					</sql:update>
				</c:catch>

				<%-- CHECK: for errors --%>
				<c:if test="${not empty error}">
					<c:set var="errors">${errors}"error":"DB-Update: ${error1.rootCause}"</c:set>
				</c:if>

			</c:when>
			<%-- FAILED: basic user ownership or mysql --%>
			<c:otherwise>
				<c:set var="errors">${errors}"error":"DB-Update: User cannot change the message OR DB error: ${error1.rootCause}"</c:set>
			</c:otherwise>
		</c:choose>

	</c:otherwise>
</c:choose>



<%-- RESPONSE --%>
<c:choose>
	<c:when test="${not empty errors}">
{ ${errors} }
	</c:when>
	<c:otherwise>
{ "status":"OK" }
	</c:otherwise>
</c:choose>