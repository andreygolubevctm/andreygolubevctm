<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Builds the CSS to create a cross browser compatible transition on a CSS property" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="property"	 	required="false"	rtexprvalue="true"	 description="The css property to transition" %>
<%@ attribute name="duration" 		required="false"	rtexprvalue="true"	 description="Duration of the transition" %>
<%@ attribute name="easing"			required="false"	rtexprvalue="true"	 description="The transition easing" %>

<%-- VARIABLES --%>
<c:if test="${empty property}"><c:set var="property" value="all" /></c:if>
<c:if test="${empty duration}"><c:set var="duration" value="1000" /></c:if>
<c:if test="${empty easing}"><c:set var="easing" value="ease-in-out" /></c:if>

-webkit-transition: <c:out value="-webkit-${property} ${duration}ms ${easing};"/>
-moz-transition: <c:out value="-moz-${property} ${duration}ms ${easing};"/>
-o-transition: <c:out value="-o-${property} ${duration}ms ${easing};"/>
transition: <c:out value="${property} ${duration}ms ${easing};"/>