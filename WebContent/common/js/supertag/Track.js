var Track = new Object();
Track = {
	_type: '',
	_lastTouch: '',
	_pageName: '',
	_transactionID: 0,

	init: function(type,pageName){
		this._type=type;
		this.setPageName(pageName);
		this._addLastTouch();
		if (!typeof s==='undefined'){
			s.pageName=pageName;
		}
	},
	saveRetrieve: function(action, tranId){
		try {
			superT.trackQuoteEvent({
				action: action,
				transactionID: tranId,
				brandCode: window.Settings.brand
			});
		} catch(err){}
	},
	transferInit: function(phoneOnline, quoteRef, tranId, prodId){
		try {
			superT.trackHandoverType({
				type: phoneOnline,
				quoteReferenceNumber: quoteRef,
				transactionID: tranId,
				productID:prodId,
				brandCode: window.Settings.brand
			});
		} catch(err){}
	},
	transfer: function(quoteRef, tranId, prodId){
		try {
			superT.trackHandover({
				quoteReferenceNumber: quoteRef,
				transactionID: tranId,
				productID:prodId,
				brandCode: window.Settings.brand
			});
		} catch(err){}
	},
	offerTerms: function(prodId){
		try {
			superT.trackOfferTerms({
				productID: prodId,
				brandCode: window.Settings.brand
			});
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
			superT.trackQuoteProductList({
				products:prodArray,
				brandCode: window.Settings.brand
			});
			superT.trackQuoteForms({
				paymentPlan: '',
				preferredExcess: '',
				sortEnvironment: '',
				sortDriveLessPayLess: '',
				sortBestPrice: '',
				sortOnlineOnlyOffer: '',
				sortHouseholdName: '',
				event: '',
				brandCode: window.Settings.brand
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
		var transId = 0;
		if(Track._getTransactionId){
			transId = Track._getTransactionId();
		} else if (typeof meerkat !== "undefined"){
			transId = meerkat.modules.transactionId.get();
		} else if (typeof referenceNo !== 'undefined' && referenceNo.getTransactionID) {
			transId = referenceNo.getTransactionID(false);
		}

		if (typeof superT !== 'undefined'){
			superT.contactCentreUser({
				contactCentreID: userId,
				quoteReferenceNumber : '',
				transactionId: transId,
				productID: '',
				brandCode: window.Settings.brand
			});
		}
	},
	splitTest : function(version, splitTestName) {
		var stObj = {
			version: version,
			splitTestName: splitTestName,
			brandCode: window.Settings.brand
		};
		try {
			superT.splitTesting(stObj);
		} catch(err){}
	}
};