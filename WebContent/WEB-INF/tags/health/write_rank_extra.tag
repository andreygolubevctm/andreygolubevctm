<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="transactionId"	required="true"	 rtexprvalue="true"	 description="current transaction ID" %>
<%@ attribute name="calcSequence"	required="true"	 rtexprvalue="true"	 description="Calc Sequence from WriteRank" %>
<%@ attribute name="rankSequence"	required="true"	 rtexprvalue="true"	 description="Rank Sequence from WriteRank" %>
<%@ attribute name="rankPosition"	required="true"	 rtexprvalue="true"	 description="Rank Position from WriteRank" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="prefix" value="rank_" />
<c:set var="suffixes" value="lhc,rebate,price_actual,price_shown,frequency,discounted,provider,providerName,productName,productCode,premium,premiumText" />

<%-- Located expected params using the suffixes list and add to rankings_data --%>
<c:set var="sqlBulkInsert" value="" />
<c:forEach var="suffix" items="${suffixes}" varStatus="status">
	<c:set var="paramName" value="${prefix}${suffix}${rankPosition}" />
	<c:if test="${not empty param[paramName]}">
		<c:choose>
			<c:when test="${empty sqlBulkInsert}">
				<c:set var="sqlBulkInsert" value="(${transactionId},${calcSequence},${rankSequence},${rankPosition},'${suffix}','${param[paramName]}')" />
			</c:when>
			<c:otherwise>
				<c:set var="sqlBulkInsert" value="(${transactionId},${calcSequence},${rankSequence},${rankPosition},'${suffix}','${param[paramName]}'),${sqlBulkInsert}" />
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
