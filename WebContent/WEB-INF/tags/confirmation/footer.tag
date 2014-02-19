<%--
	Represents a collection of panels
--%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical"	required="true"	rtexprvalue="true"	description="The label for the vertical" %>

<%-- HTML --%>
<c:choose>
	<c:when test="${vertical eq 'homeloan'}">
		<homeloan:footer />
	</c:when>
	<c:when test="${vertical eq 'homelmi'}">
		<%--<homelmi:footer/>--%>
		<agg:generic_footer/>
	</c:when>

	<c:otherwise>
		<agg:footer_outer>
			<p>default footer placeholder</p>
		</agg:footer_outer>
	</c:otherwise>
</c:choose>