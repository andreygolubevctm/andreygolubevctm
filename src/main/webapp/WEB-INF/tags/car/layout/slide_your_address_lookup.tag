<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<layout:slide formId="addressForm" nextLabel="Get Quotes">

    <layout:slide_content>
        <car:snapshot_row />
    </layout:slide_content>

    <layout:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
            <ui:bubble variant="info" className="point-left">
                <h4>Where is the car parked at night?</h4>
                <p>We're looking for the address where the car is parked at night which could be different to your postal address. This information will be used when determining your premium.</p>
            </ui:bubble>
            <c:if test="${addressFormSplitTest eq true}">
                <ui:bubble variant="info" className="point-left cantFindAddressHelper">
                    <h4>Can&#39;t find your address?</h4>
                    <p>If you cannot find the address in our drop down, just tick the &quot;Unable to find address&quot; box and manually enter your address.</p>
                </ui:bubble>
            </c:if>
		</jsp:attribute>

        <jsp:body>
            <layout:slide_content>

                <car:risk_address_lookup xpath="${xpath}/riskAddress" />

            </layout:slide_content>
        </jsp:body>
    </layout:slide_columns>

    <layout:slide_columns sideHidden="true">

        <jsp:attribute name="rightColumn"></jsp:attribute>

        <jsp:body>
            <layout:slide_content>

                <car:commencement_date xpath="${xpath}/options/commencementDate" />

                <car:contact_details xpath="${xpath}/contact" />

                <car:contact_optins xpath="${xpath}/termsAndConditions" />

            </layout:slide_content>
        </jsp:body>

    </layout:slide_columns>

</layout:slide>