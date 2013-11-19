<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a html textarea"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The textarea field's title"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:choose>
	<c:when test="${empty data[xpath]}">
		<c:set var="contents"><jsp:doBody /></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="contents">${data[xpath]}</c:set>
	</c:otherwise>
</c:choose>

<%-- HTML --%>
<textarea name="${name}" id="${name}" class="${className}">${contents}</textarea>

<%-- VALIDATION --%>
<c:if test="${required}">
	<go:validate selector="${name}" rule="required" parm="true" message="Please enter the ${title}"/>
</c:if>
