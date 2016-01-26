<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}"/>

<layout_v3:slide formId="startForm" firstSlide="true" nextLabel="Next">
    <layout_v3:slide_columns>

         <jsp:attribute name="rightColumn">
            <%--<ui:bubble variant="info" className="hidden-xs">
                <h4>How we compare</h4>
                <ul class="themed">
                    <li>Find out more about the <a href="javascript:;" data-toggle="dialog" data-content="#energy-assumptions" data-dialog-hash-id="assumptions" data-title="Energy Consumption Assumptions" data-cache="true">assumptions made about your energy consumption</a></li>
                    <li>Find out more about <a href="javascript:;" data-toggle="dialog" data-content="#state-energy-concession" data-dialog-hash-id="concession" data-title="State Energy Concessions" data-cache="true">State Energy Concessions</a></li>
                    <li>Find out more about comparing with the <a href="javascript:;" data-toggle="dialog" data-content="#thoughtworld-calculator" data-dialog-hash-id="calculator" data-title="Thought World Calculator" data-cache="true">Thought World calculator</a></li>
                </ul>
                <utilities_v3:how_we_compare />

            </ui:bubble>--%>
        <utilities_v3_content:sidebar />
        </jsp:attribute>

        <jsp:body>
            <layout_v3:slide_content>
                <utilities_v3_fieldset:household_details xpath="${xpath}/householdDetails" />
                <utilities_v3_fieldset:additional_estimate_details xpath="${xpath}/estimateDetails" />
                <utilities_v3:not_provided />
            </layout_v3:slide_content>
        </jsp:body>

    </layout_v3:slide_columns>
</layout_v3:slide>