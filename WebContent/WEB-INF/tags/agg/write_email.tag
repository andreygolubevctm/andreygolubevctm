<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="source"		 	required="true"	 rtexprvalue="true"	 description="Where we are saving the email from (ie. QUOTE, SIGNUP, SAVE_QUOTE, etc.)" %>
<%@ attribute name="brand"		 	required="true"	 rtexprvalue="true"	 description="The brand source (ie. ctm, cc, etc.)" %>
<%@ attribute name="vertical"	 	required="true"	 rtexprvalue="true"	 description="The vertical source (ie. health, car, etc.)" %>
<%@ attribute name="emailAddress"	required="true"	 rtexprvalue="true"	 description="email to be recorded in the db" %>
<%@ attribute name="emailPassword"	required="false" rtexprvalue="true"	 description="encrypted password to be recorded in the db" %>
<%@ attribute name="firstName"	 	required="true"	 rtexprvalue="true"	 description="First Name to be recorded in the db" %>
<%@ attribute name="lastName"	 	required="true"	 rtexprvalue="true"	 description="Last Name to be recorded in the db" %>
<%@ attribute name="updateName"	 	required="false" rtexprvalue="true"	 description="Whether to update the first and last name when the email already exists" %>
<%@ attribute name="items" 			required="true"  rtexprvalue="true"  description="comma seperated list of values in value=description format" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}" />
<c:set var="sessionId" 		value="${pageContext.session.id}" />
<c:set var="transactionId"	value="${data.current.transactionId}" />
<c:set var="emailAddress" 	value="${fn:trim(emailAddress)}" />
<c:set var="hashedEmail"><security:hashed_email action="encrypt" email="${emailAddress}" brand="${brand}" /></c:set>
<c:if test="${empty updateName}"><c:set var="updateName" value="${true}"/></c:if>

<%-- Trim contact name because the firstName field is only Char(15) in Production --%>
<c:if test="${fn:length(firstName) > 15}">
	<c:set var="firstName" value="${fn:substring(firstName, 0, 14)}" />
</c:if>
<%-- Trim contact name because the lastName field is only Char(20) in Production --%>
<c:if test="${fn:length(lastName) > 20}">
	<c:set var="lastName" value="${fn:substring(lastName, 0, 19)}" />
</c:if>


<c:if test="${not empty emailAddress}">
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
				(emailAddress,emailPword,brand,vertical,source,firstName,lastName,createDate,transactionId,hashedEmail)
				VALUES (?,?,?,?,?,?,?,CURRENT_DATE,?,?);
				<sql:param value="${emailAddress}" />
				<sql:param value="${emailPassword}" />
				<sql:param value="${brand}" />
				<sql:param value="${vertical}" />
				<sql:param value="${source}" />
				<sql:param value="${firstName}" />
				<sql:param value="${lastName}" />
				<sql:param value="${transactionId}" />
				<sql:param value="${hashedEmail}" />
			</sql:update>
		</c:when>
		<c:otherwise>
			<c:choose>
				<c:when test="${not empty emailPassword}">
			<sql:update>
				UPDATE aggregator.email_master
				SET 
						aggregator.email_master.emailPword=?,
						<c:if test="${updateName eq true}">
				aggregator.email_master.firstName=?,
				aggregator.email_master.lastName=?,
						</c:if>
				aggregator.email_master.changeDate=CURRENT_DATE
				WHERE
				aggregator.email_master.emailAddress=?;
						<sql:param value="${emailPassword}" />
						<c:if test="${updateName eq true}">
				<sql:param value="${firstName}" />
				<sql:param value="${lastName}" />
						</c:if>
				<sql:param value="${emailAddress}" />
			</sql:update>
				</c:when>
				<c:otherwise>
					<sql:update>
						UPDATE aggregator.email_master
					SET 
						<c:if test="${updateName eq true}">
							aggregator.email_master.firstName=?,
							aggregator.email_master.lastName=?,
						</c:if>
						aggregator.email_master.changeDate=CURRENT_DATE,
						aggregator.email_master.hashedEmail=? <%-- TRV-162: give all the old records a chance to update the hash value of their email if the email wasn't all lowercase --%>
						WHERE
						aggregator.email_master.emailAddress=?;
						<c:if test="${updateName eq true}">
							<sql:param value="${firstName}" />
							<sql:param value="${lastName}" />
						</c:if>
						<sql:param value="${hashedEmail}" />
					<sql:param value="${emailAddress}" />
				</sql:update>
		</c:otherwise>
	</c:choose>
		</c:otherwise>
	</c:choose>

	<agg:write_email_properties
		email="${emailAddress}"
		items="${items}"
		brand="${fn:toUpperCase(brand)}"
		vertical="${fn:toUpperCase(vertical)}"
		stampComment="${source}" />
</c:if>