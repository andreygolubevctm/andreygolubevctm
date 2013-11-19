<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
	
	
	<form:fieldset legend="Buy Online">
	
		<c:if test="${param.prdId != null && param.prdId == 'aubn'}">
			<b>&nbsp;&nbsp;Complete the requested details below and buy your AutObarn comprehensive market value insurance online today.</b>
		</c:if>
		
		<c:if test="${param.prdId != null && param.prdId == 'crsr'}">
			<b>&nbsp;&nbsp;Complete the requested details below and buy your carsure.com.au comprehensive market value insurance online today.</b>
		</c:if>
		
		<c:if test="${param.prdId == null}">
			<form:row className="widest_label" label="<b>&nbsp;&nbsp;Complete the requested details below and buy your comprehensive market value insurance online today.</b>"></form:row>
		</c:if>
		
	</form:fieldset>
	
	
	<form:fieldset legend="Policy Summary">
	
		<strong>Please select your payment option</strong>
		<form:row id="payment_type" className="no_label fleft" label="" >
			<field:array_radio id="avea_premium_type" items="CREDITCARD=Yearly Premium Payment <span class='avea_yearly_price'></span><br />,VICTORYCC=12 Monthly Premium Payments <span class='avea_monthly_price'></span>" required="true" xpath="quote/avea/premiumType" title="Premium Payment Type" />
		</form:row>
		<core:clear />
		
		<strong>Policy Summary</strong>
		
		<div id="avea_yearly_container">
			<div class="ml20">
				Motor Policy effective from <b><span class="avea_quote_startdate"></span></b> with an excess of <b><span class="avea_quote_excess">$</span></b><br />
				<span class="font9 lh15">*Please note that your excess may have changed</span><br />
			</div>
			<form:row className="w400_label" label="Yearly Premium amount">
				<strong class="avea_quote_premium">$</strong>
			</form:row>

			<form:row className="w400_label_nmr" label="<b>Total Payable</b>">
				<strong class="avea_quote_payable" id="avea_yearly_quote_payable">**$</strong>
			</form:row>
		</div>
		
		<div id="avea_monthly_container" class="hidden">
			<div class="ml20">
				Motor Policy effective from <b><span class="avea_quote_startdate"></span></b> with an excess of <b><span class="avea_quote_excess">$</span></b><br />
				<span class="font9 lh15">*Please note that your excess may have changed</span><br />
			</div>
			<form:row className="w400_label" label="Monthly Premium amount">
				<strong class="avea_monthly_premium">$</strong>
			</form:row>

			<form:row className="w400_label_nmr" label="<b>Total Payable</b>">
				<strong class="avea_quote_payable" id="avea_monthly_quote_payable">*$</strong>
			</form:row>
		</div>
		
		<core:clear />
		<div class="ml20 font10">**Where applicable the price includes GST, Fire Services Levy, Stamp Duty and instalment fees.</div>
		
		<core:clear />
	</form:fieldset>

	<form:fieldset legend="Contact Details">
		<strong>Please enter the contact details for the policy holder</strong>
			
			<form:row label="Name" className="wide_label fleft" >
				<div class="policyHolderName">
					<div id="quote_avea_policyholder_title" class="fleft ml20"></div> 
					<div id="quote_avea_policyholder_firstName" class="fleft"></div> 
					<div id="quote_avea_policyholder_lastName" class="fleft"></div>
					<core:clear />
				</div>
			</form:row>
			
			<group:address xpath="quote/avea/riskAddress" type="R" />
			
			<form:row label="Phone (mobile preferred)" className="wide_label fleft" >
				<field:array_select items="=,02=02,03=03,07=07,08=08" 
									xpath="quote/avea/policyholder/areaCode" 
									title="Phone Area Code"
									required="false" />
				<field:input xpath="quote/avea/policyholder/phone" title="Phone" required="true" /><span class="font9">(Leave area code blank if a mobile number)</span>
			</form:row>
			
			<form:row label="Email" className="wide_label fleft" >
				<field:input xpath="quote/avea/policyholder/email" title="Email" required="true" />
			</form:row>
			
			<core:clear />
			<div class="ml20 font11">
				This is the email address we will be sending your policy documentation to.
			</div>
			
		<core:clear />
	</form:fieldset>


	<form:fieldset legend="Payment Information">

		<form:row label="Credit Card Type" className="w200_label">
			<field:import_select xpath="quote/avea/payment/cardType" url="/WEB-INF/option_data/creditcard_type.html"
				title="the credit card type" className="creditCard"
				required="false" omitPleaseChoose="Y"/>
				<div id="paymentOptionsLogos"></div>
		</form:row>
		
		<form:row label="Name on Card" className="w200_label">
			<field:name_on_card xpath="quote/avea/payment/cardName" title="the name on the card" required="true" className="creditCard"/>
		</form:row>
		
		<form:row label="Credit Card Number" className="w200_label">
			<field:creditcard_number xpath="quote/avea/payment/cardNumber" title="credit card number" required="true" className="creditCard"/>
		</form:row>	
		
		<form:row label="Card Expiry Date" className="w200_label">
			<field:creditcard_expiry xpath="quote/avea/payment" required="true" className="creditCard" title="Card Expiry Date"/>
		</form:row>
		
		<div class="mclogo">	
			<a target="_blank" href="https://www.mcafeesecure.com/RatingVerify?ref=ecommerce.disconline.com.au&lang=AU">
			<img border="0" src="https://images.scanalert.com/meter/ecommerce.disconline.com.au/13.gif?lang=AU" alt="McAfee Secure sites help keep you safe from identity theft, credit card fraud, spyware, spam, viruses and online scams" oncontextmenu="alert('Copying Prohibited by Law - McAfee Secure is a Trademark of McAfee, Inc.'); return false;">
			</a>
		</div>
		
		<div class="verilogo">
			<a href="https://seal.verisign.com/splash?form_file=fdf/splash.fdf&dn=ECOMMERCE.DISCONLINE.COM.AU&lang=en" target="_blank">
			<img src="common/images/veriseal.gif" border="0" width="70" height="40">
			</a>
		</div>
		
	</form:fieldset>


	<div class="privacy_info">
		We take the privacy and security of your personal information very seriously and employ the following security measures: our online quote and application processes are presented via a secure server using a VeriSign SSL Certificate and our website, online quote and application process is scanned by McAfee Secure.
		<core:clear/>
	</div>


<%-- CSS --%>
<go:style marker="css-head">

	.avea_monthly_price{font-weight:bold;}
	
	.privacy_info{
		width:330px;
		padding:10px;
		margin:0 auto 10px auto;
		font-size:10px;
	}
	
    #paymentOptions, #internetSecurity {
	    display: inline-block;
	    width: 700px;
	    line-height: 16px;   
		zoom:1;
		*display:inline;		    
    }
    #paymentOptionsLogos {
    	background: transparent url("common/images/paymentMethodsLrg.gif") no-repeat;
		width:64px;
		height:141px;
		left: 780px;
		display: inline-block;
		zoom:1;
		*display:inline;	
    }
    #securityLogos {
		width:64px;
		height:85px;
		left: 780px;
		display: inline-block;
		zoom:1;
		*display:inline;			
    }
	#SARSPY {
		display: none;
		height: auto;
	}
	#directDebitRow, #bankRow, #branchRow, #taxCreditRow {
		display: none;
	}
	#bank, #branch {
		padding-top: 6px;
		height: 18px;		
	}
	.directDebitAgreement {
	    left: 407px;
	    position: relative;
	    width: 408px;
	    font: arial;
	    font-size: 11px;
	    font-weight: bold;
	    vertical-align: top;
	    padding: 2px 0px 4px 0px;
	}
	.directDebitAgreementDocument {
		position: relative;
		font: arial;
	    font-size: 11px;
	    font-weight: bold;
	}
	#avea_premium_type label{font-size:13px; line-height:30px;}
	#avea_premium_type{margin-left:13px; margin-bottom:8px;}
    #paymentOptionsLogos {
    	background: transparent url("common/images/paymentMethods.gif") no-repeat;
		width:75px;
		height:24px;
		left: 780px;
		float:left;
		margin-left:5px;
		margin-top:-1px;
    }
    .creditCard{float:left;}
   #quote_avea_payment_cardName{text-transform:uppercase;}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	

	$(".payment_method").change(function(){

		if ($(':input[name=service_request_paymentMethod]').val()=="C"){
			$("#creditCardRow").show();
			$("#directDebitRow").hide();
		} else {
			$("#directDebitRow, #creditCardRow").toggle();
		} 
		
		<%-- Validation Control --%>
		if ($("#creditCardRow").is(':visible')) {
			$('.creditCard').each(function() {
        		$(this).rules("add", {required: true});
    		});
			$('.directDebit').each(function() {
        		$(this).rules("remove", "required");
    		});
		} else {
			$('.directDebit').each(function(index) {
        		$(this).rules("add", {required: true});
    		});
			$('.creditCard').each(function() {
        		$(this).rules("remove");
    		});
		}
		
	});

	
	<%-- Yearly / Monthly Toggle  --%>
	$('#quote_avea_premiumType_CreditCardInFull, #quote_avea_premiumType_MonthlyCreditCard').change(function(){
		if( $('#quote_avea_premiumType_CreditCardInFull').is(':checked') ){
			$('#avea_yearly_container').show();
			$('#avea_monthly_container').hide();
			$('.avea_quote_payed').html('*$' + yearly_total );
		}else{
			$('#avea_monthly_container').show();
			$('#avea_yearly_container').hide();
			$('.avea_quote_payed').html('*$' + monthly_total );
		}
	});
	
	
	$(".gst").click(function(){	
		if ($(".gst :checked").val()=="Y"){
			$(':input[name=service_request_taxCredit]').rules("add", {required: true});		
			$("#taxCreditRow").show();	
		} else {
			$(':input[name=service_request_taxCredit]').rules("remove", "required");
			$("#taxCreditRow").hide();
		}
	});
	
	
	$(".bsb_number").keyup(function(){		
		if ($(".bsb_number").val().length==6) {	
			var dat = $("#directDebitRow *").serialize();
			PageProcessing.SARSPY_BSB(dat);	
		} else {
			$("#bankRow, #branchRow").hide();
		} 		 		
	});
</go:script>

