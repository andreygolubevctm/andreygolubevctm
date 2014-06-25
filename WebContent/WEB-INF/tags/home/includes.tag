<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Results conditions popup --%>
<home:results_terms />

<core:transferring />

<%-- Save Quote Popup --%>
<quote:save_quote quoteType="home" mainJS="${false}" />

<%-- Get more details on product popup --%>
<home:more_details />

<%-- Results none popup --%>
<agg:results_none providerType="Home and Content insurance" />

<go:script marker="js-href"	href="common/js/jquery.formatCurrency-1.4.0.js" />

<go:script marker="onready">

	$(document).ready(function() {
		$(".pretty_buttons").buttonset();

		$('label.ui-button').each(function() {
			var radio = $(this).prop('for');
			$(this).prop('title',$('#' + radio).prop('title'));
		});
	});


</go:script>

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
		Results.get( "ajax/json/home/results.jsp", data );
	</go:script>
</c:if>

<go:script marker="onready">
	Track._transactionID = '${data.current.transactionId}';
	Track.startSaveRetrieve(Track._transactionID, 'Start', 'Cover');
</go:script>