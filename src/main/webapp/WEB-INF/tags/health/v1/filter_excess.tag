<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filter for level of excess."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="false" rtexprvalue="true"	 description="(optional) Filter's xpath" %>
<%@ attribute name="useDefaultOutputField" 	required="false" rtexprvalue="true"	 description="Whether to use the default output field to store values or use the hardcoded health output field" %>


<%-- VARIABLES --%>
<c:if test="${not empty xpath}">
	<c:set var="name" value="${go:nameFromXpath(xpath)}" />
	<c:set var="idAttribute" value='id="${name}"' />
</c:if>

<c:if test="${empty useDefaultOutputField}">
    <c:set var="useDefaultOutputField" value="false" />
</c:if>

<%-- HTML --%>
<div ${idAttribute} class="health-filter-excess">
	<field_v2:slider useDefaultOutputField="${useDefaultOutputField}" type="excess" value="4" range="1,4" markers="4" legend="$0,$1-$250,$251-$500,ALL" xpath="${xpath}" markerAttributeKey="data-analytics" markerAttributeValue="filter excess" />
</div>
