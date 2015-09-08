<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Footer text shown at the bottom of the quote"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<agg:footer_outer>
	<content:get key="footerTextStart"/><content:get key="footerParticipatingSuppliers"/><content:get key="footerTextEnd"/>
</agg:footer_outer>