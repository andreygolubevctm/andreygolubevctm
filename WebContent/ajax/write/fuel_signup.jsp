<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<sql:setDataSource dataSource="jdbc/aggregator"/>
<c:set var="sessionid" value="${pageContext.session.id}" />
<c:set var="emailSource" value="CTFA" />
<c:set var="name_first" value="${fn:trim(param.fuel_signup_name_first)}" />
<c:set var="name_last" value="${fn:trim(param.fuel_signup_name_last)}" />
<c:set var="emailAddress" value="${fn:trim(param.fuel_signup_email)}" />
<c:set var="terms" value="${fn:trim(fn:toUpperCase(param.fuel_signup_terms))}" />
<c:set var="errorPool" value="" /> 

<%--
Requires two calls, one to add to the email master and one to sign-up for the fuel alerts
--%>

<%-- Initial variable check --%>
<c:choose>
	<c:when test="${empty emailAddress or emailAddress =='' }">
		<c:set var="errorPool">${errorPool}
		<error type="init">Missing email address</error></c:set>
	</c:when>
	<c:when test="${empty name_first or name_first =='' }">
		<c:set var="errorPool">${errorPool}
		<error type="init">Missing first name</error></c:set>	
	</c:when>
	<c:when test="${empty name_last or name_last =='' }">
		<c:set var="errorPool">${errorPool}
		<error type="init">Missing last name</error></c:set>
	</c:when>	
	<c:when test="${empty terms or terms !='Y' }">
		<c:set var="errorPool">${errorPool}
		<error type="init">Acceptance of the terms is required</error></c:set>
	</c:when>		
</c:choose>

<c:if test="${empty errorPool}">
	
	<c:catch var="error">	
		<sql:query var="results">
		 	select max(TransactionId) as previd from aggregator.transaction_header
	 			where sessionid = '${sessionid}'; 
		</sql:query>

		<c:choose>
			<c:when test="${results.rows[0].previd!=null}">
				<c:set var="tranid" value="${results.rows[0].previd}" />
			</c:when>
			<c:otherwise>
				<c:set var="tranid" value="0" />
			</c:otherwise>
		</c:choose>	

		<sql:query var="results">
		 	select count(emailAddress) as emailCount from aggregator.email_master
	 			where emailAddress = ?;
			<sql:param value="${emailAddress}" />
		</sql:query>

		<c:choose>
			<c:when test="${results.rows[0].emailCount==0}">
				<sql:update var="result">
					INSERT INTO aggregator.email_master (emailAddress, emailPword, emailSource, firstName, lastName, createDate, changeDate, transactionId)
					VALUES
					(?,NULL,?,?,?,Now(),Now(), ?);
					<sql:param value="${emailAddress}" />
					<sql:param value="${emailSource}" />			
					<sql:param value="${name_first}" />
					<sql:param value="${name_last}" />
					<sql:param value="${tranid}" />
				</sql:update>
			</c:when>
			<c:otherwise>
				<sql:update var="result">
					UPDATE aggregator.email_master
					    SET transactionId = ?
					   WHERE emailAddress=?;
					<sql:param value="${tranid}" />
					<sql:param value="${emailAddress}" />
				</sql:update>
			</c:otherwise>
		</c:choose>	

	</c:catch>

	 
	 <%-- TEST FOR DB ERROR AND HANDLE, OTHERWISE CALL THE SQL RESULT --%>
	<c:choose>
		<c:when test="${not empty error}">
			<c:set var="errorPool">${errorPool}
			<error type="sql insert email">${error.rootCause}</error></c:set>
		</c:when>
		<c:otherwise>
			
			<%-- Add the email marketing --%>
			<c:catch var="error">	
				<sql:update var="result">
					INSERT INTO aggregator.email_properties (emailAddress, propertyId, value)
					VALUES
					(?,'marketing',?)
					ON DUPLICATE KEY UPDATE value = ?;
					<sql:param value="${emailAddress}" />
					<sql:param value="${terms}" />
					<sql:param value="${terms}" />			
				</sql:update>
			</c:catch>
			
			<c:if test="${not empty error}">
				<c:set var="errorPool">${errorPool}
				<error type="sql insert marketing">${error.rootCause}</error></c:set>			
			</c:if>	
						
			<%-- Add the fuel flag --%>
			<c:catch var="error">	
				<sql:update var="result">
					INSERT INTO aggregator.email_properties (emailAddress, propertyId, value)
					VALUES
					(?,'fuel',?)
					ON DUPLICATE KEY UPDATE value = ?;
					<sql:param value="${emailAddress}" />
					<sql:param value="${terms}" />
					<sql:param value="${terms}" />			
				</sql:update>
			</c:catch>
								
			<c:if test="${not empty error}">
				<c:set var="errorPool">${errorPool}
				<error type="sql insert marketing">${error.rootCause}</error></c:set>			
			</c:if>									
		 
	    	</c:otherwise>
	</c:choose>
</c:if>


<%-- XML REPONSE --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>
<des>Fuel signup form</des>
<c:choose>
	<c:when test="${empty errorPool}">
		<resultcode>0</resultcode>
	</c:when>
	<c:otherwise>
		<resultcode>3</resultcode>
		<errors>${errorPool}</errors>
	</c:otherwise>
</c:choose>
</data>