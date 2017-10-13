<%@ tag description="" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="ProviderDetailsService" class="com.ctm.web.core.services.ProviderDetailsService" scope="page" />
${ProviderDetailsService.init(pageContext.request)}

<div class="row">
    <c:forEach items="${ProviderDetailsService.getProviderNames()}" var="nameObj">
        <div class="col-sm-6 text-left col-brand">
            <div class="checkbox">
                <input type="checkbox" name="${nameObj.dashedName}" id="${nameObj.dashedName}" class="checkbox-custom  checkbox" value="${nameObj.dashedName}" checked="checked">
                <label for="${nameObj.dashedName}">${nameObj.name}</label>
            </div>
        </div>
    </c:forEach>
</div>