;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var $component,
		_formId = '',
		_prevId = '';

	function setFormId(newFormId) {
		if (isKampyleEnabled() === false) return;
		if (newFormId === _formId) {
			return;
		}

		$component.html(replaceFormId($component.html(), newFormId));
		_prevId = _formId;
		_formId = newFormId;
	}

	function revertId() {
		if (isKampyleEnabled() === false) return;
		if (_prevId !== '' && _prevId !== _formId) {
			$component.html(replaceFormId($component.html(), _prevId));
			_formId = _prevId;
			_prevId = '';
		}
	}

	function replaceFormId(str, newFormId) {
		if (isKampyleEnabled() === false) return;
		var r = new RegExp(_formId, 'g');
		return str.replace(r, newFormId);
	}

	function updateTransId() {
		if (isKampyleEnabled() === false) return;
		var transId = 0;

		try {
			if(typeof meerkat !== 'undefined') {
				transId = meerkat.modules.transactionId.get();
			} else if (typeof Track !== 'undefined' && Track._getTransactionId) {
				transId = Track._getTransactionId();
			}
		}
		catch(err) {}

		k_button.setCustomVariable(7891, transId);
	}

	function init() {
		$(document).ready(function () {
			$component = $('#kampyle');

			if (isKampyleEnabled() === false) return;


			// Move into the footer (so XS styles work properly)
			$component.prependTo($('#footer .container'));

			// Get form ID from the data attribute
			if ($component.attr('data-kampyle-formid')) {
				_formId = $component.attr('data-kampyle-formid');
			}

			// Hook up link
			$component.on('click', '#kampylink', function kampyleLink(event) {
				updateTransId();

				if (typeof k_button !== 'undefined') {
					event.preventDefault();
					k_button.open_ff('site_code=7343362&lang=en&form_id=' + _formId);
				}

				meerkat.modules.writeQuote.write({triggeredsave:'kampyle'});
			});
		});
	}

	function isKampyleEnabled(){
		if ($component.length === 0){
			return false;
		}

		return true;
	}

	meerkat.modules.register("kampyle", {
		init: init,
		setFormId: setFormId
	});

})(jQuery);
