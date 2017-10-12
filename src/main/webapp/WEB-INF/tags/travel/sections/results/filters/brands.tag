<%@ tag description="" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="ProviderDetailsService" class="com.ctm.web.core.services.ProviderDetailsService" scope="page" />
${ProviderDetailsService.init(pageContext.request)}

<div class="row">
    <c:forEach items="${ProviderDetailsService.getProviderNames()}" var="name">
        <div class="col-sm-6 text-left">
            <div class=" checkbox">
                <input type="checkbox" name="${name.original}" id="${name}" class="checkbox-custom  checkbox" value="${name}" checked="checked">
                <label for="${name}">${name}</label>
            </div>
        </div>
    </c:forEach>
</div>