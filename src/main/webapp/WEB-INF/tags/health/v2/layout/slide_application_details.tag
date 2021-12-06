<%@ tag description="The Health Journey's 'Applications Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide  nextLabel="Proceed to Payment">

	<layout_v1:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health_v1:policySummary showProductDetails="true" />
			<health_v2_content:sidebar />
		</jsp:attribute>

		<jsp:body>

			<simples:dialogue id="84" vertical="health" />
			<simples:dialogue id="71" vertical="health" />

			<simples:dialogue id="166" vertical="health"  />

			<form  id="applicationForm_3" autocomplete="off" class="form-horizontal" role="form">
					<simples:dialogue id="145" vertical="health" mandatory="true"  className="simplesDynamicElements" />
					<c:set var="xpath" value="${pageSettings.getVerticalCode()}/application" />
					<field_v3:name_group xpath="${xpath}/primary" showInitial="true" firstNameMaxlength="24" lastNameMaxlength="20" middleInitialMaxlength="1" label="Name as it appears on Medicare Card" className="no-label simples-name-input-primary" />

					<simples:dialogue id="146" vertical="health" mandatory="true"  className="simplesDynamicElements" />

					<simples:dialogue id="167" vertical="health" mandatory="true" className="simplesAgrElementsToggle hidden"  />
			</form>


			<layout_v1:slide_content>

				<health_v1:competition_jeep />

				<div id="health_application-warning">
					<div class="fundWarning alert alert-danger">
							<%-- insert fund warning data --%>
					</div>
				</div>

				<%-- The reason for the multiple forms here is because of an issue with iOS7 --%>

				<form  id="applicationForm_1" autocomplete="off" class="form-horizontal" role="form">
					<c:set var="xpath" value="${pageSettings.getVerticalCode()}/application/govtRebateDeclaration" />
					<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

					<field_v1:hidden xpath="${xpath}/entitledToMedicare" />
					<field_v1:hidden xpath="${xpath}/declaration" />
					<field_v1:hidden xpath="${xpath}/declarationDate" />
					<field_v1:hidden xpath="${xpath}/applicantCovered" />
					<field_v1:hidden xpath="${xpath}/voiceConsent" />
					<field_v1:hidden xpath="${xpath}/childOnlyPolicy" />
					<field_v1:hidden xpath="${xpath}/removeRebate1" />
					<field_v1:hidden xpath="${xpath}/removeRebate2" />

					<c:set var="xpath" value="${pageSettings.getVerticalCode()}/application/agr/compliance" />
					<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

					<simples:dialogue id="218" vertical="health" className="simplesAgrElementsNoToggle hidden" />
					<c:set var="fieldXpath" value="${xpath}/voiceConsent" />
					<form_v3:row fieldXpath="${fieldXpath}" label="Do you agree to have your personal information collected by %FUND_NAME% for the purposes of completing the Rebate Application form?<br /><i>Customer must answer with a clear yes or no response.</i>" id="${name}_voiceConsentRow" className="agrConsent simplesAgrElementsNoToggle hidden optionalDialogue noMarginLeftRight no-label">
						<field_v2:array_radio id="${name}_voiceConsent" xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="Do you give consent for claiming the Australian Government Rebate?" />
					</form_v3:row>

					<simples:dialogue id="170" vertical="health" mandatory="true" className="agrRemoveRebate1 simplesAgrElementsNoToggle hidden"  />

					<c:set var="fieldXpath" value="${xpath}/removeRebate1" />
					<form_v2:row fieldXpath="${fieldXpath}" label="" id="${name}_removeRebate1Row" className="agrRemoveRebate1 simplesAgrElementsNoToggle hidden noMarginLeftRight">
						<field_v2:checkbox id="${name}_removeRebate1" xpath="${fieldXpath}" required="true" value="Y" title="Remove rebate and continue" label="true" errorMsg="You must remove the rebate to continue" className="validate row-content"/>
					</form_v2:row>

					<simples:dialogue id="219" vertical="health" className="simplesAgrElementsNoToggle hidden" />

					<c:set var="fieldXpath" value="${xpath}/applicantCovered" />
					<form_v3:row fieldXpath="${fieldXpath}" label="<p><strong class='bold'>Must read word for word</strong></p>Can I confirm, Are you covered by this policy?" id="${name}_applicantCoveredRow" className="argCoveredByPolicy simplesAgrElementsNoToggle optionalDialogue noMarginLeftRight no-label hidden">
						<field_v2:array_radio id="${name}_applicantCovered" xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="Are you covered by this policy?" />
					</form_v3:row>

                    <c:set var="fieldXpath" value="${xpath}/childOnlyPolicy" />
                    <form_v3:row fieldXpath="${fieldXpath}" label="Is this a child only policy?" id="${name}_childOnlyPolicyRow" className="agrChildOnlyPolicy simplesAgrElementsNoToggle optionalDialogue noMarginLeftRight hidden" renderLabelAsSimplesDialog="red">
                        <field_v2:array_radio id="${name}_childOnlyPolicy" xpath="${fieldXpath}" required="true" items="Y=Yes,N=No" title="Is this a child only policy?" />
                    </form_v3:row>

					<simples:dialogue id="171" vertical="health" mandatory="true" className="agrRemoveRebate2 simplesAgrElementsNoToggle hidden"  />

					<c:set var="fieldXpath" value="${xpath}/removeRebate2" />
					<form_v2:row fieldXpath="${fieldXpath}" label="" id="${name}_removeRebate2Row" className="agrRemoveRebate2 simplesAgrElementsNoToggle hidden">
						<field_v2:checkbox id="${name}_removeRebate2" xpath="${fieldXpath}" required="true" value="Y" title="Remove rebate and continue" label="true" errorMsg="You must remove the rebate to continue" className="validate row-content"/>
					</form_v2:row>

					<health_v3:your_details />
					<health_v3:partner_details />
				</form>

				<form  id="applicationForm_2" autocomplete="off" class="form-horizontal" role="form">
					<health_v3:dependants xpath="${pageSettings.getVerticalCode()}/application/dependants" />
				</form>

				<input type="hidden" id="${pageSettings.getVerticalCode()}_application_productClassification_hospital" name="${pageSettings.getVerticalCode()}_application_productClassification_hospital" value="">
				<input type="hidden" id="${pageSettings.getVerticalCode()}_application_productClassification_extras" name="${pageSettings.getVerticalCode()}_application_productClassification_extras" value="">

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>
