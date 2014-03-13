<%@ tag description="Results tag"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="vertical"	required="true"	 	rtexprvalue="true"	 description="The vertical using the tag" %>

<%-- HTML --%>
<div id="resultsPage" class="vertical_${vertical}">
	<jsp:doBody />
	<core:clear />
</div>
