<%@ tag description="Load the application settings"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="vertical" 	required="false"  rtexprvalue="true"	 description="Whether to load the logging or not" %>

<%-- Page settings --%>
<jsp:useBean id="pageSettings" class="com.disc_au.web.go.Data" scope="request" />

<go:setData dataVar="pageSettings" xpath="vertical" value="${vertical}" />
<go:setData dataVar="pageSettings" xpath="brand" value="${applicationService.getBrandCodeFromRequest(pageContext.getRequest())}" />

