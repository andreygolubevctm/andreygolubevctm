<%@ tag description="Unsubscribe Content" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="unsubscribe" class="com.ctm.model.Unsubscribe" scope="session"/>

<%-- VARS --%>
<c:set var="customerName"> <c:out escapeXml="true" value="${unsubscribe.getCustomerName()}"/></c:set>
<c:set var="emailAddress"><c:out escapeXml="true" value="${unsubscribe.getCustomerEmail()}"/></c:set>
<c:set var="verticalCode"><c:out escapeXml="true" value="${unsubscribe.getVertical()}"/></c:set>
<c:set var="isValid"><c:out escapeXml="true" value="${unsubscribe.isValid()}"/></c:set>

<%-- EXIT URL --%>
<c:set var="exitUrl">
    <c:if test="${pageSettings.hasSetting('exitUrl')}">
        <c:out value="${fn:toLowerCase(pageSettings.getSetting('exitUrl'))}" escapeXml="false" />
    </c:if>
</c:set>
<c:set var="leaveUnsubscribe" value="javascript:window.close();"/>
<c:if test="${not empty exitUrl}">
    <c:set var="leaveUnsubscribe" value="${fn:toLowerCase(pageSettings.getSetting('exitUrl'))}"/>
</c:if>


<c:choose>
    <c:when test="${!isValid}">
        <div class="row">
            <div class="col-xs-12">
                <h2>Unsubscribe unsuccessful</h2>

                <p>We are sorry but we have not been able to verify your email address.</p>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="row">
            <div class="col-xs-12 preUnsubscribeTextContainer">
                <h2>You're leaving</h2>

                <p>We're sorry to see you go <strong>${customerName}</strong>... we'll miss you!</p>

                <p>If you're sure you'd like to unsubscribe <c:if test="${not empty emailAddress}">(<strong>${emailAddress}</strong>)</c:if> from our email updates, then you can do so by clicking the
                    "Unsubscribe me" button below.
                </p>
            </div>
            <div class="col-xs-12 postUnsubscribeTextContainer hidden">
                <h2>Thank you</h2>

                <p>You have succcessfully been removed from this subscriber list.</p>

                <p>Please note that it may take up to 72hrs to remove your details from our system.</p>
            </div>

        </div>
        <div class="row unsubscribeButtonContainer">
            <div class="col-xs-12 col-sm-3 col-sm-push-3">
                <a class="btn btn-block btn-unsubscribe-cancel" href="${leaveUnsubscribe}">I want to stay</a>
            </div>
            <div class="col-xs-12 col-sm-3 col-sm-push-3">
                <a class="btn btn-block btn-unsubscribe" href="javascript:;">Unsubscribe me</a>
            </div>
        </div>

    </c:otherwise>
</c:choose>
<c:if test="${pageSettings.getBrandId() eq 1}">
    <div class="row">
        <div class="col-xs-12 col-md-8 col-md-push-2">
            <confirmation:other_products heading="We compare"/>
        </div>
    </div>
</c:if>
<div style="clear:both;"></div>