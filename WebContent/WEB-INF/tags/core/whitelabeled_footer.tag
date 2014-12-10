<%--
	Whitelabeled footer. Currently used for Car and Home, runs of DB content control.
--%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<p>
	<content:get key="footerTextStart"/><content:get key="footerParticipatingSuppliers"/><content:get key="footerTextEnd"/>
</p>