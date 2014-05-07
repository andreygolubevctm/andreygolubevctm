<%@ tag import="java.util.*"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Cover amounts group gadget."%>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true"	description="variable's xpath"%>
<%@ attribute name="className" required="false" rtexprvalue="true"	description="additional css class attribute"%>
<%@ attribute name="title" required="true" rtexprvalue="true"	description="title of the panel"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<go:style marker="css-head">
	.abovePolicyLimitsRadio{
		float: left;
	}
	.policyLimitsLink{
		line-height: 30px;
	}
	.fieldrow_value{
		max-width: 400px;
	}
	.specifiedValues{
		width: 73px;
	}
	.abovePolicyLimits,
	.rebuildCost,
	.replaceContentsCost,
	.abovePolicyLimitsAmount{
		display: none;
	}
	.section-title{
		max-width: 188px;
	}
</go:style>

<div class="${className}">

	<form:fieldset legend="${title}" className="${className}" id="${name}">

		<div class="rebuildCost">
			<form:row label="What is the total cost to rebuild the home at today's prices?" helpId="507">
				<field:currency
					xpath="${xpath}/rebuildCost"
					required="true"
					maxLength ="6"
					decimal="${false}"
					minValue="100000"
					maxValue="999999"
					title="The total cost to rebuild the home"/>&nbsp;
<!-- 					TEMPORARY REMOVAL OF CALCULATORS  -->
<!-- 				<a href="javascript:showCalc();" target="_blank" rel="nofollow">Building Cost Calculator</a> -->
			</form:row>
		</div>

		<div class="replaceContentsCost">
			<form:row label="What is the total cost to replace the contents at today's prices?" helpId="509">
				<field:currency
					xpath="${xpath}/replaceContentsCost"
					required="true"
					maxLength ="6"
					decimal="${false}"
					minValue="30000"
					maxValue="499999"
					percentage="10"
					percentRule="GT"
					otherElement="${xpath}/rebuildCost"
					otherElementName="the Total Rebuild cost"
					title="The Total Contents Replacement cost"/>&nbsp;
<!-- 					TEMPORARY REMOVAL OF CALCULATORS  -->
<!-- 				<a href="javascript:showCalc();" target="_blank" rel="nofollow">Contents Cost Calculator</a> -->
			</form:row>
		</div>

		<div class="abovePolicyLimits">

			<hr/>
			<div class="section-title">Specify contents above policy limits</div>
			<core:clear/>

			<form:row label="Do you wish to cover specified contents above the policy limits?"
					helpId="511" id="row_${name}_abovePolicyLimits">
				<field:array_radio
					xpath="${xpath}/abovePolicyLimits"
					required="true"
					className="pretty_buttons abovePolicyLimitsRadio"
					items="Y=Yes,N=No"
					title="if you wish to cover specified contents above the policy limits"/>&nbsp;
			</form:row>
		</div>
<%-- TEMPORARY REMOVAL OF QUESTION WHICH IS ONLY REQUIRED BY HOLLARD & CALLIDEN --%>
		<div class="abovePolicyLimitsAmount">
			<form:row label="">
<%-- 			<form:row label="Total cover for specified contents"> --%>
<%-- 				<field:currency --%>
<%-- 					xpath="${xpath}/abovePolicyLimitsAmount" --%>
<%-- 					required="true" --%>
<%-- 					maxLength ="6" --%>
<%-- 					decimal="${false}" --%>
<%-- 					minValue="1" --%>
<%-- 					maxValue="499999" --%>
<%-- 					title = "The total cover for specified contents"/> --%>
			<p><strong>Please Note:</strong> The insurance provider will capture the full description and replacement value of the item(s) you wish to specify later.</p>
			</form:row>
		</div>


		<%-- Personal Effects --%>

		<div class="itemsAway">
			<hr/>
			<div class="section-title">Personal effects away from home</div>
			<core:clear/>

			<form:row label="Do you want cover for items taken away from the home?" helpId="512">
				<field:array_radio xpath="${xpath}/itemsAway" items="Y=Yes,N=No"
					title="if you want cover for items taken away from the home" required="true"
					className="pretty_buttons" />
			</form:row>
		</div>

		<div class="unspecifiedCoverAmount">
			<form:row label="Total cover for unspecified personal effects" helpId="513">
				<field:array_select
					xpath="${xpath}/unspecifiedCoverAmount"
					className="pretty_buttons"
					title="the cover required for unspecified personal effects"
					required="true"
					items="=Please Select...,0=No Cover,1000=$1000,2000=$2000,3000=$3000,4000=$4000,5000=$5000" />
			</form:row>
		</div>

		<div class="specifyPersonalEffects">
			<form:row label="Do you wish to specify cover for personal effects?" helpId="514">
				<field:array_radio xpath="${xpath}/specifyPersonalEffects" required="true" items="Y=Yes,N=No"
					title="if you to wish to specify cover for personal effects" className="pretty_buttons" />
			</form:row>
		</div>

		<c:set var="Bicycles">
			<field:currency xpath="${xpath}/specifiedPersonalEffects/bicycle"
				required="false"
				title="Bicycles"
				className="specifiedValues"
				maxLength="5"
				minValue="1000"
				maxValue="49999"
				percentage="50"
				percentRule="LT"
				otherElement="${xpath}/replaceContentsCost"
				otherElementName="the Total Contents Replacement Value"
				altTitle="Total sum of the Specified Personal Effects"
				decimal="${false}"
				defaultValue="0"/>
		</c:set>

		<c:set var="Musical_Instruments">
			<field:currency
				xpath="${xpath}/specifiedPersonalEffects/musical"
				required="false"
				title="Musical instruments"
				className="specifiedValues"
				maxLength="5"
				minValue="1000"
				maxValue="49999"
				percentage="50"
				percentRule="LT"
				otherElement="${xpath}/replaceContentsCost"
				otherElementName="the Total Contents Replacement Value"
				altTitle="Total sum of the Specified Personal Effects"
				decimal="${false}"
				defaultValue="0"/>
		</c:set>

		<c:set var="Clothing">
			<field:currency
				xpath="${xpath}/specifiedPersonalEffects/clothing"
				required="false"
				title="Clothing"
				className="specifiedValues"
				maxLength="5"
				minValue="1000"
				maxValue="49999"
				percentage="50"
				percentRule="LT"
				otherElement="${xpath}/replaceContentsCost"
				otherElementName="the Total Contents Replacement Value"
				altTitle="Total sum of the Specified Personal Effects"
				decimal="${false}"
				defaultValue="0"/>
		</c:set>
		<c:set var="Jewellery_Watches">
			<field:currency
				xpath="${xpath}/specifiedPersonalEffects/jewellery"
				required="false"
				title="Jewellery watches"
				className="specifiedValues"
				maxLength="5"
				minValue="1000"
				maxValue="49999"
				percentage="50"
				percentRule="LT"
				otherElement="${xpath}/replaceContentsCost"
				otherElementName="the Total Contents Replacement Value"
				altTitle="Total sum of the Specified Personal Effects"
				decimal="${false}"
				defaultValue="0"/>
		</c:set>

		<c:set var="Sporting_Equipment">
			<field:currency
				xpath="${xpath}/specifiedPersonalEffects/sporting"
				required="false"
				title="Sporting equipment"
				className="specifiedValues"
				maxLength="5"
				minValue="1000"
				maxValue="49999"
				percentage="50"
				percentRule="LT"
				otherElement="${xpath}/replaceContentsCost"
				otherElementName="the Total Contents Replacement Value"
				altTitle="Total sum of the Specified Personal Effects"
				decimal="${false}"
				defaultValue="0"/>
		</c:set>

		<c:set var="Photographic_Equipment">
			<field:currency
				xpath="${xpath}/specifiedPersonalEffects/photo"
				required="false"
				title="Photographic equipment"
				className="specifiedValues"
				maxLength="5"
				minValue="1000"
				maxValue="49999"
				percentage="50"
				percentRule="LT"
				otherElement="${xpath}/replaceContentsCost"
				otherElementName="the Total Contents Replacement Value"
				altTitle="Total sum of the Specified Personal Effects"
				decimal="${false}"
				defaultValue="0"/>
		</c:set>

		<div class="specifiedItems">
			<form:items_grid
							xpath="${xpath}/specifiedPersonalEffects"
							title="Specified Personal Effects"
							items="Bicycles=${Bicycles},
								Musical Instruments=${Musical_Instruments},
								Clothing=${Clothing},
								Jewellery & Watches=${Jewellery_Watches},
								Photographic Equipment=${Photographic_Equipment},
								Sporting Equipment=${Sporting_Equipment}"
							validationValue="49999"
							validationField="${xpath}/coverTotal"

								/>
		</div>
		<field:hidden xpath="${xpath}/coverTotal" required="true" defaultValue="0"/>

	</form:fieldset>
</div>

<ui:dialog id="policylimit" width="500" title="Specified Items Limits">
	<h3>Policy Limits For Specified Content Items</h3>
	<p>Certain contents items in the home have limits that can be increased:</p>
	<table>
		<tr>
			<th>Items</th>
			<th>Policy Limit</th>
		</tr>
		<tr>
			<td>Hand woven carpets and rugs</td>
			<td>$2000 for any item</td>
		</tr>
		<tr>
			<td>CDs, DVDs, flash cards, digital media cards, audio and video tapes, records, computer discs, computer software, games cartridges and game consoles</td>
			<td>$2500 in total</td>
		</tr>
		<tr>
			<td>Collections, memorabilia, stamps, collectors pins, medals &amp; collectors non-negotiable currency</td>
			<td>$2000 in total for any one item or collection</td>
		</tr>
		<tr>
			<td>Jewellery and watches</td>
			<td>$1000 for any item or set, up to $3000 in total</td>
		</tr>
		<tr>
			<td>Paintings, pictures, works of art, sculptures or art objects</td>
			<td>$5000 for any item or set, up to $10000 in total</td>
		<tr>
	</table>
	<p>Select 'Yes' if you wish to specify individual items that exceed the policy limits.</p>
	<p>You do not need to specify items in the home if you have specified them as personal effects to be taken away from the home.</p>
	<p>Refer to the policy disclosure statement for more details.</p>
</ui:dialog>

<%-- JAVASCRIPT HEAD --%>
<go:script marker="js-head">

	var CoverAmounts = new Object();
	CoverAmounts = {

		init: function(){

			$('input[name=${name}_abovePolicyLimits]').on('change', function(){
				CoverAmounts.toggleAbovePolicyLimitsAmount();
			});

			$('input[name=${name}_itemsAway], input[name=${name}_specifyPersonalEffects]').on('change', function(){
				CoverAmounts.togglePersonalEffectsFields();
			});

			$('.specifiedValues').on('blur', function(){
				CoverAmounts.updateTotalPersonalEffects();
			});

			CoverAmounts.toggleAbovePolicyLimitsAmount();
			CoverAmounts.togglePersonalEffectsFields();

		},

		toggleAbovePolicyLimitsAmount: function(){
			if( $('input[name=${name}_abovePolicyLimits]:checked').val() == 'Y'){
				$('.abovePolicyLimitsAmount').slideDown();
			}else{
				$('.abovePolicyLimitsAmount').slideUp();
			}
		},

		hideCoverAmountsFields: function(){

			$('.abovePolicyLimits').slideUp();
			$('.rebuildCost').slideUp();
			$('.replaceContentsCost').slideUp();
			$('.abovePolicyLimitsAmount').slideUp();

		},

		toggleCoverAmountsFields: function(){

			switch(CoverType.coverType){
				case "Home Cover Only":
					CoverAmounts.hideCoverAmountsFields();
					$('.rebuildCost').slideDown();
				break;
				case "Contents Cover Only":
					CoverAmounts.hideCoverAmountsFields();
					$('.replaceContentsCost').slideDown();
					$('.abovePolicyLimits').slideDown();
				break;
				case "Home & Contents Cover":
					CoverAmounts.hideCoverAmountsFields();
					$('.rebuildCost').slideDown();
					$('.replaceContentsCost').slideDown();
					$('.abovePolicyLimits').slideDown();
				break;
				default:
					CoverAmounts.hideCoverAmountsFields();
			}

		},
		updateTotalPersonalEffects : function() {
				var bicycle = Number($('#${name}_specifiedPersonalEffects_bicycle').val());
				var musical = Number($('#${name}_specifiedPersonalEffects_musical').val());
				var clothing = Number($('#${name}_specifiedPersonalEffects_clothing').val());
				var jewellery = Number($('#${name}_specifiedPersonalEffects_jewellery').val());
				var sporting = Number($('#${name}_specifiedPersonalEffects_sporting').val());
				var photo = Number($('#${name}_specifiedPersonalEffects_photo').val());

				var totalVal = bicycle + musical + clothing + jewellery + sporting + photo;

<%-- 				console.log(totalVal); --%>

				$('#${name}_coverTotal').val(totalVal);
<%-- 				console.log('SET: '+$('#${name}_coverTotal').val()); --%>

		},

		togglePersonalEffectsFields: function() {

			if( $('input[name=${name}_itemsAway]:checked').val() == 'Y' ){

				$('.unspecifiedCoverAmount').slideDown();
				$('.unspecifiedCoverAmountTAndC').slideDown();
				$('.specifyPersonalEffects').slideDown();

				if( $('input[name=${name}_specifyPersonalEffects]:checked').val() == 'Y' ){
					$('.specifiedItems').slideDown();
				} else {
					$('.specifiedItems').slideUp();
				}

			} else {

				CoverAmounts.hidePersonalEffectsFields();

			}

			if(PropertyOccupancy.principalResidence == 'Y' && $.inArray(CoverType.coverType, ['Home & Contents Cover', 'Contents Cover Only']) != -1){
				$('.itemsAway').slideDown();
			} else {
				$('.itemsAway').slideUp();
				CoverAmounts.hidePersonalEffectsFields();
			}

		},

		hidePersonalEffectsFields: function(){

			$('.unspecifiedCoverAmount').slideUp();
			$('.specifyPersonalEffects').slideUp();
			$('.specifiedItems').slideUp();
			$('.unspecifiedCoverAmountTAndC').slideUp();

		}

	}

</go:script>

<go:script marker="onready">
	CoverAmounts.init();
</go:script>