<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core_v2:no_cache_header />
<jsp:useBean id="startquoteservice" class="com.ctm.web.simples.services.StartQuoteService" scope="application" />
${startquoteservice.init(pageContext)}
${startquoteservice.startQuote()}