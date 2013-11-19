<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built from general table."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="false" rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="type" 		required="true"	 rtexprvalue="true"	 description="type code on general table" %>
<%@ attribute name="tabIndex" 	required="false" rtexprvalue="true"	 description="additional tab index specification" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />

<%-- HTML --%>
<sql:setDataSource dataSource="jdbc/test"/>

<sql:query var="result">
	(SELECT code, description FROM general WHERE type = ? ORDER BY orderSeq LIMIT 16)
	UNION ALL
	(SELECT code, description FROM general WHERE type = ? ORDER BY description)
	<sql:param>${type}</sql:param>
	<sql:param>${type}</sql:param>
</sql:query>

<c:if test="${value == ''}">
	<c:set var="sel" value="selected" />
</c:if>

<select name="${name}" id="${name}" class="${className}"<c:if test="${not empty tabIndex}"> tabindex="${tabIndex}"</c:if> >

	<%-- Write the initial "please choose" option --%>
	<c:choose>
		<c:when test="${value == ''}">
			<option value="" selected="selected">Please choose&hellip;</option>
		</c:when>
		<c:otherwise>
			<option value="">Please choose&hellip;</option>
		</c:otherwise>
	</c:choose>

	<optgroup label="Top Makes">

	<%-- Write the options for each row --%>
	<c:forEach var="row" items="${result.rows}" varStatus='idx'>

		<c:if test="${idx.index == 16}">
			</optgroup><optgroup label="All Makes">
		</c:if>

		<c:choose>
			<c:when test="${row.code == value}">
				<option value="${row.code}" selected="selected">${row.description}</option>
			</c:when>
			<c:otherwise>
				<option value="${row.code}">${row.description}</option>
			</c:otherwise>
		</c:choose>

	</c:forEach>

	</optgroup>

</select>

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title}"/>

