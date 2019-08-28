<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="ABD Start row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/primary/abdPolicyStart" />
<form_v4:row fieldXpath="${fieldXpath}" label="What was the policy start date?" id="primary_abd_start_date" className="changes-premium hidden">
	<field_v2:calendar xpath="${fieldXpath}" required="true" title="- What was the policy start date?" className="health-payment_details-start" mode="separated" disableRowHack="${true}" showCalendarOnXS="${true}" />
</form_v4:row>