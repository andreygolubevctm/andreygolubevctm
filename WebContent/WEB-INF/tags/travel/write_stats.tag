<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Write quote states to the stats database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="tranId" 	required="true"	 rtexprvalue="true"	 description="transaction Id" %>
<%@ attribute name="debugXml" 	required="true"	 rtexprvalue="true"	 description="debugXml (from soap aggregator)" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%-- Get the last sequence number and increment if there is one--%>
<c:set var="calcSequence">
	<sql:query var="maxSeq">
		SELECT max(CalcSequence)
		FROM aggregator.statistic_master
		WHERE TransactionId=${tranId};
	</sql:query>
	<c:choose>
		<c:when test="${maxSeq.rowCount != 0}">
			<c:out value="${maxSeq.rows[0].value + 1}" />
		</c:when>
		<c:otherwise>1</c:otherwise>
	</c:choose>
</c:set>

<%-- Store the calcSequence in data (for later use) --%>
<go:setData dataVar="data" xpath="travel/calcSequence" value="${calcSequence}" />

<%-- Write the stat header --%>
<sql:update>
 	INSERT INTO aggregator.statistic_master 
 	(TransactionId,CalcSequence,TransactionDate,TransactionTime) 
 	values (
 		${tranId},
 		${calcSequence},
 		CURRENT_DATE,
 		CURRENT_TIME
 	); 
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
		 	values (
		 		${tranId},
		 		${calcSequence},
		 		'${serviceId}',
		 		'${productId}',
		 		'${responseTime}',
		 		'${responseMessage}'
		 	); 
		 </sql:update>
	</x:forEach>
</x:forEach>