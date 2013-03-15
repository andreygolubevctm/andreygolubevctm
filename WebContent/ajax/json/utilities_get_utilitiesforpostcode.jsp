<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="utilities">
	<go:scrape url="https://websvc.switchwise.com.au:444/SwitchwiseCTM_1_5_6/SwitchwiseSearchService.svc/ProductClassPackageForPostcode/${param.postcode}" sourceEncoding="UTF-8" username="ctm" password="Ctm#138s" />
</c:set>

${go:XMLtoJSON(utilities)}