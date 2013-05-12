var Track = new Object();
Track = {
	_type: '',
	_lastTouch: '',
	_pageName: '', 

	init: function(type,pageName){
		this._type=type;
		this.setPageName(pageName);
		this._addLastTouch();
		if (!typeof s==='undefined'){
			s.pageName=pageName;
		}
	},
	saveRetrieve: function(action, tranId){
		PageLog.log("SaveQuote");
		try {
			superT.trackQuoteEvent({
				action: action, 
				transactionID: tranId
			});
		} catch(err){}
	},
	transferInit: function(phoneOnline, quoteRef, tranId, prodId){
		if (phoneOnline=='ONLINE'){
			PageLog.log("ApplyOnline");
		} else {
			PageLog.log("ApplyByPhone");
		}
		try {
			superT.trackHandoverType({
				type: phoneOnline,
				quoteReferenceNumber: quoteRef,
				transactionID: tranId,
				productID:prodId
			});
		} catch(err){}
	},
	transfer: function(quoteRef, tranId, prodId){
		try {
			superT.trackHandover({
				quoteReferenceNumber: quoteRef,
				transactionID: tranId,
				productID:prodId
			});
		} catch(err){}
	},
	offerTerms: function(prodId){
		try {
			superT.trackOfferTerms({productID: prodId});
		} catch(err){}
	},
	exit: function(){
		try {
			superT.trackLastTouch(this._lastTouch);
		} catch(err){}
	},
	resultsShown: function(eventType){
		var prodArray=new Array();
		for (var i in Results._currentPrices){
			prodArray[i]={
				productID : Results._currentPrices[i].productId,
				ranking : i+1
			};
		}
		try {
			superT.trackQuoteProductList({products:prodArray});
			superT.trackQuoteForms({
				paymentPlan: '',
				preferredExcess: '',
				sortEnvironment: '',
				sortDriveLessPayLess: '',
				sortBestPrice: '',
				sortOnlineOnlyOffer: '',
				sortHouseholdName: '',
				event: ''
			});
		} catch(err){}
	},
	lastTouch: function(fld){
		this._lastTouch = $(fld).attr('title')?$(fld).attr('title'):$(fld).attr('name');
	},
	_addLastTouch: function(){
		$('input, select, textarea').filter(':input').focus(function(){
			Track.lastTouch(this);
		});
	},
	setPageName: function(pageName){
		this._pageName = pageName;
	},
	getPageName : function(){
		return s.pageName;
	},
	trackUser: function(userId){
		if(Track._getTransactionId){
			if (!typeof superT === 'undefined'){
				superT.contactCentreUser({
					contactCentreID: userId,
					quoteReferenceNumber : '',
					transactionId: Track._getTransactionId(),
					productID: ''
				});
			}
		}
	}
};