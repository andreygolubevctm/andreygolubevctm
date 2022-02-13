<%@ tag description="Returns a rice rise banner with a dialog link"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="showHelpIcon" rtexprvalue="true" description="show or not help icon" %>
<%@ attribute name="textType" rtexprvalue="true" description="show or not help icon" %>
<%@ attribute name="isHiddenByDefault" rtexprvalue="true" description="show or not help icon" %>

<c:if test="${empty textType}">
    <c:set var="textType" value="rateRiseBanner" />
</c:if>

<c:if test="${empty isHiddenByDefault}">
    <c:set var="isHiddenByDefault" value="true" />
</c:if>

<jsp:useBean id="userEditableTextService" class="com.ctm.web.simples.admin.services.UserEditableTextService" scope="page" />
<jsp:useBean id="applicationService" class="com.ctm.web.core.services.ApplicationService" scope="page" />
<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<c:set var="applicationDate" value="${applicationService.getApplicationDate(pageContext.getRequest())}" />
<c:set var="currentPriceRiseBanner" value='${userEditableTextService.getCurrentUserEditableText(textType , styleCodeId, applicationDate)}' />

<c:if test="${currentPriceRiseBanner ne null}">
<div class="price-rise-tag  <c:if test="${isHiddenByDefault eq true}">hidden</c:if>">
    <c:if test="${showHelpIcon}">
        <span class="help-icon icon-info"></span>
    </c:if>
    <span>${currentPriceRiseBanner.getContent()}</span>
    <a href="javascript:;" class="price-rise-banner-learn-more">Learn more <span class="icon-expand"></span></a>
</div>
</c:if>
