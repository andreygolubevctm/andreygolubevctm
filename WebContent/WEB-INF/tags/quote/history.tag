<%@ tag description="The Comparison Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

	$.address.init(function(event){
		if (event.parameters.stage) {
			//alert("address.init: stage=" + event.parameters.stage);
		}
	});

	$.address.externalChange(function(event){
		var stage = event.parameters.stage;
		History.showStage(event.parameters.stage, true);
	});

</go:script>
<go:script marker="js-head">
var History = new Object();
History = {
	_START : 1,
	_INTERIM : 7,
	_RESULTS : 8,
	showStage : function(stage, external){
		//set the initialClick flag to be true...
		initialClick = true;

		if (typeof Kampyle != "undefined") {
			Kampyle.setFormId("85272");
		}

		// stage is undefined.. do nothing
		if (stage == undefined || isNaN(stage)) {
			stage = this._START;
		}

		gotoSlide = stage-1;

		// If the stage we're attempting to go to is Results or Interim,
		// And we don't have a currentSlide it will be due to an F5 refresh.
		// In this case, send the user back to the last page of the quote
		if ( external && QuoteEngine.getCurrentSlide() <= 0) {
			var currentSlide = QuoteEngine.getCurrentSlide();
			stage = this._START;
			gotoSlide = stage-1;
			$("#prev-step").click();
		} else {
			// If we're trying to navigate forward - don't allow it.
			if (gotoSlide > currentSlide) {
				$("#next-step").click();
				return;
			} else if (gotoSlide < currentSlide &&  !Interim.isActive) {
				$("#prev-step").click();
				return;
			}

			// Make sure that the compare table is closed...
			if(QuoteEngine.getCurrentSlide() == 5) {
				Compare.close();
			}
		}

		//progressBar(gotoSlide);

		// Scroll to the desired page
		//$('#qe-wrapper').scrollable().seekTo(gotoSlide);
	},
	showStart : function() {
		this.showStage(this._START,false);
	},
	showResults : function() {
		Results.show();
	}
}
</go:script>