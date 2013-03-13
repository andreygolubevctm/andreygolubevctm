<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Vehicle year selection"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:setLocale value="en_GB" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />
<c:set var="startYear"><fmt:formatDate value="${now}" type="DATE" pattern="yyyy"/></c:set> 
<c:set var="count" value="${startYear - 1961}" />

<%-- HTML --%>
<select name="${name}" id="${name}" class="vehicle_year ${className}" >

	<%-- Write the initial "please choose" option --%>
	<c:choose>
		<c:when test="${value == ''}">
			<option value="" selected="SELECTED">Please choose..</option>
		</c:when>
		<c:otherwise>
			<option value="">Please choose..</option>
    	</c:otherwise>
   	</c:choose>	

	<%-- Write the options for each row --%>  
	<c:set var="year" value="${startYear}" /> 	
	<c:forEach var="i" begin="0" end="${count}">
		<c:choose>
			<c:when test="${year == value}">
				<option value="${year}" selected="SELECTED">${year}</option>
			</c:when>
			<c:otherwise>
				<option value="${year}">${year}</option>
	    	</c:otherwise>
    	</c:choose>	
    	<c:set var="year" value="${year-1}" />
	</c:forEach>
</select>

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the vehicle's year"/>
