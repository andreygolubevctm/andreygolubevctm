<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="transactionId" value="${data['current/transactionId']}" />
<c:set var="calcSequence" value="${data['travel/calcSequence']}" />

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
	values (?,?,?,?);
	<sql:param>${transactionId}</sql:param>
	<sql:param>${calcSequence}</sql:param>
	<sql:param>${rankSequence}</sql:param>
	<sql:param>${param.rankBy}</sql:param>
 </sql:update>

<%-- Read through the params --%>
<c:forEach var="position" begin="0" end="${param.rank_count-1}" varStatus="status">
	<c:set var="paramName" value="rank_productId${position}" />
	<c:set var="productId" value="${param[paramName]}"/>
	
	<sql:update>
	 	INSERT INTO aggregator.ranking_details 
		(TransactionId,CalcSequence,RankSequence,RankPosition,Property,Value)
		VALUES (?,?,?,?,'productId',?);
		<sql:param>${transactionId}</sql:param>
		<sql:param>${calcSequence}</sql:param>
		<sql:param>${rankSequence}</sql:param>
		<sql:param>${position}</sql:param>
		<sql:param>${productId}</sql:param>
	</sql:update>

	<c:set var="best_price_param_name">best_price${position}</c:set>
	<c:if test="${not empty param[best_price_param_name]}">

		<go:setData dataVar="data" xpath="travel/bestPricePosition" value="${position}" />

		<travel:best_price calcSequence="${calcSequence}" rankPosition="${position}" rankSequence="${rankSequence}" transactionId="${transactionId}" />

		<%-- Attempt to send email only after best price has been set --%>
		<c:if test="${not empty data.travel.email && empty data.userData.emailSent}">
			<c:set var="hashedEmail"><security:hashed_email action="encrypt" email="${data.travel.email}" brand="${brand}" /></c:set>
			<c:set var="emailResponse">
				<c:import url="../json/send.jsp">
					<c:param name="mode" value="edm" />
					<c:param name="tmpl" value="travel" />
					<c:param name="hashedEmail" value="${hashedEmail}" />
				</c:import>
			</c:set>
			<go:setData dataVar="data" xpath="userData/emailSent" value="true" />
		</c:if>
	</c:if>
</c:forEach>