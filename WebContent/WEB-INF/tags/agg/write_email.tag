<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%@ attribute name="emailSource" 	required="true"	 rtexprvalue="true"	 description="4 digit code like CARQ" %>
<%@ attribute name="emailAddress"	required="true"	 rtexprvalue="true"	 description="email to be recorded in the db" %>
<%@ attribute name="firstName"	 	required="true"	 rtexprvalue="true"	 description="First Name to be recorded in the db" %>
<%@ attribute name="lastName"	 	required="true"	 rtexprvalue="true"	 description="Last Name to be recorded in the db" %>
<%@ attribute name="items" 			required="true"  rtexprvalue="true"  description="comma seperated list of values in value=description format" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}" />
<c:set var="sessionId" 		value="${pageContext.session.id}" />

<c:if test="${not empty emailAddress and not empty firstName and not empty lastName}">

	<%-- check email address doesn't already exist --%>
	<c:set var="email_result">
		<sql:query var="results">
			SELECT emailAddress 
			FROM aggregator.email_master
			WHERE emailAddress=?;
			<sql:param value="${emailAddress}" />
		</sql:query>
		
		<c:choose>
			<c:when test="${results.rowCount > 0}">${true}</c:when>
			<c:otherwise>${false}</c:otherwise>		
		</c:choose>
	</c:set>
	
	<%-- Write client info to DB --%>
	<c:choose>
		<c:when test="${email_result eq false}">
			<sql:update>
			 	INSERT INTO aggregator.email_master 
			 	(emailAddress,emailSource,firstName,lastName,createDate) 
			 	VALUES (?,?,?,?,CURRENT_DATE);
				<sql:param value="${emailAddress}" />
				<sql:param value="${emailSource}" />
				<sql:param value="${firstName}" />
				<sql:param value="${lastName}" />
			</sql:update>
			
			<c:forTokens items="${items}" delims="," var="itemValue">
				<c:set var="propertyId" value="${fn:substringBefore(itemValue,'=')}" />
				<c:set var="value" value="${fn:substringAfter(itemValue,'=')}" />
			
				<sql:update var="results">
					insert into aggregator.email_properties (emailAddress,propertyId,value)
					values (?,?,?);
					<sql:param value="${emailAddress}" />
					<sql:param value="${propertyId}" />
					<sql:param value="${value}" />
				</sql:update>
			
			</c:forTokens> 
		</c:when>
		<c:otherwise>
			<sql:update>
				UPDATE aggregator.email_master
				SET 
				
				aggregator.email_master.emailSource=?,
				aggregator.email_master.firstName=?,
				aggregator.email_master.lastName=?,
				aggregator.email_master.changeDate=CURRENT_DATE
				
				
				WHERE
				aggregator.email_master.emailAddress=?;
				
				<sql:param value="${emailSource}" />
				<sql:param value="${firstName}" />
				<sql:param value="${lastName}" />
				<sql:param value="${emailAddress}" />
			</sql:update>
		
				<c:forTokens items="${items}" delims="," var="itemValue">
				<c:set var="propertyId" value="${fn:substringBefore(itemValue,'=')}" />
				<c:set var="value" value="${fn:substringAfter(itemValue,'=')}" />
			
				<sql:update var="results">
					UPDATE aggregator.email_properties 
					SET 
					aggregator.email_properties.value=?
					WHERE   aggregator.email_properties.emailAddress=? AND 
							aggregator.email_properties.propertyId=?;
					<sql:param value="${value}" />
					<sql:param value="${emailAddress}" />
					<sql:param value="${propertyId}" />
				</sql:update>
			
			</c:forTokens> 
	
		</c:otherwise>
	</c:choose>

</c:if>