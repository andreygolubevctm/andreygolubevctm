<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="ip" />

<%-- Save Quote Popup --%>
<quote:save_quote quoteType="${vertical}" mainJS="IPQuote" />

<%-- Dialog for errors during product comparisons --%>
<core:popup id="compare-error" title="Comare ERROR">
	<p id="compare-error-text">XXXXXXX</p>
	<div class="popup-buttons">
		<a href="javascript:Popup.hide('#compare-error');" class="bigbtn close-error"><span>Ok</span></a>
	</div>
</core:popup>

<%-- Dialog for confirming telephone number before submission --%>
<life:popup_callbackconfirm />

<go:script marker="js-head">
	LifeQuote._vertical = 'ip';

	var QuestionSetUpdater = {
			close : function() {
				LBCalculatorDialog.close();
			}
	};
</go:script>

<go:script marker="js-href" href="common/js/jquery.formatCurrency-1.4.0.js" />

<life:includes_js_onready />
	
<go:script marker="onready">
	
	<c:if test="${isNewQuote eq false and not empty callCentre}">
		Track.contactCentreUser( '${data.ip.application.productId}', '${authenticatedData.login.user.uid}' );
			</c:if>

</go:script>

<go:style marker="css-head">
.contact_panel_small {
	font-size: 10px;
}
</go:style>