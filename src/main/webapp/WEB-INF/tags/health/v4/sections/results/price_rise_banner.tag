<%@ tag description="Returns a rice rise banner with a dialog link"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="userEditableTextService" class="com.ctm.web.simples.admin.services.UserEditableTextService" scope="page" />
<jsp:useBean id="applicationService" class="com.ctm.web.core.services.ApplicationService" scope="page" />
<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<c:set var="applicationDate" value="${applicationService.getApplicationDate(pageContext.getRequest())}" />
<c:set var="currentPriceRiseBanner" value='${userEditableTextService.getCurrentUserEditableText("rateRiseBanner" , styleCodeId, applicationDate)}' />

<c:if test="${currentPriceRiseBanner ne null}">
<div class="price-rise-tag hidden">
    <span class="help-icon icon-info"></span>
    <span>${currentPriceRiseBanner.getContent()}</span>
    <a href="javascript:;" class="price-rise-banner-learn-more">Learn more <span class="icon-expand"></span></a>
</div>
</c:if>
