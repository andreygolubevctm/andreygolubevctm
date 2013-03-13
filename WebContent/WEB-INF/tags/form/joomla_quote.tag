<%--
	Represents a collection of panels
	http://192.168.49.71/modules/mod_custom_external/showcontent.php?id=88
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<go:import url="${data['settings/joomla-url']}"></go:import>

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
