<%--
	Whitelabeled footer.
--%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<p>
    <content:get key="eslMessage"/>
    <content:get key="footerText"/><content:get key="footerTextStart"/><content:get key="footerParticipatingSuppliers"/><content:get key="footerTextEnd"/>
</p>