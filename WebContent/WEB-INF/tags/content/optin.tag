<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="key" required="false" rtexprvalue="true" description="For DB lookup of content" %>
<%@ attribute name="content" required="false" rtexprvalue="true" description="For content that is not in the DB" %>
<%@ attribute name="useSpan" required="false" rtexprvalue="true" description="Surround text with a span instead of a p" %>



<%-- Variables --%>
<c:set var="brandurl" value="comparethemarket.com.au" />
<c:set var="currentBrand" value="${applicationService.getBrandCodeFromRequest(pageContext.getRequest())}"/>

<%-- Selecting what is your current brand --%>
<c:choose>
    <c:when test="${currentBrand eq 'cc'}">
        <c:set var="brandurl" value='Captaincompare.com.au' />
    </c:when>
    <c:when test="${currentBrand eq 'choo'}">
        <c:set var="brandurl" value='Choosi' />
    </c:when>
    <c:when test="${currentBrand eq 'yhoo'}">
        <c:set var="brandurl" value='Yahoo7' />
    </c:when>
</c:choose>
<%-- HTML --%>

<c:choose>
    <c:when test="${empty useSpan}">
        <p class="optinText">
            <c:choose>
                <c:when test="${not empty key}">
                    <content:get key="${key}"/>
                </c:when>
                <c:otherwise>
                    ${content}
                </c:otherwise>
            </c:choose>
        </p>
    </c:when>
    <c:otherwise >
        <span class="optinText">
            <c:choose>
                <c:when test="${not empty key}">
                    <content:get key="${key}"/>
                </c:when>
                <c:otherwise>
                    ${content}
                </c:otherwise>
            </c:choose>
        </span>
    </c:otherwise>
</c:choose>


<%-- JQUERY on ready --%>
<go:script marker="onready">
    var currentBrand = "${currentBrand}";
    $('.optinText:contains(${brandurl})').html(
        function(i,h){
            if(currentBrand === 'ctm') {
                return h.replace(/(${brandurl})/g,'<strong>compare</strong>the<strong>market</strong>.com.au');
              }
           /*** implement rules on how to display other brands here */

    });
</go:script>