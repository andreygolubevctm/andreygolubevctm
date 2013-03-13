<%@ tag description="Duty of Disclosure"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
 
<%-- CSS --%>
<go:style marker="css-head">
	#disclosure-popup {
		width:620px;
		height:auto;
		z-index:2001;
		display:none;
		left:50%;
	} 
	#disclosure-popup h5 {
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
	#disclosure-popup h3 {
		margin:0px 0px 10px 0px;
		font-weight:bold;
		color:#0554DF;
	    font-size:14px;
	    font-weight:bold;
	    display:block;
	}
	#disclosure-popup ul {
		margin:10px 0px 12px 12px;
	    font-size:12px;
	}
	#disclosure-popup li {
		font-size:11px;
		line-height:18px;
		margin-bottom:0px;
   		list-style:disc outside;
	}
	#disclosure-popup .buttons {
		background: transparent url("common/images/dialog/buttonpane_620.gif") no-repeat;
		width:620px;
		height:47px;
		display:block;
		padding-top:10px;
	}
	#disclosure-popup strong {
		line-height:21px;
	}
	#disclosure-popup .ok-button {
		background: transparent url("common/images/dialog/ok.gif") no-repeat;
		width:51px;
		height:36px;
		margin: 0 auto;
	}
	#disclosure-popup .ok-button:hover {
		background: transparent url("common/images/dialog/ok-on.gif") no-repeat;
	}
/*	#disclosure-popup .close-button {
	    background: url("common/images/dialog/close.gif") no-repeat scroll 0 0 transparent;
	    height: 12px;
	    left: 824px;
	    position: relative;
	    top: 25px;
	    width: 12px;
	    display: inline-block;
	}*/
	#disclosure-popup .back-button {
	    background: url("common/images/button-prev.png") no-repeat scroll 0 0 transparent;
	    height: 37px;
	    position: relative;
	    width: 140px;
		margin-top:10px;
		margin-right:5px;
	    float:right;
	}
	#disclosure-popup .back-button:hover {
	    background: url("common/images/button-prev-on.png") no-repeat scroll 0 0 transparent;
	}
	#disclosure-popup .content {
		background: white url("common/images/dialog/content_620.gif") repeat-y;
		padding:20px;
		overflow:auto;
		height:350px; 
	}
	#disclosure-popup .content p {
	    margin-bottom: 9px;
	    font-size: 12px;
	    margin: 10px 10px;
	    line-height:17px;
	}
	#disclosure-popup, #guarantee-popup h5, #guarantee-popup .buttons{width:620px;}
	
	#disclosure-popup h5{
		background: url("common/images/dialog/header_620.gif") no-repeat scroll 0 0 transparent;
	}
	#disclosure-popup .content{
		background: url("common/images/dialog/content_620.gif") repeat-y scroll 0 0 white;
	}
	#disclosure-popup .buttons{
		background: url("common/images/dialog/buttonpane_620.gif") no-repeat scroll 0 0 transparent;
	}
	#disclosure-popup .close-button{
    	left: 590px;
    }

</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var DisclosurePopup = new Object();
	DisclosurePopup = {	
		
		show: function(){
			
			var overlay = $("<div>").attr("id","disclosure-overlay")
									.addClass("ui-widget-overlay")
									.css({	"height":$(document).height() + "px", 
											"width":$(document).width()+"px"
										});
			$("body").append(overlay);
			$(overlay).fadeIn("fast");
			// Show the popup
			$("#disclosure-popup").center().show("slide",{"direction":"down"},300);
					
		}, 
		hide : function(){
			$("#disclosure-popup").hide("slide",{"direction":"down"},300);
			$("#disclosure-overlay").remove();
		}, 
		init : function(){
			$("#disclosure-popup").hide();
		}
	}


	
</go:script>
<go:script marker="jquery-ui">
	$("#disclosure-popup .ok-button, #disclosure-popup .close-button").click(function(){
		DisclosurePopup.hide();
	});
</go:script>
<go:script marker="onready">
	DisclosurePopup.init();
</go:script>
<%-- HTML --%>
<div id="disclosure-popup">
	<a href="javascript:void(0);" class="close-button"></a>
	
	<h5>YOUR DUTY OF DISCLOSURE</h5>
	
	<div class="content">
	
		<c:if test="${param.prdId != null && param.prdId == 'aubn'}">
			<div class="aubn_logo fright ml10"></div>
		</c:if>
		
		<c:if test="${param.prdId != null && param.prdId == 'crsr'}">
			<div class="crsr_logo fright ml10"></div>
		</c:if>
	
		
		<h3>WHAT YOU MUST TELL US:</h3>
		
		<p><b>Before You enter into a contract of insurance with Us for the first time</b>, You must advise Us of anything that You or a reasonable person in the circumstances could be expected to know, which is relevant to Us insuring You and, if so, on what terms. You must advise Us of any information relating to You and anyone likely to drive the Vehicle, when entering into the contract. 
		<b>When You <u>renew</u> or change Your Policy</b>, Your duty is to tell Us before the renewal or change every matter known to you which You know, or a reasonable person in the circumstances could be expected to know, is relevant to Our decision whether to insure You and whether any special conditions need to apply to Your policy. These include but are not limited to:</p>
		
		<ul>
			<li>Motor Vehicle accidents, claims, infringements and/or convictions in the last 5 years; and or </li>
			<li>Any criminal convictions or charges.</li>
		</ul>
		
		<p>You are not required to disclose anything that diminishes the risk to Us as the insurer, that we know or should know based on Our business, or is common knowledge.</p>
		
		<p>The decision to accept Your Application for insurance was based on a number of factors, as such You must tell Us immediately if any of the following details change;</p>
		
		<ul>
			<li>Drivers of Your Vehicle</li>
			<li>Change of Address</li>
			<li>Date of Birth of Youngest Driver</li>
			<li>Accessories &amp; Modifications</li>
			<li>The Vehicle itself</li>
			<li>Vehicle Use</li>
		</ul>
		
		<p><b>If You do not notify Us</b> of all information that You are aware of We may refuse to pay a claim, reduce the amount of Your claim, or Cancel Your Policy.</p>
		
		<h3>WHEN YOU RECEIVE THE POLICY MAKE SURE THE INFORMATION IS CORRECT</h3>
		<p>Please check the information you have given us and notify us of any changes or corrections. This is an important part of your Duty of Disclosure.</p>
		
		<core:clear/>

	</div>

	<div class="buttons">
		<a href="javascript:void(0)" class="ok-button"></a>
	</div>
</div>

