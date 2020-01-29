<%@ tag import="com.ctm.reward.model.SaleStatus" %>
<%@ tag import="com.ctm.web.reward.services.RewardService" %>
<%@ tag import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ tag description="The Health Set To Pending"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="errorMessage" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="transactionId" required="true" rtexprvalue="true" description="Id for this panel"%>
<%@ attribute name="resultXml" required="false" rtexprvalue="true" description="Additional css class attribute"%>
<%@ attribute name="resultJson" required="false" rtexprvalue="true" description="json to output to page"%>
<%@ attribute name="productId" required="true" rtexprvalue="true" description="Additional css class attribute"%>
<%@ attribute name="productCode" required="true" rtexprvalue="true" description="Additional css class attribute"%>
<%@ attribute name="providerId" required="true" rtexprvalue="true" description="Additional css class attribute"%>

<%
	RewardService rewardService = (RewardService) RequestContextUtils.findWebApplicationContext(request).getBean("rewardService");
	request.setAttribute("rewardServicePending", rewardService);
	request.setAttribute("rewardSaleStatusFailed", SaleStatus.Failed);
%>
<%-- Attempt to add a reward order placeholder --%>
<c:set var="ignore" value="${rewardServicePending.createPlaceholderOrderForOnline(pageContext.request, rewardSaleStatusFailed, transactionId)}" />


<c:set var="ignore">
	<jsp:useBean id="joinService" class="com.ctm.web.core.confirmation.services.JoinService" scope="page" />
	<c:set var="errorMessage" value="Application failed: ${errorMessage}" />
	<core_v1:transaction touch="F" comment="${errorMessage}" noResponse="true" productId="${productId}" />

	<%-- Application unsuccessful, provide PendingID --%>
	<c:set var="pendingID">${pageContext.session.id}-${transactionId}</c:set>
	<go:setData dataVar="data" xpath="health/pendingID" value="${pendingID}" />

	<%-- Save to store error and pendingID --%>
	<c:set var="sandbox">
		<agg_v1:write_quote rootPath="health" productType="HEALTH" triggeredsave="pending" triggeredsavereason="Pending: ${errorMessage}" />
	</c:set>
	${joinService.writeJoin(transactionId,productId,productCode,providerId)}
</c:set>
<c:choose>
	<c:when test="${not empty resultJson}">
		${resultJson}
	</c:when>
	<c:otherwise>
		<c:set var="pendingXml"><pendingID>${pendingID}</pendingID></result></c:set>
		<c:set var="resultXml" value="${fn:replace(resultXml, '</result>', pendingXml)}" />
		<c:if test="${not empty callCentre}">
			<c:set var="resultXml" value="${fn:replace(resultXml, '</result>', '<callcentre>true</callcentre></result>')}" />
		</c:if>
		${go:XMLtoJSON(resultXml)}
	</c:otherwise>
</c:choose>