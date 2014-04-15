<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- 
	lead_feed_save.jsp
	
	Used to record callback requests/lead feeds on the iSeries. 
 --%>
<session:get settings="true" authenticated="true" />

<security:populateDataFromParams rootPath="request" createRootPath="true" />

<c:choose>
	<c:when test="${empty data.request.source
					or empty data.request.leadNo
					or empty data.request.clientTel
					or empty data.request.state
					or empty data.request.brand
					or empty data.request.message
					or empty data.request.phonecallme }">{"result":false,"message":"Required request params were missing."}</c:when>
	
	<c:otherwise>
		<jsp:useBean id="insertParams" class="java.util.ArrayList" scope="request" />
		<c:set var="insertSQLSB" value="${go:getStringBuilder()}" />
		${go:appendString(insertSQLSB ,'INSERT INTO aggregator.transaction_details (transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) VALUES ')}

		<sql:setDataSource dataSource="jdbc/aggregator"/>

		<sql:query var="maxSequenceNo" >
			SELECT MAX(sequenceNo) as maxSequenceNo FROM aggregator.transaction_details
			WHERE transactionId = ?;
			<sql:param value="${data.current.transactionId}" />
		</sql:query>

		<c:set var="nextSequenceNo" value="${maxSequenceNo.rows[0].maxSequenceNo + 1}" />
		<c:if test="${nextSequenceNo < 400}"><c:set var="nextSequenceNo" value="400" /></c:if>

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

		<sql:update sql="${insertSQLSB.toString()}">
			<c:forEach var="item" items="${insertParams}">
				<sql:param value="${item}" />
			</c:forEach>
		</sql:update>

		<c:set var="myParams">
			<callback>
				<source>${data.request.source}</source>
				<leadNumber>${data.request.leadNo}</leadNumber>
				<client>${data.request.client}</client>
				<clientTel>${data.request.clientTel}</clientTel>
				<state>${data.request.state}</state>
				<brand>${data.request.brand}</brand>
				<message>${data.request.message}</message>
				<phonecallme>${data.request.phonecallme}</phonecallme>
				<c:if test="${not empty data.request.vdn}"><vdn>${data.request.vdn}</vdn></c:if>
			</callback>
		</c:set>
		
		<go:log>Recording Lead Feed</go:log>
		<go:call transactionId="${data.current.transactionId}" pageId="AGGCME" xmlVar="myParams" resultVar="myResult" />
		
		<c:choose>
			<c:when test="${myResult == 'OK'}">{"result": true}<c:set var="ct_outcome"><core:transaction touch="S" noResponse="false" comment="User requested call me back" /></c:set></c:when>
			<c:otherwise>{"result":false,"message":"We could not record the request in our system, please try again or contact us if the issue persists."}</c:otherwise>
		</c:choose>
		
	</c:otherwise>
	
</c:choose>
