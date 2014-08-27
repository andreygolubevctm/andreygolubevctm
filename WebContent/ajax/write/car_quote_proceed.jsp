<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" authenticated="true" verticalCode="CAR" />

<c:set var="proceeded" value="${param.proceeded}" />


<jsp:useBean id="now" class="java.util.Date" scope="request" />
<fmt:formatDate value="${now}" pattern="dd/MM/YYYY HH:mm:ss" />


<go:setData dataVar="data" xpath="quote/proceed/proceeded" value="${proceeded}" />
<go:setData dataVar="data" xpath="quote/proceed/datetime" value="${now}" />

<c:choose>
	<c:when test="${proceeded =='false' }">
		<c:set var="proceeded" value="Cancelled" />
	</c:when>
	<c:otherwise>
		<c:set var="proceeded" value="Transferred" />
	</c:otherwise>
</c:choose>

<%-- Update the Transaction and stamp it --%>

<agg:write_quote productType="quote" rootPath="quote" />

<agg:write_stamp
		action="toggle_quoteProcceding"
		vertical="CAR"
		target="Proceeded"
		value="${proceeded}"
		comment="QUOTE" />

