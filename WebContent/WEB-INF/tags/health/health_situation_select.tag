<%@tag import="javax.servlet.jsp.jstl.sql.Result"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
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

<%-- Assign the values from the database into groups --%>

<c:set var="avoidGroup" value=""/>
<c:set var="lifestageGroup" value=""/>
<c:set var="familyGroup" value=""/>
<c:set var="lookingGroup" value=""/>

<c:forEach var="row" items="${result.rows}">

	<%-- set the group value (they are placed into strings for each group because I can't resort them) --%>

	<c:choose>
		<c:when test="${row.code == 'ATP'}">
			<c:set var="group" value="Best price" />
			<c:set var="item" value="${row.code},${row.description},${group}"/>
			<c:set var="avoidGroup" value="${avoidGroup}||${item}" />
		</c:when>
		<c:when test="${row.code == 'YS' || row.code == 'YC'  || row.code == 'M'}">
			<c:set var="group" value="Lifestage" />
			<c:set var="item" value="${row.code},${row.description},${group}"/>
			<c:set var="lifestageGroup" value="${lifestageGroup}||${item}" />
		</c:when>
		<c:when test="${row.code == 'CSF' || row.code == 'FK' }">
			<c:set var="group" value="Family" />
			<c:set var="item" value="${row.code},${row.description},${group}"/>
			<c:set var="familyGroup" value="${familyGroup}||${item}" />
		</c:when>
		<c:when test="${row.code == 'LC' || row.code == 'LBC'  || row.code == 'O'}">
			<c:set var="group" value="Looking..." />
			<c:set var="item" value="${row.code},${row.description},${group}"/>
			<c:set var="lookingGroup" value="${lookingGroup}||${item}" />
		</c:when>
		<c:otherwise>
			<%-- Place any unknown item into the looking group and report non-fatal error --%>
			<c:set var="group" value="Looking" />
			<c:set var="item" value="${row.code},${row.description},${group}"/>
			<c:set var="lookingGroup" value="${lookingGroup}||${item}" />
			<error:non_fatal_error origin="health_quote.jsp" errorMessage="[WARNING] Health quote page: No group for ${row.code} found" errorCode="Missing situation code" />
		</c:otherwise>
	</c:choose>

</c:forEach>

<c:set var="items" value="${avoidGroup}||${lifestageGroup}||${familyGroup}||${lookingGroup}" />

<%-- Build the menu string for display --%>
<c:set var="menuString" value=""/>
<c:set var="currentGroup" value="" />

<c:forTokens items="${items}"	delims="||"	var="item">

	<c:set var="itemParts" value="${fn:split(item,',')}"/>
	<c:set var="code" value="${itemParts[0]}"/>
	<c:set var="label" value="${itemParts[1]}"/>
	<c:set var="group" value="${itemParts[2]}"/>

	<c:choose>
		<c:when test="${currentGroup != group }">
			<c:if test="${currentGroup != '' }">
				<c:set var="menuString" value="${menuString}],"/>
			</c:if>
			<c:set var="menuString" value="${menuString}${group}["/>
			<c:set var="currentGroup" value="${group}" />
		</c:when>
		<c:otherwise>
			<c:set var="menuString" value="${menuString},"/>
		</c:otherwise>
	</c:choose>

	<c:set var="menuString" value="${menuString}${code}=${label}"/>

</c:forTokens>

<c:set var="menuString" value="${menuString}]"/>
<c:set var="menuString" value="=Please choose,${menuString}"/>

<field:array_select_with_headings items="${menuString}" xpath="${xpath}" title="situation type" required="true" className="health-situation-healthSitu" />

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title}"/>
