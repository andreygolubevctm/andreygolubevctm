<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<life:accordion quoteType="life" />

<%-- VARIABLES --%>

<c:set var="bs_life"><c:out value="${param.life}" escapeXml="true"/></c:set>
<c:set var="bs_tpd"><c:out value="${param.tpd}" escapeXml="true"/></c:set>
<c:set var="bs_trauma"><c:out value="${param.trauma}" escapeXml="true"/></c:set>
<c:set var="vertical" value="life" />

<%-- Save Quote Popup --%>
<quote:save_quote quoteType="${vertical}" mainJS="LifeQuote" />

<%-- Dialog for errors during product comparisons --%>
<core:popup id="compare-error" title="Comare ERROR">
	<p id="compare-error-text">XXXXXXX</p>
	<div class="popup-buttons">
		<a href="javascript:void(0);" class="bigbtn close-error"><span>Ok</span></a>
	</div>
</core:popup>

<%-- Dialog for confirming telephone number before submission --%>
<life:popup_callbackconfirm />

<go:script marker="js-head">
	LifeQuote._vertical = 'life';

	var QuestionSetUpdater = {
			setLife : function(amt) {
				QuestionSetUpdater.update('life_primary_insurance_termentry', amt);
				QuestionSetUpdater.update('life_partner_insurance_termentry', amt);
			},

			setTPD : function(amt) {
				QuestionSetUpdater.update('life_primary_insurance_tpdentry', amt);
				QuestionSetUpdater.update('life_partner_insurance_tpdentry', amt);
			},

			setTrauma : function(amt) {
				QuestionSetUpdater.update('life_primary_insurance_traumaentry', amt);
				QuestionSetUpdater.update('life_partner_insurance_traumaentry', amt);
			},

			update : function(field_id, value) {
				if( $('#' + field_id).is(":visible") ) {
					$('#' + field_id).val( value ).trigger('blur');
				}
			},
			
			close : function() {
				LBCalculatorDialog.close();
			}
	};
</go:script>

<go:script marker="js-href" href="common/js/jquery.formatCurrency-1.4.0.js" />

<life:includes_js_onready />
	
<go:script marker="onready">
	
	<c:if test="${not empty bs_life}">
		QuestionSetUpdater.setLife(${bs_life});
	</c:if>

	<c:if test="${not empty bs_tpd}">
		QuestionSetUpdater.setTPD(${bs_tpd});
				</c:if>

	<c:if test="${not empty bs_trauma}">
		QuestionSetUpdater.setTrauma(${bs_trauma});
	</c:if>

	$("#compare-error .close-error").click(function(){
		Popup.hide("#compare-error");
	});

	</go:script>

	<go:style marker="css-head">
.contact_panel_small {
	font-size: 10px;
}

</go:style>