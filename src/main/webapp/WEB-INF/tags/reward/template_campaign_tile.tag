<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="template-campaign-tile" type="text/html">
    <div class="campaign-tile image-tile hidden-sm {{= obj.rewardType}}-{{= obj.assetOrder}}"></div>
    <div class="campaign-tile image-tile visible-sm {{= obj.rewardType}}-{{= obj.assetOrder}}-sm"></div>
</script>

<script id="template-campaign-tile-xs" type="text/html">
    <div class="campaign-tile image-tile visible-xs {{= obj.rewardType}}-xs"></div>
</script>