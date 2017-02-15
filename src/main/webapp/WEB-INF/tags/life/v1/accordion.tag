<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" 	required="true"	 rtexprvalue="true"	 description="Type of quote - life or ip" %>

<%-- VARIABLES --%>
<c:set var="insurance_label">
	<c:choose>
		<c:when test="${quoteType eq 'life'}">_insurance</c:when>
		<c:otherwise>_primary_insurance</c:otherwise>
	</c:choose>
</c:set>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
<%-- The HTML structure of the page doesn't suit implementation of jQuery's Accordion class so
	this is a custom implementation that wraps selected elements to give the same effect. --%>
var LifeAccordionElements = {};
var LifeAccordionIsPartnerQuote = function() {
	return '${quoteType}' == 'life' && $('input[name=life_primary_insurance_partner]:checked').val() == 'Y';
};
var LifeAccordion = function() {

	var vertical		= '${quoteType}',
		active_panel	= false,
		valid_panels	= [],
		labels			= [
							vertical + "${insurance_label}",
							vertical + "_primary",
							vertical + "_partner",
							vertical + "_contactDetails-selection",
						];

	var init = function() {

		<%-- Disable submit form on enter key (added in quote-engine.js)
			Validation only occurs on visible elements so this prevents
			the form being submitted before being on the last panel. --%>
		$('#qe-wrapper').unbind('keydown').bind("keydown", function(e) {
			var code = e.keyCode || e.which;
			if (code == 13 || code == 108) {
				e.preventDefault();
			}
		});

		<%-- Remove display none from all content and footer tags (set in CSS) --%>
		for(var i = 0; i < labels.length; i++) {
			$('#' + labels[i] + ' .content').show();
			$('#' + labels[i] + ' .footer').show();
		}

		<%-- Wrap content and footer elements with accordion tags --%>
		<%-- Nb: Primary & Partner sections are shown together --%>
		$("#" + vertical + "${insurance_label} .content, #" + vertical + "${insurance_label} .footer").wrapAll("<span id='accordion0' class='accordion' />");
		$("#" + vertical + "_primary .content, #" + vertical + "_primary .footer" ).wrapAll("<span id='accordion1' class='accordion' />");
		$("#" + vertical + "_contactDetails-selection .content, #" + vertical + "_contactDetails-selection .footer" ).wrapAll("<span id='accordion3' class='accordion' />");

		if( vertical == 'life' ) {
			$( "#" + vertical + "_partner" ).wrapAll( "<span id='accordion2' class='accordion' />");
		}

		<%-- Wrap primary person heading in span (needs to be updated later) --%>
		if( vertical == 'life' ) {
			var text = $("#" + vertical + "_primary h4:first").text();
			$("#" + vertical + "_primary h4:first").empty().append($('<span/>',{text:text}));
		}

		<%-- Setup elements object with required elements --%>
		LifeAccordionElements = {
			insurance :	{
				heading:	$("#" + vertical + "${insurance_label} h4:first").css({position:'relative'}),
				body:		$("#accordion0").hide(),
				content:	$("#" + vertical + "${insurance_label} .content:first"),
				edit:		$('<a/>',{text:'edit', href:'javascript:void(0);'}).addClass('accordion-toggle edit-button').hide(),
				delimiter:	$('<span/>').addClass('accordion-toggle delimiter').hide(),
				summary:	$('<span/>').addClass('accordion-toggle summary-text').hide()
			},
			personal : {
				heading:	$("#" + vertical + "_primary h4:first").css({position:'relative'}),
				title:		$("#" + vertical + "_primary h4:first").find("span:first"),
				body:		{
								primary : $("#accordion1").hide(),
								partner : $("#accordion2").hide()
				},
				content:	{
								primary : $("#" + vertical + "_primary .content:first"),
								partner : $("#" + vertical + "_partner .content:first")
				},
				edit:		$('<a/>',{text:'edit', href:'javascript:void(0);'}).addClass('accordion-toggle edit-button').hide(),
				delimiter:	$('<span/>').addClass('accordion-toggle delimiter').hide(),
				summary:	$('<span/>').addClass('accordion-toggle summary-text').hide()
			},
			contact :	{
				heading:	$("#" + vertical + "_contactDetails-selection h4:first").css({position:'relative'}),
				body:		$("#accordion3").hide(),
				content:	$("#" + vertical + "_contactDetails-selection .content:first"),
				next:		$("#content .button-wrapper:first"),
				edit:		$('<a/>',{text:'edit', href:'javascript:void(0);'}).addClass('accordion-toggle edit-button').hide(),
				delimiter:	$('<span/>').addClass('accordion-toggle delimiter').hide(),
				summary:	$('<span/>').addClass('accordion-toggle summary-text').hide()
			}
		};

		<%-- Add applicable buttons/text to each section --%>
		for(var j in LifeAccordionElements) {
			(function(panel){
				var next_panel = getNextPanel(panel);

				<%-- Add the next button to bottom of each section --%>
				if( LifeAccordionElements.hasOwnProperty(panel) ) {
					if( next_panel !== false ) {
						if( LifeAccordionElements[panel].content instanceof jQuery ) {
							LifeAccordionElements[panel].content.append( getNextButtonHTML(next_panel) );
						} else {
							LifeAccordionElements[panel].content.primary.append( getNextButtonHTML(next_panel) );
							LifeAccordionElements[panel].content.partner.append( getNextButtonHTML(next_panel) );
						}
					}

					<%-- Add edit and summary element placeholder to each section --%>
					LifeAccordionElements[panel].heading
					.append(
						LifeAccordionElements[panel].edit.on('click', function(){
							gotoPanel(panel);
						})
					)
					.append(LifeAccordionElements[panel].delimiter)
					.append(LifeAccordionElements[panel].summary);
				}
			}(j));
		}

		gotoPanel('insurance');

		if( vertical == 'life' ) {
			$("input[name='life_primary_insurance_partner']").change(updatePersonalSectionHeading);
			updatePersonalSectionHeading();
		}
	};

	<%-- gotoPanel : performs the heavy lifting for moving between sections of the accordion --%>
	var gotoPanel = function( panel ) {

		if( panel != active_panel ) {

			var is_previous_panel = isPreviousPanel(panel);

			if( active_panel !== false && (is_previous_panel || isValid()) ) {

				if( is_previous_panel ) {
					$('#slideErrorContainer').fadeOut();
				}

				if( is_previous_panel && active_panel == 'personal' ) {
					<%-- Check if names are present - if not then toggle this panel --%>
					toggleValidPanels(active_panel, false);
				}

				<%-- Hide the first next button in the personal section if partner quote --%>
				if( panel == 'personal' ) {
					if( isPartnerQuote() ) {
						LifeAccordionElements[panel].content.primary.find('.next-button:first').hide();
					} else {
						LifeAccordionElements[panel].content.primary.find('.next-button:first').show();
					}
				}

				toggleValidPanels(active_panel);
				toggleValidPanels(panel, true);

				var step2_callback = function() {
					if( LifeAccordionElements[panel].body instanceof jQuery ) {
						LifeAccordionElements[panel].body.slideDown(step3_callback);
					} else {
						if( isPartnerQuote() ) {
							LifeAccordionElements[panel].body.primary.slideDown(function(){
								LifeAccordionElements[panel].body.partner.slideDown(step3_callback)
							});
						} else {
							LifeAccordionElements[panel].body.primary.slideDown(step3_callback);
						}
					}
				}

				var step3_callback = function() {
					if( panel == 'contact' ) {
						LifeAccordionElements[panel].next.slideDown();
					} else {
						LifeAccordionElements.contact.next.slideUp()
					}
				}

				if( LifeAccordionElements[active_panel].body instanceof jQuery ) {
					LifeAccordionElements[active_panel].body.slideUp('fast', step2_callback);
				} else {
					if( isPartnerQuote() ) {
						(function(ap){
							LifeAccordionElements[ap].body.partner.slideUp('fast', function(){
								LifeAccordionElements[ap].body.primary.slideUp('fast', step2_callback);
							});
						}(active_panel));
					} else {
						LifeAccordionElements[active_panel].body.primary.slideUp('fast', step2_callback);
					}
				}

				active_panel = panel;

				updatePersonalSectionHeading();

				updateValidPanels();

			<%-- Must be on page load so just show the first section --%>
			} else if ( active_panel === false ) {
				LifeAccordionElements[panel].body.slideDown(step3_callback);

				active_panel = panel;
			}
		}
	};

	<%-- getNextPanel : returns the label of the panel that proceeds the panel provided --%>
	var getNextPanel = function( panel ) {

		var stop = false;
		for(var i in LifeAccordionElements) {
			if( LifeAccordionElements.hasOwnProperty(i) ) {
				if( stop === false ) {
					if( i == panel ) {
						stop = true;
					}
				} else {
					return i;
				}
			}
		}

		return false;
	};

	<%-- isPreviousPanel : confirms whether the requested panel is prior to the current step in journey --%>
	var isPreviousPanel = function( panel ) {

		if( active_panel !== false ) {
			var active_pos = 0;
			var panel_pos = 0;
			var counter = 0;
			for(var i in LifeAccordionElements) {
				if( LifeAccordionElements.hasOwnProperty(i) ) {
					if( i == active_panel ) {
						active_pos = counter;
					}
					if( i == panel ) {
						panel_pos = counter;
					}

					counter++;
				}
			}

			if( panel_pos < active_pos ) {
				return true;
			}
		}

		return false;
	};

	<%-- toggleValidPanels : maintains a list of completed panels used to update the summary and edit button.
		The active/current panel is always removed from the list. --%>
	var toggleValidPanels = function(panel, remove) {

		remove = remove || false;
		var pos = indexOf(valid_panels, panel);

		if( pos >= 0 && remove === true ) {
			valid_panels.splice(pos, 1);
		} else if( pos == -1 && remove == false ) {
			valid_panels.push( panel );
		}
	};

	<%-- updateValidPanels : updates the visibility and content of the summary text and edit buttons. --%>
	var updateValidPanels = function() {
		for( var i in LifeAccordionElements ) {
			if( LifeAccordionElements.hasOwnProperty(i) ) {
				if( indexOf(valid_panels, i) >= 0 ) {
					(function(id){
						<%-- Delay necessary to ensure changes happen AFTER accordion animation --%>
						setTimeout(function(){
							LifeAccordionElements[id].edit.show();
							LifeAccordionElements[id].delimiter.show();
							switch(id) {
								case 'insurance':
									LifeAccordionElements.insurance.summary.text(
										isPartnerQuote() ? 'Cover for You and Your Partner' : 'Cover for You'
									).show();
								break;
								case 'personal':
									LifeAccordionElements.personal.summary.text(
										isPartnerQuote() ? getFullName('primary') + ' & ' + getFullName('partner')
										: getFullName('primary')
									).show();
								break;
								case 'contact':
								default:
								break;
							}
						}, 500);
					}(i));
				} else {
					LifeAccordionElements[i].edit.hide();
					LifeAccordionElements[i].delimiter.hide();
					LifeAccordionElements[i].summary.hide();
				}
			}
		}
	};

	var updatePersonalSectionHeading = function() {

		if( valid_panels.length ) {
			if( active_panel != 'personal' ) {
				LifeAccordionElements.personal.title.text( isPartnerQuote() ? 'About You and Your Partner' : 'About You');
			} else {
				LifeAccordionElements.personal.title.text('About You');
			};
		} else {
			LifeAccordionElements.personal.title.text( isPartnerQuote() ? 'About You and Your Partner' : 'About You');
		}
	};

	<%-- getNextButtonHTML : returns a functional HTML element for the next button --%>
	var getNextButtonHTML = function( next_panel ) {
		return $('<div/>').addClass('fieldrow button-row')
		.append(
			$('<a/>',{
				href:	'javascript:void(0);',
				text:	'Next'
			})
			.addClass('standardButton greenButton next-button')
			.on('click', function() {
				gotoPanel(next_panel);
			})
		);
	};

	<%-- getFullName : returns the primary/partner fullname or an ellipsis if empty --%>
	var getFullName = function(type) {
		var name = $('#' + vertical + '_' + type + '_firstName').val() + ' ' + $('#' + vertical + '_' + type + '_lastname').val()
		if( $.trim(name) == '' ) {
			return "...";
		} else {
			return name;
		}
	};

	<%-- isPartnerQuote : Confirms vertical is LIFE AND partner quote option selected --%>
	var isPartnerQuote = function() {
		return LifeAccordionIsPartnerQuote();
	};

	<%-- isValid : Forces validation of visible for elements (ie those in open accordion section) --%>
	var isValid =  function() {
		return QuoteEngine.validate(false);
	};

	<%-- indexOf : Generic isArray function (not available in IE) --%>
	var indexOf = function(arr, item) {
		for (var i = 0, j = arr.length; i < j; i++) {
			if (arr[i] === item) {
				return i;
			}
		}
		return -1;
	};

	init();
};
</go:script>

<go:script marker="onready">
	LifeAccordion();
	LifeAccordion.getSectionElement = function(section, element) {
		return LifeAccordionElements[section][element];
	};
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	#${quoteType}${insurance_label} .content,
	#${quoteType}${insurance_label} .footer,
	#${quoteType}_primary .content,
	#${quoteType}_primary .footer,
	#${quoteType}_partner .content,
	#${quoteType}_partner .footer,
	#${quoteType}_contactDetails-selection .content,
	#${quoteType}_contactDetails-selection .footer {
		display:				none;
	}

	.${quoteType} .accordion {
		display:				block;
	}

	.${quoteType} .accordion .button-row a {
		float: left;
		margin-left: 206px;
	}
	
	.${quoteType} .button-wrapper {
		display:				none;
	}

	.${quoteType} .qe-window h4 span.accordion-toggle,
	.${quoteType} .qe-window h4 a.accordion-toggle {
		float:					right;
		color:					#0c4da2 !important;
		font-size:				12px !important;
		font-family:			"SunLTLightRegular",Arial,Helvetica,sans-serif !important;
		font-weight:			normal !important;
		line-height:			15px;
		background-color:		transparent;
		background-position:	center right;
		background-repeat:		no-repeat;
	}

	.${quoteType} .qe-window h4 .accordion-toggle.edit-button {
		width:					30px;
		margin-right:			15px;
		padding-right:			10px;
		background-image:		url('brand/ctm/images/results_Life_IP/accordion-pencil-icon.png');
		background-position:	23px 1px;
		text-decoration:		none;
	}

	.${quoteType} .qe-window h4 .accordion-toggle.edit-button:hover {
		text-decoration:		underline;
	}

	.${quoteType} .qe-window h4 .accordion-toggle.summary-text {}

	.${quoteType} .qe-window h4 .accordion-toggle.delimiter {
		width:					3px;
		height:					24px;
		margin:					-5px 5px 0px 5px;
		background-image:		url('brand/ctm/images/results_Life_IP/accordion-delimiter.png');
		background-position:	center center;
	}
</go:style>