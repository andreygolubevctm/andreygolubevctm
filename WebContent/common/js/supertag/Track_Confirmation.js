var Track_Confirmation = {

	init: function() {
		Track.init('Confirmation','Confirmation');

		Track.onQuoteEvent = function(action, tran_id) {
			try {
				tran_id = tran_id || ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(false) );

				superT.trackQuoteEvent({
					action: 		action,
					transactionID:	parseInt(tran_id, 10),
					brandCode: window.Settings.brand
				});
			}
			catch(err) {
				/* IGNORE */
			}
		};
					}
};