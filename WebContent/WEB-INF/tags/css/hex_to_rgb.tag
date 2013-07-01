<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="hexValue" required="true" rtexprvalue="true" description="Hexadecimal color value to convert to RGB" %>

<c:if test="${fn:length(hexValue) == 4}">
	<c:set var="hexValue">#${fn:substring(hexValue, 1,2)}${fn:substring(hexValue, 1,2)}${fn:substring(hexValue, 2,3)}${fn:substring(hexValue, 2,3)}${fn:substring(hexValue, 3,4)}${fn:substring(hexValue, 3,4)}</c:set>
</c:if>
<c:set var="firstPair">${fn:substring(hexValue, 1,3)}</c:set>
<c:set var="secondPair">${fn:substring(hexValue, 3,5)}</c:set>
<c:set var="thirdPair">${fn:substring(hexValue, 5,7)}</c:set>

${go:hexToDec(firstPair)},${go:hexToDec(secondPair)},${go:hexToDec(thirdPair)}