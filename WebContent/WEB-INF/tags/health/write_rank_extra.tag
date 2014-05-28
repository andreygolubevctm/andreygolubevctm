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
<c:forEach var="suffix" items="${suffixes}" varStatus="status">
	<c:set var="paramName" value="${prefix}${suffix}${rankPosition}" />
	<c:if test="${not empty param[paramName]}">
		<sql:update>
			INSERT INTO aggregator.ranking_details
			(TransactionId,CalcSequence,RankSequence,RankPosition,Property,Value)
			VALUES (?,?,?,?,?,?);
			<sql:param>${transactionId}</sql:param>
			<sql:param>${calcSequence}</sql:param>
			<sql:param>${rankSequence}</sql:param>
			<sql:param>${rankPosition}</sql:param>
			<sql:param>${suffix}</sql:param>
			<sql:param>${param[paramName]}</sql:param>
		</sql:update>
	</c:if>
</c:forEach>