<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filter for minimum price."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="false" rtexprvalue="true"	 description="(optional) Filter's xpath" %>


<%-- VARIABLES --%>
<c:if test="${not empty xpath}">
	<c:set var="name" value="${go:nameFromXpath(xpath)}" />
	<c:set var="idAttribute" value='id="${name}"' />
</c:if>


<%-- HTML --%>
<div ${idAttribute} class="health-filter-price">
	<field_new:slider type="price" value="0" range="0,600" markers="3" legend="ALL,MID,PREM." xpath="${xpath}" />
</div>
