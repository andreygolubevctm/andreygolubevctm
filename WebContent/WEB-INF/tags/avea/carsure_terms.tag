<%@ tag description="Carsure Terms Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
 
<%-- CSS --%>
<go:style marker="css-head">
	#carsureterms-popup {
		width:620px;
		height:auto;
		z-index:2001;
		display:none;
		left:50%;
	} 
	#carsureterms-popup h5 {
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
	#carsureterms-popup h3 {
		margin:0px 0px 10px 0px;
		font-weight:bold;
		color:#0554DF;
	    font-size:14px;
	    font-weight:bold;
	    display:block;
	}
	#carsureterms-popup h4 {font-size:14px;color:#777;}
	#carsureterms-popup ul {
		margin:10px 0px 12px 22px;
	    font-size:12px;
	}
	#carsureterms-popup li {
		font-size:12px;
		line-height:18px;
		margin-bottom:6px;
   		list-style:disc outside;
	}
	#carsureterms-popup .buttons {
		background: transparent url("common/images/dialog/buttonpane_620.gif") no-repeat;
		width:620px;
		height:47px;
		display:block;
		padding-top:10px;
	}
	#carsureterms-popup strong {
		line-height:21px;
	}
/*	#carsureterms-popup .ok-button {
		background: transparent url("common/images/dialog/ok.gif") no-repeat;
		width:51px;
		height:36px;
		margin: 0 auto;
	}
	#carsureterms-popup .ok-button:hover {
		background: transparent url("common/images/dialog/ok-on.gif") no-repeat;
	}*/
/*	#carsureterms-popup .close-button {
	    background: url("common/images/dialog/close.gif") no-repeat scroll 0 0 transparent;
	    height: 12px;
	    left: 824px;
	    position: relative;
	    top: 25px;
	    width: 12px;
	    display: inline-block;
	}*/
	#carsureterms-popup .back-button {
	    background: url("common/images/button-prev.png") no-repeat scroll 0 0 transparent;
	    height: 37px;
	    position: relative;
	    width: 140px;
		margin-top:10px;
		margin-right:5px;
	    float:right;
	}
	#carsureterms-popup .back-button:hover {
	    background: url("common/images/button-prev-on.png") no-repeat scroll 0 0 transparent;
	}
	#carsureterms-popup .content {
		background: white url("common/images/dialog/content_620.gif") repeat-y;
		padding:20px;
		overflow:auto;
		height:350px; 
	}
	#carsureterms-popup .content p {
	    margin-bottom: 9px;
	    font-size: 12px;
	    margin: 10px 10px;
	    line-height:17px;
	}
	#carsureterms-popup, #carsureterms-popup h5, #carsureterms-popup .buttons{width:620px;}
	
	#carsureterms-popup h5{
		background: url("common/images/dialog/header_620.gif") no-repeat scroll 0 0 transparent;
	}
	#carsureterms-popup .content{
		background: url("common/images/dialog/content_620.gif") repeat-y scroll 0 0 white;
	}
	#carsureterms-popup .buttons{
		background: url("common/images/dialog/buttonpane_620.gif") no-repeat scroll 0 0 transparent;
	}
	#carsureterms-popup .close-button{
    	left: 590px;
    }

</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var CarsuretermsPopup = new Object();
	CarsuretermsPopup = {	
		
		show: function(){
			
			var carsureterms_template = $("#carsureterms-template").html();
			$("#carsureterms-popup .content").html($(parseTemplate(carsureterms_template, '')));
			
			var overlay = $("<div>").attr("id","carsureterms-overlay")
									.addClass("ui-widget-overlay")
									.css({	"height":$(document).height() + "px", 
											"width":$(document).width()+"px"
										});
			$("body").append(overlay);
			$(overlay).fadeIn("fast");
			// Show the popup
			$("#carsureterms-popup").center().show("slide",{"direction":"down"},300);
			
		}, 
		hide : function(){
			$("#carsureterms-popup").hide("slide",{"direction":"down"},300);
			$("#carsureterms-overlay").remove();
		}, 
		init : function(){
			$("#carsureterms-popup").hide();
		}
	}


	
</go:script>
<go:script marker="jquery-ui">
	$("#carsureterms-popup .ok-button, #carsureterms-popup .close-button").click(function(){
		CarsuretermsPopup.hide();
	});
</go:script>
<go:script marker="onready">
	CarsuretermsPopup.init();
</go:script>
<%-- HTML --%>
<div id="carsureterms-popup">
	<a href="javascript:void(0);" class="close-button"></a>
	
	<h5>Carsure Website Terms and Conditions</h5>
	
	<div class="content"></div>

	<div class="buttons">
		<a class="ok-button"></a>
	</div>
</div>

<%-- DISCLOSURE POPUP ROW TEMPLATE --%>
<core:js_template id="carsureterms-template">

<h3>Important Information</h3>
<p>The domain name "Carsure.com.au" and this website ("Website") are owned and operated by Carsure PTY LTD (ACN 142 601 705) ("Carsure"). You consent to the following terms of use by accessing the internet materials of this Website. Carsure reserves the right to vary these terms of use at any time by publishing varied provisions on this Website. You accept and agree that by doing this, Carsure has provided you with sufficient notice of any variations. If you do not agree to be bound by these terms of use you must stop accessing this Website immediately.</p>

<h4>Uses of This Website</h4>
<p>The contents of this Website are protected by various national and international copyright laws. You may not copy, store, reproduce, republish, upload, post, transmit, or distribute in any way or in any format material from Carsure. In particular, you may not copy, modify, store ,display or deliver Carsure's names, logos, text, or graphic images without our express written permission; doing so is a violation of Carsure's copyrights. Where material not published by Carsure appears on this Website, you must not use or copy any such material without the consent of the original owner. You agree to use this Website for only lawful purposes and not to post on this Website any unlawful, harmful, defamatory, abusive or obscene material of any kind which would violate any applicable law.</p>
<p>By using this Website you agree not to:</p>
<ul>
	<li>use any automatic or manual process to combine or aggregate information, data or content contained within or accessible through this Website with information, data or content accessible via or sourced from any third party;</li>
    <li>use any information on or accessed through this Website for any commercial purpose or otherwise (either directly or indirectly) for profit or gain;</li>
    <li>use any software, device or routine to interfere or attempt to interfere with the proper working of this Website or any transaction or process being conducted on or through it;</li>
    <li>take any action that imposes an unreasonable or disproportionately large load on the infrastructure of this Website;</li>
    <li>use any screen scraper, spider, robot, data aggregation tool or other automatic or manual device or process to extract, copy, store or monitor any web pages on this Website, or any of the information, data or content contained within or accessible through this Website, without Carsure's prior written permission;</li>
    <li>alter, modify, copy, store, reproduce, create derivative works, or publicly deliver or display any part of any content from this Website without Carsure's prior written permission; or</li>
    <li>reverse assemble, reverse engineer or otherwise attempt to discover, locate, or access source code or other arithmetical formula in respect of the software underlying the infrastructure and processes associated with this Website.</li>
</ul>
	
<h4>Privacy</h4>
<p>Carsure is committed to safeguarding your privacy. By accessing or using this Website you acknowledge and agree to the computer storage, processing and use of personal information in accordance with the provisions of Carsure's Privacy and Security Statement. We collect certain information from you and it is used by this Website in order to provide insurance quotations, insurance cover and other online services. No electronic data transmission can be guaranteed as completely secure. We make every endeavour to protect such information but do not warrant the security of information transmitted by you to Carsure, which is done at your own risk.</p>

<h4>General Advice</h4>
<p>The information contained in this Website does not constitute investment advice and may not take into account any persons' particular circumstances. You should always consult a qualified adviser for advice on whether the information provided is appropriate to your particular objectives, financial situation and needs.</p>
<p>Before deciding on any product, you should read the full details of the product in the Product Disclosure Statement (PDS) which is available on this Website.</p>

<h4>Online Transactions</h4>
<p>Where this Website enables you to purchase insurance products online, then it will be done via the following process:</p>
<ul>
    <li>You must provide all the information requested for Carsure to provide an online quote.</li>
    <li>Carsure will provide a quote for its products electronically and this will constitute Carsure's offer to you.</li>
    <li>You may accept this offer by providing valid information about your credit card that you will be using to pay for the product you have chosen.</li>
    <li>Carsure will then receive an electronic instruction which it will then act upon to issue you with the product (at its discretion).</li>
    <li>A binding insurance contract is conditional on Carsure being able to successfully charge against your nominated credit card and Carsure receiving payment of your applicable premium.</li>
    <li>You should then receive a policy number for the product you have chosen.</li>
</ul>
	
<p>However, a binding insurance contract is not conditional on the insurance or receipt by you of a policy number. Therefore, the failure by you to receive a policy number via this Website does not invalidate or otherwise prejudice the existence of an insurance contract or transaction entered into using this Website.</p>
<p>Carsure may or may not issue a paper confirmation of the insurance policy. The existence of a binding contract is not conditional on Carsure issuing, or you receiving, a paper confirmation of the transaction. You are responsible for ensuring that you receive a policy number and should contact Carsure if a policy number is not received by you within 3 working days of your acceptance.</p>

<h4>Online Payments</h4>
<p>If you are paying an insurance premium online, your policy will only be in place once Carsure receives clear payment via your credit card; and a record of the transaction is generated in Carsure's database and a receipt number issued for the payment.</p>

<h4>Reliance</h4>
<p>While Carsure uses reasonable efforts to obtain information from sources which it believes to be reliable, Carsure makes no representation that the information or opinions contained on this Website is accurate, reliable or complete. The information and opinions contained in this Website are provided by Carsure for personal use and informational purposes only and are subject to change without notice.</p>
<p>Nothing contained on this Website constitutes investment, legal, tax or other advice nor is it to be relied on in making an investment or other decision. You should obtain relevant and specific professional advice before making any investment decision. Carsure reserves the right to correct pricing errors at any time. Carsure is not liable for any loss or damage whatsoever from failure to deliver or delay in delivery of its products or services.</p>

<h4>Warranty</h4>

<p>The information and opinions contained on this Website are provided without any warranty of any kind, either express or implied including but not limited to merchantability, fitness for purpose or any warranty created by a course of conduct or dealing or trade practice.</p>

<h4>Limitations of Liability</h4>
<p>By accessing this Website you assume all responsibility and risk for the use of this Website. In no event, including (without limitation) negligence, will Carsure, its directors, employees and contractors be liable or responsible to any person for any loss or damage of any kind as a consequence of the use of or reliance on any of the information contained in this Website, including (without limitation) any direct, special, indirect, incidental or consequential damages, or loss of profits, even if expressly advised of the possibility of such damages, arising out of or in connection with:</p>
<ul>
    <li>the access of, use of, performance of, browsing in or linking to other internet sites from this Website;</li>
   	<li>any conduct or statements of any user of this Website, including any advice or information and any offensive conduct or defamatory statements; or</li>
    <li>any unauthorised access to or alterations of your transmissions or data.</li>
    <li>In those countries or States which do not permit some or all of the above limitations of liability, liability shall be limited to the greatest extent permitted by law.</li>
</ul>

<h4>Indemnity</h4>
<p>You indemnify Carsure in respect of any liability incurred by Carsure for any loss or damage, howsoever caused, suffered by Carsure as a result of your breach of this Website's terms of use, or your use of this Website.</p>

<h4>Linked Websites</h4>
<p>Carsure is in no way responsible for the content or legality of any site owned by a third party that may be linked to this Website by hyperlink, whether such hyperlink is provided by Carsure or by a third party. Users and sites may include a link to this Website only by pointing to its homepage (www.carsure.com.au) and only if any discussion of Carsure is truthful, accurate and not misleading.</p>
<p>Carsure makes no representations whatsoever about any other internet site which you may access through this Website. When you access a non Carsure's internet site, please understand that it is an independent internet site, and that Carsure has no control over the content on that internet site. In addition, a link to a non Carsure's internet site does not imply that Carsure endorses or otherwise accepts any responsibility for the content, or the use, of the linked internet site.</p>

<h4>Disclaimer</h4>
<p>There are no implied or express warranties on the materials in this Website. The materials are provided "as is." Carsure disclaims, to the fullest extent of the law, all implied or express warranties, including, but not limited to, implied warranties of merchantability and fitness for a particular purpose. Carsure does not warrant that the functions will be uninterrupted or error-free, that defects will be corrected, or that this Website or the server that makes it available are free from defects, errors, viruses or other harmful software or computer programmes.</p>
<p>Carsure does not warrant or represent that the materials in this Website are correct, accurate, or reliable. You assume the entire cost of all necessary servicing, repair, or correction of the computer you are using to access this Website or any electronic data storage device. Carsure will not be liable under any circumstances, including but not limited to negligence for any special or consequential damages that may result from the use of, or the inability to use the materials in this Website. This result will follow even if Carsure has been advised of the possibility of such damages. In no event shall Carsure's liability for damages, losses, and causes of action whether in contract, tort (including, but not limited to, negligence), or otherwise exceed the amount paid, if any, for accessing this Website.</p>

<h4>Breach of Conditions</h4>
<p>If you breach any term or condition of these terms of use, Carsure may suspend your access to this Website. Carsure reserves the right to suspend your access to this Website due to technical or any other problems associated with this Website.</p>

<h4>Termination</h4>
<p>These terms of use and your access to this Website may be terminated at any time by either party without notice to the other. However, all restrictions and licences granted by you, and all disclaimers and exclusions of and limitations on liability of Carsure will survive any termination. Upon termination, you must not directly or indirectly access or use this Website or any material on this Website.</p>

<h4>General</h4>
<p>Carsure reserves the right to change, modify, add, or remove portions of these terms of use at any time. This Website is for access and use by Australian residents only. Some of the service may be limited in its application to specific States and/or Territories of Australia.</p>

<h4>Copyright</h4>
<p>Carsure authorises you to print, copy, download and view pages from this Website where:</p>
<ul>
    <li>the material is used only for personal use;</li>
    <li>the material is used in the intended manner; and</li>
    <li>the material is not altered in any way.</li>
</ul>


<core:clear/>


</core:js_template>	
