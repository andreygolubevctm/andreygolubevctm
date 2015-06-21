<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="key" required="false" rtexprvalue="true" description="For DB lookup of content" %>
<%@ attribute name="content" required="false" rtexprvalue="true" description="For content that is not in the DB" %>
<%@ attribute name="useSpan" required="false" rtexprvalue="true" description="Surround text with a span instead of a p" %>



<%-- Variables --%>

<c:set var="ctmNameToModify" value="comparethemarket.com.au"/>
<c:set var="ccNameToModify" value="Captaincompare.com.au"/>

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
    //if we want to format other brands just use the appropriate variable eg ctmNameToModify, ccNameToModify etc..
    $('.optinText:contains(${ctmNameToModify})').html(
        function(i,h){
                return h.replace(/(${ctmNameToModify})/g,'<strong>compare</strong>the<strong>market</strong>.com.au');
      });


</go:script>