<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Footer text shown at the bottom of the quote"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<agg_v1:footer_outer>
	<content:get key="footerText"/>
</agg_v1:footer_outer>