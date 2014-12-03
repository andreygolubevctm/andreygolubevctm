<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--

	The purpose of this page is to provide an 'authenticated' loading page.
	If the user is not authenticated they will redirect to the login form.

--%>
<%@ include file="/loading.jsp" %>


<%--

	Use the passed in 'url' parameter and redirect to it.

--%>
<c:set var="url" value="${param.url}" />

<a id="simples-nexturl" href="<c:out value="${url}" />">...</a>

<script>
window.onload = function() {
	var link = document.getElementById('simples-nexturl');
	window.location = link.href;
};
</script>