<%@ tag import="com.ctm.web.reward.services.RewardService" %>
<%@ tag import="com.ctm.web.reward.services.RewardTrackingService" %>
<%@ tag import="com.ctm.reward.model.TrackingStatusResponse" %>
<%@ tag import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ tag description="Reward Service Queries and Loading"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Setup Internal RewardService --%>
<%
    RewardService rewardService = (RewardService) RequestContextUtils.findWebApplicationContext(request).getBean("rewardService");
    request.setAttribute("rewardService", rewardService);
%>

<%-- GET rewardOrder from encryptedOrderLineId Token --%>
<c:set var="encryptedOrderLineId" >${param.token}</c:set>
<c:choose>
    <c:when test="${not empty encryptedOrderLineId}">
        <c:set var="rewardOrder" value="${rewardService.getOrderAsJson(encryptedOrderLineId, pageContext.request)}" />
    </c:when>
    <c:otherwise>
        <c:set var="rewardOrder" value="{}" />
    </c:otherwise>
</c:choose>

<%-- Global JS Variables --%>
<script>
    var rewardOrder = ${rewardOrder};
    var encryptedOrderLineId = "${encryptedOrderLineId}";
</script>

<%-- Redemption Confirmation / Error Container --%>
<div class="redemption-message-container hide">
    <h1 class="redemption-title"></h1>
    <p class="redemption-lead hide">If this is not the case, please contact us at <a href="mailto:toys@comparethemarket.com.au" target="_top">toys@comparethemarket.com.au</a></p>

    <div class="redemption-back-container col-xs-12 col-sm-3">
        <a class="btn btn-next btn-block" href="https://www.comparethemarket.com.au/">Back to home page</a>
    </div>

    <div class="redemption-cross-sell">
        <h2 class="redemption-cross-sell-title">Is there anything else we can help you with?</h2>
        <confirmation:other_products />
    </div>
</div>