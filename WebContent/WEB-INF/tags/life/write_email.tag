<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Write client details to the client database"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="emailSource" 	required="true"	 rtexprvalue="true"	 description="4 digit code like CARQ" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}" />
<c:set var="sessionId" 		value="${pageContext.session.id}" />
<c:set var="styleCode" 		value="" />
<c:set var="status" 		value="" />

<%-- set variables for marketing email subscribers --%>

<c:set var="emailAddress"> 
	<c:if test="${not empty data.life.contactDetails.email}">${data.life.contactDetails.email}</c:if>
</c:set>
<c:set var="firstName"> 
	<c:if test="${not empty data.life.details.primary.firstName}">${data.life.details.primary.firstName}</c:if>
</c:set>
<c:set var="lastName"> 
	<c:if test="${not empty data.life.details.primary.lastname}">${data.life.details.primary.lastname}</c:if>
</c:set>
<c:set var="phoneChoice"> 
	<c:if test="${not empty data.life.contactDetails.call}">${data.life.contactDetails.call}</c:if>
</c:set>
<c:set var="marketingChoice"> 
	<c:if test="${not empty data.life.contactDetails.optIn}">${data.life.contactDetails.optIn}</c:if>
</c:set>
<c:set var="marketingChoice"> 
	<c:choose>
		<c:when test="${empty marketingChoice}">N</c:when>
		<c:otherwise>Y</c:otherwise>
	</c:choose>
</c:set>

<%-- check email address doesn't already exist --%>

<c:set var="email_result">
	<sql:query var="results">
		SELECT emailAddress 
		FROM aggregator.email_master
		WHERE emailAddress='${emailAddress}';
	</sql:query>
	
	<c:choose>
		<c:when test="${results.rowCount != 0}">1</c:when>
		<c:otherwise>0</c:otherwise>		
	</c:choose>
</c:set>

<%-- Write client info to DB --%>
<c:choose>
	<c:when test="${email_result == 0}">
		<sql:update>
		 	insert into aggregator.email_master 
		 	(emailAddress,emailSource,firstName,lastName,createDate) 
		 	values (
			 	'${emailAddress}',
			 	'${emailSource}',
			 	'${firstName}',
			 	'${lastName}',
			 	CURRENT_DATE
		 	);
		</sql:update>
	</c:when>
	<c:otherwise>
		<sql:update>
			UPDATE aggregator.email_master
			SET 
				aggregator.email_master.emailSource='${emailSource}',
				aggregator.email_master.firstName='${firstName}',
				aggregator.email_master.lastName='${lastName}',
				aggregator.email_master.changeDate=CURRENT_DATE
			WHERE
				aggregator.email_master.emailAddress='${emailAddress}'

		</sql:update>
	</c:otherwise>
</c:choose>

<%-- Write client properties to DB --%>	
<c:forTokens items="marketing=${marketingChoice},okToCall=${phoneChoice}" delims="," var="itemValue">

	<c:set var="propertyId" value="${fn:substringBefore(itemValue,'=')}" />
	<c:set var="value" value="${fn:substringAfter(itemValue,'=')}" />

	<sql:update var="results">
		INSERT INTO aggregator.email_properties (emailAddress,propertyId,value)
		VALUES (
			'${emailAddress}',
			'${propertyId}',
			'${value}'
		) ON DUPLICATE KEY UPDATE
			value = '${value}';
	</sql:update>

</c:forTokens> 