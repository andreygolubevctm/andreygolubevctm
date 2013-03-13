<%@ tag trimDirectiveWhitespaces="true" %>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Creates an IP integer number from an IP address"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>


<%-- ATTRIBUTES --%>
<%@ attribute name="ip" 		required="true"	description="The IP number for an IP address" %>

 <%-- !!!-KEEP-!!! it is the maths behind the sums
 	(first octet * 256³) + (second octet * 256²) + (third octet * 256) + (fourth octet)
=	(first octet * 16777216) + (second octet * 65536) + (third octet * 256) + (fourth octet)
=	(202 * 16777216) + (56 * 65536) + (61 * 256) + (2)
=	3392683266
--%>

<c:forTokens delims=".:" items="${ip}" var="token" varStatus="status">
	<c:choose>
		<c:when test="${status.count == 1  }">
			<c:set var="octet_1" value="${token}" />
		</c:when>
		<c:when test="${status.count == 2  }">
			<c:set var="octet_2" value="${token}" />
		</c:when>
		<c:when test="${status.count == 3 }">
			<c:set var="octet_3" value="${token}" />
		</c:when>				
		<c:when test="${status.count == 4 }">
			<c:set var="octet_4" value="${token}" />
		</c:when>				
	</c:choose>
</c:forTokens>

<c:set var="ipInteger" value="${ (octet_1 * 16777216) + (octet_2 * 65536) + (octet_3 * 256) + (octet_4) }" />

<c:out value="${ipInteger}" />