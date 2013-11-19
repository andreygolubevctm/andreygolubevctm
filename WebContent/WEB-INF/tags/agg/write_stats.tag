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

	<c:set var="responseMessage">
		Success
	</c:set>

	<c:set var="responseTime">
		<x:out select="$thisResult/@responseTime" />
	</c:set>
	
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

<x:forEach select="$result/soap-response/error" var="thisResult">

	<c:set var="errorType">
		<x:out select="$thisResult/@type" />
	</c:set>

	<c:set var="responseMessage">
		<c:choose>
			<c:when test="${errorType == 'knock_out'}">
				knock_out
			</c:when>
			<c:when test="${errorType == 'unknown'}">
				unknown
			</c:when>
			<c:otherwise>fail</c:otherwise>
		</c:choose>
	</c:set>

	<c:set var="serviceId">
		<c:choose>
			<c:when test="${not empty thisResult.getAttribute('service')}">
				<x:out select="$thisResult/@service" />
			</c:when>
			<c:otherwise>unknown</c:otherwise>
		</c:choose>

	</c:set>

	<c:set var="productId">
		<c:choose>
			<c:when test="${not empty thisResult.getAttribute('productId')}">
				<x:out select="$thisResult/@productId" />
			</c:when>
			<c:otherwise>-1</c:otherwise>
		</c:choose>
	</c:set>

	<c:set var="responseTime">
		<c:choose>
			<c:when test="${not empty thisResult.getAttribute('responseTime')}">
				<x:out select="$thisResult/@responseTime" />
			</c:when>
			<c:otherwise>-1</c:otherwise>
		</c:choose>
	</c:set>

	<c:set var="errorCode">
		<x:out select="$thisResult/message" />
	</c:set>

	<c:set var="responseDescription">
		<x:out select="$thisResult/data" />
	</c:set>

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

	<sql:update>
		INSERT INTO aggregator.statistic_description
		(TransactionId,CalcSequence,ServiceId,ErrorType, ErrorMessage, ErrorDetail)
		values (?,?,?,?,?,?);
		<sql:param>${tranId}</sql:param>
		<sql:param>${calcSequence}</sql:param>
		<sql:param>${serviceId}</sql:param>
		<sql:param>${errorType}</sql:param>
		<sql:param>${fn:substring(errorCode,0,255)}</sql:param>
		<sql:param>${responseDescription}</sql:param>
	</sql:update>

</x:forEach>

<%--TODO: CAR-29 remove this once we are off disc --%>
<c:if test="${rootPath == 'car'}">
	<go:log>Writing Results to iSeries</go:log>
	<go:call pageId="AGGTRS"  xmlVar="${debugXml}" wait="FALSE" transactionId="${tranId}" />
</c:if>