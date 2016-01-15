<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Hidden Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" 		required="true"		rtexprvalue="true"	 description="" %>

<c:if test="${ not empty data && (empty data[xpath].mobile) && (not empty data['health/application/mobile']) }">
    <go:setData dataVar="data" xpath="${xpath}/mobile" value="${data['health/application/mobile']}" />
</c:if>
<c:if test="${ not empty data && (empty data[xpath].other) && (not empty data['health/application/other']) }">
    <go:setData dataVar="data" xpath="${xpath}/other" value="${data['health/application/other']}" />
</c:if>

<field:hidden xpath="${xpath}/mobile" />
<field:hidden xpath="${xpath}/other" />