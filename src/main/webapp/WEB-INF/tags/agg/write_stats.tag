<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write quote states to the stats database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="rootPath" 	required="true"	 rtexprvalue="true"	 description="root Path like (e.g. travel)" %>
<%@ attribute name="tranId" 	required="true"	 rtexprvalue="true"	 description="transaction Id" %>
<%@ attribute name="debugXml"					required="false"	 rtexprvalue="true"	 description="debugXml (from soap aggregator)" %>


<c:set var="ignore">
	
	<c:if test="${statisticDetailsResults == null}">
		<agg:get_soap_response_stats debugXml="${debugXml}" />
	</c:if>

	<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

	<jsp:useBean id="statisticsService" class="com.ctm.statistics.StatisticsService" scope="request" />
	<c:catch var="error">
		<c:set var="calcSequence" value="${statisticsService.writeStatistics(statisticDetailsResults , tranId)}" />
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

	${statisticDetailsResults.clear()}
</c:set>