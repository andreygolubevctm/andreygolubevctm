<%@ tag description="Details for Money Back Guarantee popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<c:choose>
	<c:when test="${param.ccad == '04021'}">
 
	<%-- CSS --%>
	<go:style marker="css-head">
		#welcome-popup {
			width:550px;
			height:auto;
			z-index:2001;
			display:none;
			left:50%;
		} 
		#welcome-popup h5 {
		    background: url("common/images/dialog/header_540.gif") no-repeat scroll 0 0 transparent;
		    display: block;
		    font-size: 17px;
		    font-weight: bold;
		    height: 39px;
		    padding-left: 13px;
		    padding-top: 10px;
		    width: 540px;
		    margin-bottom: -10px;
		    color: white;
		}
		#welcome-popup h3 {
			margin:10px 0px 10px 10px;
			font-size:14px;
			font-weight:bold;
			color: #0554DF;
		    font-size: 21px;
		    font-weight: bold;
		    display:block;
		}
		#welcome-popup li {
			font-size:11px;
			line-height:20px;
			margin-bottom:8px;
		}
		#welcome-popup .buttons {
			background: transparent url("common/images/dialog/buttonpane_540.gif") no-repeat;
			width:540px;
			height:47px;
			display:block;
			padding-top:10px;
		}
		#welcome-popup strong {
			line-height:21px;
		}
		#welcome-popup .continue-button {
			background: transparent url("common/images/dialog/button-continue.png") no-repeat;
			width:145px;
			height:39px;
			margin: 0 auto;
			cursor:pointer;
		}
		#welcome-popup .close-button {
		    left: 494px;
		}
		#welcome-popup .back-button {
		    background: url("common/images/button-prev.png") no-repeat scroll 0 0 transparent;
		    height: 37px;
		    position: relative;
		    width: 140px;
			margin-top:10px;
			margin-right:5px;
		    float:right;
		}
		#welcome-popup .back-button:hover {
		    background: url("common/images/button-prev-on.png") no-repeat scroll 0 0 transparent;
		}
		#welcome-popup .content {
			background: white url("common/images/dialog/content_540.gif") repeat-y;
			padding:10px;
			overflow: hidden;
			height:150px; 
		}
		#welcome-popup .content p {
		    font-size: 18px;
			margin: 6px 10px 20px;
		    line-height:25px;
		}
		
		#welcome-popup, #welcome-popup h5, #welcome-popup .buttons{
			width:540px;
		}
		
		#welcome-popup h5{
			background: url("common/images/dialog/header_540.gif") no-repeat scroll 0 0 transparent;
		}
		#welcome-popup .content{
			background: url("common/images/dialog/content_540.gif") repeat-y scroll 0 0 white;
		}
		#welcome-popup .buttons{
			background: url("common/images/dialog/buttonpane_540.gif") no-repeat scroll 0 0 transparent;
		}
		#welcome-popup .close-button{
	    	left: 510px;
	    	cursor:pointer;
	    }
	    #welcome-popup .with-your-quote {
	    	font-size:12px;
	    	position:relative; 
	    	left:350px; 
	    	top:-27px;
	    }
	    .welcome_left{
	    	float:left;
	    	width:350px;
	    }
	    
	    .welcome_right{
		    margin-left:2px;
	    	float:left;
	    	width:155px;
	    	font-size:20px;
	    }
	    .bluetext{
	    	color:#0052e8;
	    }
	    
	    .termsDetail{
	   		font-size:15px;
	   		line-height:17px;
	   		margin:8px 135px 0 8px;
	   }
	   
		.welcome_right img {
			margin-top: 5px;
			padding-left: 5px;
			height: 60px;
			width: 154px;
		}
	   
		#welcome-overlay {
			position:absolute;
			top:0px;
			left:0px;
			z-index:2000;		 
		}
	   
	</go:style>
	
	<%-- JAVASCRIPT --%>
	<go:script marker="js-head">	
		var WelcomePopup = new Object();
		WelcomePopup = {	
			
			show: function(){
				
				var welcome_template = $("#welcome-template").html();
				$("#welcome-popup .content").html($(parseTemplate(welcome_template, '')));
				
				var overlay = $("<div>").attr("id","welcome-overlay")
										.addClass("ui-widget-overlay")
										.css({	"height":$(document).height() + "px", 
												"width":$(document).width()+"px"
											});
				$("body").append(overlay);
				$(overlay).fadeIn("fast");
				// Show the popup
				$("#welcome-popup").css("position","absolute");
    			$("#welcome-popup").css("top", "85px");
    			$("#welcome-popup").css("left", ( $(window).width() - $("#welcome-popup").width() ) / 2+$(window).scrollLeft() + "px");
				
				$("#welcome-popup").show("slide",{"direction":"down"},300);
						
			}, 
			hide : function(){
				$("#welcome-popup").hide("slide",{"direction":"down"},300);
				$("#welcome-overlay").remove();
			}, 
			init : function(){
				$("#welcome-popup").hide();
			}
		}
	</go:script>
	
	<go:script marker="onready">
		WelcomePopup.show();
	</go:script>
	
	<go:script marker="jquery-ui">
		$("#welcome-popup .continue-button, #welcome-popup .close-button").click(function(){
			WelcomePopup.hide();
		});
	</go:script>
	
	<%-- HTML --%>
	<div id="welcome-popup">
		<a href="javascript:void(0);" class="close-button"></a>
		<h5></h5>
		<div class="content"></div>
	
		<div class="buttons">
			<div class="continue-button"></div>
			<span class="with-your-quote">with your quote</span>
		</div>
	</div>
	<go:style marker="css-head">
		.cleardiv{clear:both;}
	</go:style>
	<%-- GUARANTEE POPUP ROW TEMPLATE --%>
	<core:js_template id="welcome-template">
		<div>
		
			<div class="welcome_left">
		
				<p><b>Compare the Market welcomes visitors from Car Insurance Comparison</b></p>
				
				<div class="cleardiv"></div>
			</div>
			
			<div class="welcome_right">
				<img src="common/images/CI_bglogo.png" width="200" height="100"/>
				<div class="cleardiv"></div>
			</div>
			
			<div class="cleardiv"></div>
			
			<div class="termsDetail">
				Compare and save with live quotes from some of
				Australia's most competitive car insurance brands.
				<div class="cleardiv"></div>
			</div>
	
		</div>
	</core:js_template>
	
</c:when>
</c:choose>
