<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="transactionId"	required="true"	 rtexprvalue="true"	 description="current transaction ID" %>
<%@ attribute name="calcSequence"	required="true"	 rtexprvalue="true"	 description="Calc Sequence from WriteRank" %>
<%@ attribute name="rankSequence"	required="true"	 rtexprvalue="true"	 description="Rank Sequence from WriteRank" %>
<%@ attribute name="rankPosition"	required="true"	 rtexprvalue="true"	 description="Rank Position from WriteRank" %>


<c:set var="best_price_param_name">best_price${rankPosition}</c:set>
<c:if test="${not empty param[best_price_param_name]}">

	<go:setData dataVar="data" xpath="travel/bestPricePosition" value="${rankPosition}" />

	<travel:best_price calcSequence="${calcSequence}" rankPosition="${rankPosition}" rankSequence="${rankSequence}" transactionId="${transactionId}" />

	<%-- Attempt to send email only after best price has been set --%>
	<c:if test="${not empty data.travel.email && empty data.userData.emailSent}">
		<c:set var="hashedEmail"><security:hashed_email action="encrypt" email="${data.travel.email}" brand="CTM" /></c:set>
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