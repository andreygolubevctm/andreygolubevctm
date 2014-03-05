<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<go:style marker="css-head">

	.bubble_row{
		margin-bottom:30px;
		position:relative;
	}

	.bubble_row .speechbubble{
		float:left;
	}

</go:style>
<c:set var="maxBrands" value="12" />

<%-- Check for IE8 or less and only allow 6 items to be selected
	JIRA PRJHNC-72
--%>
<c:set var="browser" value="${fn:split(header['User-Agent'], ';')}" scope="page"/>
<c:choose>
	<c:when test="${fn:contains(browser[1],'MSIE')}">
		<c:set var="IEversion" value="${fn:replace(browser[1],'MSIE ','')}"/>

		<c:choose>
			<c:when test="${IEversion <= 8.0 }">
		<c:set var="maxBrands" value="6" />
	</c:when>
</c:choose>
	</c:when>
		<c:otherwise><%-- Ignore --%></c:otherwise>
</c:choose>


<%-- Bubbles --%>
<div class="bubble_row">
	<ui:speechbubble colour="blue" arrowPosition="left" width="980">
		<h1>Compare features</h1>
		<p>Simply select the Insurance providers you want to compare products for and start comparing features.<br/>You can choose up to <strong>${maxBrands} providers</strong> to compare.</p>
	</ui:speechbubble>

	<div class="cleardiv"></div>

</div>

<%-- Brands selection --%>
<features:brand_selector verticalFeatures="home" max="${maxBrands}" />