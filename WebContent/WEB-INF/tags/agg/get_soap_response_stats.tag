<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="get quote states"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="debugXml" 	required="true"	 rtexprvalue="true"	 description="root Path like (e.g. travel)" %>
<%@ tag import="com.ctm.statistics.dao.StatisticDetail" %>
<%@ tag import="com.ctm.statistics.dao.StatisticDescription" %>
<%@ tag import="java.util.List" %>
<%@ tag import="java.util.ArrayList" %>
<%
	List<StatisticDetail> statisticDetails = new ArrayList<StatisticDetail>();
	request.setAttribute("statisticDetailsResults", statisticDetails);
%>

<x:parse var="result" xml="${debugXml}" />
<x:forEach select="$result/soap-response/results" var="thisResult">
	<c:set var="responseTime"><x:out select="$thisResult/@responseTime" /></c:set>
	<x:forEach select="$thisResult/price" var="thisPrice">
		<c:set var="serviceId"><x:out select="$thisPrice/@service" /></c:set>
		<c:set var="productId"><x:out select="$thisPrice/@productId" /></c:set>
		<%
			com.ctm.statistics.dao.StatisticDetail statisticDetail = new com.ctm.statistics.dao.StatisticDetail();
			request.setAttribute("statisticDetail", statisticDetail);
		%>
		${statisticDetail.setServiceId(serviceId)}
		${statisticDetail.setProductId(productId)}
		${statisticDetail.setResponseTime(responseTime)}
		${statisticDetail.setResponseMessage('Success')}
		${statisticDetailsResults.add(statisticDetail)}
	</x:forEach>
</x:forEach>

<x:forEach select="$result/soap-response/error" var="thisError">
	<c:set var="errorType"><x:out select="$thisError/@type" /></c:set>
	<c:set var="serviceId"><x:out select="$thisError/@service" /></c:set>
	<c:set var="productId"><x:out select="$thisError/@productId" /></c:set>
	<c:set var="responseTime"><x:out select="$thisError/@responseTime" /></c:set>
	<c:set var="errorCode"><x:out select="$thisError/message" /></c:set>
	<c:set var="errorDetail"><x:out select="$thisError/data" /></c:set>
	<%
		StatisticDetail statisticDetail = new StatisticDetail();
		request.setAttribute("statisticDetail", statisticDetail);
		StatisticDescription statisticDescription = new StatisticDescription();
		request.setAttribute("statisticDescription", statisticDescription);
	%>
	${statisticDetail.setProductId(productId)}
	${statisticDetail.setResponseTime(responseTime)}
	${statisticDetail.setServiceId(serviceId)}
	<c:choose>
		<c:when test="${errorType == 'knock_out' || errorType == 'unknown'}">
			${statisticDetail.setResponseMessage(errorType)}
		</c:when>
		<c:otherwise>${statisticDetail.setResponseMessage('fail')}</c:otherwise>
	</c:choose>
	${statisticDescription.setErrorType(errorType)}
	${statisticDescription.setErrorMessage(fn:substring(errorCode,0,255))}
	${statisticDescription.setErrorDetail(fn:substring(errorDetail,0,255))}
	${statisticDetail.setStatisticDescription(statisticDescription)}

	${statisticDetailsResults.add(statisticDetail)}
</x:forEach>