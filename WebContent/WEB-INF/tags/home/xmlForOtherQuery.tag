<%@ tag language="java" pageEncoding="UTF-8" import="java.text.SimpleDateFormat, java.util.Calendar, java.util.Date"%>

	<%-- ATTRIBUTES --%>
	<%@ attribute name="tranId" required="true" rtexprvalue="true" description="The Transaction ID"%>

	<%--
		You will need these if you don't already have them
	--%>
	<%@ include file="/WEB-INF/tags/taglib.tagf" %>

	
	<jsp:useBean id="resultsService" class="com.ctm.services.ResultsService" scope="request" />

	<%-- GET RANKING FROM DB --%>
	<c:set var="rankings" value="${resultsService.getRankingsForTransactionId(tranId, 5)}" />

	<%-- GET PROPERTIES ABOUT PRODUCTS FROM DB --%>
	<c:set var="properties" value="${resultsService.getResultsPropertiesForTransactionId(tranId)}" />
	
	<c:set var="productCount" value="0" />
	<c:forEach var="ranking" items="${rankings}" varStatus="status">

		<c:set var="productId" value="${ranking.getProductId()}"/>

		<%-- Get Premium from Session variables
			TODO - make this more generic and reuse this entire file for the car edm --%>
		<c:set var="xpathVar" value="tempResultDetails/results/${productId}/price/annual/total" />
		<c:set var="premium" value="${data[xpathVar]}" />

		<c:if test="${premium > 0}">

			<c:forEach var="property" items="${properties}" varStatus="propStatus">
				<c:if test="${property.getProductId() eq productId}">
					<go:setData dataVar="data" xpath="tempSQL/results/product${ranking.getRankPosition()}/${property.getProperty()}" value="${property.getValue()}" />
				</c:if>
			</c:forEach>

			<c:set var="productCount" value="${productCount + 1}" />
			
			<go:setData dataVar="data" xpath="tempSQL/results/product${ranking.getRankPosition()}/price/annual/total" value="${premium}" />
		
		</c:if>

	</c:forEach>


	<c:if test="${productCount >= 5}">

		<%-- calculate the end valid date for these quotes --%>
	<%
		Calendar c = Calendar.getInstance();
		Date dt = new Date();

		c.setTime(dt); 
		c.add(Calendar.DATE, 30); // 30 days ahead

		SimpleDateFormat sdf = new SimpleDateFormat("dd MMMMM yyyy");
	    sdf.setCalendar(c);
	%>
		<%-- update the expiry date for the quote --%>
		<go:setData dataVar="data" xpath="tempSQL/home/validateDate" value="<%=sdf.format(c.getTime())%>" />

		<%-- output it to the page --%>
		${go:getEscapedXml(data['tempSQL'])}

	</c:if>