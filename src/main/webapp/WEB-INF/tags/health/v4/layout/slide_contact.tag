<%@ tag description="The Health Journey's 'Contact Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<health_v4_contact:page_settings />

<layout_v3:slide formId="contactForm" nextLabel="Get Prices">

    <layout_v3:slide_content>
        <form_v3:fieldset_columns sideHidden="true">

             <jsp:attribute name="rightColumn">
                <health_v4_content:snapshot />
             </jsp:attribute>

            <jsp:body>


                <form_v4:fieldset id="health-contact-fieldset" legend="Fill in your details below to compare products">

                    <c:set var="firstNamePlaceHolder">
                        <content:get key="firstNamePlaceHolder"/>
                    </c:set>

                    <c:set var="emailPlaceHolder">
                        <content:get key="emailPlaceHolder"/>
                    </c:set>

                    <c:set var="xpath">${pageSettings.getVerticalCode()}/contactDetails</c:set>
                    <health_v4_contact:firstname xpath="${xpath}" />
                    <health_v4_contact:contact_number xpath="${xpath}" />
                    <health_v4_contact:email_address xpath="${xpath}" />
                    <c:set var="postcodeXpath">${pageSettings.getVerticalCode()}/situation</c:set>
                    <health_v4_contact:postcode xpath="${postcodeXpath}" />
                    <health_v4_contact:hidden_fields xpath="${xpath}" />
                    <health_v4_contact:competition xpath="${xpath}" />

                    <health_v4_contact:simples_referral_tracking />
                </form_v4:fieldset>

            </jsp:body>

        </form_v3:fieldset_columns>

    </layout_v3:slide_content>

</layout_v3:slide>