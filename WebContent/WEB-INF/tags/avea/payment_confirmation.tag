<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:clear/>

<form:fieldset legend="">

	<c:if test="${param.prdId != null && param.prdId == 'aubn'}">
		<form:row label="Thank you for purchasing your AutObarn insurance policy." className="widest_label"></form:row>
	</c:if>
	
	<c:if test="${param.prdId != null && param.prdId == 'crsr'}">
		<form:row label="Thank you for purchasing your Carsure insurance policy." className="widest_label"></form:row>
	</c:if>
	
	<form:row label="Details of your payment and policy are below." className="widest_label"></form:row>
	
</form:fieldset>


<form:fieldset legend="Payment Details">

	<form:row label="Your payment details are below" className="widest_label"></form:row>
	<form:row label="<b>Policy Summary</b>" className="w300_label">
	
	</form:row>
	<form:row label="Policy Reference Number" className="w300_label">
		<strong id="final_policynumber"></strong>
	</form:row>
	<form:row label=" " className="w300_label">
		<strong>COST AU$</strong>
	</form:row>
	<form:row label="Premium" className="w300_label">
		<strong class="avea_quote_payed">$</strong>
	</form:row>
	<form:row label="<b>Total Payable</b>" className="w300_label">
		<strong class="avea_quote_payed">$</strong>
	</form:row>

	
	<core:clear />
	<div class="bot_left_note">*Where applicable the price includes GST, Fire Services Levy, Stamp Duty and instalment fees.<core:clear /></div>

	
	<div class="bot_right_note">Your payment will be taken within 2 business days</div>

	<core:clear />
	
</form:fieldset>


<form:fieldset legend="Policy Information">

	<c:if test="${param.prdId != null && param.prdId == 'aubn'}">
		<form:row label="You are now the holder of an AutObarn Comprehensive Motor Policy. A copy of your policy will be emailed to the address you provided but if you wish to view it now, please click on the link below." className="widest_label"></form:row>
		<form:row label="<div id='final_policylink'><a href='javascript:;'>Your Policy Schedule</a></div>" className="widest_label"></form:row>
		<form:row label="Should you not receive your email or if you have any questions, please contact AutObarn directly on 1800 999 977 between 9am and 5pm weekdays AEDT or email AutObarn at <a href='mailto:enquiries@fastrcar.com.au'>enquiries@fastrcar.com.au</a> and quote your policy reference number." className="widest_label"></form:row>
	</c:if>
	
	<c:if test="${param.prdId != null && param.prdId == 'crsr'}">
		<form:row label="You are now the holder of a carsure.com.au Comprehensive Motor Policy. A copy of your policy will be emailed to the address you provided but if you wish to view it now, please click on the link below." className="widest_label"></form:row>
		<form:row label="<div id='final_policylink'><a href='javascript:;'>Your Policy Schedule</a></div>" className="widest_label"></form:row>
		<form:row label="Should you not receive your email or if you have any questions, please contact CarSure directly on 1800 280 557 between 9am and 5pm weekdays AEDT or email Car Sure at <a href='mailto:enquiries@fastrcar.com.au'>enquiries@fastrcar.com.au</a> and quote your policy reference number." className="widest_label"></form:row>
	</c:if>
	<core:clear />
	
</form:fieldset>


<core:clear />


<%-- CSS STYLES --%>
<go:style marker="css-head">
	.fb_title{margin-bottom:5px;color:#0554DF;}
	.fb_cc_icon{
		background-image:url(/cc/common/images/facebook_cc_icon.png); 
		background-repeat:no-repeat; 
		width:80px; 
		height:80px;
		margin-right:10px;
	}
	.mt2{margin-top:2px;}
	.mt4{margin-top:4px;}
	.bot_right_note{
		float:right;
		text-align:right;
		margin:-4px 5px 2px 0;
		font-size:10px;
		bottom:0;
	}
	.bot_left_note{
		float:left;
		text-align:left;
		margin:-4px 5px 2px 20px;
		font-size:10px;
		bottom:0;
	}
	.widest_label a{color:#f60;}
</go:style>


<%-- JAVASCRIPT ONREADY --%>
<go:script marker="js-head">
	(function(d, s, id) {
		  var js, fjs = d.getElementsByTagName(s)[0];
		  if (d.getElementById(id)) return;
		  js = d.createElement(s); js.id = id;
		  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
		  fjs.parentNode.insertBefore(js, fjs);
		}(document, 'script', 'facebook-jssdk'));
</go:script>







