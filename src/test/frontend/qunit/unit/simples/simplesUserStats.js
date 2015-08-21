$(function () {

	module( "meerkat.modules.simplesUserStats" );

	QUnit.test( "Should disable timer", function(assert) {
		var outcome = meerkat.modules.simplesUserStats.setInterval(0);
		ok(outcome === 0, "Intervals should be zero");
	});

	QUnit.test( "Should get data", function(assert) {
		var originalGet = meerkat.modules.comms.get;

		// Override comms to return mock data
		meerkat.modules.comms.get = function() {
			var json = {"completed":7,"unsuccessful":29,"postponed":99,"contact":57,"sales":2,"conversion":12.2,"active":12,"future":6};
			return $.Deferred().resolve(json).promise();
		};

		var deferred = meerkat.modules.simplesUserStats.refresh();
		ok(typeof deferred === 'object', "refresh() returns a Deferred promise");

		deferred.always(function refreshComplete(json) {
			var valid = (typeof json === 'object'
				&& json.hasOwnProperty('completed') && _.isNumber(json.completed)
				&& json.hasOwnProperty('unsuccessful') && _.isNumber(json.unsuccessful)
			);
			ok(valid, "Completed refresh and has valid data object");
		});

		// Restore comms
		meerkat.modules.comms.get = originalGet;
	});

});
