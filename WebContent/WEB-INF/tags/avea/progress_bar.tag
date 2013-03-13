<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<div id="navContainer" style="position: relative">
	<img src="common/images/progressBar/navigation-steps-bar-interim.jpg" id="progressInterim" class="progressBar"/>
	<img src="common/images/progressBar/leftCorner.gif" id="progressLeftCorner" class="progressBar" />
	<img src="common/images/progressBar/progressPointer.gif" id="progressPointer" class="progressBar" />
	<ul id="steps">
		<!-- Menu item state if completed -->
		<li id="step-1" class="complete navStep">
			<a href="javascript:void(0);"><span>1</span>Additional Information</a>
		</li>
		<li id="step-2" class="navStep">
			<a href="javascript:void(0);"><span>2</span>Buy Online</a>
		</li>
		<li id="step-3">
			<a href="javascript:void(0);"><span>3</span>Payment and Policy Confirmation</a>
		</li>
	</ul>
</div>

<%-- CSS --%>
<go:style marker="css-head">
	.progressBar { float: left; position: absolute;  top: 0px; left: 0px; }
	#progressPointer { z-index: 1000; }
	#progressLeftCorner { z-index: 1001; }
	#progressInterim { z-index: 1002; display: none; }
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	function toggleProgressBar(showOrHide){
		if ($("#progressInterim").is(":visible") != showOrHide) {
			$("#navContainer").hide("slide", { direction: "down" }, 400, function() { 				
				$("#progressInterim").toggle(showOrHide);		
				$("#navContainer").show("slide", { direction: "down" }, 400 );		
				navPause = false;
		 	} );
		 }
	}
	
	var currentSlide = 0;
	var navPause = false;
	function progressBar(slide){

		var amountSlide = [0,118,131,125,147,120];
		
		// This will reset the navigation bar
		if (slide==0) {
			$('[id^="step-"]').each(function(index){
        		$("#step-"+(index+1)).removeClass('current');
      		});
      		$("#progressPointer").css("left",amountSlide[0]);

      		toggleProgressBar(false);      		
      		
      	} else if (slide!=currentSlide) {
	
			navPause = true; 
			var amt = (slide>currentSlide)?amountSlide[slide]:amountSlide[slide+1]*-1;
			
			if (isNaN(amt)) {
				amt=0;
			}
			
		    if (amt<0){
		    	$("#step-"+(slide+2)).removeClass('current');
		    }		
			
			if (slide < 6) {	
				$("#progressPointer").animate({
				    left: '+='+amt
				  }, 450, function() {		    
					    if (amt>0){
							$("#step-"+(slide+1)).addClass('current');					
					    } 	
					    navPause = false; 
				});				
				toggleProgressBar(false);
				
			} else {
				// reload the captcha value 
				if ($("#captcha_code").val()!=""){
					Captcha.reload();
				}
			
				toggleProgressBar(true);
			}
		}
		// Update the page history   
		//updateJoomla(slide);
		$.address.parameter("stage", slide+1, false );
		currentSlide = slide;
	}

</go:script>