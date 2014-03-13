<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filter for level of excess."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="false" rtexprvalue="true"	 description="(optional) Filter's xpath" %>


<%-- VARIABLES --%>
<c:if test="${not empty xpath}">
	<c:set var="name" value="${go:nameFromXpath(xpath)}" />
	<c:set var="idAttribute" value='id="${name}"' />
</c:if>


<%-- HTML --%>
<div ${idAttribute} class="health-filter-excess">
	<field_new:slider type="excess" value="4" range="1,4" markers="4" legend="$0,$1-$250,$251-$500,ALL" xpath="${xpath}" />
</div>
