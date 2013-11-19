<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write quote states to the stats database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

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


<%-- Store the calcSequence in data (for later use) --%>
<go:setData dataVar="data" xpath="fuel/calcSequence" value="${calcSequence}" />

<%-- Write the stat header --%>
<sql:update>
 	INSERT INTO aggregator.statistic_master 
 	(TransactionId,CalcSequence,TransactionDate,TransactionTime) 
	values (?,${calcSequence},CURRENT_DATE,CURRENT_TIME);
	<sql:param>${tranId}</sql:param>
 </sql:update>

<%-- Write the stat details --%>
<x:parse var="result" xml="${debugXml}" />

<x:forEach select="$result/soap-response/results" var="thisResult">
	<c:set var="responseTime">
		<x:out select="$thisResult/@responseTime" />
	</c:set>
	<c:set var="responseMessage">Success</c:set>
	
	<%--
	<c:set var="responseMsg">
		<x:out select="@responseMessage" />
	</c:set>
	--%>
	<x:forEach select="$thisResult/price" var="thisPrice">
		<c:set var="serviceId">
			<x:out select="$thisPrice/@service" />
		</c:set>
		<c:set var="productId">
			<x:out select="$thisPrice/@productId" />
		</c:set>
		<sql:update>
		 	INSERT INTO aggregator.statistic_details 
		 	(TransactionId,CalcSequence,ServiceId,ProductId,ResponseTime,ResponseMessage) 
			values (?,${calcSequence},?,?,?,?);
			<sql:param>${tranId}</sql:param>
			<sql:param>${serviceId}</sql:param>
			<sql:param>${productId}</sql:param>
			<sql:param>${responseTime}</sql:param>
			<sql:param>${responseMessage}</sql:param>
		 </sql:update>
	</x:forEach>
</x:forEach>