<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>

<%-- HTML --%>
<c:set var="fieldXpath" value="travel/policyType" />
<form_v2:row label="What type of cover are you looking for?" fieldXpath="${fieldXpath}" className="clear" helpId="535">
	<field_v2:array_radio xpath="${fieldXpath}" required="true"
		className="policy-type roundedCheckboxIcons" items="S=Single Trip,A=Multi-Trip"
		id="${go:nameFromXpath(xpath)}" title="your cover type." />
</form_v2:row>