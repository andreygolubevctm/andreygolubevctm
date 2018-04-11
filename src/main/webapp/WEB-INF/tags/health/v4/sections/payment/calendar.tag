<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Calendar that can be controlled by an object - uses days only as date ranges"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<c:set var="fieldXpath" value="${xpath}/start" />
<form_v4:row fieldXpath="${fieldXpath}" label="Cover start date" className="cover-start-date-row changes-premium">
    <field_v2:calendar xpath="${fieldXpath}" required="true" title="start date" className="health-payment_details-start" mode="separated" disableRowHack="${true}" showCalendarOnXS="${true}" />
</form_v4:row>