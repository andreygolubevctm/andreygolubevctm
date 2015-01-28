var Track_Fuel = new Object();

Track_Fuel = {
	init: function(){
		Track.init('Fuel','Fuel Details');

		/* Tracking extensions for Travel Quotes (extend the object - no need for prototype extension as there should only ever be one Track */
		Track.nextClicked = function(stage){

			Track.runTrackingCall('trackQuoteForms', {
				vertical: this._type,
				actionStep: stage,
				yearOfBirth: '',
				gender: '',
				postCode: '',
				state: '',
				yearOfManufacture: '',
				makeOfCar: '',
				emailID: null,
				email: null,
				destinationCountry: '',
				travelInsuranceType: '',
				marketOptIn: '',
				okToCall: ''
			});
		};

		Track.mapOpened = function() {
			Track.runTrackingCall('trackCustomPage', {customPage: "Fuel:Map"});
		};
	}
};