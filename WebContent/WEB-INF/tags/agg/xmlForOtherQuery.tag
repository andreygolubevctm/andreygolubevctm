<%@ tag language="java" pageEncoding="UTF-8"%>

	<%-- ATTRIBUTES --%>
	<%@ attribute name="tranId" 	required="true" rtexprvalue="true" description="The Transaction ID"%>
	<%@ attribute name="vertical" 	required="true" rtexprvalue="true" description="Ze Vertical"%>
	<%--
		You will need these if you don't already have them
	--%>
	<%@ include file="/WEB-INF/tags/taglib.tagf" %>


	<jsp:useBean id="resultsService" class="com.ctm.services.ResultsService" scope="request" />

	<%-- GET RANKING FROM DB --%>
	<c:set var="rankings" value="${resultsService.getRankingsForTransactionId(tranId, 5)}" />

	<%-- GET PROPERTIES ABOUT PRODUCTS FROM DB --%>
	<c:set var="properties" value="${resultsService.getResultsPropertiesForTransactionId(tranId)}" />

	<c:set var="premiumXPath">
		<c:if test="${vertical == 'home'}">price/annual/total</c:if>
		<c:if test="${vertical == 'car'}">headline/lumpSumTotal</c:if>
	</c:set>

	<c:set var="productCount" value="0" />
	<c:forEach var="ranking" items="${rankings}" varStatus="status">

		<c:set var="productId" value="${ranking.getProductId()}"/>

		<%-- Get Premium from Session variables --%>
		<c:set var="xpathVar" value="tempResultDetails/results/${productId}/${premiumXPath}" />
		<c:set var="premium" value="${data[xpathVar]}" />

		<c:if test="${premium > 0}">

			<c:forEach var="property" items="${properties}" varStatus="propStatus">
				<c:if test="${property.getProductId() eq productId}">
					<go:setData dataVar="data" xpath="tempSQL/results/product${ranking.getRankPosition()}/${property.getProperty()}" value="${property.getValue()}" />
				</c:if>
			</c:forEach>

			<c:set var="productCount" value="${productCount + 1}" />

			<go:setData dataVar="data" xpath="tempSQL/results/product${ranking.getRankPosition()}/${premiumXPath}" value="${premium}" />

		</c:if>

	</c:forEach>


	<c:if test="${productCount >= 5}">
		<%-- output it to the page --%>
		${go:getEscapedXml(data['tempSQL'])}
	</c:if>