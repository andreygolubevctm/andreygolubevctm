<%@ tag description="" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="ProviderDetailsService" class="com.ctm.web.core.services.ProviderDetailsService" scope="page" />
${ProviderDetailsService.init(pageContext.request)}

<div class="row" id="travel-filter-brands">
    <c:forEach items="${ProviderDetailsService.getProviderNames()}" var="obj">
        <div class="col-sm-4 text-left col-brand">
            <div class="checkbox">
                <input type="checkbox" data-provider-code="${obj.code}" name="${obj.dashedName}" id="${obj.dashedName}" class="checkbox-custom  checkbox" value="${obj.dashedName}" checked="checked">
                <label for="${obj.dashedName}">${obj.name}</label>
            </div>
        </div>
    </c:forEach>
</div>