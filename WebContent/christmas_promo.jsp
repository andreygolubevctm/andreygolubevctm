<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true"/>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<c:catch var="uber_error">

	<%-- Competition is over --%>
	<%-- <c:redirect url="http://www.comparethemeerkat.com.au/" /> --%>

		<go:log>COMPETITION: START</go:log>

		<c:import var="config" url="/WEB-INF/aggregator/competition/christmas.xml" />
		<x:parse doc="${config}" var="configOBJ" />

		<c:set var="firstname"><c:out value="${param.firstname}" escapeXml="true"/></c:set>
		<c:set var="email"><c:out value="${param.email}" escapeXml="true"/></c:set>
		<c:set var="postcode"><c:out value="${param.postcode}" escapeXml="true"/></c:set>
		<c:set var="marketing"><c:out value="${fn:toUpperCase(param.marketing)}" escapeXml="true"/></c:set>

		<c:set var="returnUrl"><x:out select="$configOBJ//*[local-name()='returnUrl']" /></c:set>
		<c:set var="errorUrl"><x:out select="$configOBJ//*[local-name()='errorUrl']" /></c:set>
		<c:set var="successUrl"><x:out select="$configOBJ//*[local-name()='successUrl']" /></c:set>
		<c:set var="competition_id"><x:out select="$configOBJ//*[local-name()='competition_id']" /></c:set>
		<c:set var="database" value="aggregator" />
		<c:set var="vertical" value="COMPETITION" />
		<c:set var="source"><x:out select="$configOBJ//*[local-name()='source']" /></c:set>
		<c:set var="items">firstname=${firstname}::postcode=${postcode}</c:set>

		<go:log>COMPETITION: VALIDATING PARAMS</go:log>

		<c:if test="${empty firstname}">
			<c:set var="error" value="true"/>
		</c:if>
		<c:if test="${empty email || not fn:contains(email, '@') || not fn:contains(fn:substring(email, fn:indexOf(email, '@'), fn:length(email)), '.')}">
			<c:set var="error" value="true"/>
		</c:if>
		<c:if test="${empty postcode || fn:length(postcode) != '4' || not postcode.matches('[0-9]+')}">
			<c:set var="error" value="true"/>
		</c:if>
		<c:if test="${empty marketing || marketing != 'Y'}">
			<c:set var="error" value="true"/>
		</c:if>

		<c:choose>
			<c:when test="${error eq true }">
				<c:set var="returnUrl" value="${returnUrl}${errorUrl}"/>
				<go:log>COMPETITION: ERROR - Error: ${error}</go:log>
				<go:log>COMPETITION: WILL REDIRECT TO: ${returnUrl}</go:log>
				<c:redirect url="${returnUrl}" />
			</c:when>
			<c:otherwise>
				<sql:setDataSource dataSource="jdbc/${database}"/>
				<c:catch var="error">
					<agg:write_email
						brand="MEER"
						vertical="${vertical}"
						source="${source}"
						emailAddress="${email}"
						firstName="${firstname}"
						lastName=""
						items="marketing=${marketing}" />
				</c:catch>

				<sql:query var="emailMaster">
					SELECT emailId
					    FROM `${database}`.email_master
					    WHERE emailAddress = ?
					    AND styleCodeId = ?
					    LIMIT 1;
					<sql:param value="${email}" />
					<sql:param value="${styleCodeId}" />
				</sql:query>

				<c:set var="email_id">
					<c:if test="${not empty emailMaster and emailMaster.rowCount > 0}">${emailMaster.rows[0].emailId}</c:if>
				</c:set>
				<go:log>COMPETITION: email_id: ${email_id}</go:log>
				<c:if test="${not empty email_id }">
					<c:set var="entry_result">
						<agg:write_competition
							competition_id="${competition_id}"
							email_id="${email_id}"
							items="${items}"
						/>
					</c:set>
					<go:log>COMPETITION: entry_result: ${entry_result}</go:log>
				</c:if>

				<c:choose>
					<c:when test="${not empty error}">
						<go:log>COMPETITION: ERROR - Error: ${error}</go:log>
						<c:set var="returnUrl" value="${returnUrl}${errorUrl}"/>
					</c:when>
					<c:otherwise>
						<go:log>COMPETITION: SUCCESS</go:log>
						<c:set var="returnUrl" value="${returnUrl}${successUrl}"/>
					</c:otherwise>
				</c:choose>
				<go:log>COMPETITION: WILL REDIRECT TO: ${returnUrl}</go:log>
				<go:log>COMPETITION: END</go:log>
				<c:redirect url="${returnUrl}" />
			</c:otherwise>
		</c:choose>
</c:catch>
<c:if test="${uber_error eq true}">
	<go:log>COMPETITION: uber_error: ${uber_error}</go:log>
	<c:redirect url="http://comparethemeerkat.com.au/?error=1" />
</c:if>