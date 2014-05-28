<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" />

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<%-- Variables --%>
<c:set var="database" value="aggregator" />
<c:set var="competition_id" value="${6}" />
<c:set var="brand" value="CTM" />
<c:set var="vertical" value="homelmi" />
<c:set var="source" value="SIGNUP" />
<c:set var="errorPool" value="" />
<c:set var="secret_key" value="kD0axgKXQ5HixuWsJ8-2BA" />

<security:populateDataFromParams rootPath="competition" />

<%-- STEP 1: Validate the input received before proceeding --%>
<c:if test="${empty param.email}">
	<c:set var="errorPool" value="{error:'Your email address is required.'" />
</c:if>
<c:if test="${empty param.firstname}">
	<c:set var="errorPool"><c:if test="${not empty errorPool}">${errorPool},</c:if>{"error":"Your first name is required."}</c:set>
</c:if>
<c:if test="${empty param.lastname}">
	<c:set var="errorPool"><c:if test="${not empty errorPool}">${errorPool},</c:if>{"error":"Your last name is required."}</c:set>
</c:if>
<c:if test="${empty param.location}">
	<c:set var="errorPool"><c:if test="${not empty errorPool}">${errorPool},</c:if>{"error":"Your location is required."}</c:set>
</c:if>




<%-- RECORD TRANSFER TOUCH
<core:transaction touch="T" noResponse="true" />
--%>


<%-- CHECK IF THE RECORD EXSITS--%>
<sql:setDataSource dataSource="jdbc/ctm"/>
<%--		<sql:query var="conf_entry">
			SELECT KeyID FROM `ctm`.`confirmations` where KeyID = ? and TransID = ? LIMIT 1;
			<sql:param value="${data.homelmi.confirmationkey}" />
			<sql:param value="${data.current.transactionId}" />
		</sql:query>


			<c:choose>
				<c:when test="${conf_entry.rowCount == 0}">
					<agg:write_confirmation
						transaction_id = "${data.current.transactionId}"
						confirmation_key = "${data.homelmi.confirmationkey}"
						vertical = "home"
					/>
				</c:when>
				<c:otherwise></c:otherwise>
			</c:choose>
--%>

<%-- STEP 2: Write email data to aggregator.email_master and get the EmailID --%>
<c:if test="${empty errorPool}">
	<c:catch var="error">

		<agg:write_email
			source="${source}"
			emailAddress="${param.email}"
			firstName="${param.firstname}"
			lastName="${param.lastname}"
			items="marketing=Y"
			brand="CTM"
			vertical="homelmi" />


		<sql:query var="emailId">
			SELECT emailId
			    FROM `${database}`.email_master
			    WHERE emailAddress = ?
			    AND styleCodeId = ?
			    LIMIT 1;
			<sql:param value="${param.email}" />
			<sql:param value="${styleCodeId}" />
		</sql:query>
	</c:catch>

<%-- STEP 3: Write competition details to ctm.competition_meerkat_rewards --%>
	<c:choose>
		<c:when test="${empty error and not empty emailId and emailId.rowCount > 0}">

			<c:set var="email_id">
				<c:if test="${not empty emailId and emailId.rowCount > 0}">${emailId.rows[0].emailId}</c:if>
			</c:set>



			<c:choose>
				<c:when test="${empty email_id}">
					<c:set var="errorPool" value="{error:'Failed to retrieve the emailId to make the entry.'" />
				</c:when>
				<c:otherwise>
					<c:set var="entry_result">
						<agg:write_competition
							competition_id="${competition_id}"
							email_id="${email_id}"
							items="firstname=${param.firstname}::lastname=${param.lastname}::location=${param.location}::policyRenewalDate=${param.policyRenewalDate}::TranID=${data.current.transactionId}::PreviousRootID=${data.previousRootId}"
						/>
					</c:set>

					<c:if test="${entry_result eq false}">
						<c:set var="errorPool" value="{error:'Failed to create entry in database.'" />
					</c:if>
				</c:otherwise>
			</c:choose>

<%-- STEP 4: Return results to the client --%>

		</c:when>
		<c:when test="${empty error and (empty emailId or emailId.rowCount == 0)}">
			<go:log>Failed to locate emailId for ${param.email}</go:log>
			<c:set var="errorPool" value="{error:'Failed to locate registered user.'" />
		</c:when>
		<c:otherwise>
			<go:log>Database Error2: ${error}</go:log>
			<c:set var="errorPool" value="{error:'${error}'" />
		</c:otherwise>
	</c:choose>
</c:if>


<%-- ADD TO BUCKET AND RETURN RESPONSE --%>
<go:setData dataVar="data" xpath="homelmi/signup/firstname" value="${param.firstname}" />
<go:setData dataVar="data" xpath="homelmi/signup/email" value="${param.email}" />


<%-- JSON RESPONSE --%>

<c:choose>
	<c:when test="${not empty errorPool}">
		<go:log>ENTRY ERRORS: ${errorPool}</go:log>
		${errorPool}
	</c:when>
	<c:otherwise>
		{"result":"OK", "enc_data":"", "error":""}
	</c:otherwise>
</c:choose>