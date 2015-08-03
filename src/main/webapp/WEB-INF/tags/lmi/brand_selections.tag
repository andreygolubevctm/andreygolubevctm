<%@ tag description="LMI Brand Selection Generator" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="comparePrice" required="true" rtexprvalue="true" description="Whether to display them in the left or the right box." %>

<jsp:useBean id="lmiService" class="com.ctm.services.LmiService" scope="page"/>
<c:set var="model" value="${lmiService.getLmiBrands(pageSettings.getVerticalCode())}"/>

<c:forEach items="${model}" var="brand">
    <c:if test="${brand.isInCtm() eq comparePrice}">
        <div class="selectionContainer">
            <field_new:checkbox id="product${brand.getBrandId()}_check" label="true"
                                xpath="${pageSettings.getVerticalCode()}/brand" value="${brand.getBrandId()}" required="false"
                                title="${brand.getBrandName()}" customAttribute="data-name='${go:htmlEscape(brand.getBrandName())}'"/>
        </div>
    </c:if>
</c:forEach>