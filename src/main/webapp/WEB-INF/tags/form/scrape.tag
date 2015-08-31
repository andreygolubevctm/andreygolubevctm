<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Represents a single online form."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${go:getLogger('form:scrape')}" />

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

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
		SELECT `html`
		FROM `ctm`.`scrapes`
		WHERE (styleCodeId = ? OR stylecodeid = 0)
		AND `id` = ?
		GROUP BY id
		ORDER BY id, stylecodeid DESC
		<sql:param value="${styleCodeId}" />
		<sql:param value="${id}" />
	</sql:query>
</c:catch>
<c:if test="${error}">
	${logger.warn('', error)}
</c:if>

<c:choose>
	<c:when test="${not empty error}"><!-- Scrapes DB Error: ${error} --></c:when>
	<c:when test="${not empty result and result.rowCount > 0}">${result.rows[0].html}</c:when>
	<c:otherwise><!-- No scrape results found to display --></c:otherwise><%-- ***FIX: we should place a non-fatal error log here, as it has called and retrieved nothing --%>
</c:choose>