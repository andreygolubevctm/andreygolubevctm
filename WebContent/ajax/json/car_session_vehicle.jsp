<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<% response.setHeader("Cache-Control","no-cache, max-age=0"); %>

<session:get />

<%-- Return the results as json --%>
${go:XMLtoJSON(go:getEscapedXml(data['quote/vehicle']))}