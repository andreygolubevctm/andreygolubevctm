var Track_Roadside = new Object();

Track_Roadside = {
	init: function(){
		Track.init('Roadside','Your Car');

		/* Tracking extensions for Roadside Quotes (extend the object - no need for prototype extension as there should only ever be one Track */
		Track.nextClicked = function(stage){
			try {
				superT.trackQuoteForms({
					vertical: this._type,
					actionStep: stage,
					yearOfBirth: '',
					gender: '',
					postCode: '',
					state: $('#roadside_riskAddress_state').val(),
					yearOfManufacture: $('#roadside_vehicle_year').val(),
					makeOfCar: $('#roadside_vehicle_make option:selected').text(),
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