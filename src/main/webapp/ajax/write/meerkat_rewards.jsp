<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${go:getLogger('jsp:ajax.write.home_quote_report')}" />

<session:get settings="true" />

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<%-- Variables --%>
<c:set var="database" value="aggregator" />
<c:set var="competition_id" value="${1}" />
<c:set var="brand" value="CTM" />
<c:set var="vertical" value="COMPETITION" />
<c:set var="source" value="1" />
<c:set var="errorPool" value="" />

<security:populateDataFromParams rootPath="competition" />

<%-- STEP 1: Validate the input received before proceeding --%>
<c:if test="${empty data['competition/email']}">
	<c:set var="errorPool" value="{error:'Your email address is required.'" />
</c:if>
<c:if test="${empty data['competition/firstname']}">
	<c:set var="errorPool"><c:if test="${not empty errorPool}">${errorPool},</c:if>{error:'Your first name is required.'}</c:set>
</c:if>
<c:if test="${empty data['competition/lastname']}">
	<c:set var="errorPool"><c:if test="${not empty errorPool}">${errorPool},</c:if>{error:'Your last name is required.'}</c:set>
</c:if>
<c:if test="${empty param.address}">
	<c:set var="errorPool"><c:if test="${not empty errorPool}">${errorPool},</c:if>{error:'Your address is required.'}</c:set>
</c:if>
<c:if test="${empty param.robesize or not fn:contains('XS,S,M,L,XL', param.robesize)}">
	<c:set var="errorPool"><c:if test="${not empty errorPool}">${errorPool},</c:if>{error:'Your robe size is required.'}</c:set>
</c:if>


<%-- STEP 2: Write email data to aggregator.email_master and get the EmailID --%>
<c:if test="${empty errorPool}">
	<c:catch var="error">
		<agg:write_email
			source="${source}"
			emailAddress="${param.email}"
			firstName="${data['firstname']}"
			lastName="${data['lastname']}"
			items="marketing=Y"
			brand=""
			vertical="" />

		<sql:setDataSource dataSource="jdbc/${database}"/>
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
							items="firstname=${param.firstname}||lastname=${param.lastname}||address=${param.address}||robesize=${param.robesize}"
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
			${logger.warn('Failed to locate emailId for {}', param.email)}
			<c:set var="errorPool" value="{error:'Failed to locate registered user.'" />
		</c:when>
		<c:otherwise>
			${logger.error('Database Error2:  param.email={}', param.email, error)}
			<c:set var="errorPool" value="{error:'${error}'" />
		</c:otherwise>
	</c:choose>
</c:if>

<%-- JSON RESPONSE --%>
<c:choose>
	<c:when test="${not empty errorPool}">
		${logger.warn('ENTRY ERRORS:  {}', errorPool)}
		{[${errorPool}]}
	</c:when>
	<c:otherwise>
		{"result":"OK"}
	</c:otherwise>
</c:choose>