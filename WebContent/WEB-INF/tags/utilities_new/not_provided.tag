<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="hidden">
    <c:set var="errorContent">
        <p>Sorry, it looks like energy comparison services are not available for your location at this time. For general information regarding your energy bills and consumption, we'd suggest visiting <a href='http://www.energymadeeasy.gov.au' target='_blank'>energymadeeasy.gov.au</a></p>
        <p>In the meantime, why not compare your other insurances and utilities to see if you can find a better deal.</p>
    </c:set>
    <confirmation:other_products heading="An error occurred" copy="${errorContent}" id="blocked-ip-address" />
</div>