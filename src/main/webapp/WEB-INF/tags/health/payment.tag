<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"  	rtexprvalue="true"	 description="optional id for this slide"%>
<%@ attribute name="className" 	required="false"  	rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  	rtexprvalue="true"	 description="optional id for this slide"%>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div class="health-payment ${className}" id="${id}">

	<health:payment_details xpath="${xpath}/details" />
	<health:application_compliance xpath="${xpath}" />
	<health:medicare_details xpath="${xpath}/medicare" />

	</div>
	 
</div>