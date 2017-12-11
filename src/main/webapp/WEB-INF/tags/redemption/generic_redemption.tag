<%@ tag import="com.ctm.web.reward.services.RewardService" %>
<%@ tag import="com.ctm.web.reward.services.RewardTrackingService" %>
<%@ tag import="com.ctm.reward.model.TrackingStatusResponse" %>
<%@ tag import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ tag description="Reward Service Queries and Loading"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%
    RewardService rewardService = (RewardService) RequestContextUtils.findWebApplicationContext(request).getBean("rewardService");
    request.setAttribute("rewardService", rewardService);

    // http://localhost:8080/ctm/redemption.jsp?token=6pvE7AjvZPGbrZhwJula_w

%>
<c:set var="token" >${param.token}</c:set>

<c:choose>
    <c:when test="${not empty token}">
        <c:set var="rewardOrder" value="${rewardService.getOrderAsJson(token, pageContext.request)}" />
    </c:when>
    <c:otherwise>
        <c:set var="rewardOrder" value="{}" />
    </c:otherwise>
</c:choose>

<%-- JAVASCRIPT --%>
<script>
    var rewardOrder = ${rewardOrder};
    var encryptedOrderLineId = "${token}";
    console.log("rewardOrder: ", rewardOrder);
</script>

<div class="redemption-error-container hide">
    <h1 class="redemption-error-title"></h1>
    <p class="redemption-error-expired hide">The redemption window has expired.</p>

    <div class="col-xs-12 col-sm-3 redemption-back-container hide">
        <a class="btn btn-next btn-block" href="https://www.comparethemarket.com.au/">Back to home page</a>
    </div>

    <p class="redemption-error-subtitle">If this is not the case, please contact us at <a href="mailto:toys@comparethemarket.com.au" target="_top">toys@comparethemarket.com.au</a></p>

    <div class="cross-sell">
        <h2 class="redemption-error-subtitle">Is there anything else we can help you with?</h2>
        <confirmation:other_products />
    </div>
</div>