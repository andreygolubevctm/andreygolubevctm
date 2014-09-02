<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"  	rtexprvalue="true"	 description="optional id for this slide"%>
<%@ attribute name="className" 	required="false"  	rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  	rtexprvalue="true"	 description="optional id for this slide"%>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="verintUpgradeSwitch"><content:get key="verintUpgradeSwitch"/></c:set>

<%-- HTML --%>
<div class="health-payment ${className}" id="${id}">

	<health:payment_details xpath="${xpath}/details" />

	<%-- This content will be turned on/off with the main update button --%>
	<div id="update-content">
		<c:choose>
			<c:when test="${verintUpgradeSwitch == 'Y'}">
		<health:application_compliance xpath="${xpath}" />
			</c:when>
			<c:otherwise>
				<health:application_compliance_OLD xpath="${xpath}" />
			</c:otherwise>
		</c:choose>
		<health:medicare_details xpath="${xpath}/medicare" />
		<simples:dialogue id="31" vertical="health" mandatory="true" />
	</div>
	 
</div>