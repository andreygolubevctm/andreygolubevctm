var Track_Fuel = new Object();

Track_Fuel = {
	init: function(){
		Track.init('Fuel','Fuel Details');
		
		/* Tracking extensions for Travel Quotes (extend the object - no need for prototype extension as there should only ever be one Track */
		Track.nextClicked = function(stage){
			try {
				superT.trackQuoteForms({
				    vertical: this._type,
				    actionStep: stage,
				    yearOfBirth: '',
				    gender: '',
				    postCode: '',
				    state: '',
				    yearOfManufacture: '',
				    makeOfCar: '',
				    emailID: '',
				    destinationCountry: '',
				    travelInsuranceType: '',
				    marketOptIn: '',
				    okToCall: ''
				});
			} catch(err){}
		};
	}
};