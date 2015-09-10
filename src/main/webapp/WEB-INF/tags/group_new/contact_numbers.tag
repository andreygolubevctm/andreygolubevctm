<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" 		required="true"		rtexprvalue="true"	 description="" %>
<%@ attribute name="required" 	required="true" 	rtexprvalue="true"	 description="" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:set var="additionalAttributes" value="" />
<c:if test="${required}">
	<c:set var="additionalAttributes" value=" data-rule-requireOneContactNumber='true' data-msg-requireOneContactNumber='Please include at least one phone number' " />
</c:if>

<c:set var="fieldXpath" value="${xpath}/mobile" />
<form_new:row label="Mobile Number" fieldXpath="${fieldXpath}input">
	<field:contact_mobile xpath="${fieldXpath}" size="15" required="false" title="The mobile number" labelName="mobile number" placeHolder="04XX XXX XXX" className="sessioncamexclude" additionalAttributes="${additionalAttributes}" />
</form_new:row>

<c:set var="fieldXpath" value="${xpath}/other" />
<form_new:row label="Other Number" fieldXpath="${fieldXpath}input">
	<field:contact_telno xpath="${fieldXpath}" size="15" required="false" isLandline="true" title="The other number" labelName="other number" />
</form_new:row>