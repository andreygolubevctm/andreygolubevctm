<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<% response.setHeader("Cache-Control","no-cache, max-age=0"); %>

<%-- Return the results as json --%>
${go:XMLtoJSON(go:getEscapedXml(data['quote/vehicle']))}