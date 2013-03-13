<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Create kamplye button"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="formId" 	required="true"	 rtexprvalue="true"	 description="Kampyle Form Id" %>

<go:style marker="css-href" href="common/kampyle/css/k_button.css" />
<go:style marker="css-head">
#kampyle {
    top: 40%;
    position:fixed;
    right: 0;
    z-index: 2;
}
</go:style>
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
			if (typeof Track !== 'undefined' && Track._getTransactionId) {
				transId = Track._getTransactionId();
			}
		} catch(err){}
		k_button.setCustomVariable(7891, transId);
	}
};


</go:script>

<%--
<go:script marker="onready">
	k_button.setCustomVariable(269, "${pageContext.session.id}");
</go:script>
 --%>
<%-- HTML --%>
<!--Start Kampyle Feedback Form Button-->

<div id="kampyle"><a href='https://www.kampyle.com/feedback_form/ff-feedback-form.php?site_code=7343362&amp;lang=en&amp;form_id=${formId}'  target='kampyleWindow' id='kampylink' class='k_static' onclick="javascript:Kampyle.updateTransId();k_button.open_ff('site_code=7343362&amp;lang=en&amp;form_id=${formId}');return false;"><img src="common/kampyle/images/feedback.png" alt="Feedback Form" border="0"/></a></div>

<script src="common/kampyle/js/k_button.js" type="text/javascript"></script>
<script src="common/kampyle/js/k_push.js" type="text/javascript"></script>