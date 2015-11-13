<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Create kamplye button"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="formId" 	required="true"	 rtexprvalue="true"	 description="Kampyle Form Id" %>

<go:style marker="css-href" href="common/k_button.css" />

<go:script marker="js-head">
var Kampyle = new Object();
Kampyle = {
	_formId : "${formId}",
	_prevId : '',

	setFormId : function(newFormId) {
		if (newFormId == this._formId){
			return;
		}
		//$("#kampylink").attr("href" ,this._replaceFormId($("#kampylink").attr("href"),newFormId));
		$("#kampyle").html(this._replaceFormId($("#kampyle").html(),newFormId));
		this._prevId=this._formId;
		this._formId = newFormId;
	},
	_replaceFormId : function(str, newFormId){
		var r = new RegExp(this._formId, "g");
		return str.replace(r,newFormId);
	},
	revertId: function(){
		if (this._prevId != '' && this._prevId != this._formId) {
			$("#kampyle").html(this._replaceFormId($("#kampyle").html(),this.prevId));
			this._formId = this._prevId;
			this._prevId='';
		}
	},
	updateTransId: function() {
		var transId = 0;
		try {
			if(typeof referenceNo !== 'undefined' && referenceNo.getTransactionID) {
				transId = referenceNo.getTransactionID(true);
			}
			else if (typeof Track !== 'undefined' && Track._getTransactionId) {
				transId = Track._getTransactionId();
			}
		} catch(err){}
		k_button.setCustomVariable(7891, transId);
	}
};
</go:script>

<go:script marker="onready">
	if(is_mobile_device() == true){
		$("#footer").prepend($("#kampyle"));
		$("#kampyle a").html("Feedback")
	}
</go:script>

<%--
<go:script marker="onready">
	k_button.setCustomVariable(269, "${pageContext.session.id}");
</go:script>
--%>
<%-- HTML --%>
<!--Start Kampyle Feedback Form Button-->

<div id="kampyle"><a href='https://www.kampyle.com/feedback_form/ff-feedback-form.php?site_code=7343362&amp;lang=en&amp;form_id=${formId}'  target='kampyleWindow' id='kampylink' class='k_static' onclick="javascript:Kampyle.updateTransId();k_button.open_ff('site_code=7343362&amp;lang=en&amp;form_id=${formId}');write_quote_ajax.write({triggeredsave:'kampyle'});return false;" title="Feedback"></a></div>
<input type="hidden" name="k_host_server" id="k_host_server" value="www.kampyle.com" />

<script src="common/js/k_button.js" type="text/javascript"></script>
<script src="common/js/k_push.js" type="text/javascript"></script>