<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>

<%-- HTML --%>
<c:set var="fieldXpath" value="travel/policyType" />
<form_v2:row label="What type of cover are you looking for?" fieldXpath="${fieldXpath}" className="clear has-icons" helpId="535">
	<field_v2:array_radio xpath="${fieldXpath}" required="true"
		className="policy-type" items="S=<i class='travel-single-trip'></i>Single Trip,A=<i class='travel-multi-trip'></i>Multi-Trip"
		id="${go:nameFromXpath(xpath)}" title="your cover type." />
</form_v2:row>