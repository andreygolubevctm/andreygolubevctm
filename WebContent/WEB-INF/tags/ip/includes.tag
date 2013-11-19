<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

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
			Track.contactCentreUser( '${data.ip.application.productId}', '${data.login.user.uid}' );
			</c:if>

</go:script>

<go:style marker="css-head">
.contact_panel_small {
	font-size: 10px;
}

</go:style>