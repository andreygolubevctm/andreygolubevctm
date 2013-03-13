<%--
	Represents a collection of panels
	http://192.168.49.71/modules/mod_custom_external/showcontent.php?id=88
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<%-- <go:import url="${data['settings/joomla-url']}"></go:import> --%>
<div id="external-content">
    <!-- (Joomla Content) -->
        <div class="tips-step-0 joomla">
            <div class="tip">
                <h3>HI THERE SUPER SAVER</h3>
                <ul>
                    <li>You're just one step away from comparing a range of Roadside assistance Quotes</li>
                    <li>Be sure to give us accurate information so that we can get the right quotes for you</li>

                </ul>
            </div>
        </div>
        <div class="tips-step-1 joomla">
            <!-- Content for Step 2 -->
            <div class="tip">
                <h3>ANOTHER TIP FROM THE<br>CAPTAIN</h3>
                <ul>
                    <li>Remember the address we are looking for here, is where the car is parked at night. This could be different to your postal address.</li>
                </ul>
            </div>   
        </div>
        <div class="tips-step-2 joomla">
            <!-- Content for Step 3 -->
            <div class="tip">
                <h3>YOU'RE ALMOST THERE</h3>
                <ul>
                    <li>Complete this page and you'll soon be helping us rank your quote results</li>
                    <li>Clicking on the 'Go Back' button allows you to review or amend your quote details at any point in the quote process</li>
                </ul>
            </div>   
        </div>
</div>

<%-- CSS --%>
<go:style marker="css-head">
	.joomla { display: none; position: absolute; z-index: 1000;  }
	.tips-step-0 { display: block; }
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var currentJoomlaSlide = -1;
	function updateJoomla(slide){
		if (slide == currentSlide){
			return;
		}
		if (slide==6) { 
			$('[class^="tips-step-"]').css('display', 'none');
			currentJoomlaSlide=slide;

		} else {
			$('.tips-step-'+slide).css('z-index',1001).fadeIn(400, function() {		
				$('.tips-step-'+slide).css('z-index',1000);	
				$('.tips-step-'+currentJoomlaSlide).hide();
				currentJoomlaSlide=slide;											
			});			
		}
	
	}
</go:script>
