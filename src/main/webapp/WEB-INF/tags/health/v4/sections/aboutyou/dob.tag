<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="DOB row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/primary/dob" />
<form_v4:row label="What is your date of birth?" fieldXpath="${fieldXpath}" className="health-your_details-dob-group lhcRebateCalcTrigger">
	<field_v4:person_dob xpath="${fieldXpath}" title="primary person's" required="true" ageMin="16" ageMax="120" />
</form_v4:row>