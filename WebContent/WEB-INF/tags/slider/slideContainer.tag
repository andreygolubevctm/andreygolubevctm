<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1"%>
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
		</div>
	</div>
	<a href="javascript:void(0);" class="tab-button prev" id="slide-prev" style="display:none">Previous</a>
	<a href="javascript:void(0);" class="tab-button next" id="slide-next" style="display:none">Next</a>
</div>


<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$("#next-step").click(function(){
		if (QuoteEngine.validate()){
			QuoteEngine.nextSlide();				
		} 
	});		
	$("#prev-step").click(function(){
		QuoteEngine.resetValidation();	
		QuoteEngine.prevSlide();
	});		
</go:script>



