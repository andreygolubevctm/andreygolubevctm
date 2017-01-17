<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="template-reward-promo" type="text/html">
    <div class="promo-tile image-tile hidden-sm {{= data.rewardType}}-{{= data.assetOrder}}"></div>
    <div class="promo-tile image-tile visible-sm {{= data.rewardType}}-sm"></div>
</script>

<script id="template-reward-promo-mobile" type="text/html">
    <div class="promo-tile image-tile visible-xs {{= data.rewardType}}-xs"></div>
</script>