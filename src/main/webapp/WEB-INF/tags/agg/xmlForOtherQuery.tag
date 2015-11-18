<%@ tag language="java" pageEncoding="UTF-8"%>

	<%-- ATTRIBUTES --%>
	<%@ attribute name="tranId" 	required="true" rtexprvalue="true" description="The Transaction ID"%>
	<%@ attribute name="vertical" 	required="true" rtexprvalue="true" description="Ze Vertical"%>
	<%@ attribute name="hashedEmail" required="true" rtexprvalue="true" description="Hashed Email"%>
	<%@ attribute name="emailTokenType" required="true" rtexprvalue="true" description="Email Token Type"%>
	<%@ attribute name="emailAction" required="true" rtexprvalue="true" description="Email Action"%>
	<%@ attribute name="emailTokenEnabled" required="true" rtexprvalue="true" description="Flag to check if email token creating is enabled"%>

	<%--
		You will need these if you don't already have them
	--%>
	<%@ include file="/WEB-INF/tags/taglib.tagf" %>


	<jsp:useBean id="resultsService" class="com.ctm.web.core.services.ResultsService" scope="request" />

	<%-- GET RANKING FROM DB --%>
	<c:set var="rankings" value="${resultsService.getRankingsForTransactionId(tranId, 5)}" />

	<%-- GET PROPERTIES ABOUT PRODUCTS FROM DB --%>
	<c:set var="properties" value="${resultsService.getResultsPropertiesForTransactionId(tranId)}" />

	<c:set var="premiumXPath">
		<c:if test="${vertical == 'home'}">price/annual/total</c:if>
		<c:if test="${vertical == 'car'}">headline/lumpSumTotal</c:if>
	</c:set>

	<c:set var="productCount" value="0" />

	<c:if test="${emailTokenEnabled}">
		<jsp:useBean id="tokenServiceFactory" class="com.ctm.web.core.email.services.token.EmailTokenServiceFactory"/>
		<c:set var="tokenService" value="${tokenServiceFactory.getEmailTokenServiceInstance(pageSettings)}" />
		<c:set var="emailVar" value="${tokenService.insertEmailTokenRecord(tranId, hashedEmail, pageSettings.getBrandId(), emailTokenType, 'load')}" />
	</c:if>

	<c:forEach var="ranking" items="${rankings}" varStatus="status">

		<c:set var="productId" value="${ranking.getProductId()}"/>

		<%-- Get Premium from Session variables --%>
		<c:set var="xpathVar" value="tempResultDetails/results/${productId}/${premiumXPath}" />
		<c:set var="premium" value="${data[xpathVar]}" />

		<c:if test="${premium > 0}">

			<c:forEach var="property" items="${properties}" varStatus="propStatus">
				<c:if test="${property.getProductId() eq productId}">
					<go:setData dataVar="data" xpath="tempSQL/results/product${ranking.getRankPosition()}/${property.getProperty()}" value="${property.getValue()}" />

					<c:if test="${emailTokenEnabled}">
						<c:set var="loadQuoteToken" value="${tokenService.generateToken(tranId, hashedEmail, pageSettings.getBrandId(), emailTokenType, emailAction, productId, null, vertical, null, false)}" />
						<go:setData dataVar="data" xpath="tempSQL/results/product${ranking.getRankPosition()}/loadQuoteToken" value="${loadQuoteToken}" />
					</c:if>
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