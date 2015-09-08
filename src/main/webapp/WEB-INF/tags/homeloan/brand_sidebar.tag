<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Brands Sidebar"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<form_new:fieldset legend="Our Lenders">
<div class="row">
	<div class="col-xs-12">
		<p>Compare Home Loans from 30 lenders including...</p>
	</div>

	<c:set var="brands" value="${fn:split('ANZ,BOQ,CBA,MACQ,NAB,GEORGE,ING,SUNCORP,WESTPAC',',')}" />

	<c:forEach items="${brands}" var="brand" varStatus="loop">
		<div class="col-md-4 col-xs-6">
			<div class="companyLogo logo_${brand}"></div>
		</div>
	</c:forEach>

	<div class="col-xs-12">
	<a href="javascript:;" class="btn-view-brands pull-right" >View all <strong>32 lenders</strong> here</a>
	</div>
</div>
</form_new:fieldset>

<homeloan:brands />
