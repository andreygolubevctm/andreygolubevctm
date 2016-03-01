<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Other Products Renderer"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="id" required="false" rtexprvalue="true" description="id of the fieldset" %>

<c:set var="heading"><content:get key="noQuoteTitle"/></c:set>
<c:set var="body"><content:get key="noQuoteBody"/></c:set>
<confirmation:other_products heading="${heading}" copy="${body}" id="${id}"/>