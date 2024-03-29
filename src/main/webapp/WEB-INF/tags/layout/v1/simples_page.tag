<%@ tag description="Simples general page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="fullWidth"	required="false"  rtexprvalue="true" description="If not set will wrap the page in a width container" %>

<%@ attribute fragment="true" required="true" name="head" %>
<%@ attribute fragment="true" required="false" name="body_end" %>

<c:set var="classes">
	<c:if test="${empty fullWidth}">
		<c:out value="container" />
	</c:if>
</c:set>

<layout_v1:page title="Simples">

	<jsp:attribute name="head">
		<jsp:invoke fragment="head" />
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="body_end">
		<jsp:invoke fragment="body_end" />
	</jsp:attribute>

	<jsp:body>
		<article id="page" class="${classes}">

			<jsp:doBody />

		</article>
	</jsp:body>

</layout_v1:page>
