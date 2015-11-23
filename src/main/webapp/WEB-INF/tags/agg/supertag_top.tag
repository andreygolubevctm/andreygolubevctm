<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="type" required="true" rtexprvalue="true" description="Type to supply to supertag (car/travel etc)" %>
<%@ attribute name="initialPageName" required="false" rtexprvalue="true" description="Initial Page Name" %>
<%@ attribute name="initVertical" required="false" rtexprvalue="true" description="Pass the vertical to the Tranck.init() or not" %>
<%@ attribute name="loadExternalJs" required="false" rtexprvalue="true" description="Whether to load external JavaScript File" %>
<%@ attribute name="useCustomJs" required="false" rtexprvalue="true" description="Legacy value, when false, no tracking js files are loaded or called" %>
<c:set var="superTagEnabled" value="${pageSettings.getSetting('superTagEnabled') eq 'Y'}"/>
<c:if test="${superTagEnabled eq true}">
    <!-- #1: BEGIN SUPERTAG TOP CODE v2.7.7.1 -->
    <script type="text/javascript" src="//c.supert.ag/compare-the-market/compare-the-market/supertag.js"></script>
    <%-- Do NOT remove the following tag: SuperTag requires the following as a separate <script> block --%>
    <script type="text/javascript">
        if (typeof superT != "undefined" && typeof superT.t == "function") {
            superT.t();
        }
    </script>
    <!-- #1: END SUPERTAG TOP CODE -->
</c:if>
<c:if test="${empty initVertical}">
    <c:set var="initVertical" value="false"/>
</c:if>

<c:if test="${empty useCustomJs}">
    <c:set var="useCustomJs" value="true"/>
</c:if>

<c:if test="${useCustomJs eq true}">

    <c:if test="${empty loadExternalJs}">
        <c:set var="loadExternalJs" value="true"/>
    </c:if>

    <go:script href="common/js/supertag/Track.js" marker="js-href"/>

    <c:if test="${loadExternalJs}">
        <go:script href="common/js/supertag/Track_${type}.js" marker="js-href"/>
    </c:if>
    <go:script marker="onready">
        <c:choose>
            <c:when test="${initVertical eq false}">
                Track_${type}.init();
            </c:when>
            <c:otherwise>
                Track_${type}.init('${initVertical}');
            </c:otherwise>
        </c:choose>
    </go:script>
    <c:if test="${superTagEnabled eq true}">
        <c:set var="pageName">
            <c:choose>
                <c:when test="${not empty initialPageName}">${initialPageName}</c:when>
                <c:otherwise>Your Car</c:otherwise>
            </c:choose>
        </c:set>
        <script type="text/javascript">
            if (!typeof s === 'undefined') {
                s.pageName = '${pageName}';
            }
        </script>
    </c:if>
</c:if>
