<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:script href="common/js/referenceNumber.js" marker="js-href" />

<core:transferring />

<%-- Flash animation holder --%>
<div id="flashWrapper"></div>
<div id="ieflashMask"></div>

<%-- Results conditions popup --%>
<quote:results_terms />

<%-- Special Conditions conditions popup --%>
<quote:results_specialconditions/>


<%-- Save Quote Popup --%>
<quote:save_quote quoteType="car" mainJS="${false}" />

<%-- Get more details on product popup --%>
<quote:more_details />

<go:script marker="onready">
	function submitForm() {
		$("#mainform").validate().resetNumberOfInvalids();
		$('#slide6 :input').each(function(index) {
			if ($(this).attr("id")){
				$("#mainform").validate().element("#" + $(this).attr("id"));
			}
		});
		if ($("#mainform").validate().numberOfInvalids() == 0) {
				nav.next();
				progressBar(slideIdx);
				Interim.show();
		}
	}

</go:script>

<%--//REVISE: Remove this--%>
<go:script marker="onready">
	$('body').keyup(function(e){
		if (e.ctrlKey && e.keyCode==39 && $.address.parameter("stage") != 'results'){
			$('.next').click();
		}
	});
</go:script>

<c:if test="${param.action == 'latest'}">
	<go:script marker="onready">
		var data =  {
			action: "latest",
			transactionId: '${data.current.transactionId}'
		};
		Results.get( "ajax/json/car_quote_results.jsp", data );
	</go:script>
</c:if>

<go:script marker="onready">
	Track._transactionID = '${data.current.transactionId}';
	Track.startSaveRetrieve(Track._transactionID, 'Start', 'Your Car');
	Track.nextClicked(0);
</go:script>

<go:script marker="jquery-ui">
	// Quick config
	var labels  = ['Not important', 'Neutral', 'Important'];
	var min 	= 1;
	var max 	= 3;
</go:script>