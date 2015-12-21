<%@ tag description="Property Cover Amounts" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="displaySuffix"><c:out value="${data[xpath].exists}" escapeXml="true"/></c:set>

<form_v2:fieldset_columns sideHidden="false">
	<jsp:attribute name="rightColumn">
	</jsp:attribute>
	<jsp:body>
		<form_v2:fieldset legend="Cover Amounts" className="no-bottom-margin">

			<%-- Rebuild Cost --%>
			<c:set var="fieldXpath" value="${xpath}/rebuildCost" />
			<form_v2:row fieldXpath="${fieldXpath}" label="What is the total cost to rebuild the home at today's prices?"  helpId="507" id="rebuildCostRow">
				<field_new:currency xpath="${fieldXpath}"
					required="true"
					decimal="${false}"
					minValue="120000"
					title="The total cost to rebuild the home"/>
			</form_v2:row>
		</form_v2:fieldset>
	</jsp:body>
</form_v2:fieldset_columns>
<form_v2:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
		<ui:bubble variant="help" className="abovePolicyLimitsAmount">
			<h4>Please note:</h4>
			<p>The insurance provider will capture the full description and replacement value of the item(s) you wish to specify later.</p>
		</ui:bubble>
	</jsp:attribute>

	<jsp:body>
		<form_v2:fieldset legend="">

		<%-- Contents Cost --%>
		<c:set var="fieldXpath" value="${xpath}/replaceContentsCost" />
		<form_v2:row fieldXpath="${fieldXpath}" label="What is the total cost to replace the contents at today's prices?"  helpId="509" id="replaceContentsCostRow">
			<field_new:currency xpath="${fieldXpath}"
				required="true"
				decimal="${false}"
				minValue="20000"
				title="The total contents replacement cost"/>
		</form_v2:row>

		<%-- Contents above policy Limits --%>
		<c:set var="fieldXpath" value="${xpath}/abovePolicyLimits" />
		<form_v2:row fieldXpath="${fieldXpath}" label="<strong>Specify contents above policy limits</strong></br>Do you wish to cover specified contents above the policy limits?"  helpId="511" id="abovePolicyLimitsRow">
			<field_new:array_radio xpath="${fieldXpath}"
				required="true"
				className="pretty_buttons abovePolicyLimitsRadio"
				items="Y=Yes,N=No"
				title="if you wish to cover specified contents above the policy limits"/>
		</form_v2:row>

		<%-- Personal effects away from home --%>
		<c:set var="fieldXpath" value="${xpath}/itemsAway"/>
		<form_v2:row fieldXpath="${fieldXpath}" label="<strong>Personal effects away from home</strong></br>Do you want cover for items taken away from the home?"  helpId="512" id="itemsAwayRow">
			<field_new:array_radio xpath="${fieldXpath}"
				items="Y=Yes,N=No"
				title="if you want cover for items taken away from the home" required="true"
				className="pretty_buttons" />
		</form_v2:row>

		<%-- Unspecified Personal Effects --%>
		<c:set var="fieldXpath" value="${xpath}/unspecifiedCoverAmount"/>
		<form_v2:row fieldXpath="${fieldXpath}" label="Total cover for unspecified personal effects"  helpId="513" id="unspecifiedCoverAmountRow">
			<field_new:array_select xpath="${fieldXpath}"
				className="pretty_buttons"
				title="the cover required for unspecified personal effects"
				required="true"
				items="=Please Select...,0=No Cover,1000=$1000,2000=$2000,3000=$3000,4000=$4000,5000=$5000" />
		</form_v2:row>

		<%-- Specified Personal Effects --%>
		<c:set var="fieldXpath" value="${xpath}/specifyPersonalEffects"/>
		<form_v2:row fieldXpath="${fieldXpath}" label="Do you wish to specify cover for personal effects?"  helpId="514" id="specifyPersonalEffectsRow">
			<field_new:array_radio xpath="${fieldXpath}"
				required="true"
				items="Y=Yes,N=No"
				title="if you to wish to specify cover for personal effects" />
		</form_v2:row>

		<div id="specifiedItemsRows" class="show_${displaySuffix}">

			<c:set var="fieldXpath" value="${xpath}/coverTotal" />
			<c:set var="fieldXpathName"  value="${go:nameFromXpath(fieldXpath)}" />
			<c:set var="parms">{"e":"${name}_replaceContentsCost","p":"100","r":"LT"}</c:set>
			<form_v2:row fieldXpath="${fieldXpath}" label="" id="coverTotalValidation">
				<field_new:input xpath="${fieldXpath}" required="true" readOnly="false" type="text" includeInForm="true" className="invisible no-height" additionalAttributes=" data-rule-coverAmountsPercentage='${parms}' data-coverAmountsTotal='' "/>
			</form_v2:row>


			<%-- Bicycles --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/bicycle" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Bicycles" id="specifiedPersonalEffects_bicycleRow">
				<field_new:currency xpath="${fieldXpath}"
					required="false"
					title="Bicycles"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0" />
			</form_v2:row>

			<%-- Musical Instruments --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/musical" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Musical Instruments" id="specifiedPersonalEffects_musicalRow">
				<field_new:currency xpath="${fieldXpath}"
					required="false"
					title="Musical instruments"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"/>
			</form_v2:row>

			<%-- Clothing --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/clothing" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Clothing" id="specifiedPersonalEffects_clothingRow">
				<field_new:currency xpath="${fieldXpath}"
					required="false"
					title="Clothing"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"/>
			</form_v2:row>

			<%-- Jewellery & Watches --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/jewellery" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Jewellery & Watches" id="specifiedPersonalEffects_jewelleryRow">
				<field_new:currency xpath="${fieldXpath}"
					required="false"
					title="Jewellery and watches"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"/>
			</form_v2:row>

			<%-- Sporting Equipment --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/sporting" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Sporting Equipment" id="specifiedPersonalEffects_sportingRow">
				<field_new:currency xpath="${fieldXpath}"
					required="false"
					title="Sporting equipment"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"/>
			</form_v2:row>

			<%-- Photographic Equipment --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/photo" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Photographic Equipment" id="specifiedPersonalEffects_photoRow">
				<field_new:currency xpath="${fieldXpath}"
					required="false"
					title="Photographic equipment"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"/>
			</form_v2:row>
		</div>

		</form_v2:fieldset>
	</jsp:body>
</form_v2:fieldset_columns>