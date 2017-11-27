<%@ page import="com.sun.org.apache.xpath.internal.operations.String"%><%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" authenticated="true" verticalCode="CAR" />

<%-- Foward the request to CarQuoteController --%>
<jsp:forward page="/spring/rest/car/propensity_score/get.json"/>