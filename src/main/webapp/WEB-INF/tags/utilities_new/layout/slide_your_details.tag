<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}"/>

<layout:slide formId="startForm" firstSlide="true" nextLabel="Next">
    <layout:slide_columns>

         <jsp:attribute name="rightColumn">
			<ui:bubble variant="info" className="hidden-xs">
                <h4>How we compare</h4>
                <ul class="themed">
                    <li>Find out more about the <a href="javascript:;" data-toggle="dialog" data-content="#energy-assumptions" data-dialog-hash-id="assumptions" data-title="Energy Consumption Assumptions" data-cache="true">assumptions made about your energy consumption</a></li>
                    <li>Find out more about <a href="javascript:;" data-toggle="dialog" data-content="#state-energy-concession" data-dialog-hash-id="concession" data-title="State Energy Concessions" data-cache="true">State Energy Concessions</a></li>
                    <li>Find out more about comparing with the <a href="javascript:;" data-toggle="dialog" data-content="#thoughtworld-calculator" data-dialog-hash-id="calculator" data-title="Thought World Calculator" data-cache="true">Thought World calculator</a></li>
                </ul>
                <utilities_new:how_we_compare />
            </ui:bubble>

		</jsp:attribute>

        <jsp:body>
            <layout:slide_content>
                <utilities_new_fieldset:household_details xpath="${xpath}/householdDetails" />
                <utilities_new_fieldset:additional_estimate_details xpath="${xpath}/estimateDetails" />

                <utilities_new:not_provided />
            </layout:slide_content>
        </jsp:body>

    </layout:slide_columns>

</layout:slide>