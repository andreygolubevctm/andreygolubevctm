<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Display The Application date for Local/Dev Environments"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="applicationService" class="com.ctm.services.ApplicationService" scope="page" />

<c:set var="env" value="${environmentService.getEnvironmentAsString()}" />
<c:if test="${env eq 'localhost' or env eq 'NXI' or env eq 'NXQ' or env eq 'NXS'}">

	<c:set var="applicationDate" value="${applicationService.getApplicationDateIfSet(pageContext.getRequest())}" />

	<span class="applicationDateContainer error-field"><strong>Application Date: <span class="applicationDate">${applicationDate}</span></strong></span>

</c:if>