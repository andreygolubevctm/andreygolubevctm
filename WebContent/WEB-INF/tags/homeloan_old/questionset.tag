<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<ui:bubble variant="chatty">
	<h4>Let's get you started.</h4>
	<p>Answering the following questions will help us supply you with home loan options from our participating lenders</p>
</ui:bubble>
<homeloan:details xpath="${xpath}/details" />
<homeloan:contact xpath="${xpath}/contact" />

<form_new:row id="confirm-step" hideHelpIconCol="true">
	<a href="javascript:void(0);" class="btn btn-next col-xs-12 col-sm-8 col-md-5 journeyNavButton" id="submit_btn">Let's get started <span class="icon icon-arrow-right"></span></a>
</form_new:row>