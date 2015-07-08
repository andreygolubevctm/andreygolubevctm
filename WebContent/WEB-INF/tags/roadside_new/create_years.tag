<%@ tag description="Create the Years list for array_select tag." %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date"/>
<fmt:setLocale value="en_GB" scope="session"/>
<c:set var="startYear"><fmt:formatDate value="${now}" type="DATE" pattern="yyyy"/></c:set>
<c:set var="count" value="${startYear - 1961}"/>

<%-- Default option --%>
<c:set var="yearsList" value="=Please choose..." />
<c:set var="year" value="${startYear}"/>
<c:forEach var="i" begin="0" end="${count}">
    <c:set var="yearsList" value="${yearsList},${year}=${year}" />
    <c:set var="year" value="${year-1}"/>
</c:forEach>

<c:out value="${yearsList}" />