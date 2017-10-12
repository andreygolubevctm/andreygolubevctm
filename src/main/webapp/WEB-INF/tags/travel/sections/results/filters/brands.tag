<%@ tag description="" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="ProviderDetailsService" class="com.ctm.web.core.services.ProviderDetailsService" scope="page" />
${ProviderDetailsService.init(pageContext.request)}

<c:set var="fieldXpath" value="travel/filter/brands"/>
<div class="row">
    <c:forEach items="${ProviderDetailsService.getProviderNames()}" var="name">
        <div class="col-sm-6 text-left">
            <field_v2:checkbox
                    xpath="${fieldXpath}/${name}"
                    value="${name}"
                    required="false"
                    title="${name}"
                    label="true"
            />
        </div>
    </c:forEach>
</div>