<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Brands Sidebar"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<c:set var="heading"><content:get key="sidebarHeading"/></c:set>
<form_new:fieldset legend="${heading}" className="hidden-xs">
<div class="row logogrid">
	<div class="col-xs-12">
		<p><content:get key="briefInsurerCopy"/></p>
	</div>
	<jsp:useBean id="logoGridService" class="com.ctm.services.LogoGridService" scope="page" />
	${logoGridService.init(pageContext.request)}

	<c:forEach items="${logoGridService.getMaxProviderCodes()}" var="brand">
		<c:if test="${not empty brand}">
			<div class="col-md-4 col-sm-6">
				<div class="travelCompanyLogo logo_${brand}"></div>
			</div>
		</c:if>
	</c:forEach>

	<div class="col-xs-12 underwriter-link">
		<a href="javascript:;" class="btn-view-brands pull-right" >View all <strong>27 brands</strong> and their underwriters here</a>
	</div>
</div>
</form_new:fieldset>

<travel:brands providerCodes="${logoGridService.getAllProviderCodes()}" />
