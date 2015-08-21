<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="callCentreService" class="com.ctm.services.CallCentreService" scope="application" />

<core_new:no_cache_header />
<jsp:useBean id="startquoteservice" class="com.ctm.services.simples.StartQuoteService" scope="application" />
${startquoteservice.init(pageContext)}
${startquoteservice.startQuote()}