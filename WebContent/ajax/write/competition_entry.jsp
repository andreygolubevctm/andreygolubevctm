<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<security:populateDataFromParams rootPath="competition" />

<session:get settings="true"/>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<c:set var="styleCode">${pageSettings.getBrandCode()}</c:set>

<%-- Variables --%>
<c:set var="database" value="aggregator" />
<c:set var="competition_id" value="${2}" /><%-- 1=Robe, 2=1000grubs, 3=1000dollars --%>
<c:set var="brand" value="CTM" />
<c:set var="vertical" value="COMPETITION" />
<c:set var="source" value="OctPromo1000grubs" />
<c:set var="errorPool" value="" />

<%-- Param if coming from the health journey  --%>
<c:choose>
	<%-- HLT-608 --%>
	<c:when test="${not empty param.secret and param.secret == '498j984j983j4f'}">
		<c:set var="competition_id" value="${3}" />
		<c:set var="source" value="OctPromo$1000" />
	</c:when>
	<%-- HLT-661 --%>
	<c:when test="${not empty param.secret and param.secret == '879n5b5435fgxz'}">
		<c:set var="competition_id" value="${4}" />
		<c:set var="source" value="NovPromo$1000" />
	</c:when>
	<%-- HLT-1213 --%>
	<c:when test="${not empty param.secret and param.secret == 'bRevefUM4Pruwr'}">
		<c:set var="competition_id" value="${8}" />
		<c:set var="source" value="June2014$1000" />
	</c:when>
</c:choose>


<%-- STEP 1: Validate the input received before proceeding --%>
<c:if test="${empty data['competition/email']}">
	<c:set var="errorPool" value="{error:'Your email address is required.'}" />
</c:if>
<c:if test="${empty data['competition/firstname']}">
	<c:set var="errorPool"><c:if test="${not empty errorPool}">${errorPool},</c:if>{error:'Your first name is required.'}</c:set>
</c:if>
<c:if test="${competition_id == 2 and empty data['competition/lastname']}">
	<c:set var="errorPool"><c:if test="${not empty errorPool}">${errorPool},</c:if>{error:'Your last name is required.'}</c:set>
</c:if>
<c:if test="${empty data['competition/phone']}">
	<c:set var="errorPool"><c:if test="${not empty errorPool}">${errorPool},</c:if>{error:'Your phone number is required.'}</c:set>
</c:if>


<%-- STEP 2: Write email data to aggregator.email_master and get the EmailID --%>
<c:if test="${empty errorPool}">
	<c:catch var="error">
		<agg:write_email
			source="${source}"
			brand="${brand}"
			vertical="${vertical}"
			emailAddress="${data['competition/email']}"
			firstName="${data['competition/firstname']}"
			lastName="${data['competition/lastname']}"
			items="marketing=Y,okToCall=Y" />

		<sql:setDataSource dataSource="jdbc/${database}"/>
		<sql:query var="emailMaster">
			SELECT emailId
			    FROM `${database}`.email_master
			    WHERE emailAddress = ?
			    AND styleCodeId = ?
			    LIMIT 1;
			<sql:param value="${data['competition/email']}" />
			<sql:param value="${styleCodeId}" />
		</sql:query>
	</c:catch>

<%-- STEP 3: Write competition details to ctm.competition_data --%>
	<c:choose>
		<c:when test="${empty error and not empty emailMaster and emailMaster.rowCount > 0}">

			<c:set var="email_id">
				<c:if test="${not empty emailMaster and emailMaster.rowCount > 0}">${emailMaster.rows[0].emailId}</c:if>
			</c:set>

			<c:choose>
				<c:when test="${empty email_id}">
					<c:set var="errorPool" value="{error:'Failed to retrieve the emailId to make the entry.'}" />
				</c:when>
				<c:otherwise>
					<c:set var="items">firstname=${data['competition/firstname']}::lastname=${data['competition/lastname']}::phone=${data['competition/phone']}</c:set>

					<c:set var="entry_result">
						<agg:write_competition
							competition_id="${competition_id}"
							email_id="${email_id}"
							items="${items}"
						/>
					</c:set>

					<c:if test="${entry_result eq false}">
						<c:set var="errorPool" value="{error:'Failed to create entry in database.'}" />
					</c:if>
				</c:otherwise>
			</c:choose>

<%-- STEP 4: Return results to the client --%>

		</c:when>
		<c:when test="${empty error and (empty emailMaster or emailMaster.rowCount == 0)}">
			<go:log level="ERROR">Failed to locate emailId for ${data['competition/email']}</go:log>
			<c:set var="errorPool" value="{error:'Failed to locate registered user.'}" />
		</c:when>
		<c:otherwise>
			<go:log level="ERROR" error="${error}">Database Error2: ${error}</go:log>
			<c:set var="errorPool" value="{error:'${error}'}" />
		</c:otherwise>
	</c:choose>
</c:if>

<%-- JSON RESPONSE --%>
<c:choose>
	<c:when test="${not empty errorPool}">
		<go:log source="october_promo_jsp">ENTRY ERRORS: ${errorPool}</go:log>
		{[${errorPool}]}

		<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
			<c:param name="transactionId" value="${data.current.transactionId}" />
			<c:param name="page" value="${pageContext.request.servletPath}" />
			<c:param name="message" value="Competition error" />
			<c:param name="description" value="${errorPool}" />
			<c:param name="data" value="competition_id:${competition_id} email:${data['competition/email']} firstname:${data['competition/firstname']} lastname:${data['competition/lastname']} phone:${data['competition/phone']}" />
		</c:import>
	</c:when>
	<c:otherwise>
		{"result":"OK"}
	</c:otherwise>
</c:choose>