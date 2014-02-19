var Track_Features = new Object();

Track_Features = {

	init: function( vertical ){

		Track.init(vertical,'Select');

		// Only one stage for LMI journey - don't need to track next button clicks.
		var stObj={
			vertical: this._type,
			actionStep: "Select"
		};

		try {
			//console.log("SUPERTAG - SELECT - PLEASE REMOVE ME");
			superT.trackQuoteForms(stObj);
		} catch(err){}


		Track.resultsShown=function(eventType){

			try {

				var productsArray = Track_Features.getDisplayedProducts();
				superT.trackFeaturedProducts({products:productsArray});
				superT.trackQuoteForms({
					paymentPlan: '',
					preferredExcess: '',
					sortEnvironment: '',
					sortDriveLessPayLess: '',
					sortBestPrice: '',
					sortOnlineOnlyOffer: '',
					sortHouseholdName: '',
					sortPaymentFrequency: '',
					event: eventType
				});

			} catch(err){
				Track_Features.onError("Track.resultsShown: "+err);
			}

			//console.log("SUPERTAG - RESULTS - PLEASE REMOVE ME: ", productsArray);
		};

		Track.compareClicked= function(){
			try {

				Write.touchQuote('H', false, 'CompareProducts');

				var productsArray = Track_Features.getDisplayedProducts();
				superT.trackCompareFeatures({ products: productsArray });

			} catch(err){
				Track_Features.onError("Track.compareClicked: "+err);
			}

			//console.log("SUPERTAG - COMPARE - PLEASE REMOVE ME",productsArray);

		};

	},

	getDisplayedProducts:function(){
		var productsArray=new Array();
		var positionCounter = 1;
		for (var i in Results.model.sortedProducts){
			var item = Results.model.sortedProducts[i];
			var isDisplayed = Results.isResultDisplayed(item);
			if(isDisplayed){
				productsArray.push({product:item.brandName+" - "+item.policyName, ranking:positionCounter});
				positionCounter++;
			}
		}

		return productsArray;
	},

	trackBrandSelection:function(brands){

		try {

			var brandsArray=new Array();
			for (var b in brands){
				brandsArray.push({brand:brands[b]});
			}
			superT.trackBrandComparison({ brands: brandsArray });

		} catch(err){
			Track_Features.onError("Track_Features.trackBrandSelection: "+err);
		}

		//console.log("SUPERTAG - BRANDS - PLEASE REMOVE ME",brandsArray);
	},

	onError:function(message){
		try{
			//NonFatalError.exec({message:message, page:"carBrands.jsp"}); // put back later
		}catch(err){

		}
	}

};