<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Used to capture commencement date for a quote"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>


<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="currentDate"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- HTML --%>
<jsp:useBean id="now" class="java.util.GregorianCalendar" scope="page" />

<fmt:setLocale value="en_GB" scope="session" />

<select name="${name}" id="${name}">
	<option value="">Please choose...</option>
	<c:forEach var="i" begin="1" end="30">
		<fmt:formatDate value="${now.time}" pattern="dd/MM/yyyy" var="date" />
		<c:choose>
		<c:when test="${date == currentDate}">
			<option value="${date}" selected="selected">${date}</option>
		</c:when>
		<c:otherwise>
			<option value="${date}">${date}</option>
		</c:otherwise>
		</c:choose>
		<%-- Unfortunately no easy way to add durations to dates in JSTL so have to resort to scriptlet :( --%>
		<% now.add(java.util.GregorianCalendar.DAY_OF_MONTH, 1); %>
	</c:forEach>
</select>

<%-- VALIDATION --%>
<c:if test="${required}">
	<go:validate selector="${name}" rule="required" parm="${required}" message="Please choose the commencement date"/>
</c:if>

