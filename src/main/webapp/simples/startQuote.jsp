<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="startquoteservice" class="com.ctm.services.simples.StartQuoteService" scope="application" />
<core_new:no_cache_header />
${startquoteservice.init(pageContext)}
${startquoteservice.startQuote()}
