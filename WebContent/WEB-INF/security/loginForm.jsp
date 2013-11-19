<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<c:set var="userName" value="" />
<c:if test="${ not empty(param.j_username) }">
	<c:set var="userName" value="${param.j_username}" />
</c:if>

<%@ include file="/WEB-INF/security/pageHeader.jsp" %>

<div class="fieldrow"><div class="fieldrow_label"></div><p class="fieldrow_value"><c:out value="${welcomeText}" /></p></div>
<form action="<c:url value="/j_security_check" />" method="POST">
	<ul>
		<li class="fieldrow"><label class="fieldrow_label" for="j_username">Username </label><div class="fieldrow_value"><input type="text" id="j_username" name="j_username" size="32" maxlength="400" value="<c:out value="${userName}" />"></div></li>
		<li class="fieldrow"><label class="fieldrow_label" for="j_password">Password </label><div class="fieldrow_value"><input type="password" id="j_password" name="j_password" size="16" maxlength="400"></div></li>
	</ul>
	<div class="fieldrow button-wrapper"><button id="next-step" type="submit"><span>Log In</span></button></div>
</form>
<script>
window.onload = function() {
	var loginUrl = window.location.toString(),
		loginUrlFinal = loginUrl,
		discHostnameSearch = /(.+\.)?ecommerce\.disconline\.com\.au$/;

	if ( discHostnameSearch.test(window.location.hostname) ) {
		loginUrlFinal = window.location.protocol + '//' + ( window.location.protocol == 'file:' ? '/' : '' )
			+ window.location.hostname.replace(discHostnameSearch, '$1secure.comparethemarket.com.au')
			+ ( window.location.protocol != 'http:' || window.location.protocol != 'https:' || ( window.location.protocol == 'http:' && window.location.port != 80 ) || ( window.location.protocol == 'https:' && window.location.port != 443 ) ? ':' + window.location.port : '' )
			+ window.location.pathname
			+ window.location.search
			+ window.location.hash;
	}

	if ( window.top != window || loginUrl !== loginUrlFinal ) {
		window.top.location = loginUrlFinal;
	} else {
		document.getElementById('j_username').focus();
	}
};
</script>
<%@ include file="/WEB-INF/security/pageFooter.jsp" %>
