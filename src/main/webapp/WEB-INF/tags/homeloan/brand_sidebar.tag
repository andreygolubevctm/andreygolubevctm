<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Brands Sidebar"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<form_v2:fieldset legend="Our Lenders">
<div class="row">
	<div class="col-xs-12">
		<p>Compare Home Loans from over 45 lenders</p>
	</div>

	<c:set var="brands" value="${fn:split('ANZ,BOQ,CBA,MACQ,NAB,GEORGE,ING,SUNCORP,WESTPAC',',')}" />

	<c:forEach items="${brands}" var="brand" varStatus="loop">
		<div class="col-md-4 col-xs-6">
			<div class="companyLogo logo_${brand}"></div>
		</div>
	</c:forEach>

	<div class="col-xs-12">
	<a href="javascript:;" class="btn-view-brands pull-right" >View <strong>all lenders</strong> here</a>
	</div>
</div>
</form_v2:fieldset>

<homeloan:brands />
