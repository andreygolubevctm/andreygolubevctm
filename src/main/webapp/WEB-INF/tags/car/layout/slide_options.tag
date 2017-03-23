<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote"/>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<layout_v1:slide formId="optionsForm" nextLabel="Next Step">

    <layout_v1:slide_columns sideHidden="false">

		<jsp:attribute name="rightColumn">
			<car:snapshot/>
		</jsp:attribute>

        <jsp:body>
            <layout_v1:slide_content>
                <ui:bubble variant="chatty">
                    <h4>Tell us about your car</h4>
                    <p>Answering these questions will help us supply you with car insurance quotes from our participating suppliers.</p>
                </ui:bubble>
                <car:rego_with_details/>

                <c:choose>
                    <c:when test="${pageSettings.getBrandCode() eq 'ctm'}">
                        <car:options_type_of_cover xpath="${xpath}/optionsTypeOfCover"/>
                    </c:when>
                    <c:otherwise>
                        <field_v1:hidden xpath="${xpath}/optionsTypeOfCover" defaultValue="COMPREHENSIVE" constantValue="COMPREHENSIVE" />
                    </c:otherwise>
                </c:choose>

                <form_v2:fieldset legend="Accessories and Modifications" id="${name}AccessoriesFieldSet">

                        <car:options_factory xpath="${xpath}/vehicle/factoryOptions"/>

                        <car:options_accessories xpath="${xpath}/vehicle/accessories"/>

                        <car:options_modifications xpath="${xpath}/vehicle/modifications"/>

                </form_v2:fieldset>

                <car:options_usage xpath="${xpath}/vehicle"/>

                <car:options_dialog_inputs xpath="${xpath}/vehicle/options/inputs/container"/>

            </layout_v1:slide_content>
        </jsp:body>

    </layout_v1:slide_columns>

</layout_v1:slide>
