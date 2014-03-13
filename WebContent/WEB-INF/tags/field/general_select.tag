<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built from general table."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath"			required="true"	 rtexprvalue="true"		description="variable's xpath" %>
<%@ attribute name="required"		required="false" rtexprvalue="true"	description="is this field required?" %>
<%@ attribute name="className"		required="false" rtexprvalue="true"		description="additional css class attribute" %>
<%@ attribute name="title"			required="false" rtexprvalue="true"		description="subject of the select box" %>
<%@ attribute name="type" 			required="false" rtexprvalue="true"		description="type code on general table" %>
<%@ attribute name="initialText"	required="false" rtexprvalue="true"		description="Text used to invite selection" %>
<%@ attribute name="tabIndex"		required="false" rtexprvalue="true"		description="additional tab index specification" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${empty type}">
	<c:set var="type" value="emptyset" />
</c:if>
<c:if test="${empty initialText}">
	<c:set var="initialText" value="Please choose&hellip;" />
</c:if>

<%-- HTML --%>
<sql:setDataSource dataSource="jdbc/test"/>

<sql:query var="result">
	SELECT code, description FROM general WHERE type = ? ORDER BY orderSeq
	<sql:param>${type}</sql:param>
</sql:query>

<c:if test="${value == ''}">
	<c:set var="sel" value="selected" />
</c:if>

<c:if test="${disabled == 'true'}">
	<c:set var="disabled" value="selected" />
</c:if>

<select name="${name}" id="${name}" class="form-control ${className}"<c:if test="${not empty tabIndex}"> tabindex="${tabIndex}"</c:if> >
	<%-- Write the initial "please choose" option --%>
	<option value="">${initialText}</option>

	<%-- Write the options for each row --%>
	<c:forEach var="row" items="${result.rows}">
		<c:choose>
			<c:when test="${row.code == value}">
				<option value="${row.code}" selected="selected">${row.description}</option>
			</c:when>
			<c:otherwise>
				<option value="${row.code}">${row.description}</option>
			</c:otherwise>
		</c:choose>
	</c:forEach>
</select>

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title}"/>

