<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" required="true" rtexprvalue="true"
	description="additional css class attribute"%>
<%@ attribute name="id" required="false" rtexprvalue="true"
	description="optional id for this slide container"%>

<%-- HTML --%>
<div id="qe-wrapper">
	<div class="scrollable">
		<div id="qe-main">
			<jsp:doBody />
			<core:clear />
		</div>
	</div>
	<a href="javascript:void(0);" class="tab-button prev" id="slide-prev" style="display:none">Previous</a>
	<a href="javascript:void(0);" class="tab-button next" id="slide-next" style="display:none">Next</a>
</div>


<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$("#next-step").click(function(){
		if (QuoteEngine.validate()){
			$('#sidePanel-help-'+QuoteEngine._options.currentSlide).hide();

			QuoteEngine.nextSlide();				

			$('#sidePanel-help-'+QuoteEngine._options.currentSlide).show();
		} 
	});		
	$("#prev-step").click(function(){
		$('#sidePanel-help-'+QuoteEngine._options.currentSlide).hide();

		QuoteEngine.resetValidation();	
		QuoteEngine.prevSlide();

		$('#sidePanel-help-'+QuoteEngine._options.currentSlide).show();
		$('.right-panel').removeClass('hidden');
	});		
</go:script>



