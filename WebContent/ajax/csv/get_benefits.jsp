<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Set the vertical, otherwise it throws "No vertical set on page context" exception --%>
<settings:setVertical verticalCode="HEALTH" />

<%-- Get the benefits and extras codes for the health cover situatuation --%>
<c:set var="contentItems" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "healthSituCvr")}' />
<c:set var="cvrString" value="${contentItems.getSupplementaryValueByKey(param.situation)}" />

${cvrString}