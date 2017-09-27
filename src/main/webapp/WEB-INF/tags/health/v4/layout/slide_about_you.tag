<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="startForm" firstSlide="true" nextLabel="Insurance preferences">

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
                <form_v3:fieldset_columns sideHidden="true">

                <jsp:attribute name="rightColumn">
                    <competition:snapshot vertical="health" />
                    <reward:campaign_tile_container />
                    <health_v4_aboutyou:retrievequotes />
                    <health_v4_aboutyou:medicarecheck />
                </jsp:attribute>
                    <jsp:body>

                        <%-- PROVIDER TESTING --%>
                        <health_v1:provider_testing xpath="${pageSettings.getVerticalCode()}" />

                        <form_v4:fieldset id="healthAboutYou"
                                          legend="Tell us about yourself, so we can find the right cover for you"
                                          className="health-about-you">
                            <health_v4_aboutyou:youarea xpath="${xpath}" />
                            <c:set var="xpath" value="${pageSettings.getVerticalCode()}/healthCover" />
                            <health_v4_aboutyou:dob xpath="${xpath}" />
                            <health_v4_aboutyou:currentlyowninsurance xpath="${xpath}" />
                            <health_v4_aboutyou:continuous_cover xpath="${xpath}" />
                            <health_v4_aboutyou:applyrebate xpath="${xpath}" />
                            <health_v4_aboutyou:optin xpath="${xpath}" />
                        </form_v4:fieldset>

                    </jsp:body>
                </form_v3:fieldset_columns>
            </div>
        </div>

    </layout_v3:slide_content>

</layout_v3:slide>
