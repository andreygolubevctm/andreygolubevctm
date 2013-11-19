<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="transactionId" value="${data['fuel/transactionId']}" />
<c:set var="calcSequence" value="${data['fuel/calcSequence']}" />

<c:set var="rankSequence">
	<sql:query var="maxSeq">
		SELECT max(RankSequence) AS prevRank
		FROM aggregator.ranking_master
		WHERE TransactionId=?
		AND CalcSequence=?
		<sql:param>${transactionId}</sql:param>
		<sql:param>${calcSequence}</sql:param>
	</sql:query>
	
	<c:choose>
		<c:when test="${maxSeq.rowCount != 0}">
			<c:out value="${maxSeq.rows[0].prevRank + 1}" />
		</c:when>
		<c:otherwise>0</c:otherwise>		
	</c:choose>
</c:set>

<%-- Write the ranking master --%>
<sql:update>
 	INSERT INTO aggregator.ranking_master
 	(TransactionId,CalcSequence,RankSequence,RankBy) 
	values (?,?,'${rankSequence}',?);
	<sql:param>${transactionId}</sql:param>
	<sql:param>${calcSequence}</sql:param>
	<sql:param>${param.rankBy}</sql:param>
 </sql:update>

<%-- Read through the params --%>
<c:forEach var="position" begin="0" end="${param.rank_count-1}" varStatus="status">
	<c:set var="paramName" value="rank_productId${position}" />
	<c:set var="productId" value="${param[paramName]}"/>
	
	<sql:update>
	 	INSERT INTO aggregator.ranking_details 
	 	(TransactionId,CalcSequence,RankSequence,RankPosition,ProductId) 
		VALUES (?,'${calcSequence}',?,?,?);
		<sql:param>${transactionId}</sql:param>
		<sql:param>${rankSequence}</sql:param>
		<sql:param>${position}</sql:param>
		<sql:param>${productId}</sql:param>
	</sql:update>
	
	
</c:forEach>

