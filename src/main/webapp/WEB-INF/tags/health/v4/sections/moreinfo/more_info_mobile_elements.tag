<%@ tag description="The Health More Info mobile elements"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="continueOnlineCTAHtml" scope="application">
    <a href="javascript:;" class="btn btn-cta btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Continue Online<span class="icon-arrow-right" /></a>
</c:set>

<c:set var="continueOnlineALinkHtml" scope="application">
    <a href="javascript:;" class="btn-more-info-apply" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />>Continue Online&nbsp;<span class="icon-arrow-right" /></a>
</c:set>

<c:set var="callNowCTAHtml" scope="application">
    <a href="tel:{{= '${callCentreNumber}'.replace(/\s/g, '') }}" target="_blank" class="btn btn-cta btn-more-info-call-now" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />> <span class="icon-phone" />&nbsp;Call&nbsp;${callCentreNumber}</a>
</c:set>

<c:set var="callNowALinkHtml" scope="application">
    <a href="tel:{{= '${callCentreNumber}'.replace(/\s/g, '') }}" target="_blank" class="btn-more-info-call-now" data-productId="{{= productId }}" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />> <span class="icon-phone" />&nbsp;Call&nbsp;${callCentreNumber}</a>
</c:set>

<c:set var="quoteRefHtml" scope="application">
    <div class="quote-reference-number hidden-large">
        <h3>Quote Ref: <span class="transactionId">{{= obj.transactionId }}</span></h3>
    </div>
</c:set>

<c:set var="emailBrochuresHtml" scope="application">
    <div class="getPrintableBrochures hidden-slim">
        <a href="javascript:;" class="getPrintableBrochures hidden-slim">Email brochures</a>
    </div>
</c:set>