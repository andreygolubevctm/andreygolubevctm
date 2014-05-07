var Track_Home = new Object();

Track_Home = {
		_coverType: '',
		init: function() {
			Track.init('Home_Contents' , 'Cover Start');
			Track.getCoverType = function (){
				switch($('#home_coverType').val()){
					case "Home Cover Only":
						this._coverType=':Home Only';
						break;
					case "Contents Cover Only":
						this._coverType=':Contents Only';
						break;
					case "Home & Contents Cover":
						this._coverType=':Home & Contents';
						break;
					default:
						this._coverType='';
				}
			};
			Track.nextClicked = function(stage){
				var actionStep='';
				Track.getCoverType();

				switch(stage){
					case 0:
					case 'start':
						actionStep='Cover'+this._coverType;
						PageLog.log("Cover"+this._coverType);
					break;
				case 1:
						actionStep='Occupancy'+this._coverType;
						PageLog.log("Occupancy"+this._coverType);
					break;
				case 2:
						actionStep='Property'+this._coverType;
						PageLog.log("Property"+this._coverType);
					break;
				case 3:
						actionStep='You'+this._coverType;
						PageLog.log("You"+this._coverType);
					break;
				case 4:
						actionStep='History'+this._coverType;
						PageLog.log("History"+this._coverType);
					break;
				}
				var stObj={
						vertical: this._type,
						actionStep: actionStep,
					};
				try {
					superT.trackQuoteForms( stObj );
				} catch(err) {
					/* IGNORE */
				}
			};

			/* @Override resultsShown */
			Track.resultsShown=function(eventType){
				PageLog.log("Results");
				var prodArray=new Array();
				var j=0;
				for (var i in Results._currentPrices){
					if (Results._currentPrices[i].available==='Y'){
						var rank=1+parseInt(j);
						prodArray[j]={
							productID : Results._currentPrices[i].productId,
							ranking : rank
						};
						j++;
					}
				}
				try {
					Track.getCoverType();
					superT.trackQuoteProductList({products:prodArray});

					superT.trackQuoteForms({
						paymentPlan: $('#quote_paymentType option:selected').text(),
						preferredExcess: $('#quote_excess option:selected').text(),
						sortEnvironment: Track._getSliderText('small-env'),
						sortDriveLessPayLess:  Track._getSliderText('small-payasdrive'),
						sortBestPrice: Track._getSliderText('small-price'),
						sortOnlineOnlyOffer: Track._getSliderText('small-onlinedeal'),
						sortHouseholdName: Track._getSliderText('small-household'),
						event: eventType,
						coverType: this._coverType
					});
				} catch(err){}
			};
			Track.compareClicked= function(){
				var prodArray=new Array();
				$('#basket .basket-items .item').each(function(i,obj){
					prodArray[i]={
						productID:$(this).attr('id').substring(19)
					};
				});
				PageLog.log("CompareProducts");
				try {
					superT.trackQuoteComparison({ products: prodArray });
				} catch(err){}

			};
			Track._getSliderText= function(sliderId){
				var s=$('#'+sliderId).prev('span');
				if (s.length >0){
					return s.text();
				} else {
					return '';
				}
			};
			Track._getEmailId = function(emailAddress,marketing,oktocall) {
				var emailId = '';
				var mkt = (marketing) ? 'Y' : 'N';
				var ok = (oktocall) ? 'Y' : 'N';
				if(emailAddress) {
					
					var dat = {
						s:'CTCQ', 
						email:emailAddress, 
						m:mkt, 
						o:ok,
						transactionId:referenceNo.getTransactionID()
					};
					
					$.ajax({
						url: "ajax/json/get_email_id.jsp",
						data: dat,
						type: "GET",
						async: false,
						dataType: "json",
						success: function(msg){
							emailId = msg.emailId;
						},
						timeout: 20000
					});
					return emailId;
				}
			};
			Track._getTransactionId = function( reset ) {
				reset = (reset===true) ? true : false;
				return ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(reset) );
			};

			Track.startSaveRetrieve = function(transId, action, step) {
				var stObj={
						action: action,
						transactionID: transId,
						actionStep: step
					};
				try {
					superT.trackQuoteEvent(stObj);
				} catch(err){}
			};

			Track.onApplyClick = function( product ){
				try{
					superT.trackHandoverType({
						type: 				"Online",
						quoteReferenceNumber: product.transactionId,
						transactionID: 		product.transactionId,
						productID: 			product.productId
					});
				}
				catch(err){
					//console.log(err);
				}
			};
			Track.quoteLoadRefresh = function(eventType){
				superT.trackQuoteList ({
					event: eventType
				});
			};
		}
	};