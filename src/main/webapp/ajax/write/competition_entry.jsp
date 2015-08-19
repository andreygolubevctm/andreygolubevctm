<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" />

<security:populateDataFromParams rootPath="competition" />

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<c:set var="styleCode">${pageSettings.getBrandCode()}</c:set>

<%-- Pass in competition_phone_required param to tell the script if phone is required --%>
<c:set var="phoneRequiredParam"><c:out value="${data['competition/required/phone']}" /></c:set>
<c:set var="isPhoneRequired" value="${true}" />
<c:if test="${phoneRequiredParam eq 'N'}">
	<c:set var="isPhoneRequired" value="${false}" />
</c:if>


<%-- Variables --%>
<c:set var="database" value="ctm" />
<c:set var="competition_id" value="${2}" /><%-- 1=Robe, 2=1000grubs, 3=1000dollars --%>
<c:set var="brand" value="CTM" />
<c:set var="vertical" value="COMPETITION" />
<c:set var="source" value="OctPromo1000grubs" />
<c:set var="errorPool" value="" />

<%-- Param if coming from the health journey  --%>
<c:choose>
	<%-- HLT-2470 --%>
	<c:when test="${not empty param.secret and param.secret == 'vU9CD4NjT3S6p7a83a4t'}">
		<c:set var="competition_id" value="${26}" />
		<c:set var="source" value="AugustHealthPromo2015$5000" />
	</c:when>
	<%-- HLT-2229 --%>
	<c:when test="${not empty param.secret and param.secret == 'kSdRdpu5bdM5UkKQ8gsK'}">
		<c:set var="competition_id" value="${24}" />
		<c:set var="source" value="AugustHealthPromo2015$1000" />
	</c:when>
	<%-- HLT-2221 --%>
	<c:when test="${not empty param.secret and param.secret == 'C7F9FILY0qe02X98rXCH'}">
		<c:set var="competition_id" value="${19}" />
		<c:set var="source" value="MayHealthPromo2015$1000" />
	</c:when>
	<%-- PRJWHL-261 YAHOO --%>
	<c:when test="${not empty param.secret and param.secret == '1NjmJ507mwUnX81Lj96b'}">
		<c:set var="competition_id" value="${20}" />
		<c:set var="source" value="YHOO-MayPromo2015$1000" />
	</c:when>
	<%-- HLT-1737 --%>
	<c:when test="${not empty param.secret and param.secret == '1F6F87144375AD8BAED4D53F8CF5B'}">
		<c:set var="competition_id" value="${15}" />
		<c:set var="source" value="Feb2015HealthJEEPPromo" />
	</c:when>
</c:choose>

<%-- Car promos, uses ID sent from car_quote_results --%>
<c:if test="${not empty param.secret and param.secret == 'Ja1337c0Bru1z2'}">
	<c:choose>
		<c:when test="${not empty param.competitionId}">
			<c:set var="competition_id" value="${param.competitionId}" />
			<c:choose>
			<c:when test="${competition_id == '9'}">
				<%-- CAR-553 --%>
				<c:set var="source" value="AugFuelPromo2014$1000" />
			</c:when>
			<c:when test="${competition_id == '11'}">
				<%-- CAR-710 --%>
				<c:set var="source" value="Car$1000CashPromoOct2014" />
			</c:when>
			</c:choose>
		</c:when>
	</c:choose>
</c:if>

<%-- Life/IP promos, uses ID sent from life_quote_results --%>
<c:if test="${not empty param.secret and param.secret == 'F982336B6A298CDBFCECBE719645C'}">
	<c:if test="${not empty param.competitionId}">
		<c:set var="competition_id" value="${param.competitionId}" />
		<c:choose>
			<c:when test="${competition_id == '13'}">
				<c:set var="source" value="Life$1000CashNov2014" />
			</c:when>
			<c:when test="${competition_id == '17'}">
				<c:set var="source" value="Life$1000CashFeb2015" />
			</c:when>
			<c:when test="${competition_id == '22'}">
				<c:set var="source" value="Life$1000CashJune2015" />
			</c:when>
		</c:choose>
	</c:if>
</c:if>

<%-- Utilities promos, uses ID sent from life_quote_results --%>
<c:if test="${not empty param.secret and param.secret == 'W8C6A452F9823ECBE719DBZFC196C3QB'}">
	<c:if test="${not empty param.competitionId}">
		<c:set var="competition_id" value="${param.competitionId}" />
		<c:choose>
			<c:when test="${competition_id == '14'}">
				<c:set var="source" value="Energy$1000CashJan2015" />
			</c:when>
			<c:when test="${competition_id == '21'}">
				<c:set var="source" value="Energy$1000CashMay2015" />
			</c:when>
		</c:choose>
	</c:if>
</c:if>

<%-- Credit Cards promo --%>
<c:if test="${not empty param.secret and param.secret == 'yfIOyxdBzXw7CjVcNWuX'}">
	<c:set var="competition_id" value="${18}" />
	<c:set var="source" value="CC$1000CashApril2015" />
</c:if>

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
<c:if test="${isPhoneRequired eq true && empty data['competition/phone']}">
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
				FROM aggregator.email_master
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
		<go:log source="competition_entry_jsp">ENTRY ERRORS: ${errorPool}</go:log>
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