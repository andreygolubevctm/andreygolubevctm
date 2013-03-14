<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="utilities">
	<go:scrape url="${data['settings/switchwise-web-service']}/ProductClassPackageForPostcode/${param.postcode}" sourceEncoding="UTF-8" username="webtest" password="web#1test" />
</c:set>

${go:XMLtoJSON(utilities)}
