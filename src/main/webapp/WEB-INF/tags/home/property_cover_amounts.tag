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
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Cost to Rebuild Home - Tool Tip" quoteChar="\"" /></c:set>
			<form_v2:row fieldXpath="${fieldXpath}" label="What is the total cost to rebuild the property at today's prices?"  helpId="507" id="rebuildCostRow" tooltipAttributes="${analyticsAttr}">
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Cost to Rebuild Home" quoteChar="\"" /></c:set>
				<field_v2:currency xpath="${fieldXpath}"
					required="true"
					decimal="${false}"
					minValue="150000"
					maxValue="1500000"
					title="The total cost to rebuild the home"
					additionalAttributes="${analyticsAttr}" />
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

					<div class="notLandlord">
						<%-- Contents Cost --%>
						<c:set var="fieldXpath" value="${xpath}/replaceContentsCost" />
						<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Cost to Replace Contents" quoteChar="\"" /></c:set>
						<form_v2:row fieldXpath="${fieldXpath}" label="What is the total cost to replace the contents at today's prices?"  helpId="509" id="replaceContentsCostRow" tooltipAttributes="${analyticsAttr}">
							<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Cost to Replace Contents" quoteChar="\"" /></c:set>
							<field_v2:currency xpath="${fieldXpath}"
								required="true"
								decimal="${false}"
								minValue="20000"
							  maxValue="349999"
								title="The total contents replacement cost"
								additionalAttributes="${analyticsAttr}" />
						</form_v2:row>

						<%-- Contents above policy Limits --%>
						<c:set var="fieldXpath" value="${xpath}/abovePolicyLimits" />
						<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Policy Limits - Tool Tip" quoteChar="\"" /></c:set>
						<form_v2:row fieldXpath="${fieldXpath}" label="<strong>Specify contents above policy limits</strong></br>Do you wish to cover specified contents above the policy limits?"  helpId="511" id="abovePolicyLimitsRow" tooltipAttributes="${analyticsAttr}">
							<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Policy Limits" quoteChar="\"" /></c:set>
							<field_v2:array_radio xpath="${fieldXpath}"
								required="true"
								className="pretty_buttons abovePolicyLimitsRadio"
								items="Y=Yes,N=No"
								title="if you wish to cover specified contents above the policy limits"
								additionalLabelAttributes="${analyticsAttr}" />
						</form_v2:row>
					</div>



		<div class="isLandlord">
			<%-- Contents Cost --%>
			<c:set var="fieldXpath" value="${xpath}/replaceContentsCost" />
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Cost to Replace Contents" quoteChar="\"" /></c:set>
			<form_v2:row fieldXpath="${fieldXpath}" label="What is the total cost to replace the contents at today's prices?"  helpId="509" id="replaceContentsCostRow" tooltipAttributes="${analyticsAttr}">
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Cost to Replace Contents" quoteChar="\"" /></c:set>
				<field_v2:currency xpath="${fieldXpath}"
					landlordFix="${xpath}/replaceContentsCostLandlord"
					required="true"
					decimal="${false}"
					minValue="10000"
					maxValue="100000"
					title="The total contents replacement cost"
					additionalAttributes="${analyticsAttr}" />
			</form_v2:row>
		</div>


		<%-- Personal effects away from home --%>
		<c:set var="fieldXpath" value="${xpath}/itemsAway"/>
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Personal Effects - Tool Tip" quoteChar="\"" /></c:set>
		<form_v2:row fieldXpath="${fieldXpath}" label="<strong>Personal effects away from home</strong></br>Do you want cover for items taken away from the home?"  helpId="512" id="itemsAwayRow" tooltipAttributes="${analyticsAttr}">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Personal Effects" quoteChar="\"" /></c:set>
			<field_v2:array_radio xpath="${fieldXpath}"
				items="Y=Yes,N=No"
				title="if you want cover for items taken away from the home" required="true"
				className="pretty_buttons"
				additionalLabelAttributes="${analyticsAttr}" />
		</form_v2:row>

		<%-- Unspecified Personal Effects --%>
		<c:set var="fieldXpath" value="${xpath}/unspecifiedCoverAmount"/>
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Total Unspecified Effects - Tool Tip" quoteChar="\"" /></c:set>
		<form_v2:row fieldXpath="${fieldXpath}" label="Total cover for unspecified personal effects"  helpId="513" id="unspecifiedCoverAmountRow" tooltipAttributes="${analyticsAttr}">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Total Unspecified Effects" quoteChar="\"" /></c:set>
			<field_v2:array_select xpath="${fieldXpath}"
				className="pretty_buttons"
				title="the cover required for unspecified personal effects"
				required="true"
				items="=Please Select...,0=No Cover,1000=$1000,2000=$2000,3000=$3000,4000=$4000,5000=$5000"
				extraDataAttributes="${analyticsAttr}" />
		</form_v2:row>

		<%-- Specified Personal Effects --%>
		<c:set var="fieldXpath" value="${xpath}/specifyPersonalEffects"/>
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Specify Cover for Personal Effects - Tool Tip" quoteChar="\"" /></c:set>
		<form_v2:row fieldXpath="${fieldXpath}" label="Do you wish to specify cover for personal effects?"  helpId="514" id="specifyPersonalEffectsRow" tooltipAttributes="${analyticsAttr}">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Specify Cover for Personal Effects" quoteChar="\"" /></c:set>
			<field_v2:array_radio xpath="${fieldXpath}"
				required="true"
				items="Y=Yes,N=No"
				title="if you to wish to specify cover for personal effects"
				additionalLabelAttributes="${analyticsAttr}" />
		</form_v2:row>

		<div id="specifiedItemsRows" class="show_${displaySuffix}">

			<c:set var="fieldXpath" value="${xpath}/coverTotal" />
			<c:set var="fieldXpathName"  value="${go:nameFromXpath(fieldXpath)}" />
			<c:set var="parms">{"e":"${name}_replaceContentsCost","p":"100","r":"LT"}</c:set>
			<form_v2:row fieldXpath="${fieldXpath}" label="" id="coverTotalValidation">
				<field_v2:input xpath="${fieldXpath}" required="true" readOnly="false" type="text" includeInForm="true" className="invisible no-height" additionalAttributes=" data-rule-coverAmountsPercentage='${parms}' data-coverAmountsTotal='' "/>
			</form_v2:row>


			<%-- Bicycles --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/bicycle" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Bicycles" id="specifiedPersonalEffects_bicycleRow">
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Bicycles" quoteChar="\"" /></c:set>
				<field_v2:currency xpath="${fieldXpath}"
					required="false"
					title="Bicycles"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"
					additionalAttributes="${analyticsAttr}" />
			</form_v2:row>

			<%-- Musical Instruments --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/musical" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Musical Instruments" id="specifiedPersonalEffects_musicalRow">
				<field_v2:currency xpath="${fieldXpath}"
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
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Musical Instruments" quoteChar="\"" /></c:set>
				<field_v2:currency xpath="${fieldXpath}"
					required="false"
					title="Clothing"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"
					additionalAttributes="${analyticsAttr}" />
			</form_v2:row>

			<%-- Jewellery & Watches --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/jewellery" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Jewellery & Watches" id="specifiedPersonalEffects_jewelleryRow">
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Jewellery & Watches" quoteChar="\"" /></c:set>
				<field_v2:currency xpath="${fieldXpath}"
					required="false"
					title="Jewellery and watches"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"
					additionalAttributes="${analyticsAttr}" />
			</form_v2:row>

			<%-- Sporting Equipment --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/sporting" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Sporting Equipment" id="specifiedPersonalEffects_sportingRow">
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Sporting Equipment" quoteChar="\"" /></c:set>
				<field_v2:currency xpath="${fieldXpath}"
					required="false"
					title="Sporting equipment"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"
					additionalAttributes="${analyticsAttr}" />
			</form_v2:row>

			<%-- Photographic Equipment --%>
			<c:set var="fieldXpath" value="${xpath}/specifiedPersonalEffects/photo" />
			<form_v2:row fieldXpath="${fieldXpath}" label="Photographic Equipment" id="specifiedPersonalEffects_photoRow">
				<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Photographic Equipment" quoteChar="\"" /></c:set>
				<field_v2:currency xpath="${fieldXpath}"
					required="false"
					title="Photographic equipment"
					className="specifiedValues"
					minValue="1000"
					decimal="${false}"
					defaultValue="0"
					additionalAttributes="${analyticsAttr}" />
			</form_v2:row>
		</div>

		</form_v2:fieldset>
	</jsp:body>
</form_v2:fieldset_columns>
