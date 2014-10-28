<%@ tag description="Property Cover Amounts" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="displaySuffix"><c:out value="${data[xpath].exists}" escapeXml="true"/></c:set>

<form_new:fieldset_columns sideHidden="false">
	<jsp:attribute name="rightColumn">
	</jsp:attribute>
	<jsp:body>
		<form_new:fieldset legend="Cover Amounts" className="no-bottom-margin">

			<%-- Rebuild Cost --%>
			<c:set var="fieldXpath" value="${xpath}/rebuildCost" />
			<form_new:row fieldXpath="${fieldXpath}" label="What is the total cost to rebuild the home at today's prices?"  helpId="507" id="rebuildCostRow">
				<field_new:currency xpath="${fieldXpath}"
					required="true"
					decimal="${false}"
					minValue="120000"
					title="The total cost to rebuild the home"/>
			</form_new:row>
		</form_new:fieldset>
	</jsp:body>
</form_new:fieldset_columns>
<form_new:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
		<ui:bubble variant="help" className="abovePolicyLimitsAmount">
			<h4>Please note:</h4>
			<p>The insurance provider will capture the full description and replacement value of the item(s) you wish to specify later.</p>
		</ui:bubble>
	</jsp:attribute>

	<jsp:body>
		<form_new:fieldset legend="">

		<%-- Contents Cost --%>
		<c:set var="fieldXpath" value="${xpath}/replaceContentsCost" />
		<form_new:row fieldXpath="${fieldXpath}" label="What is the total cost to replace the contents at today's prices?"  helpId="509" id="replaceContentsCostRow">
			<field_new:currency xpath="${fieldXpath}"
				required="true"
				decimal="${false}"
				minValue="20000"
				title="The total contents replacement cost"/>
		</form_new:row>

		<%-- Contents above policy Limits --%>
		<c:set var="fieldXpath" value="${xpath}/abovePolicyLimits" />
		<form_new:row fieldXpath="${fieldXpath}" label="<strong>Specify contents above policy limits</strong></br>Do you wish to cover specified contents above the policy limits?"  helpId="511" id="abovePolicyLimitsRow">
			<field_new:array_radio xpath="${fieldXpath}"
				required="true"
				className="pretty_buttons abovePolicyLimitsRadio"
				items="Y=Yes,N=No"
				title="if you wish to cover specified contents above the policy limits"/>
		</form_new:row>

		<%-- Personal effects away from home --%>
		<c:set var="fieldXpath" value="${xpath}/itemsAway"/>
		<form_new:row fieldXpath="${fieldXpath}" label="<strong>Personal effects away from home</strong></br>Do you want cover for items taken away from the home?"  helpId="512" id="itemsAwayRow">
			<field_new:array_radio xpath="${fieldXpath}"
				items="Y=Yes,N=No"
				title="if you want cover for items taken away from the home" required="true"
				className="pretty_buttons" />
		</form_new:row>

		<%-- Unspecified Personal Effects --%>
		<c:set var="fieldXpath" value="${xpath}/unspecifiedCoverAmount"/>
		<form_new:row fieldXpath="${fieldXpath}" label="Total cover for unspecified personal effects"  helpId="513" id="unspecifiedCoverAmountRow">
			<field_new:array_select xpath="${fieldXpath}"
				className="pretty_buttons"
				title="the cover required for unspecified personal effects"
				required="true"
				items="=Please Select...,0=No Cover,1000=$1000,2000=$2000,3000=$3000,4000=$4000,5000=$5000" />
		</form_new:row>

		<%-- Specified Personal Effects --%>
		<c:set var="fieldXpath" value="${xpath}/specifyPersonalEffects"/>
		<form_new:row fieldXpath="${fieldXpath}" label="Do you wish to specify cover for personal effects?"  helpId="514" id="specifyPersonalEffectsRow">
			<field_new:array_radio xpath="${fieldXpath}"
				required="true"
				items="Y=Yes,N=No"
				title="if you to wish to specify cover for personal effects" />
		</form_new:row>

		<div id="specifiedItemsRows" class="show_${displaySuffix}">

			<c:set var="fieldXpath" value="${xpath}/coverTotal" />
			<field_new:input xpath="${fieldXpath}" required="true" className="hidden"/> <%-- Note: this wont update the field value when inspecting the element --%>

			<%-- JAVASCRIPT HEAD --%>
			<go:script marker="js-head">
				$.validator.addMethod("${go:nameFromXpath(fieldXpath)}_percent",
					function(value, elem, parm) {

						var parmsArray = parm.split(",");
						var percentage = parmsArray[1];
						var percentRule = parmsArray[2];
						var val = $(elem).val();
						var thisVal = Number(val.replace(/[^0-9\.]+/g,""));
						var parmVal = $('#'+parmsArray[0]).val();
						var ratio = thisVal / parmVal;
						var percent = ratio * 100;

						if (percent >= percentage && percentRule == "GT" ) {
							$('.specifiedValues').parent().removeClass('has-error').addClass('has-success');
							return true;
						}
						else if (percent <= percentage && percentRule == "LT" ) {
							$('.specifiedValues').parent().removeClass('has-error').addClass('has-success');
							return true;
						}
						else {
							$('.specifiedValues').parent().addClass('has-error').removeClass('has-success');
							return false;
						}
					},
					"Custom message"
				);
			</go:script>
			<c:set var="parms">"${go:nameFromXpath(xpath)}_replaceContentsCost,100,LT"</c:set>
			<go:validate selector="${go:nameFromXpath(fieldXpath)}" rule="${go:nameFromXpath(fieldXpath)}_percent" parm="${parms}" message="Total sum of the Specified Personal Effects must be under 100% of the Total Contents Replacement Value"/>

			<%-- Bicycles --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/bicycle" />
			<form_new:row fieldXpath="${fieldXpath}" label="Bicycles" id="specifiedPersonalEffects_bicycleRow">
				<field_new:currency xpath="${fieldXpath}"
					required="false"
					title="Bicycles"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"/>
			</form_new:row>

			<%-- Musical Instruments --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/musical" />
			<form_new:row fieldXpath="${fieldXpath}" label="Musical Instruments" id="specifiedPersonalEffects_musicalRow">
				<field_new:currency xpath="${fieldXpath}"
					required="false"
					title="Musical instruments"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"/>
			</form_new:row>

			<%-- Clothing --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/clothing" />
			<form_new:row fieldXpath="${fieldXpath}" label="Clothing" id="specifiedPersonalEffects_clothingRow">
				<field_new:currency xpath="${fieldXpath}"
					required="false"
					title="Clothing"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"/>
			</form_new:row>

			<%-- Jewellery & Watches --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/jewellery" />
			<form_new:row fieldXpath="${fieldXpath}" label="Jewellery" id="specifiedPersonalEffects_jewelleryRow">
				<field_new:currency xpath="${fieldXpath}"
					required="false"
					title="Jewellery watches"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"/>
			</form_new:row>

			<%-- Sporting Equipment --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/sporting" />
			<form_new:row fieldXpath="${fieldXpath}" label="Sporting Equipment" id="specifiedPersonalEffects_sportingRow">
				<field_new:currency xpath="${fieldXpath}"
					required="false"
					title="Sporting equipment"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"/>
			</form_new:row>

			<%-- Photographic Equipment --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/photo" />
			<form_new:row fieldXpath="${fieldXpath}" label="Photographic Equipment" id="specifiedPersonalEffects_photoRow">
				<field_new:currency xpath="${fieldXpath}"
					required="false"
					title="Photographic equipment"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"/>
			</form_new:row>
		</div>



		</form_new:fieldset>
	</jsp:body>
</form_new:fieldset_columns>