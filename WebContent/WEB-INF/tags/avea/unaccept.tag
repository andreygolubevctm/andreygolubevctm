<%@ tag description="Unacceptable Risk Popup"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
 
<%-- CSS --%>
<go:style marker="css-head">
	#unaccept-popup {
		width:620px;
		position:absolute;
		margin-left:-310px;
		left:50%;
		height:auto;
		z-index:9001;
		display:none;
		top:20px;
	}
	#unaccept-popup h5 {
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
	#unaccept-popup h3 {
		margin:0px 0px 10px 0px;
		font-weight:bold;
		color:#0554DF;
	    font-size:14px;
	    font-weight:bold;
	    display:block;
	}
	#unaccept-popup ul {
		margin:10px 0px 12px 12px;
	    font-size:12px;
	}
	#unaccept-popup li {
		font-size:11px;
		line-height:18px;
		margin-bottom:0px;
   		list-style:disc outside;
	}
	#unaccept-popup .buttons {
		background: transparent url("common/images/dialog/buttonpane_620.gif") no-repeat;
		width:620px;
		height:47px;
		display:block;
		padding-top:10px;
	}
	#unaccept-popup strong {
		line-height:21px;
	}
	#unaccept-popup .ok-button {
		background: transparent url("common/images/dialog/ok.gif") no-repeat;
		width:51px;
		height:36px;
		margin: 0 auto;
	}
	#unaccept-popup .ok-button:hover {
		background: transparent url("common/images/dialog/ok-on.gif") no-repeat;
	}
/*	#unaccept-popup .close-button {
	    background: url("common/images/dialog/close.gif") no-repeat scroll 0 0 transparent;
	    height: 12px;
	    left: 824px;
	    position: relative;
	    top: 25px;
	    width: 12px;
	    display: inline-block;
	}*/
	#unaccept-popup .back-button {
	    background: url("common/images/button-prev.png") no-repeat scroll 0 0 transparent;
	    height: 37px;
	    position: relative;
	    width: 140px;
		margin-top:10px;
		margin-right:5px;
	    float:right;
	}
	#unaccept-popup .back-button:hover {
	    background: url("common/images/button-prev-on.png") no-repeat scroll 0 0 transparent;
	}
	#unaccept-popup .content {
		background: white url("common/images/dialog/content_620.gif") repeat-y;
		padding:20px;
		overflow:auto;
		height:350px; 
	}
	#unaccept-popup .content p {
	    margin-bottom: 9px;
	    font-size: 12px;
	    margin: 10px 10px;
	    line-height:17px;
	}
	#unaccept-popup, #unaccept-popup h5, #unaccept-popup .buttons{width:620px;}
	
	#unaccept-popup h5{
		background: url("common/images/dialog/header_620.gif") no-repeat scroll 0 0 transparent;
	}
	#unaccept-popup .content{
		background: url("common/images/dialog/content_620.gif") repeat-y scroll 0 0 white;
	}
	#unaccept-popup .buttons{
		background: url("common/images/dialog/buttonpane_620.gif") no-repeat scroll 0 0 transparent;
	}
	#unaccept-popup .close-button{
    	left: 590px;
    }

</go:style>



<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var UnacceptPopup = new Object();
	UnacceptPopup = {	
		
		show: function(){
			
			var overlay = $("<div>").attr("id","unaccept-overlay")
									.addClass("ui-widget-overlay unacceptoverlay")
									.css({	"height":$(document).height() + "px", 
											"width":$(document).width()+"px", 
											"z-index":"9000"
										});
			$("body").append(overlay);
			
			<%-- Show the popup --%>
			$(overlay).fadeIn(300, function(){
				$("#unaccept-popup").fadeIn(300);
			});
			
		}, 
		hide : function(){
			$("#unaccept-popup").fadeOut(500, function(){
				$("#unaccept-overlay").remove();
				$(".unacceptoverlay").remove();
				
				<%-- Clear AVEA from data bucket first, then close window --%>
				$.ajax({
					url: "ajax/json/avea_clear.jsp",
					type: "POST",
					async: false,
					dataType: "json",
					success: function(result){
						window.close();
					}
				});
				
			});
		}, 
		init : function(){
			$("#unaccept-popup").hide();
		}
	}


	
</go:script>
<go:script marker="jquery-ui">
	$("#unaccept-popup .ok-button, #unaccept-popup .close-button").click(function(){
		UnacceptPopup.hide();
	});
</go:script>
<go:script marker="onready">
	UnacceptPopup.init();
	$('#unaccept-popup .avea_details').show();
</go:script>

<%-- HTML --%>
<div id="unaccept-popup">
	<a href="javascript:void(0);" class="close-button"></a>
	
	<h5>Application Information</h5>
	
	<div class="content">

		<c:if test="${param.prdId == 'aubn'}">
			<div title="AutObarn" class="aubn_logo"></div>
			<avea:head_underwriter show="1" />
		</c:if>
		
		<c:if test="${param.prdId == 'crsr'}">
			<div title="Carsure" class="crsr_logo"></div>
			<avea:head_underwriter show="1" />
		</c:if>
		
		<h3>Underwriting Referral</h3>
		
		<c:if test="${param.prdId == 'aubn'}">
			<p>Unfortunately we are unable to continue with this purchase as a result of AutObarn's underwriting guidelines.</p>
		</c:if>
		
		<c:if test="${param.prdId == 'crsr'}">
			<p>Unfortunately we are unable to continue with this purchase as a result of carsure.com.au's underwriting guidelines.</p>
		</c:if>
		
		<p>We recommend you contact the Financial Ombudsmen Service Limited (FOS) to help you find an insurer with an appropriate policy. <a href="http://www.fos.org.au/findaninsurer" target="_blank">www.fos.org.au/findaninsurer</a></p>
		
		<core:clear/>		
	
	</div>

	<div class="buttons">
		<a class="ok-button"></a>
	</div>
</div>


