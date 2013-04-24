<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- 
	lead_feed_save.jsp
	
	Used to record callback requests/lead feeds on the iSeries. 
 --%>

<go:setData dataVar="data" value="*DELETE" xpath="request" />
<go:setData dataVar="data" value="*PARAMS" xpath="request" />

<c:choose>

	<c:when test="${empty data.request.source
					or empty data.request.leadNo
					or empty data.request.client
					or empty data.request.clientTel
					or empty data.request.state
					or empty data.request.brand
					or empty data.request.message }">
		Some information was missing, please make sure you have input all the necessary information.
	</c:when>
	
	<c:otherwise>
		<c:set var="myParams">
			<callback>
				<source>${data.request.source}</source>
				<leadNumber>${data.request.leadNo}</leadNumber>
				<client>${data.request.client}</client>
				<clientTel>${data.request.clientTel}</clientTel>
				<state>${data.request.state}</state>
				<brand>${data.request.brand}</brand>
				<message>${data.request.message}</message>
				<c:if test="${not empty data.request.vdn}"><vdn>${data.request.vdn}</vdn></c:if>
			</callback>
		</c:set>
		
		<go:log>Recording Lead Feed</go:log>
		<go:call transactionId="${data.current.transactionId}" pageId="AGGCME" xmlVar="myParams" resultVar="myResult" />
		
		<c:choose>
			<c:when test="${myResult == 'OK'}">true</c:when>
			<c:otherwise>We could not record your request in our system, please try again or contact us if the issue persists.</c:otherwise>
		</c:choose>
		
	</c:otherwise>
	
</c:choose>
