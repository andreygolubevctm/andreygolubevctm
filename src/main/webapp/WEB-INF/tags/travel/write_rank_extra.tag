<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="transactionId"	required="true"	 rtexprvalue="true"	 description="current transaction ID" %>
<%@ attribute name="calcSequence"	required="true"	 rtexprvalue="true"	 description="Calc Sequence from WriteRank" %>
<%@ attribute name="rankSequence"	required="true"	 rtexprvalue="true"	 description="Rank Sequence from WriteRank" %>
<%@ attribute name="rankPosition"	required="true"	 rtexprvalue="true"	 description="Rank Position from WriteRank" %>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<c:set var="best_price_param_name">best_price${rankPosition}</c:set>
<%-- Left this line below in as removing prevents the price from being picked up and sent. Quite possibly due to the permissions system  --%>
<c:if test="${not empty param[best_price_param_name]}">
	<%-- Used by dreammail/send.jsp xmlForOtherQuery call ---%>
	<go:setData dataVar="data" xpath="travel/bestPricePosition" value="${rankPosition}" />

	<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

	<c:set var="prefix" value="best_price_" />
	<c:set var="suffixes" value="productId,providerName,service,productName,excess,medical,cxdfee,luggage,rentalVehicle,price,url,coverLevelType" />
	<c:set var="search" value="'" />
	<c:set var="replace" value="\\'" />

	<%-- This should be made core when cover level tabs is available on more verticals --%>
	<c:if test="${rankPosition eq 0}">
		<%-- set the cover level tab --%>
		<c:set var="coverLevelParamName" value="coverLevelType${rankPosition}" />
		<go:setData dataVar="data" xpath="travel/coverLevelTab" value="${param[coverLevelParamName]}" />
	</c:if>


	<c:if test="${rankPosition eq 0 and not empty data.travel.coverLevelTab}">
		<sql:update>
			INSERT INTO aggregator.ranking_details
			(TransactionId,CalcSequence,RankSequence,RankPosition,Property,Value)
			VALUES (${transactionId},${calcSequence},${rankSequence},${rankPosition},'coverLevelType','${data.travel.coverLevelTab}')
		</sql:update>
	</c:if>

	<%-- Located expected params using the suffixes list and add to rankings_data --%>
	<c:set var="sqlBulkInsert" value="" />
	<c:forEach var="suffix" items="${suffixes}" varStatus="status">
		<c:set var="paramName" value="${prefix}${suffix}${rankPosition}" />
		<c:set var="paramValue" value="${fn:replace(param[paramName], search, replace)}" />
		<c:if test="${not empty param[paramName]}">
			<c:choose>
				<c:when test="${empty sqlBulkInsert}">
					<c:set var="sqlBulkInsert" value="(${transactionId},${calcSequence},${rankSequence},${rankPosition},'${suffix}','${paramValue}')" />
				</c:when>
				<c:otherwise>
					<c:set var="sqlBulkInsert" value="(${transactionId},${calcSequence},${rankSequence},${rankPosition},'${suffix}','${paramValue}'),${sqlBulkInsert}" />
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:forEach>

	<c:if test="${not empty sqlBulkInsert}">
		<sql:update>
			INSERT INTO aggregator.ranking_details
			(TransactionId,CalcSequence,RankSequence,RankPosition,Property,Value)
			VALUES ${sqlBulkInsert}
		</sql:update>
	</c:if>
</c:if>