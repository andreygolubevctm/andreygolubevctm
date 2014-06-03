//A lot of these variables are left over from the initial script
var INDEX_RESPONSE_RESULT 		= "responsecode",
	INDEX_SESSION_ERROR			= "SessionStoredError",
	SUCCESSFUL_RESULT			= 1,
	VAR_MASKED_CC_NUMBER		= "maskedcardno",
	IFRAME_PARENT_SELECTOR		= "div#credit-card-lightbox div#credit-card-number div.fields", //This is located on where?
	PLACEHOLDER_MASKED_CARD 	= "#ccnumber#",
	SUCCESS_MESSAGE				= PLACEHOLDER_MASKED_CARD,
	//TESTING_IFRAME_URL			= "http://www.vicwebster.net/bupatest/iframe-tunnel.php", //What is this used for
	USING_IFRAME_CLASS			= "usingIFrame",
	//PROXY_PAGE_URL				= "https://ext.bupa.com.au/tokenisation/proxy.html", // if null or empty, then no proxy will be used!
	//PROXY_PAGE_URL				= null, // if null or empty, then no proxy will be used!
	CREDIT_CARD_FORM_SELECTOR	= "form#credit-card-form",
	//RESULT_DIRECTORY			= "staticfiles/PageFurniture/protect/", //WHAT is this used for?
	DEBUG						= false, // print debug statements to console
	SHOW_LOADING_BOX_IN_IE		= false, // show the loading box in IE8 or below
	HOST_DEBUG_STRING			=  "(from cc-tokenisation.js hosted on BUPA SITE -- CtM Site iFrame Tunnel required?)"; // for debugging

var global_is_IE8_or_below = jQuery.browser.msie && jQuery.browser.version <= 8;


function debugLog( string )
	{
		if ( DEBUG )
			{
				var debugDiv	= document.createElement( 'div' ),
					hostSpan	= document.createElement( 'span' );

				debugDiv.style.padding  = "5px";
				hostSpan.style.color    = "purple";
				debugDiv.innerHTML      =  string;
				hostSpan.innerHTML      =  " "+HOST_DEBUG_STRING;

				document.body.appendChild( debugDiv );
				debugDiv.appendChild( hostSpan );

				if(typeof console != 'undefined') {
					console.log('DEBUG: ' + string);
				}
			}

	}


/*
 * When the window is loaded (above window.onload function), we check to see if the correct response query string values are set. Obviously,
 * they will NOT be set the first time the window loads. Because they are not set, we put an "iframe tunnel" into the page (this happens
 * in .onload). That iframe tunnel itself includes another iframe "tunnel" that references -this- page. It's a circular loop of iframes
 * designed to overcome cross-domain java-scripting problems. However, we DO set query string values when we load the tunnel back to this
 * page. The code then analyses those values and calls "top.registerSuccess". That has the effect of calling the function in the top-most
 * parent window, instead of one of the iframes.
 */
jQuery( document ).ready( function() {

		if ( global_is_IE8_or_below )
			{
				debugLog("IE8 or below detected.");
			}

		debugLog("window.onload() called.");

		var $ccButtons = jQuery( 'button' );

		$ccButtons.on("mouseup", onCCButtonMouseUp );

		//Checks to see if the response was good
		if($('input[name="maskedcardno"]').length > 0 && $('input[name="token"]').length > 0) {

			//pull out the starting path which would have come in the string, and use the hard coded ipp.jsp
			var url = $('script[src$="/iframe-tunnel.js"]').attr('src'),
			newUrl = url.replace('iframe-tunnel.js','ipp.jsp');

			debugLog('New URL = ' + newUrl);
			//grab the values and make the window change its source
			var _url = newUrl
						+'?token=' + $('input[name="token"]').val()
						+ '&maskedcardno=' + $('input[name="maskedcardno"]').val()
						+ '&cardtype=' + $('input[name="cardtype"]').val()
						+ '&sst=' + $('input[name="sst"]').val()
						+ '&sessionid=' + $('input[name="sessionid"]').val()
						+ '&responsecode=' + $('input[name="responsecode"]').val()
						+ '&responseresult=' + $('input[name="responseresult"]').val()
						+ '&resultPage=0';

			//use the iFrame with the direct source so the tunnel can be made
			debugLog(_url);
			$('body').append('<p>Loading...</p><iframe frameborder="0" id="cc-frame" src="'+ _url +'"></iframe>');
		} else if ($('input[name="responsecode"]').val() <= 0) {
			$('body').prepend("<br /><p>Please check the number and try again.</p>");
		} else if ($('input[name="SessionStoredError"]').length == 1) {
			//pull out the starting path which would have come in the string, and use the hard coded ipp.jsp
			var url = $('script[src$="/iframe-tunnel.js"]').attr('src'),
			newUrl = url.replace('iframe-tunnel.js','ipp.jsp');

			//Capture the error
			var _url = newUrl
						+'?error=1'
						+'&responsecode=' + $('input[name="responsecode"]').val();

			$('body').append('<p>Loading...</p><iframe frameborder="0" id="cc-frame" src="'+ _url +'"></iframe>');
		} else {
			//pull out the starting path which would have come in the string, and use the hard coded ipp.jsp
			/*
			var url = $('script[src$="/iframe-tunnel.js"]').attr('src'),
			newUrl = url.replace('iframe-tunnel.js','ipp.jsp');

			//Capture the error
			var _url = newUrl
						+'?responsecode=' + $('input[name="responsecode"]').val()
						+'&responseresult=' + $('input[name="responseresult"]').val()
						+'error=1';
			*/
		};


		debugLog("\t*** window.onload() complete.");

});






function onCCButtonMouseUp()
	{

		debugLog("mouseup event has been fired.");

		jQuery( 'button' ).hide();

		/*
		jQuery("div.formrow#credit-card-number" ).find("span" ).remove();
		jQuery("form#credit-card-form button" ).hide();

		debugLog("....about to call insertinto DOM");
		insertIFrameIntoDOM( false );
		debugLog("....called insertinto DOM");

		debugLog("mouseup event has complete.");
		*/

		debugLog("About to POST data to IPP - use their default values...");
		//It would appear there is a logon form, so either we are not submitting the correct data or getting it from the wrong place.

		//submitToIPP();

	}


function insertIFrameIntoDOM( boolRegisterAnError )
	{
		debugLog( 'insertIFrameIntoDOM() called.');
	}






/**
 * This function is called from universal.credit-card-widget.js
 */
var refreshIFrameContents = function()
	{
		debugLog("refreshIFrameContents() called.");

		var $ = jQuery;

		$( IFRAME_PARENT_SELECTOR ).find("iframe" ).remove();
		$("div.hiddenCCInfo" ).remove();
		$("div.formrow#credit-card-number span" ).remove();
		$("div#credit-card-lightbox div#submit button" ).hide();

		insertIFrameIntoDOM( false );

		debugLog("\t*** refreshIFrameContents() complete.");
	};





function showLoadingBox()
	{
		debugLog("showLoadingBox() called.");

		var $loadingBox = jQuery("<div id='loadingBox' >Loading...</div>");

		if ( !SHOW_LOADING_BOX_IN_IE && global_is_IE8_or_below )
			{
				debugLog("Not showing loading box because <=IE8 and SHOW_LOADING_BOX_IN_IE == false.");
			}
		else
			{
				jQuery(CREDIT_CARD_FORM_SELECTOR).append( $loadingBox );
			}

		debugLog("\t***showLoadingBox() complete.");
	}


function hideLoadingBox()
	{
		debugLog("hideLoadingBox() called.");

		var $loadingBox			= jQuery("div#loadingBox" );

		debugLog("$loadingBox.html() : "+$loadingBox.html());

		if ( global_is_IE8_or_below )
			{
				debugLog("\tis IE8 or below, so no hide animation.");
				$loadingBox.hide();
				$loadingBox.remove();
				delete $loadingBox;
				debugLog("\tdone <IE8 remove.");
			}
		else
			{
				$loadingBox.slideUp(300, function() { $loadingBox.remove(); } );
			}

		debugLog("\t***hideLoadingBox() complete.");
	}



var registerSessionError = function()
	{
		debugLog("registerSessionError() called.");

		var locationURL 			= location.href.toString(),
			isOnApplicationPage	= locationURL.match("") !== null,
			$errorBox				= isOnApplicationPage? get$ApplicationFormErrorBox() : get$NormalErrorBox();

		jQuery(CREDIT_CARD_FORM_SELECTOR).append( $errorBox );
		$errorBox.slideDown(200);

		debugLog("\t**registerSessionError() complete.");
	};



function continueButtonPressed( $event )
	{
		debugLog("continueButtonPressed() called.");

		var jQueryFormRow				= jQuery( IFRAME_PARENT_SELECTOR ),
			$ccWidgetForm				= jQueryFormRow.parents("form" ),
			$origCCNumberInput		= $ccWidgetForm.find("input#credit-card-number" );

		$event.preventDefault();
		$origCCNumberInput.val("UNPROCESSED");
		pressOriginalSubmitButton();
		debugLog("\t*** continueButtonPressed() done.");
	}



function closeButtonPressed( $event )
	{
		debugLog("closeButtonPressed() called.");

		var $ = jQuery,
			$lightBoxCloseButton = $("div#lightbox a.lightbox-close-button");

		$event.preventDefault();
		$lightBoxCloseButton.click();

		debugLog("\t*** closeButtonPressed() done.");
	}



function get$ApplicationFormErrorBox()
	{
		debugLog("get$ApplicationFormErrorBox() called.");

		var $ 			= jQuery,
			$errorBox  = jQuery("<div id='errorBox applicationForm' style='display: none'></div>" ),
			$button		= $("<button>continue</button>" ),
			errorText	= "<p>Oops... Our system is down and we can’t process your credit card.</p>"+
							"<p>Continue with your application and we can collect your details after you join.</p>";

		$errorBox.html( errorText );
		$errorBox.append( $button );
		$button.on("click", continueButtonPressed );

		debugLog("\tget$ApplicationFormErrorBox() returning:");
		debugLog( $errorBox );

		return $errorBox;

	}



function get$NormalErrorBox()
	{
		debugLog("get$NormalErrorBox() called.");

		var $ 			= jQuery,
			$errorBox  = jQuery("<div id='errorBox normal' style='display: none'></div>" ),
			$button		= $("<button>continue</button>" ),
			errorText	= "<p>We’re sorry but our system is down and we are unable to process your credit card details right now.</p>" +
							"<p>Please try again later or contact us on:</p>"+
							"<p><b>134 135</b><br>from within Australia</p>"+
							"<p><b>+61 3 9487 6400</b> from outside Australia</p>" +
							"<p><8am - 8pm Mon to Fri, AEDT</p>" +
							"<p>9am - 1pm Sat, AEDT</p>";

		$errorBox.html( errorText );
		$errorBox.append( $button );
		$button.on("click", closeButtonPressed );

		debugLog("\tget$NormalErrorBox() returning:");
		debugLog( $errorBox );

		return $errorBox;
	}



function pressOriginalSubmitButton()
	{
		debugLog("pressOriginalSubmitButton() called.");

		var jQueryFormRow				= jQuery( IFRAME_PARENT_SELECTOR ),
			$ccWidgetForm				= jQueryFormRow.parents("form" );

			$ccWidgetForm.find("button" ).show().click();
			hideLoadingBox();

		debugLog("\t**pressOriginalSubmitButton() done.");
	}


/**
 * This can be a little confusing, because it removes the hidden iframe from the source, so a developer looking only at the source might
 * find it difficult to see what's happened.
 */
var registerSubmission = function( responseArray )
	{
		debugLog("registerSubmission() called.");

		//we'll need to make something very different from this, and call it from within our application

		var resultSuccessful 		= responseArray[INDEX_RESPONSE_RESULT] == SUCCESSFUL_RESULT,
			jQueryFormRow				= jQuery( IFRAME_PARENT_SELECTOR ),
			$ccWidgetForm				= jQueryFormRow.parents("form" ),
			$origCCNumberInput		= $ccWidgetForm.find("input#credit-card-number" ),
			maskedCardString			= VAR_MASKED_CC_NUMBER in responseArray? responseArray[ VAR_MASKED_CC_NUMBER ]: -1;

		$origCCNumberInput.val( maskedCardString );

		debugLog("\tresultSuccessful: "+resultSuccessful);
		debugLog("\tresponseArray");
		debugLog(responseArray);

		// reset from possible previous submission attempt
		$origCCNumberInput.removeClass("error");
		$origCCNumberInput.parent().find("label.error" ).remove();


		if ( resultSuccessful )
			{
				var cardPlaceHolderRegEx	= new RegExp(PLACEHOLDER_MASKED_CARD, "gm" ),
					successString				= SUCCESS_MESSAGE.replace( cardPlaceHolderRegEx, maskedCardString ),
					$mainForm					= jQuery("div#cc-buttons" ).parents("form" ),
					$hiddenInformation		= jQuery("<div class=\"hiddenCCInfo\"></div>" );

				jQueryFormRow.prepend("<span id='successNumber'>"+successString+"</span>");
				jQueryFormRow.find("iframe" ).remove();

				if (PROXY_PAGE_URL)
					$hiddenInformation.append("<br>Going through proxy at: <a href='"+PROXY_PAGE_URL+"'>"+PROXY_PAGE_URL+"</a>");

				$hiddenInformation.append("<h4>The following values were returned:</h4>");
				$mainForm.prepend($hiddenInformation);

				for( var key in responseArray )
					{
						var $hiddenInputDiv = jQuery("<div>" +
															"	<label for='"+key+"'>"+key+":</label>" +
															"	<input id='"+key+"' name='"+key+"' value='"+responseArray[key]+"' />" +
															"</div>");

						$hiddenInformation.append($hiddenInputDiv);
					}

				pressOriginalSubmitButton();


				// -----------------------------------
			}
		else // an error must have occurred in the CC number submission
			{
				/* This is a back-up and will only occur if IP Payments return an error that our JavaScript validation did not detect. See
					iframe_tunnel.js to find our JavaScript Validation.
				 */

				debuglog("Note: IPP has detected a CC number error that the PROXY FE validation did not detect.");
				insertIFrameIntoDOM( true );


			}

		debugLog("registerSubmission() complete.");
	};