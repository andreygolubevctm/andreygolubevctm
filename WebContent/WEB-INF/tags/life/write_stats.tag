<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write quote states to the stats database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="rootPath" 	required="true"	 rtexprvalue="true"	 description="root Path like (e.g. travel)" %>
<%@ attribute name="tranId" 	required="true"	 rtexprvalue="true"	 description="transaction Id" %>
<%@ attribute name="debugXml" 	required="true"	 rtexprvalue="true"	 description="debugXml (from soap aggregator)" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%-- Get the last sequence number and increment if there is one--%>
<c:set var="calcSequence">
	<sql:query var="maxSeq">
		SELECT max(CalcSequence) AS value
		FROM aggregator.statistic_master
		WHERE TransactionId=?;
		<sql:param>${tranId}</sql:param>
	</sql:query>
	<c:choose>
		<c:when test="${maxSeq.rowCount != 0}">
			<c:out value="${maxSeq.rows[0].value + 1}" />
		</c:when>
		<c:otherwise>1</c:otherwise>
	</c:choose>
</c:set>

<go:setData dataVar="data" xpath="${rootPath}/calcSequence" value="${calcSequence}" />

<%-- Write the stat header --%>
<sql:update>
	INSERT INTO aggregator.statistic_master
	(TransactionId,CalcSequence,TransactionDate,TransactionTime)
	values (?,?,CURRENT_DATE,CURRENT_TIME);
	<sql:param>${tranId}</sql:param>
	<sql:param>${calcSequence}</sql:param>
</sql:update>

<%-- Write the stat details --%>
<x:parse var="result" xml="${debugXml}" />

<x:forEach select="$result/soap-response/results" var="thisResult">
	<c:set var="responseTime">
		<x:out select="$thisResult/@responseTime" />
	</c:set>
	<c:set var="responseMessage">Success</c:set>

	<x:forEach select="$thisResult/products/premium" var="thisPremium">
		<c:set var="serviceId">RESULTS</c:set>
		<c:set var="productId"><x:out select="$thisPremium/product_id" /></c:set>
		<sql:update>
			INSERT INTO aggregator.statistic_details
			(TransactionId,CalcSequence,ServiceId,ProductId,ResponseTime,ResponseMessage)
			values (?,?,?,?,?,?);
			<sql:param>${tranId}</sql:param>
			<sql:param>${calcSequence}</sql:param>
			<sql:param>${serviceId}</sql:param>
			<sql:param>${productId}</sql:param>
			<sql:param>${responseTime}</sql:param>
			<sql:param>${responseMessage}</sql:param>
		</sql:update>
	</x:forEach>
</x:forEach>