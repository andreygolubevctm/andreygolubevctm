<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Select box built from general table."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="false" rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="type" 		required="false" rtexprvalue="true"	 description="type code on general table" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />

<c:if test="${empty type}">
	<c:set var="type" value="emptyset" />
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

<select name="${name}" id="${name}" class="${className}">
	<%-- Write the initial "please choose" option --%>
	<c:choose>
		<c:when test="${value == ''}">
			<option value="" selected="selected">Please choose..</option>
		</c:when>
		<c:otherwise>
			<option value="">Please choose..</option>
		</c:otherwise>
	</c:choose>
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

