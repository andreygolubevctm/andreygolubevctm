<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	<go:log>Writing Ranking</go:log>
	<go:setData dataVar="data" xpath="ranking" value="*DELETE" />
	<go:setData dataVar="data" value="*PARAMS" />
--%>
<go:log>${data.xml['ranking']}</go:log>

<go:script>
</go:script>