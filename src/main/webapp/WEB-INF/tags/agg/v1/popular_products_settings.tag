<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="popularProductsService" class="com.ctm.web.core.popularProducts.services.PopularProductsService" />

<%@ attribute name="vertical" required="true" rtexprvalue="true" description="The vertical this Popular Products is for"%>

<c:set var="showPopularProducts" scope="application">
    <c:choose>
        <c:when test="${popularProductsService.showPopularProducts(pageContext.request, vertical)}">
            true
        </c:when>
        <c:otherwise>
            false
        </c:otherwise>
    </c:choose>
</c:set>