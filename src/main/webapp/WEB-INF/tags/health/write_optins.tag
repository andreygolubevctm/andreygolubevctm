<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${go:getLogger('tag:health.write_optins')}" />

<jsp:useBean id="now" class="java.util.Date" scope="request" />

<%-- Attributes --%>
<%@ attribute name="rootPath" 					required="true"	 rtexprvalue="true"	 description="Email address entered in questionset phase" %>

<%@ attribute name="qs_emailAddress" 			required="false" rtexprvalue="true"	 description="Email address entered in questionset phase" %>
<%@ attribute name="qs_optinEmailAddress" 		required="false" rtexprvalue="true"	 description="Email optin from questionset phase" %>
<%@ attribute name="qs_emailAddressSecondary" 	required="false" rtexprvalue="true"	 description="Secondary email address from questionset phase" %>
<%@ attribute name="qs_optOutEmailHistory"		required="false" rtexprvalue="true"	 description="Unused email history from questionset phase" %>
<%@ attribute name="qs_phoneOther" 				required="false" rtexprvalue="true"	 description="Phone Other entered from questionset phase" %>
<%@ attribute name="qs_phoneMobile"				required="false" rtexprvalue="true"	 description="Phone Mobile entered from questionset phase" %>
<%@ attribute name="qs_okToCall"				required="false" rtexprvalue="true"	 description="OkToCall optin from questionset phase" %>

<%@ attribute name="app_emailAddress" 			required="false" rtexprvalue="true"	 description="Email address entered in application phase" %>
<%@ attribute name="app_optinEmailAddress" 		required="false" rtexprvalue="true"	 description="Email optin from application phase" %>
<%@ attribute name="app_emailAddressSecondary" 	required="false" rtexprvalue="true"	 description="Secondary email address from application phase" %>
<%@ attribute name="app_optOutEmailHistory"		required="false" rtexprvalue="true"	 description="Unused email history from application phase" %>
<%@ attribute name="app_phoneOther" 			required="false" rtexprvalue="true"	 description="Phone Other entered from application phase" %>
<%@ attribute name="app_phoneMobile"			required="false" rtexprvalue="true"	 description="Phone Mobile entered from application phase" %>
<%@ attribute name="app_okToCall"				required="false" rtexprvalue="true"	 description="OkToCall optin from application phase" %>

<%@ attribute name="firstname"					required="false" rtexprvalue="true"	 description="Users first name from either questionset or application" %>
<%@ attribute name="lastname"					required="false" rtexprvalue="true"	 description="Users first name from either questionset or application" %>

<c:set var="brand" value="${pageSettings.getBrandCode()}"/>
<%-- 1st step - optout emails in the history. Done first just in case an email in the history in questionset
	is added again in the application phase --%>
<c:if test="${not empty qs_optOutEmailHistory}">
	<c:forTokens items="${qs_optOutEmailHistory}" delims="," var="email">
		${logger.info('Questionset Email History Optout: email={}', email)}
		<c:catch var="error">
			<agg:write_email
				brand="${brand}"
				vertical="${rootPath}"
				source="QUOTE"
				emailAddress="${email}"
				firstName="${firstname}"
				lastName="${lastname}"
				items="marketing=N" />
		</c:catch>
		<c:if test="${error}">
			${logger.warn('', error)}
		</c:if>
	</c:forTokens>
</c:if>
<c:if test="${not empty app_optOutEmailHistory}">
	<c:forTokens items="${app_optOutEmailHistory}" delims="," var="email">
		${logger.info('Application Email History Optout: email={}', email)}
		<c:catch var="error">
			<agg:write_email
				brand="${brand}"
				vertical="${rootPath}"
				source="QUOTE"
				emailAddress="${email}"
				firstName="${firstname}"
				lastName="${lastname}"
				items="marketing=N" />
		</c:catch>
		<c:if test="${error}">
			${logger.warn('', error)}
		</c:if>
	</c:forTokens>
</c:if>

<%-- 2nd step - Add optins for secondary email fields --%>
<c:if test="${not empty qs_emailAddressSecondary}">
	${logger.info('Questionset Secondary Optin: {}', qs_emailAddressSecondary)}
	<c:catch var="error">
		<agg:write_email
			brand="${brand}"
			vertical="${rootPath}"
			source="QUOTE"
			emailAddress="${qs_emailAddressSecondary}"
			firstName="${firstname}"
			lastName="${lastname}"
			items="marketing=Y" />
	</c:catch>
	<c:if test="${error}">
		${logger.warn('', error)}
	</c:if>
</c:if>
<c:if test="${not empty app_emailAddressSecondary}">
	${logger.info('Application Secondary Email Optin: app_emailAddressSecondary={}', app_emailAddressSecondary)}
	<c:catch var="error">
		<agg:write_email
			brand="${brand}"
			vertical="${rootPath}"
			source="APPLICATION"
			emailAddress="${app_emailAddressSecondary}"
			firstName="${firstname}"
			lastName="${lastname}"
			items="marketing=Y" />
	</c:catch>
	<c:if test="${error}">
		${logger.warn('', error)}
	</c:if>
</c:if>

<%-- 3rd step - Add primary email fields --%>
<c:if test="${not empty qs_emailAddress}">
	${logger.info('Questionset emailAddress={},marketing={},okToCall={}',qs_emailAddress, qs_optinEmailAddress,qs_okToCall)}
	<c:catch var="error">
		<agg:write_email
			brand="${brand}"
			vertical="${rootPath}"
			source="QUOTE"
			emailAddress="${qs_emailAddress}"
			firstName="${firstname}"
			lastName="${lastname}"
			items="marketing=${qs_optinEmailAddress},okToCall=${qs_okToCall}" />
	</c:catch>
	<c:if test="${error}">
		${logger.warn('', error)}
	</c:if>
</c:if>
<c:if test="${not empty app_emailAddress}">
	${logger.info('Application emailAddress=${app_emailAddress},marketing={},okToCall={}', app_emailAddress,app_optinEmailAddress,app_okToCall)}
	<c:catch var="error">
		<agg:write_email
			brand="${brand}"
			vertical="${rootPath}"
			source="APPLICATION"
			emailAddress="${app_emailAddress}"
			firstName="${firstname}"
			lastName="${lastname}"
			items="marketing=${app_optinEmailAddress},okToCall=${app_okToCall}" />
	</c:catch>
	<c:if test="${error}">
		${logger.warn('', error)}
	</c:if>
</c:if>

<%-- 4th step - Write phone optins to stamping table --%>
<c:set var="qs_okToCall_value">
	<c:choose>
		<c:when test="${qs_okToCall eq 'Y'}">on</c:when>
		<c:otherwise>off</c:otherwise>
	</c:choose>
</c:set>
<c:if test="${not empty qs_phoneOther}">
	<agg:write_stamp
		action="toggle_okToCall"
		vertical="${fn:toLowerCase(rootPath)}"
		target="${qs_phoneOther}"
		value="${qs_okToCall_value}"
		comment="QUOTE"
	/>
</c:if>
<c:if test="${not empty qs_phoneMobile}">
	<agg:write_stamp
		action="toggle_okToCall"
		vertical="${fn:toLowerCase(rootPath)}"
		target="${qs_phoneMobile}"
		value="${qs_okToCall_value}"
		comment="QUOTE"
	/>
</c:if>

<c:set var="app_okToCall_value">
	<c:choose>
		<c:when test="${app_okToCall eq 'Y'}">on</c:when>
		<c:otherwise>off</c:otherwise>
	</c:choose>
</c:set>
<c:if test="${not empty app_phoneOther}">
	<agg:write_stamp
		action="toggle_okToCall"
		vertical="${fn:toLowerCase(rootPath)}"
		target="${app_phoneOther}"
		value="${app_okToCall_value}"
		comment="APPLICATION"
	/>
</c:if>
<c:if test="${not empty app_phoneMobile}">
	<agg:write_stamp
		action="toggle_okToCall"
		vertical="${fn:toLowerCase(rootPath)}"
		target="${app_phoneMobile}"
		value="${app_okToCall_value}"
		comment="APPLICATION"
	/>
</c:if>

${logger.debug('brand={} rootPath={} qs_emailAddress={} qs_optinEmailAddress={} qs_emailAddressSecondary={}', brand , rootPath, qs_emailAddress, qs_optinEmailAddress)}
${logger.debug('qs_optOutEmailHistory={} qs_phoneOther={} qs_phoneMobile={} qs_okToCall={}', qs_optOutEmailHistory,qs_phoneOther,qs_phoneMobile, qs_okToCall)}
${logger.debug('app_emailAddress={} app_optinEmailAddress={} app_emailAddressSecondary={} app_optOutEmailHistory={}', app_emailAddress, app_optinEmailAddress,app_emailAddressSecondary,app_optOutEmailHistory)}
${logger.debug('app_phoneOther={} app_phoneMobile={} app_okToCall={}', app_phoneOther,app_phoneMobile, app_okToCall)}
${logger.debug('firstname={} lastname={}', firstname ,lastname)}