<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="ABD Start row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/primary/abd" />
<form_v4:row label="To the best of your knowledge, when did that policy start?" fieldXpath="${fieldXpath}" className="health-your_details-dob-group">
	<field_v4:basic_date_no_calendar xpath="${fieldXpath}" title="primary person's" required="true" ageMin="16" ageMax="99" />
</form_v4:row>`