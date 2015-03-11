<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Header for retrieve_quotes.jsp"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="previousTransactionId"	required="true"	description="Set a vertical option"%>

<c:set var="DISCxml"><?xml version="1.0" encoding="UTF-8"?>
	<data>
		<transactionData>
			<transactionId>${data['current/transactionId']}</transactionId>
			<previousId>${previousTransactionId}</previousId>
		</transactionData>
	</data>
</c:set>
<%-- HEAD TO DISC --%>
<go:log source="save_transaction_to_disc">Saving ${data['current/transactionId']} to DISC</go:log>
<c:set var="AGIS_leadFeedCode" scope="request"><content:get key="AGIS_leadFeedCode"/></c:set>
<go:call pageId="AGGTID" wait="FALSE" resultVar="tranXml" xmlVar="${DISCxml}" transactionId="${data['current/transactionId']}" style="${AGIS_leadFeedCode}" />
<go:setData dataVar="data" xml="${tranXml}" xpath="tmpTranXml" />
<c:choose>
	<c:when test="${data.tmpTranXml.data.transactionData.transactionId == data['current/transactionId'] &&
					data.tmpTranXml.data.transactionData.previousId == previousTransactionId}">
		DISC
	</c:when>
	<c:otherwise >
		ERROR: DISC
		<go:setData dataVar="data" value="" xpath="current/transactionId" />
	</c:otherwise>
</c:choose>
<go:setData dataVar="data" value="*DELETE" xpath="tmpTranXml" />
