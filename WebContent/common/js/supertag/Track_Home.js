var Track_Home = new Object();

Track_Home = {
		_brand: 'ctm',
		_coverType: '',
		_furtherestStep: 0,
		_email:null,
		_usedLeads:null,
		init: function() {
			Track.init('Home_Contents' , 'Cover Start');

			Track_Home._brand = 'ctm';
			Track_Home._furtherestStep = 0;
			Track_Home._email = {
				address: '',
				id: ''
			};
			Track_Home._usedLeads = [];


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

				var callScheduled = false;

				var actionStep='';
				Track.getCoverType();

				switch(stage){
					case 0:
					case 'start':
						actionStep='Cover';
					break;
				case 1:
						actionStep='Occupancy';
					break;
				case 2:
						actionStep='Property';
					break;
				case 3:
						actionStep='You';
					break;
				case 4:
						actionStep='History';
					break;
					case 5:
						actionStep='Results';
						break;
					case 6:
						actionStep='MoreInfo';
						break;
					default:
						return;
						break;
				}

				if(stage > Track_Home._furtherestStep) {
					Track_Home._furtherestStep = stage;
				}

				var tranId = Track._getTransactionId();

				var response =  {
						vertical:				this._type,
						brandCode:				Track_Home._brand,
						actionStep:				actionStep,
						transactionID:			tranId,
						quoteReferenceNumber:	tranId,
						yearOfManufacture:		null,
						makeOfCar:				null,
						gender:					null,
						yearOfBirth:			null,
						postCode:				null,
						state:					null,
						email:					null,
						emailID:				null,
						marketOptIn:			null,
						okToCall:				null,
						coverType:				null
				};

				var trackCall = function(data) {

					Track.logData("superT.trackQuoteForms", data);

					try {
						superT.trackQuoteForms( data );
					} catch(err) {
						/* IGNORE */
					}

				};

				if(Track_Home._furtherestStep > 0) {
					response.coverType = this._coverType.substring(1);
					response.postCode = $('#home_property_address_postCode').val();
					response.state = $('#home_property_address_state').val();
				}

				if(Track_Home._furtherestStep > 3) {
					response.yearOfBirth = $('#home_policyHolder_dob').val().split('/').pop();
					response.email = $('#home_policyHolder_email').val();
					response.marketOptIn = $('input[name=home_policyHolder_marketing]:checked').val();
					response.okToCall = $('input[name=home_policyHolder_oktocall]:checked').val();

					var title = $('#home_policyHolder_title').val();
					if(title != '' && title.length) {
						response.gender = title.toUpperCase() == 'MR' ? 'M' : 'F';
					}

					if(response.email != '' && response.email.length) {
						if(response.email == Track_Home._email.address && Track_Home._email.id != '') {
							response.emailID = Track_Home._email.id;
						} else {
							callScheduled = true;
							Track._getEmailId(response.email, response.marketOptIn, response.okToCall, function(emailId){
								response.emailID = emailId;
								Track_Home._email.address = response.email;
								Track_Home._email.id = emailId;
								trackCall(response);
							});
						}
					}
				}

				if(callScheduled === false) {
					trackCall(response);
				}
			};

			Track.quoteProductList = function(){

				var productArray = new Array();
				var j = 0;
				var results = Results.getFilteredResults();
				for(var i = 0; i < results.length; i++) {
					if(results[i].productAvailable == 'Y') {
					var rank = 1 + parseInt(j);
					productArray[j] = {
						productID : results[i].productId,
							ranking : rank
						};
						j++;
					}
				}

				var data = {
						brandCode:Track_Home._brand,
						vertical:this._type,
						products:productArray
				};

				Track.logData("superT.trackQuoteProductList", data);

				try {
					superT.trackQuoteProductList(data);
				} catch(err){}
			};

			Track.quoteList = function(eventType){

				var data = {
						brandCode:Track_Home._brand,
						vertical:this._type,
						event:eventType,
						display:Results.getDisplayMode(),
						paymentPlan:Results.getFrequency(),
						homeExcess:'0',
						contentsExcess:'0'
				};

				if(this._coverType.toLowerCase().indexOf('home') != -1) {
					data.homeExcess = $('#home_homeExcess').val();
				}

				if(this._coverType.toLowerCase().indexOf('content') != -1) {
					data.contentsExcess = $('#home_contentsExcess').val();
				}

				Track.logData("superT.trackQuoteList", data);

				try {
					superT.trackQuoteList(data);
				} catch(err){}
			};

			/* @Override resultsShown */
			Track.resultsShown = function(eventType) {
				try {
					Track.getCoverType();

					Track.quoteProductList();

					Track.quoteList(eventType);

					Track.nextClicked(5);
				} catch(err){}
			};

			Track.resultsSorted = function(eventType) {
				try {
					Track.getCoverType();

					Track.quoteProductList();

					Track.quoteList(eventType);
				} catch(err){}
			};

			Track.viewProduct = function(productId) {
				var data = {
						brandCode:Track_Home._brand,
						vertical:this._type,
						productID: productId
				};

				Track.logData("superT.trackProductView", data);

				try {
					superT.trackProductView (data);
					Track.nextClicked(6);
				} catch(err){}
			};

			Track.offerTerms = function(prodId){

				var data = {
						productID: prodId,
						brandCode: window.Settings.brand
				};

				Track.logData("superT.trackOfferTerms", data);

				try {
					superT.trackOfferTerms(data);
				} catch(err){}
			},

			Track.handOver = function(productId, leadRef) {

				var tranId = Track._getTransactionId();

				var handOverData = {
						brandCode:Track_Home._brand,
						vertical:this._type,
						quoteReferenceNumber: leadRef, // lead number
						transactionID: tranId,
						productID: productId
				};

				var handOverTypeData = $.extend({type:"ONLINE"}, handOverData);

				Track.logData("superT.trackHandover", handOverData);
				Track.logData("superT.trackHandoverType", handOverTypeData);

				try{
					superT.trackHandover(handOverData);
					superT.trackHandoverType(handOverTypeData);
				}catch(e){}
			};

			Track.callDirect = function(leadRef, productId, elementId) {

				// Confirm if leadRef has been submitted previously
				var leadUsed = false;
				for(var i=0; i<Track_Home._usedLeads.length; i++) {
					var info = Track_Home._usedLeads[i];
					if(info == leadRef) {
						leadUsed = true;
					}
				}

				if(leadUsed === false) {

					Track_Home._usedLeads.push(leadRef);

					var tranId = Track._getTransactionId();

					var data = {
							brandCode:Track_Home._brand,
							vertical:this._type,
							quoteReferenceNumber: leadRef, // lead number
							transactionID: tranId,
							productID: productId,
							type: elementId
					};

					Track.logData("superT.trackBridgingClick", data);

					try{
						superT.trackBridgingClick (data);
					}catch(e){}
				} else {
					// Ignore - lead feed already submitted
				}

			};

			Track.startSaveRetrieve = function(transId, action, step) {

				var data = {
						brandCode:Track_Home._brand,
						vertical:this._type,
						action: action,
						transactionID: transId,
						actionStep: step
				};

				Track.logData("superT.trackQuoteEvent", data);

				try {
					superT.trackQuoteEvent(data);
				} catch(err){}
			};

			Track.compareClicked= function() {

				var data = [];
				for(var i=0; i<Compare.model.products.length; i++) {
					data.push({
						productID:Compare.model.products[i].id
					});
				};

				Track.logData("superT.trackQuoteComparison", data);

				try {
					superT.trackQuoteComparison({ products: data });
				} catch(err){}

			};

			Track._getEmailId = function(emailAddress,marketing,oktocall,callback) {
				var emailId = '';
				var mkt = (marketing) ? 'Y' : 'N';
				var ok = (oktocall) ? 'Y' : 'N';
				if(emailAddress) {
					
					var data = {
						email:emailAddress,
						m:mkt,
						o:ok,
						transactionId:referenceNo.getTransactionID()
					};
					
					$.ajax({
						url: "ajax/json/get_email_id.jsp",
						data: data,
						type: "POST",
						async: true,
						dataType: "json",
						success: function(msg){
							callback(msg.emailId);
						},
						timeout: 20000
					});

					return emailId;
				}
			};

			Track._getTransactionId = function(reset) {
				reset = (reset===true) ? true : false;
				return ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(reset) );
			};

			Track.logData = function() {
				try {
					if(window.location.protocol != "https:") {
						if(typeof console === 'object' && typeof console.info === 'function') {
							if(arguments.length) {
								console.info(arguments);
							}
						}
					}
				} catch(e) { /* IGNORE */ }
			};
		}
	};