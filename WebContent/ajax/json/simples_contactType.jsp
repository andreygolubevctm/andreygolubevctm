<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />


<go:setData dataVar="data" xpath="health/simples/contactType" value="${param.contactType}" />

<c:set var="contactType" value="${param.contactType}" scope="session" />
