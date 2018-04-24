<%@ tag description="The Health Journey's 'Benefits' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="benefitsForm">

    <layout_v3:slide_content>
        <form_v3:fieldset_columns nextLabel="Next step" sideHidden="true">

            <jsp:attribute name="rightColumn">
                <competition:snapshot vertical="health" />
                <simples:snapshot />
                <health_v4_content:snapshot/>
                <health_v4:price_promise step="benefits" />
            </jsp:attribute>
            <jsp:body>
                <form_v4:fieldset
                        legend=""
                        className="benefitsContainer">
                    <!-- TODO: update the fields with the newer fields -->
                    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/healthCover" />
                    <div class="fieldrow healthCoverPartnerHeading"><h3>We have a few additional questions about you and your partner</h3></div>
                    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/healthCover" />
                    <health_v4_insuranceprefs:partner_dob xpath="${xpath}" />
                    <health_v4_insuranceprefs:partner_cover xpath="${xpath}" />
                    <health_v4_insuranceprefs:partner_cover_loading xpath="${xpath}" />

                    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/benefits" />
                    <health_v4_insuranceprefs:benefits xpath="${xpath}" />

                </form_v4:fieldset>

            </jsp:body>
        </form_v3:fieldset_columns>

    </layout_v3:slide_content>

</layout_v3:slide>
