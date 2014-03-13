<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="resultsService" class="com.ctm.results.ResultsService" scope="request" />
<c:set var="jsonString" value="${resultsService.getResultItemsAsJsonString(param.vertical,param.type)}" scope="request"  />
${jsonString}