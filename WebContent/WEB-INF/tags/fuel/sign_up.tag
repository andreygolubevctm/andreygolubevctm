<%@ tag description="Fuel user sign-up for alerts and promotional"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<security:populateDataFromParams rootPath="fuel" delete="false" />

<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div class="head">
	<h3>Sign Up Now!</h3>
	<p></p>
</div>
<div class="body">
	<form:row label="First Name*">
		<field:input xpath="${xpath}/signup/name/first" title="First Name" className="required validate" required="false" />
	</form:row>
	<form:row label="Last Name*">
		<field:input xpath="${xpath}/signup/name/last" title="Last Name" className="required validate" required="false" />
	</form:row>
	<form:row label="Your email address*">
		<field:input xpath="${xpath}/signup/email" title="Your email address" className="required email validate" required="false" />
	</form:row>
	<div class="terms">
		<field:checkbox xpath="${xpath}/signup/terms" label="true" value="Y" title="I would like to receive news and offers from Compare the Market*" className="required validate" required="false" />
	</div>

	<%-- Mandatory agreement to privacy policy --%>
	<form:privacy_optin vertical="fuel" />

	<p class="link">
		<ui:button classNames="fuel-sign-up" theme="green">Sign Up Now</ui:button>
	</p>
	<p class="caption">* Mandatory Field</p>
</div>

<%-- JQUERY UI --%>
<go:script marker="onready">
	$('a.fuel-sign-up').click(function(){

		if( $('#quickForm').find('input').valid() ) {

			<%-- If for is valid submit the sign-up form via AJAX --%>
			var ajaxFill = function(){

				$.ajax({
				async: false,
				timeout: 30000,
				url: "ajax/write/fuel_signup.jsp",
				dataType: "xml",
				method: "post",
				async: false,
				data: $("#quickForm").serialize(),

				success: function(data){
						//check for errors and send result message
						if ( ($(data).find("resultcode").val() > 0) || ($(data).find("resultcode").length == 0) ) {
							$('#quickForm .head p').html('<span class="error">There was an error submitting the form, please try again.</span>');
						} else {
							//omnitureReporting(50);
							//replace the function with a message completed!!!
							$('#quickForm .head p').html('<strong>Thank you for registering your details with us</strong><br /><br />Sign up successful');
							$('#quickForm .body').html('');
						}
				},
				error: function(){
						$('#quickForm .head p').html('<span class="error">There was a server error when submitting the form, please try again.</span>');
				}
				});

			};

			ajaxFill();

		}

	});

	$('#${name}_signup_email').on('blur', function() { $(this).val($.trim($(this).val())); });
</go:script>

<go:style marker="css-head">
	#quickForm .fieldrow {
		font-size:11px;
		width:100%;
		position:relative;
	}
	#quickForm .fieldrow_value {
		margin:0;
	}
	#quickForm .fieldrow_label {
		width:60px;
		font-size:11px;
	}
	#quickForm .fieldrow_value input {
		width:95px;
	}
	#quickForm .body, #quickForm input  {
		font-size:10px;
	}
	#quickForm .terms {
		margin:10px 5px 0px 5px;
		width:111px;
		padding-left:65px;
		padding-right:0;
		position:relative;
	}
	#quickForm .terms label {
		line-height:130%;
	}
	#quickForm .terms input {
		display:inline;
		margin-left:-25px;
		position:relative;
		float:left;
	}
	a.fuel-sign-up{
		width: 170px;
		padding: 8px 0;
		margin: 10px;
		font-size: 12px;
	}

</go:style>


<%-- VALIDATION --%>


