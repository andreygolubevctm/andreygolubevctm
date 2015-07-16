<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Display The Product Title Search value for Local/Dev Environments"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<c:set var="env" value="${environmentService.getEnvironmentAsString()}" />
<c:if test="${env eq 'localhost' or env eq 'NXI' or env eq 'NXQ' or env eq 'NXS'}"><br>
    <span class="productTitleSearchContainer" style="display: none;"><strong style="color:red">Product Title: <span class="productTitleSearch"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></span>
</c:if>