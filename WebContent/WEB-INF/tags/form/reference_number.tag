<%@ tag description="The reference number aka transaction number for the quote"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" 			required="true" rtexprvalue="true"	 	description="The vertical the quote is associated with" %>
<%@ attribute name="id" 				required="false" rtexprvalue="true"	 	description="ID for the element - defaults to 'reference_number'" %>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 	description="additional css class attribute" %>
<%@ attribute name="label" 				required="false" rtexprvalue="true"	 	description="Label for the field - defaults to 'Reference Number'" %>
<%@ attribute name="showReferenceNo" 	required="false" rtexprvalue="true"		description="Flag whether to display the reference number" %>

<c:if test="${empty id}">
	<c:set var="id" value="reference_number" />
</c:if>

<c:if test="${empty label}">
	<c:set var="label" value="Reference No. " />
</c:if>

<c:if test="${empty showReferenceNo}">
	<c:set var="showReferenceNo" value="true" />
</c:if>

<%-- HTML --%>
<div id="${id}" class="${className}">
	<h4>${label}<span>${data.current.transactionId}</span></h4>
	<a href="javascript:void(0);" id="header-save-your-quote" class="bigbtn"><span>Save Quote</span></a>
</div>

<%-- CSS --%>
<go:style marker="css-head">
#${id} {
	display:			none;
	position:			relative;
	width: 				230px;
	height: 			80px;
	float: 				right;
	top:				177px;
	z-index:			1000;
	background: 		transparent url(brand/ctm/images/bg_reference_no_tall.png) center center no-repeat;
}

#${id} h4 {
	font-size:			14px;
	color: 				#1C3F94;
	text-align:			center;
	margin-top:			10px;
	line-height:		20px;
	font-weight:		normal;
}

#${id} h4 span {
	font-size:			150%;
}

#${id} a {
	position:			absolute;
	top:				38px;
	left:				60px;
	width: 				98px;
	cursor: 			pointer;
}

#${id} a span {
	width: 				100%;
}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var ReferenceNo = {

	transaction_id : 	"${data.current.transactionId}",
	elements : 			{},
	speed : 			300,
	
	_FLAG_PRESERVE : 1,
	_FLAG_INCREMENT : 2,
	_FLAG_RESET : 3,
	_FLAG_DEFAULT : false,
	
	init : function()
	{
		elements = {
			root :	$("#${id}"),
			num :	$("#${id}").find("span").first(),
			save :	$("#header-save-your-quote")
		};
		
		elements.save.on("click", function(){
			SaveQuote.setToMySQL().show();
		});
		
		ReferenceNo.render();
	},
	
	overrideSave : function( callback ) {
		elements.save.off("click");
		elements.save.on("click", callback);
	},
	
	getTransactionID : function( flag )
	{
		flag = flag || ReferenceNo._FLAG_DEFAULT;
		
		if( flag !== ReferenceNo._FLAG_DEFAULT || ReferenceNo.transaction_id == false )
		{
			ReferenceNo.transaction_id = String(ReferenceNo.retrieveTransactionID( flag ));
			ReferenceNo.render();
		}
		
		ReferenceNo.updateSimples();
		
		return ReferenceNo.transaction_id;
	},
	
	update : function( tran_id, flag )
	{
		tran_id = tran_id || false;
		flag = flag || ReferenceNo._FLAG_DEFAULT;
		
		if( tran_id !== false )
		{
			if( typeof tran_id == "number" || (typeof tran_id == "object" && tran_id.constructor === String) )
			{
				ReferenceNo.transaction_id = String(tran_id);
			}
		}
		else
		{
			ReferenceNo.transaction_id = ReferenceNo.getTransactionID( flag );
		}
		
		ReferenceNo.updateSimples();
		
		ReferenceNo.render();
	},
	
	updateSimples : function()
	{
		if( typeof parent.QuoteComments == "object" && parent.QuoteComments.hasOwnProperty("_transactionid") )
		{
			parent.QuoteComments._transactionid = ReferenceNo.transaction_id;
		}
	},
	
	hide : function()
	{
		if( elements.root.is(":visible") )
		{
			elements.root.fadeOut(ReferenceNo.speed);
		}
	},
	
	show : function()
	{
		<c:if test="${showReferenceNo eq 'true'}">
			if( !elements.root.is(":visible") )
			{
				elements.root.fadeIn(ReferenceNo.speed);
			}
		</c:if>
	},
	
	render : function()
	{
		try{
			if( ReferenceNo.transaction_id.length )
			{
				elements.num.empty().append( ReferenceNo.transaction_id );
				ReferenceNo.show();
			}
			else
			{
				ReferenceNo.hide();
			}
		}
		catch(e)
		{
			// ignore
		}
	},
	
	retrieveTransactionID : function( flag ) {
	
		flag = flag || ReferenceNo._FLAG_DEFAULT;
		
		switch(flag) {
			case ReferenceNo._FLAG_PRESERVE:
				flag = 'preserve_tranId';
				break;
			case ReferenceNo._FLAG_INCREMENT:
				flag = 'increment_tranId';
				break;
			case ReferenceNo._FLAG_RESET:
				flag = 'reset_tranId';
				break;
			case ReferenceNo._FLAG_DEFAULT:
			default:
				// IGNORE AND MOVE ON
				break;
		}
		
		var dat = {quoteType:"${quoteType}"};
		
		if( flag !== ReferenceNo._FLAG_DEFAULT ) {
			dat.id_handler = flag;
		}
		
		var transId = '';
		$.ajax({
			url: "ajax/json/get_transactionid.jsp",
			dataType: "json",
			data: dat,
			type: "GET",
			async: false,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(msg){
				transId = msg.transactionId;
			},
			error: function(obj, txt){
				transId = ReferenceNo.transaction_id;
			},
			timeout: 20000
		});
		
		return String(transId);			
	}
};
</go:script>

<go:script marker="onready">
ReferenceNo.init();
</go:script>
