<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- competitionEnabled set in contact_details.tag --%>

<c:if test="${competitionEnabled == true}">
    <c:set var="competitionId"><content:get key="competitionId"/></c:set>
    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/resultsDisplayed"/>

    <c:if test="${competitionId eq '21'}">
        <form_new:row label="" className="promotion-container" hideHelpIconCol="true">
            <div class="promo-image ${pageSettings.getVerticalCode()}"></div>
        </form_new:row>
    </c:if>

    <form_new:row label="" hideHelpIconCol="true">
        <c:set var="competitionCheckboxText"><content:get key="competitionCheckboxText"/></c:set>
        <field_new:checkbox xpath="${xpath}/competition/optin" value="Y" title=" ${competitionCheckboxText}" required="false" label="${true}"/>
    </form_new:row>
</c:if>