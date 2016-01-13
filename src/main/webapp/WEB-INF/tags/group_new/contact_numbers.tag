<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" 		required="true"		rtexprvalue="true"	 description="" %>
<%@ attribute name="required" 	required="true" 	rtexprvalue="true"	 description="" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:set var="additionalAttributes" value="" />


<c:if test="${ not empty data && (empty data[xpath].mobile) && (not empty data['health/application/mobile']) }">
	<go:setData dataVar="data" xpath="${xpath}/mobile" value="${data['health/application/mobile']}" />
</c:if>
<c:if test="${ not empty data && (empty data[xpath].other) && (not empty data['health/application/other']) }">
	<go:setData dataVar="data" xpath="${xpath}/other" value="${data['health/application/other']}" />
</c:if>

<c:set var="fieldXPath" value="${xpath}/mobile" />
<form_new:row label="Mobile Number" fieldXpath="${fieldXpath}input">
	<field:flexi_contact_number xpath="${fieldXPath}"
								maxLength="20"
								required="false"
								className="sessioncamexclude"
								labelName="mobile number"
								phoneType="Mobile"
								additionalAttributes="${additionalAttributes}"
								requireOnePlusNumber="true"/>
</form_new:row>

<c:set var="fieldXPath" value="${xpath}/other" />
<form_new:row label="Other Number" fieldXpath="${fieldXpath}input">
	<field:flexi_contact_number xpath="${fieldXPath}"
								maxLength="20"
								required="false"
								className="sessioncamexclude"
								labelName="other number"
								phoneType="LandLine"
								additionalAttributes="${additionalAttributes}"
								requireOnePlusNumber="true"/>
</form_new:row>