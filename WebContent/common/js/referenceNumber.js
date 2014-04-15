	function ReferenceNo(idIn, showReferenceNoIn, quoteTypeIn){


		/** private variables **/
		var showReferenceNo= showReferenceNoIn;
		var quoteType = quoteTypeIn;
		var transaction_id = 0;
		var elements = {};
		var speed = 300;
		var id  = idIn;

		/** public methods **/
		this.showReferenceNo = showReferenceNoIn;

		this.overrideSave = function( callback ) {
			elements.save.off("click");
			elements.save.on("click", callback);
		};

		this.setTransactionId = function( transId ) {
			transaction_id = transId;
			render();
			updateSimples();
		};

		/**
			setting fetchFromServer to true will make a synchronous ajax call to
			get the transaction. Try to do this bundled up in another call if you can eg touch quote.
			If you can't call this method.
		 **/
		this.getTransactionID = function( fetchFromServer, callback ) {
			if(fetchFromServer) {
				callGetTransactionIdAJAX(false, 'preserve_tranId', 3, callback);
			}
			return transaction_id;
		};

		/**
			makes an asynchronous ajax call that increments the transaction
			Try to do this bundled up in another call if you can
		 **/
		this.generateNewTransactionID = function(retryAttempts, callBack) {
			this.waitingOnNewTransactionId = true;
			callGetTransactionIdAJAX(true ,'increment_tranId' , retryAttempts, function(transactionId) {
				referenceNo.cancelGenerateNewTransactionID();
				if( typeof callBack == "function" ) {
					callBack(transactionId);
				}
			})
		};

		this.cancelGenerateNewTransactionID = function() {
			this.waitingOnNewTransactionId = false;
		};

		var that = this;
		this.init = function() {
			elements = {
				root :	$("#" + id),
				num :	$("#" + id).find("span").first(),
				save :	$("#header-save-your-quote")
			};

			that.elements = elements;

			if (typeof SaveQuote !== 'undefined' && SaveQuote.show) {
				elements.save.on("click", SaveQuote.show);
			}

			this.waitingOnNewTransactionId = false;
			render();
		};

		/** private methods **/

		var updateSimples = function() {
			try{
				if( typeof parent.QuoteComments == "object" && parent.QuoteComments.hasOwnProperty("_transactionid") ) {
					parent.QuoteComments._transactionid = transaction_id;
				}
			}catch(e){
			
			}
		};

		var callGetTransactionIdAJAX = function(isAsync , actionId , retryAttempts, ajaxCallBack) {
			var dat = {quoteType:quoteType};
			dat.id_handler = actionId;
			dat.transactionId = transaction_id; // need to send the 'current' transaction id. (if sending this to change the id)
			$.ajax({
				url: "ajax/json/get_transactionid.jsp",
				dataType: "json",
				async: isAsync,
				data: dat,
				type: "GET",
				cache: false,
				beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
				},
				success: function(msg) {
					transId = msg.transactionId;
					transaction_id = transId;
					render();
					updateSimples();
					if( typeof ajaxCallBack == "function" ) {
						ajaxCallBack(transId);
					}
				},
				error: function(obj, txt, errorThrown) {
					if (retryAttempts > 0 && this.waitingOnNewTransactionId) {
						this.callGetTransactionIdAJAX(actionId , retryAttempts - 1 , ajaxCallBack);
					} else {
						FatalErrorDialog.display({
							message:		"An undefined error has occurred - please try again later.",
							page:			"reference_number.tag",
							description:	"ReferenceNo.generateNewTransactionID(). AJAX request returned an error: " + txt + ' ' + errorThrown + ". Original transaction id: " + transaction_id
						});
						if( typeof ajaxCallBack == "function" ) {
							ajaxCallBack(0);
						}
					}
				},
				timeout: 10000
			});
		};

		var hide = function() {
			if( elements.root.is(":visible") )
			{
				elements.root.fadeOut(speed);
			}
		};

		var show = function() {
			if(showReferenceNo && !elements.root.is(":visible") ) {
				elements.root.fadeIn(speed);
			}
		};

		var render = function() {
			try {
				if( transaction_id.length || transaction_id > 0 ) {
					elements.num.empty().append( transaction_id );
					show();
				} else {
					hide();
				}
			}
			catch(e)
			{
				// ignore
			}
		};
	};