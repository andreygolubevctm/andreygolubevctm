<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

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
		<go:log level="INFO" source="health:write_optins">################ Questionset Email History Optout: ${email}</go:log>
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
	</c:forTokens>
</c:if>
<c:if test="${not empty app_optOutEmailHistory}">
	<c:forTokens items="${app_optOutEmailHistory}" delims="," var="email">
		<go:log level="INFO" source="health:write_optins">################ Application Email History Optout: ${email}</go:log>
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
	</c:forTokens>
</c:if>

<%-- 2nd step - Add optins for secondary email fields --%>
<c:if test="${not empty qs_emailAddressSecondary}">
	<go:log level="INFO" source="health:write_optins">################ Questionset Secondary Optin: ${qs_emailAddressSecondary}</go:log>
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
</c:if>
<c:if test="${not empty app_emailAddressSecondary}">
	<go:log level="INFO" source="health:write_optins">################ Application Secondary Email Optin: ${app_emailAddressSecondary}</go:log>
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
</c:if>

<%-- 3rd step - Add primary email fields --%>
<c:if test="${not empty qs_emailAddress}">
	<go:log level="INFO" source="health:write_optins">################ Questionset Email ${qs_emailAddress}: marketing=${qs_optinEmailAddress},okToCall=${qs_okToCall}</go:log>
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
</c:if>
<c:if test="${not empty app_emailAddress}">
	<go:log level="INFO" source="health:write_optins">################ Application Email ${app_emailAddress}: marketing=${app_optinEmailAddress},okToCall=${app_okToCall}</go:log>
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

<go:log level="DEBUG" source="health:write_optins">=============================================</go:log>
<go:log level="DEBUG" source="health:write_optins">brand:${brand}</go:log>
<go:log level="DEBUG" source="health:write_optins">rootPath:${rootPath}</go:log>

<go:log level="DEBUG" source="health:write_optins">qs_emailAddress:${qs_emailAddress}</go:log>
<go:log level="DEBUG" source="health:write_optins">qs_optinEmailAddress:${qs_optinEmailAddress}</go:log>
<go:log level="DEBUG" source="health:write_optins">qs_emailAddressSecondary:${qs_emailAddressSecondary}</go:log>
<go:log level="DEBUG" source="health:write_optins">qs_optOutEmailHistory:${qs_optOutEmailHistory}</go:log>
<go:log level="DEBUG" source="health:write_optins">qs_phoneOther:${qs_phoneOther}</go:log>
<go:log level="DEBUG" source="health:write_optins">qs_phoneMobile:${qs_phoneMobile}</go:log>
<go:log level="DEBUG" source="health:write_optins">qs_okToCall:${qs_okToCall}</go:log>

<go:log level="DEBUG" source="health:write_optins">app_emailAddress:${app_emailAddress}</go:log>
<go:log level="DEBUG" source="health:write_optins">app_optinEmailAddress:${app_optinEmailAddress}</go:log>
<go:log level="DEBUG" source="health:write_optins">app_emailAddressSecondary:${app_emailAddressSecondary}</go:log>
<go:log level="DEBUG" source="health:write_optins">app_optOutEmailHistory:${app_optOutEmailHistory}</go:log>
<go:log level="DEBUG" source="health:write_optins">app_phoneOther:${app_phoneOther}</go:log>
<go:log level="DEBUG" source="health:write_optins">app_phoneMobile:${app_phoneMobile}</go:log>
<go:log level="DEBUG" source="health:write_optins">app_okToCall:${app_okToCall}</go:log>

<go:log level="DEBUG" source="health:write_optins">firstname:${firstname}</go:log>
<go:log level="DEBUG" source="health:write_optins">lastname:${lastname}</go:log>