<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a person's name."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The input field's title"%>
<%@ attribute name="maxlength" 	required="false" rtexprvalue="true"	 description="The maximum length for the input field"%>
<%@ attribute name="size" 	    required="false" rtexprvalue="true"	 description="The maximum size for the input field"%>
<%@ attribute name="readOnly" 	required="false" rtexprvalue="true" description="readOnly true or otherwise" %>

<c:if test="${readOnly}">
	<go:setData dataVar="data" xpath="readonly/${xpath}" value="${data[xpath]}" />
</c:if>

<c:choose>
	<c:when test="${not empty size}">
		<c:set var="size" value="${size}" />
	</c:when>
	<c:otherwise>
		<c:set var="size" value="20" />
	</c:otherwise>
</c:choose>
<c:if test="${ not empty maxlength }">
	<c:set var="maxlength" value=" maxlength='${maxlength}'" />
</c:if>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:choose>
	<c:when test="${!readOnly}">
		<%-- HTML --%>
		<input type="text" name="${name}" id="${name}" class="${className}" value="${data[xpath]}"${maxlength} size="${size}">

		<%-- VALIDATION --%>
		<c:if test="${required}">
			<go:validate selector="${name}" rule="required" parm="true" message="Please enter the ${title}"/>
		</c:if>

		<field:highlight_row name="${name}" inlineValidate="${required}" />
	</c:when>
	<c:otherwise>
		<input type="hidden" name="${name}" id="${name}" class="${className}" value="${data[xpath]}" maxlength="${maxlength}" size="${size}">
		<div class="field readonly" id="${name}-readonly">${data[xpath]}</div>
	</c:otherwise>
</c:choose>
