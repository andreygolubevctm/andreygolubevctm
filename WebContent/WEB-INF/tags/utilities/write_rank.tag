<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="transactionId" value="${data['current/transactionId']}" />
<c:set var="calcSequence" value="${data['utilities/calcSequence']}" />
<c:set var="rankBy">${param.rankBy}</c:set>>

<%-- If rankBy value too long for DB column, trim left chars --%>
<c:if test="${fn:length(param.rankBy) > 20}">
	<c:set var="rankBy">${fn:substring(param.rankBy, fn:length(param.rankBy)-20, fn:length(param.rankBy))}</c:set>
</c:if>

<c:set var="rankSequence">
	<sql:query var="maxSeq">
		SELECT max(RankSequence) AS prevRank
		FROM aggregator.ranking_master
		WHERE TransactionId=${transactionId} 
		AND CalcSequence=${calcSequence};
	</sql:query>
	
	<c:choose>
		<c:when test="${maxSeq.rowCount != 0}">${maxSeq.rows[0].prevRank + 1}</c:when>
		<c:otherwise>0</c:otherwise>		
	</c:choose>
</c:set>

<%-- Write the ranking master --%>
<sql:update>
	INSERT INTO aggregator.ranking_master
	(TransactionId,CalcSequence,RankSequence,RankBy) 
	values (
		'${transactionId}',
		'${calcSequence}',
		'${rankSequence}',
		'${rankBy}'
	);
</sql:update>

<%-- Read through the params --%>
<c:forEach var="position" begin="0" end="${param.rank_count-1}" varStatus="status">
	<c:set var="paramName" value="rank_product_id${position}" />
	<c:set var="productId" value="${param[paramName]}"/>
	
	<sql:update>
		INSERT INTO aggregator.ranking_details 
		(TransactionId,CalcSequence,RankSequence,RankPosition,ProductId) 
		VALUES (
			'${transactionId}',
			'${calcSequence}',
			'${rankSequence}',
			'${position}',
			'${productId}'
		);
	</sql:update>
</c:forEach>
