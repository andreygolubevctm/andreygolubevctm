<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- 
	lead_feed_save.jsp
	
	Used to record callback requests/lead feeds on the iSeries. 
 --%>
<session:get settings="true" authenticated="true" />
<security:populateDataFromParams rootPath="request" createRootPath="true" />
<c:choose>
	<c:when
		test="${empty data.request.source
					or empty data.current.transactionId
					or empty data.request.leadNo
					or (empty data.request.clientTel and data.request.phonecallme eq 'GetaCall')
					or empty data.request.state
					or empty data.request.brand
					or empty data.request.message
					or empty data.request.phonecallme }">{"error":"Required request params were missing."}</c:when>
	<c:otherwise>
		<jsp:useBean id="insertParams" class="java.util.ArrayList" scope="request" />
		<c:set var="insertSQLSB" value="${go:getStringBuilder()}" />
		${go:appendString(insertSQLSB ,'INSERT INTO aggregator.transaction_details (transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) VALUES ')}

		<sql:setDataSource dataSource="jdbc/aggregator"/>
		<c:catch var="error">
		<sql:query var="maxSequenceNo" >
			SELECT MAX(sequenceNo) as maxSequenceNo FROM aggregator.transaction_details
			WHERE transactionId = ?;
			<sql:param value="${data.current.transactionId}" />
		</sql:query>
		</c:catch>

		<c:choose>
			<c:when test="${empty error}">
		<c:set var="nextSequenceNo" value="${maxSequenceNo.rows[0].maxSequenceNo + 1}" />
				<c:if test="${nextSequenceNo < 400}">
					<c:set var="nextSequenceNo" value="400" />
				</c:if>

		<c:set var="xpathPrefix" value="request" />
		<c:forTokens items="source,leadNo,client,clientTel,state,brand,message,phonecallme,vdn" delims="," var="token">
			<c:set var="xpath" value="${xpathPrefix}/${token}" />
			<c:set var="dataBaseValue">${data[xpath]}</c:set>
			<c:set var="dataBaseValue" value="${go:unescapeXml(dataBaseValue)}" />
			${go:appendString(insertSQLSB ,prefix)}
			<c:set var="prefix" value="," />
			${go:appendString(insertSQLSB , '(')}
			${go:appendString(insertSQLSB , data.current.transactionId)}
			${go:appendString(insertSQLSB , ', ?, ?, ?, default, Now()) ')}
			<c:set var="ignore">
					${insertParams.add(nextSequenceNo)};
					${insertParams.add(xpath)};
					${insertParams.add(dataBaseValue)};
			</c:set>
			<c:set var="nextSequenceNo" value="${nextSequenceNo + 1}" />
		</c:forTokens>

		${go:appendString(insertSQLSB ,'ON DUPLICATE KEY UPDATE xpath=VALUES(xpath), textValue=VALUES(textValue); ')}
				<c:catch var="updateError">
		<sql:update sql="${insertSQLSB.toString()}">
			<c:forEach var="item" items="${insertParams}">
				<sql:param value="${item}" />
			</c:forEach>
		</sql:update>
				</c:catch>

				<c:choose>
					<c:when test="${empty updateError}">
		<c:set var="myParams">
			<callback>
							<source><c:out value="${data.request.source}" escapeXml="true" /></source>
							<leadNumber><c:out value="${data.request.leadNo}" escapeXml="true" /></leadNumber>
							<client><c:out value="${data.request.client}" escapeXml="true" /></client>
							<clientTel><c:out value="${data.request.clientTel}" escapeXml="true" /></clientTel>
							<state><c:out value="${data.request.state}" escapeXml="true" /></state>
							<brand><c:out value="${data.request.brand}" escapeXml="true" /></brand>
							<message><c:out value="${data.request.message}" escapeXml="true" /></message>
							<phonecallme><c:out value="${data.request.phonecallme}" escapeXml="true" /></phonecallme>
				<c:if test="${not empty data.request.vdn}"><vdn>${data.request.vdn}</vdn></c:if>
			</callback>
		</c:set>

						<%-- Record details in DISC --%>
		<go:call transactionId="${data.current.transactionId}" pageId="AGGCME" xmlVar="myParams" resultVar="myResult" />

		<c:choose>
							<c:when test="${myResult == 'OK'}">
								<c:out value='{"result": true}' escapeXml="false" />

								<c:set var="touchType">
									<c:choose>
										<c:when test="${not empty data.request.phonecallme && data.request.phonecallme eq 'GetaCall'}">CB</c:when>
										<c:when test="${not empty data.request.phonecallme && data.request.phonecallme eq 'CallDirect'}">CD</c:when>
										<c:otherwise>S</c:otherwise>
									</c:choose>
								</c:set>

								<%-- Record appropriate touch --%>
								<core:transaction touch="${touchType}" noResponse="true" comment="User requested call me back" />

							</c:when>
			<c:otherwise>{"result":false,"message":"We could not record the request in our system, please try again or contact us if the issue persists."}</c:otherwise>
		</c:choose>
					</c:when>
					<c:otherwise>
						{"error":"An error occurred updating transaction details with callback information."}
					</c:otherwise>
				</c:choose>
		
			</c:when>
			<c:otherwise>
				{"error":"An error occurred running the maxSequenceNo query for transaction id ${data.current.transactionId}."}
	</c:otherwise>
		</c:choose>
	
	</c:otherwise>
</c:choose>