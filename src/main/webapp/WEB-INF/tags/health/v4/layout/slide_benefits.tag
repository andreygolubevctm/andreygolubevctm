<%@ tag description="The Health Journey's 'Benefits' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="benefitsForm" nextLabel="Next Step">

    <layout_v3:slide_content>

        <%-- VARIABLES --%>
        <c:set var="xpath" 			value="${pageSettings.getVerticalCode()}/situation" />
        <c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

        <form_v3:fieldset_columns>

        <jsp:attribute name="rightColumn">
            <health_v2_content:sidebar />
        </jsp:attribute>
            <jsp:body>

                <simples:dialogue id="49" vertical="health" />

                <form_v2:fieldset legend="We have a few additional questions about you and your partner" postLegend="">
                    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/healthCover" />
                    <health_v4_insuranceprefs:continuous_cover xpath="${xpath}" />

                    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/healthCover" />
                    <health_v4_insuranceprefs:partner_dob xpath="${xpath}" />
                    <health_v4_insuranceprefs:partner_cover xpath="${xpath}" />
                    <health_v4_insuranceprefs:partner_cover_loading xpath="${xpath}" />
                    <health_v4_insuranceprefs:simples xpath="${xpath}" />

                    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/situation" />
                    <health_v4_insuranceprefs:benefits xpath="${xpath}" />

                </form_v2:fieldset>

            </jsp:body>
        </form_v3:fieldset_columns>

    </layout_v3:slide_content>

</layout_v3:slide>