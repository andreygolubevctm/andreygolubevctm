<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>



<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="verticalFeatures" value="home" />
<c:set var="xpath" value="${verticalFeatures}lmi" />
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<go:style marker="css-head">

	.head{
		border-bottom:solid 1px #ccc;
		padding-bottom:3px;
		margin-bottom:10px;}
	.head h3{
		color:#485f94;}

	.body{

		width:900px;
		padding-top:10px;}

	.customInput{
		height:16px;
		width:200px;}

	.lightGreyCheckbox{
		margin-top:3px;
	}

	.left{
		width:400px;}

	#${name}_location{
		width:100px;
	}

	.errorFill{
		background-image:none;
	}
	#slideErrorContainer{
		background-color:#FBFBFB;
		border: solid 1px #F4A97F;
		border-radius:10px;
		padding-right:20px;
		width:400px;

	}

	.bubble_row{
		margin-bottom:30px;
		margin-top:10px;
		position:relative;}

	.bubble_row .speechbubble{
		float:left;}

	.body div.fieldrow_label{
		color:#7F807A;}

	.terms label{
		position:relative;
		top:-3px;
		color:#7F807A;
	}
	.buttons{
		padding:10px 10px;}

	.btn.grey {
		background-color: #7F807A;
		color: #FFFFFF;
		margin-right:15px;
}

​

</go:style>

<%-- Bubbles --%>
<div class="bubble_row">


	<form:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="2" overRidePosition="true" />

	<div class="cleardiv"></div>

</div>

<%-- HTML --%>

<div class="body">
	<div class="head">
		<h3>Your Details</h3>
		<p></p>
	</div>
	<form:form action="javascript:void(0)" method="POST" id="signUpForm" name="frmSignUp">
			<div class="left">
				<form:row label="First Name">
					<field:input xpath="competition/firstname" title="First Name" className="required customInput" required="true" tabIndex="1"   />
				</form:row>

				<form:row label="Email Address">
					<field:input xpath="competition/email" title="Email Address" className="required email customInput" required="true"  tabIndex="3" />
				</form:row>

				<form:row label="Suburb/Postcode">
						<field:suburb_postcode xpath="competition/location" title="Postcode/Suburb" id=""
						required="true"    />
				</form:row>
			</div>
			<div class="right">
				<form:row label="Last Name">
					<field:input xpath="competition/lastname" title="Last Name"  className="required customInput" required="true" tabIndex="2" />
				</form:row>
				<form:row label="Confirm Email Address">
					<field:input xpath="competition/Cemail" title="Confirm Email Address" className="required email customInput" required="true" tabIndex="5" />
				</form:row>
				<form:row label="When is your Home and contents policy up for renewal?">
					<field:basic_date xpath="competition/policyRenewalDate" title="When is your Home and contents policy up for renewal?" className="customInput" required="false"  />
				</form:row>
			</div>
			<div class="cleardiv"></div>
			<div class="terms">
				<field:checkbox xpath="competition/terms" label="false" value="Y" title=" I consent to comparethemarket.com.au sending me communications regarding Home and Contents Insurance. " className="required lightGreyCheckbox" required="true"/>
			</div>

			<div class="buttons">
				<a class="btn grey arrow-left" id="competition_cancel" href="javascript:void(0)" tabindex="10">Cancel</a>
				<a class="btn orange arrow-right" id="competition_submit" href="javascript:void(0)" tabindex="9">Submit</a>
			</div>

		</form:form>
</div>




<%-- JQUERY UI --%>
<go:script marker="jquery-ui">


var homeEmailSignUp = new Object();
homeEmailSignUp = {

	init : function() {
			homeEmailSignUp.addListeners();
			$('#competition_location').attr('tabIndex','6');
			$('#competition_policyRenewalDate').attr('tabIndex','7');
			$('#competition_terms').attr('tabIndex','8');
			$("#slideErrorContainer div.error-panel-top, #slideErrorContainer div.error-panel-middle,#slideErrorContainer div.error-panel-bottom").addClass('errorFill');
			$("#slideErrorContainer div.error-panel-middle").css({'min-height':'50px'});

			$('#slideErrorContainer').css({

					width:'500px',
					position:'absolute',
					top:'0px',
					left:'180px'
			});

	},
	addListeners: function() {

		$('#competition_submit').click(function(){
			if(!$('#mainform').valid() ) {
					if($('#slideErrorContainer').css('display')=='block'){
						$('.body').css('margin-top',$('#slideErrorContainer').height() + 5 +'px').slideDown();
					}
					else{
						$('.body').css('margin-top','2px');
					}
			}else{
				homeEmailSignUp.submitForm();
			}
		});

		$('#competition_firstname').blur(function(){
			if($.trim($(this).val()).length > 0 ){
				$('.insert h1').html('Hi ' + $.trim($(this).val()) +',');
			}else{
				$('.insert h1').html('Hi,');
			}
		});


		$('#competition_cancel').click(function(){
			window.location.href='home_brands.jsp';
		});

		$(":input").blur(function() {
			if($('#slideErrorContainer').css('display') =='block'){
				$('.body').css('margin-top',$('#slideErrorContainer').height());
			}else{
				$('.body').css('margin-top','0px');
			}
		});

	},

	submitForm: function(){
				var dat = homeEmailSignUp.getFormData();

				$.ajax({
						url: "ajax/write/home_brands_signup.jsp",
						data: dat,
						type: "POST",
						async: true,
						dataType: "json",
						timeout:60000,
						cache: false,
						beforeSend : function(xhr,setting) {
							var url = setting.url;
							var label = "uncache",
							url = url.replace("?_=","?" + label + "=");
							url = url.replace("&_=","&" + label + "=");
							setting.url = url;
						},
						success: function(json){
							homeEmailSignUp.showSuccess(json);
							return false;
						},
						error: function(data){
							homeEmailSignUp.showFailure(data.responseText);
							return false;
						}
					});

	},

	getFormData: function(){

		return {
			firstname	: $.trim($('#competition_firstname').val()),
			lastname	: $.trim($('#competition_lastname').val()),
			email		: $.trim($('#competition_email').val()),
			location	: $.trim($('#competition_location').val()),
			policyRenewalDate: $.trim($('#competition_policyRenewalDate').val()),
			terms		: $.trim($('input[name=terms]:checked').val())

		};


	},



	resetForm: function(){

			$('#competition_firstname').val('');
			$('#competition_lastname').val('');
			$('#competition_email').val('');
			$('#competition_Cemail').val('');
			$('#competition_location').val('');
			$('#competition_policyRenewalDate').val('');
			$('#competition_terms').prop('checked', false);

	},

	showSuccess: function(respdata) {

		//Check for errors
		if(respdata.error != ''){
			homeEmailSignUp.showFailure(respdata);
			return;
		}

		window.location.href='confirmation.jsp?vertical=${xpath}';
	},
	showFailure: function(errors) {

		$('#slideErrorContainer div.error-panel-middle .error-list ul').empty().append('<li><label class="error">'+ errors.error+'</label></li>');
		$('#slideErrorContainer').show();
	},

	setTestValues: function(){

			$('#competition_firstname').val('Joe');
			$('#competition_lastname').val('Bloggs');
			$('#competition_email').val('e@fake.org');
			$('#competition_Cemail').val('e@fake.org');
			$('#competition_location').val('Brisbane Anne Street 4000 QLD');
			$('#competition_policyRenewalDate').val('12/02/2014');
			$('#competition_terms').prop('checked', true);

	},


}

//Custom Validation
	$.validator.addMethod("matchEmails",
		function(value, element) {

			if($('#competition_Cemail').val() === $('#competition_email').val()){
				$('.email').removeClass("error");
				$('.email').parents(".content").removeClass("errorGroup");
				return true;
			}

			$('.email').addClass("error");
			$('.email').parents(".content").addClass("errorGroup");

			return false;
		},
		"Email addresses do not match."
	);


homeEmailSignUp.init();
</go:script>

<go:validate selector="competition_Cemail" rule="matchEmails" parm="true" message="Email addresses do not match." />

