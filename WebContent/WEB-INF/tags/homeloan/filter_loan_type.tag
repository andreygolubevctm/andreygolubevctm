<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filter for the fees."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}/filter/loanDetails" />

<%-- HTML --%>
<div class="homeloan-filter-fees">
	<field_new:checkbox xpath="${xpath}/productFixed" value="Fixed"
				title="Fixed"
				required="false"
				label="true" />
	<field_new:checkbox xpath="${xpath}/productVariable" value="Variable"
				title="Variable"
				required="false"
				label="true" />
	<field_new:checkbox xpath="${xpath}/productLineOfCredit" value="LineOfCredit"
				title="Line of Credit"
				required="false"
				label="true" />
	<field_new:checkbox xpath="${xpath}/productLowIntroductoryRate" value="LowIntroductoryRate"
				title="Low Introductory Rate"
				required="false"
				label="true" />
</div>
