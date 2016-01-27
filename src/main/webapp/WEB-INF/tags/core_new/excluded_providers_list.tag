<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="provide a hidden list of exluded providers" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="serviceConfigurationService" class="com.ctm.web.core.services.ServiceConfigurationService" scope="session"/>




<c:if test="${not empty param['automated-test'] and param['automated-test'] eq 'true'}">
  <c:set var="verticalId" value="${pageSettings.getVertical().getId()}"/>
  <c:set var="brandId" value="${pageSettings.getBrandId()}"/>

  <c:set var="excludedProvidersList" value='${serviceConfigurationService.getExcludedProviders(brandId,verticalId)}' />
  <c:set var="excludedProviders" value=""/>
  <c:forEach var="i" items="${excludedProvidersList}">
    <c:set var="excludedProviders" value="${excludedProviders} ${i.code}"/>
  </c:forEach>
  <field:hidden xpath="${pageSettings.getVerticalCode()}/excludedProviderList" constantValue="${excludedProviders}" />
</c:if>

