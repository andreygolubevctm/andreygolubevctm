<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true"/>

<c:set var="verticalFeatures" value="home" />
<c:set var="xpath" value="${verticalFeatures}lmi" />
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- Redirect as no longer required PRJHNC-97 --%>
<c:redirect url="${pageSettings.getBaseUrl()}home_contents_quote.jsp" />


<%-- CREATE CONFIRMATION KEY --%>
<go:setData dataVar="data" xpath="homelmi/confirmationkey" value="${pageContext.session.id}-${data.current.transactionId}" />

<agg:page vertical="${xpath}" formAction="#" >

	<jsp:attribute name="header">
		<core:head title="${go:TitleCase(verticalFeatures)} Compare Features" mainCss="common/base.css" mainJs="common/js/features/FeaturesResults.js" />
	</jsp:attribute>

	<jsp:attribute name="body_start">
		<%-- SuperTag Top Code--%>
		<agg:supertag_top type="Features" initVertical="${xpath}" initialPageName="ctm:${go:TitleCase(verticalFeatures)}:LMI:Select" loadExternalJs="true"/>
	</jsp:attribute>

	<jsp:attribute name="form_top">
		<form:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="false" />
		<core:referral_tracking vertical="${xpath}" />
	</jsp:attribute>

	<jsp:attribute name="footer">
			<homelmi:footer />
	</jsp:attribute>

	<jsp:body>
		<homelmi:email_signup/>
		<homelmi:includes />
	</jsp:body>
</agg:page>
