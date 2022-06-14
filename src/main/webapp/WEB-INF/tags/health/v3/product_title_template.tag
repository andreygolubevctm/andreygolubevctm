<%@ tag description="The Health Product Title template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:if test="${not empty callCentre}">
    {{ if (!obj.hasOwnProperty('info') || !obj.info.hasOwnProperty('productTitle')) {return;} }}
    {{ var productTitle = obj.info.productTitle; }}
    {{ if (!_.isNull(productTitle) && !_.isUndefined(productTitle) && productTitle !== '') { }}
        <div class="productTitle">
            {{= productTitle }}
        </div>
    {{ } }}
</c:if>
