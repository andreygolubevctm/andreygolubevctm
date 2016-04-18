<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote"/>

<layout_v1:slide formId="optionsForm" nextLabel="Next Step">

    <layout_v1:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<car:snapshot/>
		</jsp:attribute>

        <jsp:body>
            <layout_v1:slide_content>
                <c:choose>
                    <c:when test="${regoLookupSplitTest eq true}">
                        <ui:bubble variant="chatty">
                            <h4>Tell us about your car</h4>
                            <p>Answering these questions will help us supply you with car insurance quotes from our participating suppliers.</p>
                        </ui:bubble>
                        <car:rego_with_details/>
                    </c:when>
                    <c:otherwise>
                        <ui:bubble variant="chatty">
                            <h4>Options, Accessories & Modifications</h4>
                            <p>By listing all of the options, accessories and modifications, the insurer will be able to get a more accurate idea of the car's true value.</p>
                        </ui:bubble>
                    </c:otherwise>
                </c:choose>

                <car:options_factory xpath="${xpath}/vehicle/factoryOptions"/>

                <car:options_accessories xpath="${xpath}/vehicle/accessories"/>

                <car:options_modifications xpath="${xpath}/vehicle/modifications"/>

                <car:options_usage xpath="${xpath}/vehicle"/>

                <car:options_dialog_inputs xpath="${xpath}/vehicle/options/inputs/container"/>

            </layout_v1:slide_content>
        </jsp:body>

    </layout_v1:slide_columns>

</layout_v1:slide>
