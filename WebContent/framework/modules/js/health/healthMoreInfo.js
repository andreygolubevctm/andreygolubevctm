/*
	More Info panel can be easily triggered by applying a class:

		<a href="javascript:;" class="more-info">More info</a>

	If you want the apply button to also display:

		<a href="javascript:;" class="more-info more-info-showapply">More info</a>

*/
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var events = {
			healthMoreInfo: {
				bridgingPage: {
					CHANGE: "BRIDGINGPAGE_CHANGE", // only triggered when state chages from open to closed or closed to open
					SHOW: "BRIDGINGPAGE_SHOW", // trigger on every show (i.e. even when switching from product to product => show to show)
					HIDE: "BRIDGINGPAGE_HIDE" // triggers on close
			}
			}
		},
		moduleEvents = events.healthMoreInfo;

	var template,
		htmlTemplate,
		product,
		modalId,
		isModalOpen = false,
		isBridgingPageOpen = false,
		$moreInfoElement,
		headerBarHeight;

	var topPosition;
	function updatePosition() {
		topPosition = $('.resultsHeadersBg').height();
	}

	function initMoreInfo() {

		$moreInfoElement = $(".moreInfoDropdown");

		jQuery(document).ready(function($) {

			if(meerkat.site.vertical != "health" || meerkat.site.pageAction == "confirmation") return false;

			// prepare compiled template
			template = $("#more-info-template").html();
			if( typeof(template) != "undefined" ){

				htmlTemplate = _.template(template);

				applyEventListeners();

				eventSubscriptions();

			}

		});

	}

	function applyEventListeners(){

		// RESULTS PAGE LISTENERS
			if( typeof Results.settings !== "undefined" ){

				if( meerkat.modules.deviceMediaState.get() != 'xs' ){
					$(Results.settings.elements.page).on("click", ".btn-more-info", openbridgingPageDropdown);
				} else {
					$(Results.settings.elements.page).on("click", ".btn-more-info", openModalClick);
				}

				// close bridging page
				$(Results.settings.elements.page).on("click", ".btn-close-more-info", closeBridgingPageDropdown);

			}

			// Close any more info panels when fetching new results
			$(document).on("resultsFetchStart", function onResultsFetchStart() {
				meerkat.modules.healthMoreInfo.close();
			});

		// MORE INFO GENERAL STUFF
			// Apply button in bridging page
			$(document.body).on("click", ".btn-more-info-apply", function applyClick(){
				var $this = $(this);

				$this.addClass('inactive').addClass('disabled');
				meerkat.modules.loadingAnimation.showInside($this, true);

				_.defer(function deferApplyNow() {

					// If a different product is selected, ensure the join declaration is unticked
					if (Results.getSelectedProduct() !== false && Results.getSelectedProduct().productId != $this.attr("data-productId")) {
						$('#health_declaration:checked').prop('checked', false).change();
					}

					// Set selected product
					Results.setSelectedProduct( $this.attr("data-productId") );
					var product = Results.getSelectedProduct();
					if (product) {
						meerkat.modules.healthResults.setSelectedProduct(product);

						healthFunds.load(product.info.provider, applyCallback);

						var transaction_id = meerkat.modules.transactionId.get();

						meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
							method: 'trackHandoverType',
							object: {
								type: "Online_R",
								quoteReferenceNumber: transaction_id,
								transactionID: transaction_id,
								productID: "productID"
							}
						});
					}
					else {
						applyCallback(false);
					}

				});//defer

			});

			// Add dialog on "promo conditions" links
			$(document.body).on("click", ".dialogPop", function promoConditionsLinksClick(){

				meerkat.modules.dialogs.show({
					title: $(this).attr("title"),
					htmlContent: $(this).attr("data-content")
				});

			});

		// APPLICATION/PAYMENT PAGE LISTENERS
			$(document.body).on("click", ".more-info", function moreInfoLinkClick(event){
				setProduct( meerkat.modules.healthResults.getSelectedProduct() );
				openModal();
			});

	}

	function applyCallback(success) {
		_.delay(function deferApplyCallback() {
			$('.btn-more-info-apply').removeClass('inactive').removeClass('disabled');
			meerkat.modules.loadingAnimation.hide($('.btn-more-info-apply'));
		}, 1000);

		if (success === true) {
			// send to apply step
			meerkat.modules.address.setHash('apply');
		}
	}

	function eventSubscriptions(){

		//On ANY breakpoint change, update the position variable.
		meerkat.messaging.subscribe(meerkatEvents.device.STATE_CHANGE, function breakPointChange(data) {
			updatePosition();
		});

		// Close when results page changes
			$(document).on("resultPageChange", function(){
				if( isBridgingPageOpen ){
					closeBridgingPageDropdown();
				}
			});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function bridgingPageEnterXsState(){
			if( isBridgingPageOpen ){
				// close dropdown/tab styled bridging page in case it's open when entering the xs breakpoint
				closeBridgingPageDropdown();
			}

			$(Results.settings.elements.page).off("click", ".btn-more-info");
			$(Results.settings.elements.page).on("click", ".btn-more-info", openModalClick);
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function bridgingPageLeaveXsState(){

			if( isModalOpen ){
				// hide the xs modal
				closeModal();
			}

			$(Results.settings.elements.page).off("click", ".btn-more-info");
			$(Results.settings.elements.page).on("click", ".btn-more-info", openbridgingPageDropdown);
		});

		meerkat.messaging.subscribe( moduleEvents.bridgingPage.SHOW, function(state){ adaptResultsPageHeight(state.isOpen); });
		meerkat.messaging.subscribe( moduleEvents.bridgingPage.HIDE, function(state){ adaptResultsPageHeight(state.isOpen); });

	}

	function show( target ){
		// show loading animation
		target.html( meerkat.modules.loadingAnimation.getTemplate() ).show();

		prepareProduct( function moreInfoShowSuccess(){

			var htmlString = htmlTemplate(product);

			// fade out loading anim
			target.find(".spinner").fadeOut();

			// append content
			target.html(htmlString);
			if(meerkat.site.emailBrochures.enabled){
				// initialise send brochure email button functionality
				initialiseBrochureEmailForm(product, target, $('#resultsForm'));
				populateBrochureEmail();
			}

			// Insert next_info_all_funds
			$('.more-info-content .next-info-all').html( $('.more-info-content .next-steps-all-funds-source').html() );

			var animDuration = 400;
			var scrollToTopDuration = 250;
			var totalDuration = 0;

			if( isBridgingPageOpen ){
				target.find(".more-info-content").fadeIn(animDuration);
				totalDuration = animDuration;
			} else {
				meerkat.modules.utilities.scrollPageTo('.resultsHeadersBg', scrollToTopDuration, -$("#navbar-main").height(), function(){
					target.find(".more-info-content").slideDown(animDuration);
				});
				totalDuration = animDuration + scrollToTopDuration;
			}

			isBridgingPageOpen = true;

			_.delay(function(){
				meerkat.messaging.publish(moduleEvents.bridgingPage.SHOW, {isOpen:isBridgingPageOpen});
				if( !isBridgingPageOpen ){
					//after we are done animating set position from the global.
					updatePosition();
					target.css({'top': topPosition});
				}
			}, totalDuration);

			meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
				method:'trackProductView',
				object:{
					productID: product.productId
				}
			});

		});

	}

	function adaptResultsPageHeight( isOpen ){
		if(isOpen){
			$(Results.settings.elements.page).css("overflow", "hidden").height( $moreInfoElement.outerHeight() );
		} else {
			$(Results.settings.elements.page).css("overflow", "visible").height("");
		}
	}

	function hide( target ){
		// unfade all headers
		$(Results.settings.elements.page).find(".result").removeClass("faded");

		// reset button to default one
		$('.btn-close-more-info').removeClass("btn-close-more-info").addClass("btn-more-info");

		target.slideUp(400, function hideMoreInfo(){
			target.html('').hide();
			isBridgingPageOpen = false;
			meerkat.messaging.publish(moduleEvents.bridgingPage.CHANGE, {isOpen:isBridgingPageOpen});
			meerkat.messaging.publish(moduleEvents.bridgingPage.HIDE, {isOpen:isBridgingPageOpen});
		});
	}

	function openModalClick( event ){
		var $this = $(this),
			productId = $this.attr("data-productId"),
			showApply = $this.hasClass('more-info-showapply');
		setProduct( Results.getResult("productId", productId), showApply );

		openModal();
	}

	function openModal(){
		prepareProduct( function moreInfoOpenModalSuccess(){

			var htmlString = "<form class='healthMoreInfoModel'>" + htmlTemplate(product) + "</form>";
			modalId = meerkat.modules.dialogs.show({
				htmlContent: htmlString,
				className: "modal-breakpoint-wide modal-tight",
				onOpen : function onOpen(id) {
					if(meerkat.site.emailBrochures.enabled){
						initialiseBrochureEmailForm(product, $('#'+id), $('#'+id).find('.healthMoreInfoModel'));
					}
				}
			});


			// Insert next_info_all_funds
			$('.more-info-content .next-info .next-info-all').html( $('.more-info-content .next-steps-all-funds-source').html() );

			// Move dual-pricing panel
			$('.more-info-content .moreInfoRightColumn > .dualPricing').insertAfter($('.more-info-content .moreInfoMainDetails'));

			isModalOpen = true;

			$(".more-info-content").show();

			meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
				method:'trackProductView',
				object:{
					productID: product.productId
				}
		});

		});
	}

	function initialiseBrochureEmailForm(product, parent, form) {
		var emailBrochuresElement = parent.find('.moreInfoEmailBrochures');
		emailBrochuresElement.show();
		meerkat.modules.emailBrochures.setup({
				emailInput : emailBrochuresElement.find('.sendBrochureEmailAddress'),
				submitButton : emailBrochuresElement.find('.btn-email-brochure'),
				form : form,
				marketing : emailBrochuresElement.find('.optInMarketing'),
				productData : [
						{name:"hospitalPDSUrl",value: product.promo.hospitalPDF},
						{name:"extrasPDSUrl",value: product.promo.extrasPDF},
						{name:"provider",value: product.info.provider},
						{name:"providerName",value: product.info.providerName},
						{name:"productName",value: product.info.productTitle},
						{name:"productId",value: product.productId},
						{name:"productCode",value: product.info.productCode},
						{name:"premium",value: product.premium[Results.settings.frequency].lhcfreetext},
						{name:"premiumText",value: product.premium[Results.settings.frequency].lhcfreepricing}
				],
				product : product,
				identifier: "SEND_BROCHURES" + product.productId,
				emailResultsSuccessCallback : function onSendBrochuresCallback(result, settings) {
					if(result.success) {
						parent.find('.formInput').hide();
						parent.find('.moreInfoEmailBrochuresSuccess').show();
						meerkat.modules.emailBrochures.tearDown(settings);
					} else {
						meerkat.modules.errorHandling.error({
							errorLevel:		'warning',
							message:		'Oops! Something seems to have gone wrong. Please try again by re-entering your email address or ' +
											'alternatively contact our call centre on ' + meerkat.site.content.callCentreHelpNumber +  ' and they\'ll be able to assist you further.',
							page:			'healthMoreInfo.js:onSendBrochuresCallback',
							description:	result.message,
							data:			product
						});
					}
				}
		});
	}

	function closeModal(){
		$('#'+modalId).modal('hide');
		isModalOpen = false;
	}

	function openbridgingPageDropdown(event){
		var $this = $(this);

		// fade all other headers
		$(Results.settings.elements.page).find(".result").addClass("faded");

		// reset all the close buttons (there should only be one) to default button
		$(".btn-close-more-info").removeClass("btn-close-more-info").addClass("btn-more-info");

		// unfade the header from the clicked button
		$this.parents(".result").removeClass("faded");

		// replace clicked button with close button
		$this.removeClass("btn-more-info").addClass("btn-close-more-info");

		var productId = $this.attr("data-productId"),
			showApply = $this.hasClass('more-info-showapply');

		setProduct( Results.getResult("productId", productId), showApply );

		// disable the fixed header
		meerkat.modules.resultsHeaderBar.disableAffixMode();

		// load, parse and show the bridging page
		show( $moreInfoElement );

	}

	function closeBridgingPageDropdown(event){
		hide($moreInfoElement);

		// re-enable the fixed header
		meerkat.modules.resultsHeaderBar.enableAffixMode();

		if (isModalOpen) {
			// hide the xs modal
			closeModal();
		}
	}

	function setProduct( productToParse, showApply ) {
		product = productToParse;

		if (product !== false) {
			if (showApply === true) {
				product.showApply = true;
			} else {
				product.showApply = false;
			}
		}


		return product;
	}

	function getOpenProduct(){
		if(isBridgingPageOpen === false) return null;
		return product;
	}

	function prepareProduct( successCallback ){
		prepareCover();
		prepareExternalCopy( successCallback );
	}

	//
	// Sort out inclusions, restrictions and hospital/extras for this product if not done already
	//
	function prepareCover() {
		if (typeof product.hospitalCover === "undefined") {
			// Ensure this is a Hospital product before trying to use the benefits properties
			if (typeof product.hospital !== 'undefined' && typeof product.hospital.benefits !== 'undefined') {

				prepareCoverFeatures( "hospital.benefits", "hospitalCover" );

				coverSwitch( product.hospital.inclusions.publicHospital, "hospitalCover", "Public Hospital");
				coverSwitch( product.hospital.inclusions.privateHospital, "hospitalCover", "Private Hospital");
			}
		}

		if (typeof product.extrasCover === "undefined") {
			// Ensure this is a Extras product before trying to use the benefits properties
			if (typeof product.extras !== 'undefined' && typeof product.extras === 'object') {

				prepareCoverFeatures( "extras", "extrasCover" );

			}
		}
	}

	function prepareExternalCopy( successCallback ){

		// Default text in case an ajax error occurs
		product.aboutFund = '<p>Apologies. This information did not download successfully.</p>';
		product.whatHappensNext = '<p>Apologies. This information did not download successfully.</p>';

		// Get the "about fund" and "what happens next" info
		$.when(
			meerkat.modules.comms.get({
				url: "health_fund_info/"+ product.info.provider +"/about.html",
				cache: true,
				errorLevel: "silent",
				onSuccess: function aboutFundSuccess(result) {
					product.aboutFund = result;
				}
			}),
			meerkat.modules.comms.get({
				url: "health_fund_info/"+ product.info.provider +"/next_info.html",
				cache: true,
				errorLevel: "silent",
				onSuccess: function whatHappensNextSuccess(result) {
					product.whatHappensNext = result;
				}
			})
		)
		.then(
			successCallback,
			successCallback //the 'fail' function, but we handle the ajax fails above.
		);

	}

	function prepareCoverFeatures( searchPath, target ){

		product[target] = {
			inclusions: [],
			restrictions: [],
			exclusions: []
		};

		var lookupKey;
		var name;
		_.each( Object.byString(product, searchPath), function eachBenefit(benefit, key) {

			lookupKey = searchPath + "." + key + ".covered";
			foundObject = _.findWhere( resultLabels, {"p": lookupKey} );

			if (typeof foundObject !== "undefined") {
				name = foundObject.n;
				coverSwitch( benefit.covered, target, name);
			}

		});

	}

	function coverSwitch( cover, target, name){
		switch( cover ){
			case 'Y':
				product[target].inclusions.push(name);
				break;
			case 'R':
				product[target].restrictions.push(name);
				break;
			case 'N':
				product[target].exclusions.push(name);
				break;
		}
	}

	function populateBrochureEmail () {
		var emailAddress = $('#health_contactDetails_email').val();
		if (emailAddress !== "") {
			$('#emailAddress').val(emailAddress).trigger('blur');
		}
	}

	meerkat.modules.register("healthMoreInfo", {
		initMoreInfo: initMoreInfo,
		events: events,
		setProduct: setProduct,
		prepareProduct: prepareProduct,
		prepareCover: prepareCover,
		prepareExternalCopy: prepareExternalCopy,
		getOpenProduct: getOpenProduct,
		close: closeBridgingPageDropdown,
		applyEventListeners: applyEventListeners
	});

})(jQuery);