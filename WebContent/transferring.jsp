<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core:doctype />
<go:html>
	<core:head quoteType="false" title="Transferring you..." nonQuotePage="${true}" />

	<core:transferring_init />

	<body class="engine">

		<%-- Transferring popup holder --%>
		<core:transferring />

		<form:form action="" method="POST" id="signupForm" name="signupForm">
		</form:form>

		<%-- Test the tracking codes --%>
		<c:if test="${ (not empty param.trackCode) && (param.trackCode != 'undefined')}">
			<fmt:parseNumber var="trackCode" type="number" value="${param.trackCode}" integerOnly="true" />
			<c:if test="${not empty trackCode}">
				<img src="https://partners.comparethemarket.com.au/z/${trackCode}/CD1/${param.transactionId}" />
			</c:if>
		</c:if>

		<%-- Dialog for rendering fatal errors --%>
		<form:fatal_error />
	</body>

</go:html>