<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="rgbValue" required="true" rtexprvalue="true" description="RGB value to convert in hexadecimal" %>

<%-- prepare the different hexadecimal characters --%>
<c:set var="hexValues">0123456789ABCDEF</c:set>
<c:set var="hexPosition" value="${(rgbValue - rgbValue % 16) / 16}" />
<c:set var="hexPositionAlt" value="${rgbValue % 16}" />

${fn:substring(hexValues, hexPosition, hexPosition + 1)}
${fn:substring(hexValues, hexPositionAlt, hexPositionAlt + 1)}