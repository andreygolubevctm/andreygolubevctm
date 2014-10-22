<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Form for entry of policy commencement date"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="base xpath for input e.g. car/options/commDate" %>

<%-- VARIABLES --%>
<%--<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="nowDate" pattern="yyyy-MM-dd" value="${now - (60*60*24)}" />--%>

<jsp:useBean id="now" class="java.util.GregorianCalendar" />
<c:if test="${not empty param.expiredcommencementdatetest}">
	<% now.add(java.util.GregorianCalendar.DAY_OF_MONTH, -1); %>
</c:if>
<fmt:formatDate var="nowDate" pattern="yyyy-MM-dd" value="${now.time}" />

<jsp:useBean id="nowPlusMonth" class="java.util.GregorianCalendar" />
<% nowPlusMonth.add(java.util.GregorianCalendar.DAY_OF_MONTH, 30); %>
<fmt:formatDate var="nowPlusMonthDate" pattern="yyyy-MM-dd" value="${nowPlusMonth.time}" />

<%-- PRELOAD HANDLING --%>
<c:if test="${not empty param.preload and param.preload eq 'true'}">
	<fmt:formatDate var="nowDiffFmt" pattern="dd/MM/yyyy" value="${now.time}" />
	<go:setData dataVar="data" xpath="${xpath}" value="${nowDiffFmt}" />
</c:if>

<%-- HTML --%>
<field_new:calendar mobileClassName="hidden-xs hidden-sm" mode="component" validateMinMax="true" xpath="${xpath}" required="true" title="commencement date" minDate="${nowDate}" maxDate="${nowPlusMonthDate}" startView="0" nonLegacy="true"/>
<field_new:mobile_commencement_date_dropdown mobileClassName="hidden-md hidden-lg" xpath="${xpath}Dropdown" required="true" title="commencement"/>
