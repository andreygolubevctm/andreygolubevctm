<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Represents a single online form."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Tag simply pulls in the html for the nominated scrape ID and renders
	 it out at the location of the tag - nice and simple.
	 
	 For now, any special styling required for the content needs to be
	 applied where the tag is included.
--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" required="true" description="The ID of the scrape record to be displayed"%>

<sql:setDataSource dataSource="jdbc/ctm"/>

<c:catch var="error">
	<sql:query var="result">
		SELECT *
		FROM `ctm`.`scrapes`
		WHERE `id` = ?
		LIMIT 1
		<sql:param value="${id}" />
	</sql:query>
</c:catch>

<c:choose>
	<c:when test="${not empty error}"><!-- Scrapes DB Error: ${error} --></c:when>
	<c:when test="${not empty result and result.rowCount > 0}">
		<c:forEach var="scrape" items="${result.rows}">${scrape.html}</c:forEach>
	</c:when>
	<c:otherwise><!-- No scrape results found to display --></c:otherwise>
</c:choose>