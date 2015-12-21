<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- competitionEnabled set in contact_details.tag --%>

<c:if test="${competitionEnabled == true}">
    <c:set var="competitionId"><content:get key="competitionId"/></c:set>
    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/resultsDisplayed"/>
    <c:choose>
        <c:when test="${competitionId eq '21'}">
            <form_v2:row label="" className="promotion-container" hideHelpIconCol="true">
                <div class="promo-image ${pageSettings.getVerticalCode()}"></div>
            </form_v2:row>
        </c:when>
        <c:otherwise>
            <content:get key="competitionPromoImage"/>
        </c:otherwise>
    </c:choose>
    <form_v2:row label="" hideHelpIconCol="true">
        <c:set var="competitionCheckboxText"><content:get key="competitionCheckboxText"/></c:set>
        <field_v2:checkbox xpath="${xpath}/competition/optin" value="Y" title=" ${competitionCheckboxText}" required="false" label="${true}"/>
    </form_v2:row>
</c:if>