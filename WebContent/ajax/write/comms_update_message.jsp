<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/ctm" />

<go:setData dataVar="data" value="*DELETE" xpath="request" />
<go:setData dataVar="data" value="*PARAMS" xpath="request" />

<c:set var="errors" value="" />

<go:log>
THE PARAMS:
${param}

THE DATA:
${data.request}

AUTHOR D? ${data.request['/*/author']}
COMMSID D? ${data.request['/*/commsId']}
</go:log>


<%-- UPDATE or INSERT --%>
<c:choose>
	<%-- INSERT: a new message --%>
	<c:when test="${empty data.request['/*/commsId'] || data.request['/*/commsId'] == 0}">
		
		<%-- Is a reschedule triggered? --%>
		<c:set var="reschedule" value="${data.request['/*/rescheduleCount']}" />		
		
		<go:log>
				THIS IS THE FIRTS INSERT
				<sql-update var="update">
					INSERT INTO `ctm`.`comms`
					SET `parentId` = ?, `type` = 'm', `title` = ?, `author` = ?, `owner` = ?, `message` = ?, `createTime` = now();
					<sql-param value="${data.request['/*/parentId']}" />
					<sql-param value="${data.request['/*/title']}" />
					<sql-param value="${data.request['/*/author']}" />
					<sql-param value="${data.request['/*/owner']}" />
					<sql-param value="${data.request['/*/message']}" />	
				</sql-update>		
		</go:log>
		
		<sql:transaction>
			<%-- INSERT: part 1 --%>
			<c:catch var="error">	
				<sql:update var="update">
					INSERT INTO `ctm`.`comms`
					SET `parentId` = ?, `type` = 'm', `title` = ?, `author` = ?, `owner` = ?, `message` = ?, `createTime` = now();
					
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
						sql-update var="update2"
							INSERT INTO `ctm`.`messages`
							SET `commsId` = ?, `queue` = ?, `state` = ?, `priority` = ?, `callBack` = ?, `rescheduleCount` = ?, `rescheduleReason` = ?;
							<sql-param value="${result.rows[0]['lastinserted']}" />
							<sql-param value="${data.request['/*/queue']}" />
							<sql-param value="${data.request['/*/state']}" />
							<sql-param value="${data.request['/*/priority']}" />
							<sql-param value="${data.request['/*/date']}, ${data.request['/*/time']}" />
							<sql-param value="${reschedule}" />
							<sql-param value="${data.request['/*/rescheduleReason']}" />
						/sql-update				
			</go:log>
			
			
			<%-- INSERT: part 2 --%>
			<c:choose>			
				<c:when test="${result.rowCount > 0 && empty error}">
					<c:catch var="error2">
						<sql:update var="update2">
							INSERT INTO `ctm`.`messages`
							SET `commsId` = ?, `queue` = ?, `state` = ?, `priority` = ?, `callBack` = ?, `rescheduleCount` = ?, `rescheduleReason` = ?;
							<sql:param value="${result.rows[0]['lastinserted']}" />
							<sql:param value="${data.request['/*/queue']}" />
							<sql:param value="${data.request['/*/state']}" />
							<sql:param value="${data.request['/*/priority']}" />
							<sql:param value="${data.request['/*/date']}, ${data.request['/*/time']}" />
							<sql:param value="${reschedule}" />
							<sql:param value="${data.request['/*/rescheduleReason']}" />
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
	
	<%-- UPDATE: a message --%>
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
					<sql-update var="update">
						UPDATE ctm.comms cm, ctm.messages me
						SET `cm`.`owner` = ?, `cm`.`message` = ?, `me`.`queue` = ?, `me`.`state` = ?, `me`.`priority` = ?, `me`.`callBack` = ?
						WHERE `cm`.`commsId` = ? AND `me`.`commsId` = ?;
						<sql-param value="${data.request['/*/owner']}" />
						<sql-param value="${data.request['/*/message']}" />
						<sql-param value="${data.request['/*/queue']}" />
						<sql-param value="${data.request['/*/state']}" />
						<sql-param value="${data.request['/*/priority']}" />
						<sql-param value="${data.request['/*/date']}, ${data.request['/*/time']}" />
						<sql-param value="${data.request['/*/commsId']}" />
						<sql-param value="${data.request['/*/commsId']}" />
					</sql-update>	
		</go:log>
	
		<c:choose>
			<c:when test="${result.rowCount > 0 && empty error1}">
				<c:catch var="error">
					<sql:update var="update">
						UPDATE ctm.comms cm, ctm.messages me
						SET `cm`.`owner` = ?, `cm`.`message` = ?, `me`.`queue` = ?, `me`.`state` = ?, `me`.`priority` = ?, `me`.`callBack` = ?
						WHERE `cm`.`commsId` = ? AND `me`.`commsId` = ?;
						<sql:param value="${data.request['/*/owner']}" />
						<sql:param value="${data.request['/*/message']}" />
						<sql:param value="${data.request['/*/queue']}" />
						<sql:param value="${data.request['/*/state']}" />
						<sql:param value="${data.request['/*/priority']}" />
						<sql:param value="${data.request['/*/date']}, ${data.request['/*/time']}" />
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