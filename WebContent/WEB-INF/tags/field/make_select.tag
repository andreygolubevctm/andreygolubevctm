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
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

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

<c:if test="${required}">

	<c:set var="titleText">
		<c:choose>
			<c:when test="${not empty title}">${title}</c:when>
			<c:otherwise>vehicle manufacturer</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="requiredAttribute" value=' required="required" ' />

</c:if>

<c:if test="${not empty tabIndex}">
	<c:set var="tabindexAttribute"> tabindex="${tabIndex}" </c:set>
</c:if>

<select name="${name}" id="${name}" class="${className}" ${tabindexAttribute} data-msg-required="Please enter the ${titleText}"  ${requiredAttribute} >

	<%-- Write the initial "please choose" option --%>
	<option value="">Please choose&hellip;</option>

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

