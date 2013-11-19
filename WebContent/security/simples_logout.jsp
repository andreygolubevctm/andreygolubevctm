<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<% session.invalidate(); %>
<c:redirect url="${data['settings/root-url']}${data.settings.styleCode}/simples.jsp" />
