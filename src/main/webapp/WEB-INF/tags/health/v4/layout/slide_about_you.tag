<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="rememberMeService" class="com.ctm.web.core.rememberme.services.RememberMeService" />
<agg_v1:remember_me_settings vertical="health" />

<layout_v3:slide formId="startForm" firstSlide="true">

    <layout_v3:slide_content>

        <%-- PROVIDER TESTING --%>
        <%--<health_v4_aboutyou:provider_testing xpath="${pageSettings.getVerticalCode()}" />--%>

        <%-- COVER TYPE / SITUATION --%>
        <div id="${pageSettings.getVerticalCode()}_situation">

                <%-- VARIABLES --%>
            <c:set var="xpath" 			value="${pageSettings.getVerticalCode()}/situation" />
            <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

                <%-- HTML --%>
            <div id="${name}-selection" class="health-situation">
                <form_v3:fieldset_columns nextLabel="Insurance preferences" sideHidden="true">

                    <jsp:attribute name="rightColumn">
                        <competition:snapshot vertical="health" />
                        <reward:campaign_tile_container />
                        <health_v4_aboutyou:retrievequotes />
                        <health_v4_aboutyou:medicarecheck />
                        <health_v4:price_promise step="start" />
                    </jsp:attribute>
                    <jsp:body>

                        <%-- PROVIDER TESTING --%>
                        <health_v1:provider_testing xpath="${pageSettings.getVerticalCode()}" />

                        <c:set var="legend">
                            <c:choose>
                                <c:when test="${isRememberMe and hasUserVisitedInLast30Minutes}">
                                    <c:set var="firstname" value="${rememberMeService.getNameOfUser(pageContext.request, pageContext.response, 'health')}" />
                                    Hi ${firstname}, to make things easier we have filled out the details you entered last time. Review your quote and amend your details to compare products
                                </c:when>
                                <c:otherwise>
                                    Tell us about yourself, so we can find the right cover for you..
                                </c:otherwise>
                            </c:choose>
                        </c:set>

                        <form_v4:fieldset id="healthAboutYou"
                                          legend="${legend}"
                                          className="health-about-you">
                            <health_v4_aboutyou:youarea xpath="${xpath}" />
                            <c:set var="xpath" value="${pageSettings.getVerticalCode()}/healthCover" />
                            <health_v4_aboutyou:dob xpath="${xpath}" />
                            <health_v4_aboutyou:currentlyowninsurance xpath="${xpath}" />
                            <health_v4_aboutyou:continuous_cover xpath="${xpath}" />
                            <health_v4_aboutyou:everownedinsurance xpath="${xpath}" />
                            <health_v4_aboutyou:applyrebate xpath="${xpath}" />
                            <health_v4_aboutyou:optin xpath="${xpath}" />
                        </form_v4:fieldset>

                    </jsp:body>
                </form_v3:fieldset_columns>
            </div>
        </div>

    </layout_v3:slide_content>

</layout_v3:slide>
