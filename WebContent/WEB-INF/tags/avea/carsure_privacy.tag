<%@ tag description="Carsure Terms Popup"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
 
<%-- CSS --%>
<go:style marker="css-head">
	#carsureprivacy-popup {
		width:620px;
		height:auto;
		z-index:2001;
		display:none;
		left:50%;
	} 
	#carsureprivacy-popup h5 {
	    background: url("common/images/dialog/header_620.gif") no-repeat scroll 0 0 transparent;
	    display: block;
	    font-size: 17px;
	    font-weight: bold;
	    height: 39px;
	    padding-left: 13px;
	    padding-top: 10px;
	    width: 620px;
	    margin-bottom: -10px;
	    color: white;
	}
	#carsureprivacy-popup h3 {
		margin:0px 0px 10px 0px;
		font-weight:bold;
		color:#0554DF;
	    font-size:14px;
	    font-weight:bold;
	    display:block;
	}
	#carsureprivacy-popup h4 {font-size:14px;color:#777;}
	#carsureprivacy-popup ul {
		margin:10px 0px 12px 22px;
	    font-size:12px;
	}
	#carsureprivacy-popup li {
		font-size:12px;
		line-height:18px;
		margin-bottom:6px;
   		list-style:disc outside;
	}
	#carsureprivacy-popup .buttons {
		background: transparent url("common/images/dialog/buttonpane_620.gif") no-repeat;
		width:620px;
		height:47px;
		display:block;
		padding-top:10px;
	}
	#carsureprivacy-popup strong {
		line-height:21px;
	}
	#carsureprivacy-popup .ok-button {
		background: transparent url("common/images/dialog/ok.gif") no-repeat;
		width:51px;
		height:36px;
		margin: 0 auto;
	}
	#carsureprivacy-popup .ok-button:hover {
		background: transparent url("common/images/dialog/ok-on.gif") no-repeat;
	}
/*	#carsureprivacy-popup .close-button {
	    background: url("common/images/dialog/close.gif") no-repeat scroll 0 0 transparent;
	    height: 12px;
	    left: 824px;
	    position: relative;
	    top: 25px;
	    width: 12px;
	    display: inline-block;
	}*/
	#carsureprivacy-popup .back-button {
	    background: url("common/images/button-prev.png") no-repeat scroll 0 0 transparent;
	    height: 37px;
	    position: relative;
	    width: 140px;
		margin-top:10px;
		margin-right:5px;
	    float:right;
	}
	#carsureprivacy-popup .back-button:hover {
	    background: url("common/images/button-prev-on.png") no-repeat scroll 0 0 transparent;
	}
	#carsureprivacy-popup .content {
		background: white url("common/images/dialog/content_620.gif") repeat-y;
		padding:20px;
		overflow:auto;
		height:350px; 
	}
	#carsureprivacy-popup .content p {
	    margin-bottom: 9px;
	    font-size: 12px;
	    margin: 10px 10px;
	    line-height:17px;
	}
	#carsureprivacy-popup, #carsureprivacy-popup h5, #carsureprivacy-popup .buttons{width:620px;}
	
	#carsureprivacy-popup h5{
		background: url("common/images/dialog/header_620.gif") no-repeat scroll 0 0 transparent;
	}
	#carsureprivacy-popup .content{
		background: url("common/images/dialog/content_620.gif") repeat-y scroll 0 0 white;
	}
	#carsureprivacy-popup .buttons{
		background: url("common/images/dialog/buttonpane_620.gif") no-repeat scroll 0 0 transparent;
	}
	#carsureprivacy-popup .close-button{
    	left: 590px;
    }

</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var CarsureprivacyPopup = new Object();
	CarsureprivacyPopup = {	
		
		show: function(){
			
			var carsureprivacy_template = $("#carsureprivacy-template").html();
			$("#carsureprivacy-popup .content").html($(parseTemplate(carsureprivacy_template, '')));
			
			var overlay = $("<div>").attr("id","carsureprivacy-overlay")
									.addClass("ui-widget-overlay")
									.css({	"height":$(document).height() + "px", 
											"width":$(document).width()+"px"
										});
			$("body").append(overlay);
			$(overlay).fadeIn("fast");
			// Show the popup
			$("#carsureprivacy-popup").center().show("slide",{"direction":"down"},300);
			
		}, 
		hide : function(){
			$("#carsureprivacy-popup").hide("slide",{"direction":"down"},300);
			$("#carsureprivacy-overlay").remove();
		}, 
		init : function(){
			$("#carsureprivacy-popup").hide();
		}
	}


	
</go:script>
<go:script marker="jquery-ui">
	$("#carsureprivacy-popup .ok-button, #carsureprivacy-popup .close-button").click(function(){
		CarsureprivacyPopup.hide();
	});
</go:script>
<go:script marker="onready">
	CarsureprivacyPopup.init();
</go:script>
<%-- HTML --%>
<div id="carsureprivacy-popup">
	<a href="javascript:void(0);" class="close-button"></a>
	
	<h5>Carsure Privacy Policy</h5>
	
	<div class="content"></div>

	<div class="buttons">
		<a class="ok-button"></a>
	</div>
</div>

<%-- POPUP ROW TEMPLATE --%>
<core:js_template id="carsureprivacy-template">
	
	<h3>Privacy Policy</h3>
	
	<p>At Carsure Pty Ltd (ACN 142 601 705) ("we, our or us") we want to provide the best possible level of service. To achieve this we need to make the most efficient use of your personal information.</p>
	<p>However it is equally important to us that you are confident that all of your personal information entrusted to us or our agents is treated with the appropriate degree of privacy.</p>
	<p>In order to achieve these objectives, Carsure has developed this Privacy Policy through which we are committed to the requirements of the Privacy Act 1988 (Clth) and the National Privacy Principles.  The terms of our Privacy Policy may change from time to time. The current terms will be displayed on our website.</p>
	
	<h3>The Privacy Act</h3>
	<p>The Privacy Act 1988 regulates the way we collect, use, keep, secure and disclose personal information.</p>
	
	
	<h3>Personal Information</h3>
	<p>Personal information is any information about you that identifies you or by which your identity can be reasonably determined.</p>
	
	<h3>Sensitive Information</h3>
	<p>If personal information concerns particular topics it is regarded as sensitive information. Sensitive information can be information about your racial or ethnic origin, political opinions, membership of a political association, religious beliefs or affiliations, philosophical beliefs, membership of a professional or trade association, membership of a trade union, sexual preferences or practices, criminal record and health. Carsure only collects, uses or discloses sensitive information about you to provide its services or as is allowed by law; for example where we have received your consent to do so or the collection is necessary for the establishment, exercise or defence of a legal claim, or as required by State, Territory or Federal Government authorities.</p>
	
	<h3>Collection of Information</h3>
	<p>Collecting your personal information is essential for us to be able to conduct our business of providing our products and services.</p>
	
	<p>By collecting this information we set up and administer our various products and services, assess a claim made by you under one or more of our products, improve our products and services and identify you and protect you from unauthorised access to your information.</p>
	<p>If we do not collect and make use of this information, we will be unable to do business with you.</p>
	
	<h3>How Do We Collect Your Personal Information?</h3>
	<p>Where possible we collect your personal information directly from you. Often personal information is collected during the course of our relationship with you. Examples of personal information collection during our relationship may be when you complete an insurance application or renew an insurance policy.</p>
	<p>However, collection may also take place in a number of ways such as when you complete an insurance application or request one of our products or services over the telephone or internet. </p>
	<p>Sometimes personal information may be collected about you from other services. Examples of where we may receive personal information about you from another source and why this would happen are; a credit reference about you from a credit reporting or similar agency, in the course of assessing your application for insurance and an insurance investigation or reference service in the course of assessing your claim under a policy of insurance.</p>
	
	<p>In most cases we will require you specifically to consent to any collection, use or disclosure of your personal information by us.</p>
	
	<h3>How Do We Use Your Personal Information?</h3>
	<p>We use the information that we collect so that we can conduct our business of providing insurance related products and services and to administer and enhance the relationship we have with you. To enable us to do this we may share your personal information with related companies or with organisations that assist us to provide these products and services to you.</p>
	
	<h3>Privacy Online</h3>
	<p>Depending on the way in which you access our website we will collect personal information. If you provide your email details we may use this information to respond to your requests or if you are purchasing insurance online we may send you specific information regarding your insurance product.</p>
	<p>We may request your email address for the inclusion into a mailing list. If you choose to submit your email address an option to remove this address from our database will be offered to you via email correspondence. All opt-in emails sent to the mailing list will comply with the Spam Act 2003 (Clth).</p>
	
	
	<h3>Use of Cookies</h3>
	<p>We may use data collection devices such as 'cookies' in conjunction with our website. Cookies are commonly used on the internet. They are a small file placed onto a computer by a server. A cookie can later be identified by a server. We may use both 'persistent' and 'session cookies'. Any information that is collected in this way is used in an aggregated form only; that is, we do not use it to identify you as an individual.</p>
	<p>Cookies may be used for various purposes such as:</p>
	<ul>
	    <li>to provide you with better and more customised service and a more effective website;</li>
	    <li>collecting anonymous statistical information such as how many visitors our sites receive, how those visitors use the sites and were they came from; or</li>
	
	    <li>if you wish, you can configure your browser so it does not accept cookies, but this may affect the functionality of the website.</li>
	</ul>
	
	<h3>Direct Marketing</h3>
	<p>From time to time we may use your personal information to provide you with information about our extensive range of products and services.</p>
	<p>If you do not want to receive any of this information just contact us by calling 1800 280 557.</p>
	<p>We do not disclose your personal information to other parties for the purposes of allowing them to direct market their products or services to you.</p>
	
	<p>Often the law requires us to provide you with certain information about the product or service that you receive from us. You will continue to receive this type of information from us even if you have decided not to receive information about our products and services generally.</p>
	
	<h3>Do We Disclose Your Personal Information to Other Parties?</h3>
	<p>Carsure may disclose your personal information in certain circumstances.</p>
	<p>We may disclose your personal information where you have consented to our doing so. Your consent to the disclosure of your personal information may be given explicitly such as in writing or verbally or may be implied from your conduct.</p>
	<p>However, Carsure does not disclose your personal information to a party outside of Carsure, unless that party is contracted to Carsure to provide services or activities on our behalf and that party is bound by the same privacy rules we follow.</p>
	<p>Some examples of parties outside Carsure to whom we may disclose your personal information and the reason for disclosure are: Marketing Agents, Sales Agents for promotion and service; other insurers, insurance reference agencies, loss assessors, medical practitioners, investigative services or lawyers for the assessment of insurance claims or requests. We may also disclose psersonal information in circumstances where we are required or authorised to do so by law.</p>
	
	
	<h3>Ensuring Your Information is Up-to-Date</h3>
	<p>We rely on the information we hold about you to efficiently conduct our business of providing insurance products and services. For this reason, it is very important that the information we collect from you is accurate, complete and up-to-date. If your information changes please notify us so that we may update our records if we agree your personal information is inaccurate.</p>
	
	<h3>Can I Access the Information Carsure Holds About Me?</h3>
	<p>You may request access to any of the personal information we hold about you.</p>
	<p>In most cases, a summary of this information such as your name and address details, contact telephone numbers, policy numbers, policy cover and the products and services you have with us are freely available to you by calling 1800 280 557.</p>
	<p>For more detailed requests for access to information, for example, access to information held in archives, a fee may be charged to cover the cost of retrieval and the supply of this information to you.</p>
	
	<p>All requests for access to personal information will be handled as quickly as possible and we shall endeavour to process any request for access within 30 days of having received the request. Some request for access may take longer than 30 days to process depending upon the nature of the information being sought.</p>
	<p>Carsure may be required by law to retain your information for a period of time after you have ceased your relationship with us. After the required time has elapsed we attend to the secure destruction of your information.</p>
	
	<h3>Can My Request For Access to My Information Be Denied?</h3>
	<p>Carsure is not always required to provide you with access to your personal information upon your request.</p>
	<p>We may refuse you access to this information in a number of circumstances such as; where the information may relate to existing or anticipated legal proceedings with you, where denying access is required or authorised by law, or where the request for access is regarded as frivolous or vexatious.</p>
	<p>If we deny your request for access to, or refuse your request to correct your information, we will explain why.</p>
	
	
	<h3>Do I Have to Provide My Information?</h3>
	<p>It is not possible for us to do business with you and identify your insurance requirements unless we have identified you and in some cases, the law requires that you identify yourself to us.</p>
	<p>Wherever it is lawful and practicable to do so, we may offer you the opportunity to deal with us anonymously.</p>
	
	<h3>Information Accuracy</h3>
	<p>We endeavour to ensure that all personal information held by Carsure is accurate and up-to-date. If you believe your personal information is not accurate and up-to-date, please contact us.</p>
	
	<h3>Information Security</h3>
	
	<p>We may store your personal information in paper form or electronically. All reasonable precautions will be taken to ensure that your personal information is kept safe and secure and protected against unlawful use.</p>
	<p>While we endeavour to take all reasonable steps to protect personal information, we can not guarantee information sent over the internet is secure. Data security is a high priority but receiving and sending information over the internet is at the user's own risk.</p>
	
	<h3>Links</h3>
	<p>We take no responsibility and have no control over other web sites and the conduct of companies that operate these web sites. Always read the privacy and security statements before using other web sites.</p>
	
	<h3>Our Privacy Policy May Change From Time to Time</h3>
	<p>Carsure constantly reviews all its policies and procedures to keep up to date with changes in the law, technology and market practice.</p>
	
	<p>As a result we may change this Privacy Policy from time to time.</p>
	<p>This Privacy Policy was last varied on 8th December 2008.</p>
	
	<h3>Complaints in Respect to a Breach of Privacy</h3>
	<p>Carsure has established a formal Privacy Complaints Procedure to deal with any complaints lodged with us in relation to breaches of the National Privacy Principals or the Privacy Act 1988.</p>
	<p>If you believe that Carsure has not protected your personal information as set out in this Privacy Policy you may lodge a complaint with us. Complaint can be made by telephoning the number or writing to the address set out below and should be directed to the Compliance Officer, who will provide you with further information about Carsure's Privacy Complaints Procedure.</p>
	
	<h3>What if I am Not Satisfied With Carsure's Response?</h3>
	
	<p>If you are not satisfied with the result of you complaint to Carsure you can refer your complaint to the Office of the Privacy Commissioner on 1300 363 992, or visit its website <a href="http://www.privacy.gov.au">www.privacy.gov.au</a>.</p>
	
	<h3>Contact Details</h3>
	<p>If you have any questions or concerns about this Privacy Policy, the Privacy Complaints Procedure, or wish to lodge a request to access your personal information you can contact us in any of the following ways:</p>
	<p>By visiting: <a href="http://www.carsure.com.au">www.carsure.com.au</a></p>
	<p>By telephoning: 1800 280 557</p>
	
	<p>Email: <a href="mailto:enquiries@carsure.com.au">enquiries@carsure.com.au</a></p>


<core:clear/>


</core:js_template>	
