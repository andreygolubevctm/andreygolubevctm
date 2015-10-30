<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Import Travel Partner Regions</title>
<link rel="stylesheet" href="/ctm/assets/brand/ctm/css/internal.css" media="all">
<script type="text/javascript" src="../../common/js/jquery-1.10.1.min.js?rev="></script>
</head>
<body>
<jsp:useBean id="environmentService" class="com.ctm.web.core.services.EnvironmentService" scope="request" />
<c:set var="environment" value="${environmentService.getEnvironmentAsString()}" />
<jsp:useBean id="providers" class="com.ctm.web.core.services.provider.ProviderService" scope="request" />
<c:set var="providerHTML" value="${providers.fetchProviders('TRAVEL', 1)}" />

<div class="container"><div class="row" style="padding-top: 80px;">
<div class="col-md-6">
	<%-- Only available in localhost & NXI --%>
	<c:if test="${environment == 'localhost' || environment == 'NXI'}">
<form id="process" method="POST" enctype="multipart/form-data" class="form-horizontal" action="../../travel/countrymapping/import">
<div class="form-group">
<div class="select">
<label for="providerCode">Select the Provider</label>
<select id="providerCode" name="providerCode" class="form-control">
	<option val="">Select the Provider...</option>
	${providerHTML}
</select></div>
</div>
<div class="form-group">

<table id="products" class="table table-striped">
<thead>
</thead>
<tbody></tbody>
</table>
</div>
<div class="form-group">
<label for="effectivedate">Effective Date</label>
	<jsp:useBean id="preloadToDate" class="java.util.GregorianCalendar" />
	<% preloadToDate.add(java.util.GregorianCalendar.DAY_OF_MONTH, 8); %>

	<fmt:formatDate var="effectivedate" value="${now}" pattern="yyyy-MM-dd" />
<input type="text" id="effectivedate" name="effectivedate" placeholder="2015-01-01" class="form-control" value="${effectivedate}">
</div>
<div class="form-group">
<label for="jira">Jira Id</label>
<input type="text" id="jira" name="jira" class="form-control">
</div>
<div class="form-group">
<label for="sheet">Import File</label>
<input type="file" id="sheet" name="sheet">
</div>
<div class="form-group">
<input type="submit" value="Process">
</div>
</form>
	</c:if>
</div>
</div></div>

</body>
</html>