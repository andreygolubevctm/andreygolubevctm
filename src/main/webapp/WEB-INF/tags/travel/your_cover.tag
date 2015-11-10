<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>
<jsp:useBean id="splitTests" class="com.ctm.web.core.services.tracking.SplitTestService" />
<%-- HTML --%>

<c:set var="fieldXpath" value="travel/policyType" />
<form_new:row label="What type of cover are you looking for?" fieldXpath="${fieldXpath}" className="clear" helpId="535">
	<field_new:array_radio xpath="${fieldXpath}" required="true"
		className="" items="S=Single Trip,A=Multi-Trip"
		id="${go:nameFromXpath(xpath)}" title="your cover type." />
</form_new:row>