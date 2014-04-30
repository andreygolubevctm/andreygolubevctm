<%@ tag import="java.util.*"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Select box built comma separated values."%>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="variable's xpath"%>
<%@ attribute name="className" required="false" rtexprvalue="true" description="additional css class attribute"%>
<%@ attribute name="title" required="true" rtexprvalue="true" description="title of the select box"%>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- CSS --%>
<go:style marker="css-head">
	#oktocallText,
	#emailOfferText {
		font-size: 11px;
		width: 210px;
		text-align: left;
		color: #808080;
		margin-left: 10px;
		position: absolute;
		right: 0px;
		top: 0px;
	}

	.anyoneOlder,
	.oldestPersonDob,
	.over55{
		display: none;
	}
	.jointPolicyHolder{
		display: none;
	}
	.fieldrow.policyHolderColumns h5{
		padding-left: 0;
	}
	.policyHolderColumns .gridColumn2Label{
		width: 0 !important;
		margin: 0 !important;
		padding: 0 !important;
	}
	.policyHolderColumns .floatLeft{
		width: 32%;
	}
	.policyHolderColumns .column{
		max-width: 16em;
	}
	.dob_container{
		float: left;
	}
	.dob_container span.fieldrow_legend{
		display: none;
	}
	.toggleJointPolicyHolderIcon{
		height: 16px;
		width: 16px;
		background: url(brand/ctm/images/ui-icons_2e83ff_256x240.png) no-repeat 0px -192px;
		float: left;
	}
</go:style>

<%-- HTML --%>
<div class="${className}">

	<form:fieldset legend="Policy Holder(s)" className="${className}" id="${name}">

		<%-- column titles --%>
		<c:set var="policyHolderColumn">
			<h5>Policy Holder</h5>
		</c:set>
		<c:set var="jointPolicyHolderColumn">
			<a href="javascript:void(0);" class="toggleJointPolicyHolder" title="Toggle Joint Policy Holder"><h5><div class="toggleJointPolicyHolderIcon"></div><span>Add Joint Policy Holder</span></h5></a>
		</c:set>
		<form:items_grid label="&nbsp;" columns="2" items="=${policyHolderColumn},=${jointPolicyHolderColumn}" className="policyHolderColumns" xpath="${xpath}/Column"/>

		<%-- titles --%>
		<c:set var="titleField">
			<field:import_select xpath="${xpath}/title" title="the policy holder's title"  required="false" url="/WEB-INF/option_data/titles_simple.html" className="person-title"/>
		</c:set>
		<c:set var="jointTitleField">
			<field:import_select xpath="${xpath}/jointTitle" title="the joint policy holder's title"  required="false" url="/WEB-INF/option_data/titles_simple.html" className="person-title jointPolicyHolder"/>
		</c:set>
		<form:items_grid label="Title" columns="2" items="=${titleField},=${jointTitleField}" className="policyHolderColumns"  xpath="${xpath}/bothTitles"/>

		<%-- first names --%>
		<c:set var="firstName">
			<field:input xpath="${xpath}/firstName" title="policy holder's first name" required="false" maxlength="50"/>
		</c:set>
		<c:set var="jointFirstName">
			<field:input xpath="${xpath}/jointFirstName" title="joint policy holder's first name" required="false" maxlength="50" className="jointPolicyHolder"/>
		</c:set>
		<form:items_grid label="First Name" columns="2" items="=${firstName},=${jointFirstName}" className="policyHolderColumns"  xpath="${xpath}/bothFirstNames"/>

		<%-- lastNames --%>
		<c:set var="lastName">
			<field:input xpath="${xpath}/lastName" title="policy holder's last name" required="false" maxlength="50"/>
		</c:set>
		<c:set var="jointLastName">
			<field:input xpath="${xpath}/jointLastName" title="joint policy holder's last name" required="false" maxlength="50" className="jointPolicyHolder"/>
		</c:set>
		<form:items_grid label="Last Name" columns="2" items="=${lastName},=${jointLastName}" className="policyHolderColumns"  xpath="${xpath}/bothLastNames"/>

		<%-- DOBs --%>
		<c:set var="dob">
			<field:person_dob xpath="${xpath}/dob" title="policy holder's" required="true" />
		</c:set>
		<c:set var="jointDob">
			<field:person_dob xpath="${xpath}/jointDob" title="joint policy holder's" required="true" className="jointPolicyHolder"/>
		</c:set>
		<form:items_grid label="Policy Holder's Date of Birth" columns="2" items="=${dob},=${jointDob}" className="policyHolderColumns" xpath="${xpath}/bothDOB" />


		<div class="anyoneOlder">

			<hr/>

			<form:row label="Will anyone older than the policy holder(s) live in the home?" id="row_${name}_anyoneOlder">
				<field:array_radio
					items="Y=Yes,N=No"
					xpath="${xpath}/anyoneOlder"
					className="pretty_buttons"
					title="if anyone is older than the policy holder at the home"
					required="true" />
			</form:row>
		</div>

		<div class="oldestPersonDob">
			<form:row label="Date of birth of oldest person living in the home" id="row_${name}_oldestPersonDob">
				<field:person_dob
					xpath="${xpath}/oldestPersonDob"
					titleSuffix="of the oldest person living at the home"
					required="true" />
			</form:row>
		</div>

		<div class="over55">
			<form:row label="Is any person living in the home over 55 and retired?" id="row_${name}_over55" helpId="516">
				<field:array_radio
					items="Y=Yes,N=No"
					xpath="${xpath}/over55"
					className="pretty_buttons"
					title="whether there is anyone over 55 and retired living at the home"
					required="true" />
			</form:row>
		</div>

		<hr/>

		<form:row label="Email Address">
			<field:contact_email
				xpath="${xpath}/email"
				required="false"
				title="the policy holder's email address"
				/>
				<%--helptext="To send you a copy of your quote"  --%>
		</form:row>

		<form:row label="OK to email">
			<field:array_radio
				xpath="${xpath}/marketing"
				required="true"
				items="Y=Yes,N=No"
				className="pretty_buttons"
				id="marketing"
				title="if you would like to be informed via email of news and other offers" />
		</form:row>

		<form:row label="Best contact number" helpId="524">
			<field:contact_telno
				xpath="${xpath}/phone"
				required="false"
				title="best number for the insurance provider to contact you on (You will only be contacted by phone if you answer 'Yes' to the 'OK to call' question on this screen)"/>
		</form:row>

		<form:row label="OK to call">
			<field:array_radio
				xpath="${xpath}/oktocall"
				required="true"
				items="Y=Yes,N=No"
				className="pretty_buttons"
				id="oktocall"
				title="if it's OK to call the policy holder regarding the lowest price quote" />
		</form:row>

		<%-- Mandatory agreement to privacy policy --%>
		<form:privacy_optin vertical="home" />

		<core:clear />
	</form:fieldset>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var PolicyHolder = new Object();
	PolicyHolder = {
		init: function(){

			$("#marketing").append("<span id='emailOfferText'>I agree to receive news &amp; offer emails from Compare the Market &amp; the insurance provider that presents the lowest price.</span>");
			$("#oktocall").append("<span id='oktocallText'>I give permission for the insurance provider that presents the lowest price to call me within the next 2 business days to discuss my home &amp; contents insurance needs.</span>");

			$('input[name=${name}_anyoneOlder]').on('change', function(){
				PolicyHolder.toggleOldestPerson();
			});

			PolicyHolder.toggleJointPolicyHolder();


			$("#${name}_dob, #${name}_jointDob, #${name}_oldestPersonDob").on('change', function(){
				PolicyHolder.toggleOldestPerson();
				PolicyHolder.toggleOver55();
			});

			PolicyHolder.togglePolicyHolderFields();
			PolicyHolder.toggleOldestPerson();
			PolicyHolder.toggleOver55();

		},
		toggleJointPolicyHolder: function(){
			$(".toggleJointPolicyHolder").on("click", function(){
				if ( $(".jointPolicyHolder").is(":visible") ){
					$(".toggleJointPolicyHolder span").text("Add Joint Policy Holder");
					$(".toggleJointPolicyHolderIcon").css("backgroundPosition", "0 -192px");
				} else {
					$(".toggleJointPolicyHolder span").text("Remove Joint Policy Holder");
					$(".toggleJointPolicyHolderIcon").css("backgroundPosition", "-16px -192px");
				}
				$(".jointPolicyHolder").slideToggle(400, function(){
					PolicyHolder.toggleOver55();
				});
			});
			if ($("#${name}_jointFirstName").val() != "" || $("#${name}_jointLastName").val() != "" || $("#${name}_jointDob").val() != "" || $("#${name}_jointDob").val() != "") {
				$(".toggleJointPolicyHolder").click();
			}
		},

		togglePolicyHolderFields: function(){

			if(PropertyOccupancy.principalResidence == 'Y'){

				$('.anyoneOlder').slideDown();
				PolicyHolder.toggleOldestPerson();
				PolicyHolder.toggleOver55();

			} else {

				$('.anyoneOlder').slideUp();
				$('.over55').slideUp();
				$('.oldestPersonDob').slideUp();

			}

		},

		toggleOldestPerson: function(){

			if($('input[name=${name}_anyoneOlder]:checked').val() == 'Y' && PropertyOccupancy.principalResidence == 'Y'){
				$('.oldestPersonDob').slideDown();
			} else {
				$('.oldestPersonDob').slideUp();
			}

		},

		toggleOver55: function(){

			var dateFormat = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;

			var dob = $("#${name}_dob");
			var jointDob = $("#${name}_jointDob");
			var oldestPersonDob = $("#${name}_oldestPersonDob");

			if(PropertyOccupancy.principalResidence == 'Y' &&
				(
					( dob.val().match(dateFormat) && dobHandler.getAge( dob.val() ) >= 55 ) ||
					( jointDob.is(":visible") && jointDob.val().match(dateFormat) && dobHandler.getAge( jointDob.val() ) >= 55 ) ||
					( oldestPersonDob.is(":visible") && oldestPersonDob.val().match(dateFormat) && dobHandler.getAge( oldestPersonDob.val() ) >= 55 )
				)
			) {
				$('.over55').slideDown();
			} else {
				$('.over55').slideUp();
			}

		}
	}

	$.validator.addMethod("contactNumberRequired",
		function(value, element, param) {

			if( $("input[name=${name}_oktocall]:checked").val() == 'Y' &&  $(element).val() == ''){
				return false;
			}
			return true;

		},
		"Custom message"
	);

	$.validator.addMethod("okToCallRequired",
		function(value, element, param) {

			if($("#${name}_phone").val() != "" && $("input[name=${name}_oktocall]:checked").length != 1){
				return false;
			}
			return true;

		},
		"Custom message"
	);

	$.validator.addMethod("oldestPersonOlderThanPolicyHolders",
		function(value, element, param) {

			var dob = $("#${name}_dob").val().split("/").reverse().join("");
			var oldestPersonDob = $("#${name}_oldestPersonDob").val().split("/").reverse().join("");

			var jointDobVis = $("#${name}_jointDob");
			if (jointDobVis.is(":visible")){
				var jointDob = $("#${name}_jointDob").val().split("/").reverse().join("");
			}

			if( oldestPersonDob > dob || (jointDobVis.is(":visible") && oldestPersonDob > jointDob)){
				return false;
			}
			return true;

		},
		"Custom message"
	);

	$.validator.addMethod("emailRequired",
		function(value, element, param) {

			var emailRequired = $('#home_policyHolder_marketing_Y').is(':checked');
			var email = $('#home_policyHolder_email').val();

			if( emailRequired && email == ""){
				return false;
			}
			return true;

		},
		"Custom message"
	);

</go:script>

<go:script marker="onready">
	PolicyHolder.init();
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}_phoneinput" rule="contactNumberRequired" parm="true" message="Please enter the best contact number to call you or select \\\"No\\\" to the question \\\"OK to call\\\"" />
<go:validate selector="${name}_oktocall" rule="okToCallRequired" parm="true" message="Please choose whether it's OK to call the policy holder regarding the lowest price quote" />
<go:validate selector="${name}_oldestPersonDob" rule="oldestPersonOlderThanPolicyHolders" parm="true" message="The date of birth of the oldest person living at the home has to be prior to the policy holder(s)'s date of birth." />
<go:validate selector="${name}_email" rule="emailRequired" parm="true" message="Please enter the policy holder's email address" />