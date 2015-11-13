<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.write.competition')}" />

<session:get settings="true" />

<security:populateDataFromParams rootPath="competition" />

<core:transaction touch="P" noResponse="true" />

<c:set var="transactionId"	value="${data.current.transactionId}" />
<c:set var="styleCodeId">2</c:set>
<c:set var="styleCode">meer</c:set>


<%-- Variables --%>
<c:set var="competition_id" value="${data['competition/competitionId']}" />
<c:set var="competition_email" value="${data['competition/email']}" />
<c:set var="brand" value="${styleCode}" />
<c:set var="vertical" value="COMPETITION" />
<c:set var="source" value="Meerkat" />
<c:set var="errorPool" value="" />
<c:set var="promoCode" value="" />

<%-- STEP 1: Write email data to aggregator.email_master and get the EmailID --%>
	<c:catch var="error">
		<agg:write_email
			source="${source}"
			brand="${brand}"
			vertical="${vertical}"
			emailAddress="${competition_email}"
			firstName="${data['competition/firstName']}"
			lastName="${data['competition/lastName']}"
			items="marketing=Y,okToCall=N" />

		<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
		<sql:query var="emailMaster">
			SELECT emailId, hashedEmail
				FROM aggregator.email_master
				WHERE emailAddress = ?
				AND styleCodeId = ?
				LIMIT 1;
			<sql:param value="${competition_email}" />
			<sql:param value="${styleCodeId}" />
		</sql:query>
	</c:catch>

<%-- STEP 2: Write competition details to ctm.competition_data --%>
	<c:choose>
		<c:when test="${empty error and not empty emailMaster and emailMaster.rowCount > 0}">

			<c:set var="email_id">
				<c:if test="${not empty emailMaster and emailMaster.rowCount > 0}">${emailMaster.rows[0].emailId}</c:if>
			</c:set>

			<c:set var="promocode">
				<c:if test="${not empty emailMaster and emailMaster.rowCount > 0}">${emailMaster.rows[0].hashedEmail}</c:if>
			</c:set>

			<c:choose>
				<c:when test="${empty email_id}">
					<c:set var="errorPool" value="{error:'Failed to retrieve the emailId to make the entry.'}" />
				</c:when>
				<c:otherwise>
					<c:set var="items">firstname=${data['competition/firstName']}::lastname=${data['competition/lastName']}::postcode=${data['competition/postcode']}::dateofbirth=${data['competition/dob']}::promocode=${data['competition/promocode']}</c:set>

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

<%-- STEP 3: Return results to the client --%>

		</c:when>
		<c:when test="${empty error and (empty emailMaster or emailMaster.rowCount == 0)}">
			${logger.warn('Failed to locate emailId. {}' , log:kv('email', competition_email))}
			<c:set var="errorPool" value="{error:'Failed to locate registered user.'}" />
		</c:when>
		<c:otherwise>
			${logger.error('Database error querying aggregator.email_master. {}', log:kv('email', competition_email) , error)}
			<c:set var="errorPool" value="{error:'${error}'}" />
		</c:otherwise>
	</c:choose>

<%-- JSON RESPONSE --%>
<c:choose>
	<c:when test="${not empty errorPool}">
		${logger.info('Returning errors to the browser', log:kv('errorPool', errorPool))}
		{[${errorPool}]}

		<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
			<c:param name="transactionId" value="${data.current.transactionId}" />
			<c:param name="page" value="${pageContext.request.servletPath}" />
			<c:param name="message" value="Competition error" />
			<c:param name="description" value="${errorPool}" />
			<c:param name="data" value="competition_id:${competition_id} email:${competition_email} firstname:${data['competition/firstname']} lastname:${data['competition/lastname']} postcode=${data['competition/postcode']} dateofbirth=${data['competition/dob']}  promocode=${data['competition/promocode']}" />
		</c:import>
	</c:when>
	<c:otherwise>
		{"result":"OK","promocode":"${promocode}"}
	</c:otherwise>
</c:choose>