<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write quote states to the stats database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="rootPath" 	required="true"	 rtexprvalue="true"	 description="root Path like (e.g. travel)" %>
<%@ attribute name="tranId" 	required="true"	 rtexprvalue="true"	 description="transaction Id" %>
<%@ attribute name="debugXml"					required="false"	 rtexprvalue="true"	 description="debugXml (from soap aggregator)" %>

<go:log>WRITE STATS: ${rootPath}</go:log>
<c:set var="ignore">
	<go:log>statisticDetailsResults: ${statisticDetailsResults}</go:log>
	<c:if test="${statisticDetailsResults == null}">
		<agg:get_soap_response_stats debugXml="${debugXml}" />
	</c:if>

<sql:setDataSource dataSource="jdbc/aggregator"/>

	<jsp:useBean id="statisticsService" class="com.ctm.statistics.StatisticsService" scope="request" />
	<c:catch var="error">
		<c:set var="calcSequence" value="${statisticsService.writeStatistics(statisticDetailsResults , tranId)}" />
		<go:log>calcSequence: ${calcSequence}</go:log>
<go:setData dataVar="data" xpath="${rootPath}/calcSequence" value="${calcSequence}" />
	</c:catch>
	<c:if test="${not empty error}">
		<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
			<c:param name="transactionId" value="${tranId}" />
			<c:param name="page" value="${pageContext.request.servletPath}" />
			<c:param name="message" value="Failed to write to stats" />
			<c:param name="description" value="${error}" />
			<c:param name="data" value="${debugXml}" />
		</c:import>
	</c:if>

<%--TODO: CAR-29 remove this once we are off disc --%>
	<c:if test="${rootPath == 'quote'}">
	<go:log>Writing Results to iSeries</go:log>
		<c:set var="AGIS_leadFeedCode" scope="request"><content:get key="AGIS_leadFeedCode"/></c:set>
		<go:call pageId="AGGTRS"  xmlVar="${debugXml}" wait="FALSE" transactionId="${tranId}" style="${AGIS_leadFeedCode}" />
	</c:if>
	${statisticDetailsResults.clear()}
</c:set>