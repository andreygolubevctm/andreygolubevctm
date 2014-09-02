<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" authenticated="true" verticalCode="HOMELOAN" />

<%-- VARIABLES --%>
<c:set var="secret_key" value="kD0axgKXQ5HixuWsJ8-2BA" />
<c:set var="brand" value="${pageSettings.getBrandCode()}" />
<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />
<c:set var="source" value="QUOTE" />

<%-- LOAD PARAMS INTO DATA --%>
<security:populateDataFromParams rootPath="${vertical}" />

<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/homeloan_submit.jsp" quoteType="${vertical}" />
</c:if>

<%-- REGISTER MARKETING OPTIN IF REQUIRED --%>
<c:if test="${not empty data.homeloan.contact.email}">
	<c:set var="optin_mktg">
		<c:choose>
			<c:when test="${not empty data.homeloan.contact.optIn}">Y</c:when>
			<c:otherwise>N</c:otherwise>
		</c:choose>
	</c:set>
	<agg:write_email
		brand="${brand}"
		vertical="${vertical}"
		source="${source}"
		emailAddress="${data.homeloan.contact.email}"
		emailPassword=""
		firstName="${data.homeloan.contact.firstName}"
		lastName="${data.homeloan.contact.lastName}"
		items="marketing=${optin_mktg}" />
</c:if>

<%-- CREATE CONFIRMATION KEY --%>
<go:setData dataVar="data" xpath="homeloan/confirmationkey" value="${pageContext.session.id}-${data.current.transactionId}" />

<%-- RECORD TRANSFER TOUCH --%>
<core:transaction touch="T" noResponse="true" />

<%-- WRITE TO CONFIRMATIONS TABLE --%>
<sql:setDataSource dataSource="jdbc/ctm"/>
<sql:query var="conf_entry">
	SELECT KeyID FROM ctm.confirmations where KeyID = ? and TransID = ? LIMIT 1;
	<sql:param value="${data.homeloan.confirmationkey}" />
	<sql:param value="${data.current.transactionId}" />
</sql:query>

<c:if test="${conf_entry.rowCount == 0}">
	<agg:write_confirmation
	transaction_id = "${data.current.transactionId}"
	confirmation_key = "${data.homeloan.confirmationkey}"
	vertical = "${vertical}"
	/>
</c:if>

<%-- Store the URL to redirect to --%>
<c:set var="redirect_url">${pageSettings.getSetting('redirectNormal')}</c:set>

<%-- BUILD JSON OBJECT TO RETURN --%>
<c:set var="json">{"personalSituation":"<c:out value="${data.homeloan.details.situation}" />","suburb":"<c:out value="${data.homeloan.details.suburb}" />","postcode":"<c:out value="${data.homeloan.details.postcode}" />","state":"<c:out value="${data.homeloan.details.state}" />","firstName":"<c:out value="${data.homeloan.contact.firstName}" />","lastName":"<c:out value="${data.homeloan.contact.lastName}" />","transactionId":"${data.current.transactionId}","emailAddress":"<c:out value="${data.homeloan.contact.email}" />","referenceId":"<c:out value="${data.homeloan.confirmationkey}" />"}</c:set>

<%-- ENCRYPT THE JSON --%>
<c:set var="enc_json"><go:AESEncryptDecrypt action="encrypt" key="${secret_key}" content="${json}" /></c:set>

<%-- LOG CONFIRMATION URL FOR TESTING --%>
<c:set var="confirmation_json">{"firstName":"<c:out value="${data.homeloan.contact.firstName}" />","emailAddress":"<c:out value="${data.homeloan.contact.email}" />","flexOpportunityId":"to_be_provided_by_AFG"}</c:set>
<go:log level="DEBUG" source="ajax/json/homeloan_submit.jsp">Link for confirmation page: confirmation_entry.jsp?ConfirmationID=${data.homeloan.confirmationkey}&data=<go:AESEncryptDecrypt action="encrypt" key="${secret_key}" content="${confirmation_json}" /></go:log>

<%-- LOG 'BACK' URL FOR TESTING --%>
<c:set var="back_json">{"referenceId":"<c:out value="${data.homeloan.confirmationkey}" />"}</c:set>
<go:log level="DEBUG" source="ajax/json/homeloan_submit.jsp">Back link to questionset: homeloan_quote.jsp?data=<go:AESEncryptDecrypt action="encrypt" key="${secret_key}" content="${back_json}" /></go:log>

<%-- ADD TO BUCKET AND RETURN RESPONSE --%>
<go:setData dataVar="data" xpath="response/json"		value="${enc_json}" />
<go:setData dataVar="data" xpath="response/redirect_url"	value="${redirect_url}" />
${go:XMLtoJSON(go:getEscapedXml(data['response']))}