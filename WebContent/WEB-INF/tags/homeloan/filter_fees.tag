<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filter for the fees."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}/filter/fees" />

<%-- HTML --%>
<div class="homeloan-filter-fees">
	<field_new:checkbox xpath="${xpath}/noApplication" value="noApplication"
				title="No Application Fees"
				required="false"
				label="true" />
	<field_new:checkbox xpath="${xpath}/noOngoing" value="noOngoing"
				title="No Ongoing Fees"
				required="false"
				label="true" />
</div>
