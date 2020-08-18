<%@ tag description="The Health Journey's 'Benefits' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="benefitsForm">

    <layout_v3:slide_content>
        <form_v3:fieldset_columns nextLabel="Next step" sideHidden="true" sticky="true" stickyTopClass="top60">

            <jsp:attribute name="rightColumn">
                <competition:snapshot vertical="health" />
                <simples:snapshot />
                <health_v4_content:snapshot/>
                <health_v4:price_promise step="benefits" dismissible="true" />
            </jsp:attribute>
            <jsp:body>
                <form_v4:fieldset
                        legend=""
                        className="benefitsContainer">

                    <c:set var="xpath" value="${pageSettings.getVerticalCode()}/benefits" />
                    <health_v4_insuranceprefs_v2:benefits xpath="${xpath}" />

                </form_v4:fieldset>

            </jsp:body>
        </form_v3:fieldset_columns>

    </layout_v3:slide_content>

</layout_v3:slide>
