<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built from imported option."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="url" 		required="true"	 rtexprvalue="true"	 description="url of import file containing options" %>
<%@ attribute name="omitPleaseChoose" required="false"	rtexprvalue="true"	 description="should 'please choose' be omitted?" %>
<%@ attribute name="validateRule" required="false"	rtexprvalue="true"	 description="specify your own validation rule" %>


<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- HTML --%>
<%-- Import the file into a variable --%>
<c:import url="${url}" var="optionData" />
<%-- Substitute the value="X" --%>
<c:set var="findVal" 	value="value=\"${value}\"" />
<c:set var="replaceVal" value="value='${value}' selected='selected'" />

<c:if test="${required && validateRule == null}">
	<c:set var="titleText">
		<c:choose>
			<c:when test="${not empty title}">${title}</c:when>
			<c:otherwise>a value</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="requiredAttribute" value=' required="required" '/>
</c:if>


<div class="select">
	<span class=" input-group-addon">
		<i class="icon-select-input"></i>
	</span>
	<select name="${name}" ${requiredAttribute} data-msg-required="Please choose ${title}" id="${name}" class="form-control ${className}" >
		<%-- Write the initial "please choose" option --%>
		<c:choose>
			<c:when test="${omitPleaseChoose == 'Y'}"></c:when>
			<c:when test="${value == ''}">
				<option value="" selected="selected">Please choose...</option>
			</c:when>
			<c:otherwise>
				<option value="">Please choose...</option>
			</c:otherwise>
		</c:choose>
		${fn:replace(optionData,findVal,replaceVal)}
	</select>
</div>

<%-- VALIDATION --%>
<c:if test="${validateRule != null}">
	<go:validate selector="${name}" rule="${validateRule}" parm="${required}" message="Please choose a valid ${title}"/>
</c:if>

