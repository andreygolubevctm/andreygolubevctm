<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Grouping together of dependantren"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection" class="health-dependants">

	<form:fieldset legend="Your Dependants' Details" >
	
		<%-- //FIX: need to insert fund's real definition here --%>
		<div class="definition">This policy provides cover for your children aged less than 22 years plus students studying full time between the ages of 22 and 24. You can still obtain cover for your adult child outside these criteria by applying for a separate singles policy</div>
		
		<div id="${name}_threshold">
			<field:hidden required="true" validationRule="validateMinDependants" validationMessage="A dependant is required." defaultValue="" xpath="${xpath}/dependantrequired" />
			<h5>You have not added any dependants but have selected a cover type that requires them.</h5>
			<p>If you do not wish to add any dependants, you can search for suitable policies by <a href="javascript:void(0);">changing your cover type</a>.</p>
			<p>If you wish to continue, please add your dependants now.</p>
		</div>
	
		<health:dependant_details xpath="${xpath}/dependant" count="1" />
		<core:clear />
		<health:dependant_details xpath="${xpath}/dependant" count="2" />
		<core:clear />
		<health:dependant_details xpath="${xpath}/dependant" count="3" />
		<core:clear />
		<health:dependant_details xpath="${xpath}/dependant" count="4" />
		<core:clear />
		<health:dependant_details xpath="${xpath}/dependant" count="5" />
		<core:clear />
		<health:dependant_details xpath="${xpath}/dependant" count="6" />
		<core:clear />
		<health:dependant_details xpath="${xpath}/dependant" count="7" />
		<core:clear />
		<health:dependant_details xpath="${xpath}/dependant" count="8" />
		<core:clear />
		<health:dependant_details xpath="${xpath}/dependant" count="9" />
		<core:clear />
		<health:dependant_details xpath="${xpath}/dependant" count="10" />
		<core:clear />
		<health:dependant_details xpath="${xpath}/dependant" count="11" />
		<core:clear />
		<health:dependant_details xpath="${xpath}/dependant" count="12" />
		<core:clear />
		
		<div id="dependents_list_options">
			<a href="javascript:void(0);" class="remove-last-dependent tinybtn" title="Remove last dependent"><span>Remove Last Dependant</span></a>
			<a href="javascript:void(0);" class="add-new-dependent tinybtn" title="Add new dependent"><span>Add New Dependant</span></a>
			<div class="clear"><!-- empty --></div>
		</div>
		
		<%-- If the user changes the amount of dependants here, we will need to re-confirm their selection --%>
		<div class="health-dependants-tier">
			<h5>When completed, confirm your new income tier</h5>
			<form:row label="What is the estimated taxable income for your household for the financial year 1st July 2012 to 30 June 2013?" id="${name}_tier">
				<field:array_select xpath="${xpath}/income"  title="Please enter your household income" required="true" items="=Please choose...||0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" className="income health_dependants_details_income"/>
				<span class="fieldrow_legend" id="${name}_incomeMessage"></span>
			</form:row>	
		</div>		
	
	</form:fieldset>

</div>


<%-- CSS --%>
<go:style marker="css-head">
	#${name}-selection {
	}
	
	#${name}-selection .item .fieldrow {
		min-height:0px;
	}
	.health_dependant_details {
		display:none;
	}
	.health_dependant_details h5 {
		cursor:pointer;
	}
	.health_dependant_details .items {
		overflow:hidden;
		/*max-height:0px;*/
	}
	.health_dependant_details_schoolGroup,
	.health_dependant_details_schoolIDGroup,
	.health_dependant_details_schoolDateGroup {
		display:none;
		min-height:0px;	
	}
	.health-dependants-tier {
		margin-top:10px;
	}
	#${name}_threshold,
	.health-dependants-tier {
		display:none;
	}
	
	.health_dependant_details_maritalincomestatus .fieldrow_label {
		text-indent:20px;
	}
</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var healthDependents = {

	_dependents: 0,
	_limit: 12,
	maxAge: 25,
	
	init: function()
	{
		healthDependents.setDependants();
		healthDependents.resetConfig();
	},
	
	resetConfig: function(){
		healthDependents.config = { 'school':true, 'schoolMin':22, 'schoolMax':24, 'schoolID':false, 'schoolIDMandatory':false, 'schoolDate':false, 'schoolDateMandatory':false, 'defacto':false, 'defactoMin':21, 'defactoMax':24 };
		healthDependents.maxAge = 25;		
	},
	
	setDependants: function()
	{
		var _dependants = $('#mainform').find('.health_cover_details_dependants').find('select').val();
		if( healthCoverDetails.getRebateChoice() == 'Y' && !isNaN(_dependants)) {
			healthDependents._dependents = _dependants;
		} else {
			healthDependents._dependents = 1;
		};
		
		healthDependents.updateDependentOptionsDOM();
		
		if( healthChoices.hasChildren() ) {
			$('#${name}-selection').show();
		} else {
			$('#${name}-selection').hide();
			return;
		};
		
		$('#${name}-selection').find('.health_dependant_details').each( function(){
			var index = parseInt( $(this).attr('data-id') );
			if( index > healthDependents._dependents )
			{
				$(this).hide();
			}
			else
			{
				$(this).show();
			};
			
			healthDependents.checkDependent( index );
		});		
	},
	addDependent: function()
	{
		if( healthDependents._dependents < healthDependents._limit )
		{
			healthDependents._dependents++;
			var $_obj = $('#${name}_dependant' + healthDependents._dependents);
			$_obj.find('input[type=text], select').val('');
			resetRadio($_obj.find('.health_dependant_details_maritalincomestatus'),'');
			$_obj.show();
			healthDependents.updateDependentOptionsDOM();
			healthDependents.hasChanged();
		}
	},
	dropDependent: function()
	{
		if( healthDependents._dependents > 0 )
		{
			$('#${name}_dependant' + healthDependents._dependents).find("input[type=text]").each(function(){
				$(this).val("");
			});
			$('#${name}_dependant' + healthDependents._dependents).find("input[type=radio]:checked").each(function(){
				this.checked = false;
			});
			$('#${name}_dependant' + healthDependents._dependents).find("select").each(function(){
				$(this).removeAttr("selected");
			});
			$('#${name}_dependant' + healthDependents._dependents).hide();
			healthDependents._dependents--;			
			healthDependents.updateDependentOptionsDOM();
			healthDependents.hasChanged();
		}
	},
	updateDependentOptionsDOM: function()
	{
		if( healthDependents._dependents <= 0 ) {
			$("#dependents_list_options").find(".remove-last-dependent").hide();			
			$('#${name}_threshold').slideDown();
			$("#${name}_dependantrequired").val("").addClass("validate");
		} else if( !$("#dependents_list_options").find(".remove-last-dependent").is(":visible") ) {
			$('#${name}_threshold').slideUp();
			$("#dependents_list_options").find(".remove-last-dependent").show();
			$("#${name}_dependantrequired").val("ignoreme").removeClass("validate");			
		};
		
		if( healthDependents._dependents >= healthDependents._limit ) {
			$("#dependents_list_options").find(".add-new-dependent").hide();
		} else if( $("#dependents_list_options").find(".add-new-dependent").not(":visible") ) {
			$("#dependents_list_options").find(".add-new-dependent").show();
		};
	},
	checkDependent: function(e)
	{
		var index = e;
		
		if( isNaN(e) && typeof e == 'object' ) {
			index = e.data;
		};
		
		<%-- Create an age check mechanism --%>
		var dob = $('#${name}_dependant' + index + '_dob').val();		
		if( !dob.length){
			var age = 0;
		} else {		
			var age = healthDependents.getAge(dob);
			if( isNaN(age) ){
				return false;
			};
		};
		
		<%-- Check the individual questions --%>
		healthDependents.addSchool(index, age);
		healthDependents.addDefacto(index, age);		
	},
	
	getAge: function( dob )
	{
		var dob_pieces = dob.split("/");
		var year = Number(dob_pieces[2]);
		var month = Number(dob_pieces[1]) - 1;
		var day = Number(dob_pieces[0]);
		var today = new Date();
		var age = today.getFullYear() - year;
		if(today.getMonth() < month || (today.getMonth() == month && today.getDate() < day))
		{
			age--;
		}
		
		return age;
	},
	
	addSchool: function(index, age){
		if( healthDependents.config.school === false ){
			$('#${name}-selection').find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').hide();
			return false;
		};		
		if( (age >= healthDependents.config.schoolMin) && (age <= healthDependents.config.schoolMax) ){
			$('#${name}-selection').find('.dependant'+ index).find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').show();
			<%-- Show/hide ID number field, with optional validation --%>
			if( healthDependents.config.schoolID === false ) {
				$('#${name}-selection').find('.dependant'+ index).find('.health_dependant_details_schoolIDGroup').hide();			
			}
			else {
				if (this.config.schoolIDMandatory === true) {
					$('#${name}-selection').find('#health_application_dependants_dependant' + index + '_schoolID').rules('add', {required:true, messages:{required:'Please enter dependant '+index+'\'s student ID'}});
				}
				else {
					$('#${name}-selection').find('#health_application_dependants_dependant' + index + '_schoolID').rules('remove', 'required');
				}
			};
			<%-- Show/hide date study commenced field, with optional validation --%>
			if (this.config.schoolDate !== true) {
				$('#${name}-selection').find('.dependant'+ index).find('.health_dependant_details_schoolDateGroup').hide();
			}
			else {
				if (this.config.schoolDateMandatory === true) {
					$('#${name}-selection').find('#health_application_dependants_dependant' + index + '_schoolDate').rules('add', {required:true, messages:{required:'Please enter date that dependant '+index+' commenced study'}});
				}
				else {
					$('#${name}-selection').find('#health_application_dependants_dependant' + index + '_schoolDate').rules('remove', 'required');
				}
			};
		} else {
			$('#${name}-selection').find('.dependant'+ index).find('.health_dependant_details_schoolGroup, .health_dependant_details_schoolIDGroup, .health_dependant_details_schoolDateGroup').hide();
		};
	},
	
	addDefacto: function(index, age){
		if( healthDependents.config.defacto === false ){			
			return false;
		};		
		if( (age >= healthDependents.config.defactoMin) && (age <= healthDependents.config.defactoMax) ){
			$('#${name}-selection').find('.dependant'+ index).find('.health_dependant_details_maritalincomestatus').show();
		} else {
			$('#${name}-selection').find('.dependant'+ index).find('.health_dependant_details_maritalincomestatus').hide();
		};
	},
	
	hasChanged: function( ){		
		var $_obj = $('#${name}-selection').find('.health-dependants-tier');
		if(healthCoverDetails.getRebateChoice() == 'N' ) {
			$_obj.slideUp();
		} else if( healthDependents._dependents > 0 ){
			<%-- Call the summary panel error message --%>
			healthPolicyDetails.error();
			
			<%-- Refresh/Call the Dependants and rebate tiers --%>
			$('#health_healthCover_dependants').val( healthDependents._dependents ).trigger('change');
			
			<%-- Change the income questions --%>
			var $_original = $('#health_healthCover_tier');			
			$_obj.find('select').html( $_original.find('select').html() );
			$_obj.find('#${name}_incomeMessage').text( $_original.find('span').text() );
			if( $_obj.is(':hidden') ){	
				$_obj.slideDown();
			};
		} else {
			$_obj.slideUp();
		};		
	}
};

healthDependents.resetConfig();


<%-- Validation for defacto messages --%>
$.validator.addMethod("defactoConfirmation",
	function(value, element) {
	
		if( $(element).parent().find(':checked').val() == 'Y' ){
			return true; <%-- Passes --%>
		} else {
			return false; <%-- Fails --%>
		};
		
	},
	"Custom message"
);


<%-- Validation for defacto messages --%>
$.validator.addMethod("validateMinDependants",
	function(value, element) {
		return !$("#${name}_threshold").is(":visible");
	},
	"Custom message"
);


<%-- DOB validation message --%>
$.validator.addMethod("limitDependentAgeToUnder25",
	function(value, element) {	
		var getAge = returnAge(value);
		if( getAge >= healthDependents.maxAge ) {
			<%-- Change the element message on the fly --%>
			$(element).rules("add", { messages: { 'limitDependentAgeToUnder25':'Your child cannot be added to the policy as they are aged ' + healthDependents.maxAge + ' years or older. You can still arrange cover for this dependant by applying for a separate singles policy or please contact us if you require assistance.' } } );
			return false;
		};
		return true;
	}
);
</go:script>

<go:script marker="onready">
	healthDependents.init();
	
	<%-- Mirror the tier selection from the PRE questions --%>
	$('#${name}_income').on('change', function(){
		$('#mainform').find('.health_cover_details_income').val( $(this).val() );
	});
	
	<%-- The user has changed their mind for supporting dependants --%>
	$('#${name}_threshold').find('a').on('click', function(){
		Results.startOver();
	});
	
	<%-- DOB binding --%>
	$('#${name}-selection').on('change', '.person_dob', function(){
		healthDependents.checkDependent( $(this).closest('.health_dependant_details').attr('data-id') );
	});
	
	<%-- Add and remove bindings --%>
	$('#${name}-selection').find(".remove-last-dependent").on("click", function(){
		healthDependents.dropDependent();
	});	
	$('#${name}-selection').find(".add-new-dependent").on("click", function(){
		healthDependents.addDependent();
	});
	
	<%-- Whenever a new fund is loaded, re-render the dependants actions --%>
	slide_callbacks.register({
		mode:		'before',
		direction: 'forward',
		slide_id:	3,
		callback:	function() {
			healthDependents.setDependants();
		}
	});	
	
</go:script>