<%--
	active_progress_bar.tag adds clickable functionality to the main progress bar

	To implement - include code similar to below in a go:script onready

	var active_progress_bar = new ActiveProgressBar({
		milestones : {
			1:{
				exit : function(){
					// Do something
				},
				enter : {
					forward : function(){
						// Do something
					},
					backward : function(){
						// Do something
					}
				},
				skip : function() {
					// Do something
				}
			}
		},
		directional : [2],
		ignore : [5]
	});

	The argument for the ActiveProgressBar constructor is optional as are its properties (milestones and directional).
	However, should any of these properties be provided then follow the format prescribed above. if ommitted then
	default forward/backwards and goto functionality will be applied.

	Milestones: represent special slides in the user journey that require unique function calls to maintain continuity (eg results page).
	Directional: represents an array of slide ids that can only be accessed via the progress bar when going backwards.
	Void: represents an array of slide ids that will be ignored and not have click events added.
--%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:script marker="js-head">
var ActiveProgressBar = function( options ) {

	var terminus = false;

	options = options || {};

	var init = function() {

		<%-- Store the last slide in the journey--%>
		terminus = $('#steps .navStep').length - 1;

		<%-- Apply initial click events for the first slide --%>
		updateProgressClickEvents();

		<%-- Schedule updating click events on each slide change --%>
		slide_callbacks.register({
			mode:		'before',
			slide_id:	-1,
			callback:	function() {
				updateProgressClickEvents();
			}
		});
	};

	<%-- Apply appropriate click functionality to steps in the progress bar:
			* Not for the current selected slide;
			* Ignore slides more than one step ahead of current position; and
			* Not if next slide is directional and can only be accessed via the progress bar going backwards
	--%>
	var updateProgressClickEvents = function() {

		var active_slide = 0;
		var count = 0;
		var current_slide = QuoteEngine.getCurrentSlide();
		var max_slide = current_slide + 1;

		$("ul#steps li.navStep").each(function() {

			<%-- Remove existing click tricks --%>
			$(this).find('a')
			.removeClass('active')
			.unbind('click.APBar');

			<%-- Add click tricks to appropriate steps --%>
			if( !isVoid(active_slide) ) { <%-- Voided steps never have click events --%>
				if( terminus !== false && current_slide != terminus ) { <%-- Always disable all steps when on final slide --%>
					if( count <= max_slide ) { <%-- Limit to up to next slide only --%>
						if( active_slide != current_slide && active_slide <= max_slide && !isDirectional(active_slide) ) {
							$(this).find('a')
							.addClass('active')
							.on('click.APBar', {slide: active_slide}, click);
						}
						count++;
					}
				}
			}

			active_slide++;
		});
	};

	<%-- Event fired whenever a progress bar step is clicked --%>
	var click = function( event ) {

		var selected = event.data.slide;
		var current = QuoteEngine.getCurrentSlide();

		if( selected != current ) {
			<%-- Handle milestone pages using provided actions --%>
			if( isMilestone( selected ) ) {
				actionMilestone( selected, current );
			} else {
				<%-- Use next trigger for one step forward --%>
				if( selected == current + 1 ) {
					$('#next-step').trigger("click");
				} else if ( selected == current - 1 ) {
					<%-- When exiting a milestone call its exit handler --%>
					if( isMilestone( current ) ) {
						actionMilestone( current, current, selected );
					<%-- Otherwise just trigger the previous button --%>
					} else {
						$('#prev-step').trigger("click");
					}
				} else if ( selected < current ) {
					<%-- If exiting a milestone - call its exit handler first. --%>
					if( isMilestone( current ) ) {
						actionMilestone( current, current, selected );
					} else {
						<%-- Check if any milestones are to be skipped and action --%>
						actionSkippedMilestones(current, selected);

						<%-- Then simply go to the selected slide --%>
						goto(selected);
					}
				} else {
					<%-- Ignore as clearly a click has happened that should not be --%>
				}
			}
		} else {
			<%-- ignore as selected current slide --%>
		}
	};

	<%-- Action implements the milestone specific functionality provided in the constructor.
		If no function is provided then default functionality is applied.
	--%>
	var actionMilestone = function( milestone, current, selected ) {

		if(typeof selected != "number") {
			selected = false;
		}

		<%-- Action if exiting the milestone and going backwards --%>
		if( selected !== false && milestone == current && selected < current ) {
			if( options.milestones[milestone].hasOwnProperty("exit") &&
				typeof options.milestones[milestone].exit == "function"
			) {
				options.milestones[milestone].exit( selected );
			} else {
				goto(selected);
			}
		<%-- Action if selecting the milestone from previous step --%>
		} else if( milestone == current + 1 ) {
			if( options.milestones[milestone].hasOwnProperty("enter") &&
				typeof options.milestones[milestone].enter == "object" &&
				options.milestones[milestone].enter.hasOwnProperty("forward") &&
				typeof options.milestones[milestone].enter.forward == "function"
			) {
				options.milestones[milestone].enter.forward();
			} else {
				$('#next-step').trigger("click");
			}
		<%-- Action if going back to the milestone from any position --%>
		} else if ( milestone < current ) {
			if( options.milestones[milestone].hasOwnProperty("enter") &&
				typeof options.milestones[milestone].enter == "object" &&
				options.milestones[milestone].enter.hasOwnProperty("backward") &&
				typeof options.milestones[milestone].enter.backward == "function"
			) {
				options.milestones[milestone].enter.backward();
			} else {
				goto(selected);
			}
		} else {
			<%-- Unreachable if all holds true --%>
		}
	};

	<%-- Check whether a milestone is to be skipped over and if so call its skip method if defined --%>
	var actionSkippedMilestones = function(current, selected) {

		if( hasMilestones() ) {
			for(var i in options.milestones) {
				if( options.milestones.hasOwnProperty(i) ) {
					if( isMilestone(i) && options.milestones[i].hasOwnProperty('skip') && typeof options.milestones[i].skip == "function" ) {
						options.milestones[i].skip(current, selected);
					}
				}
			}
		}
	}

	<%-- Shortcut to QuoteEngines gotoSlide method --%>
	var goto = function(slide) {
		QuoteEngine.gotoSlide({noAnimation:true, index:slide});
	};

	<%-- Confirms whether any Milestones exist --%>
	var hasMilestones = function( slide ) {
		return typeof options == "object" && options.hasOwnProperty("milestones") && typeof options.milestones == "object";
	};

	<%-- Confirms whether the selected slide is a Milestone --%>
	var isMilestone = function( slide ) {
		return hasMilestones() && options.milestones.hasOwnProperty(slide);
	};

	<%-- Confirms whether the selected slide is a Directional (only clickable when going backwards) --%>
	var isDirectional = function( slide ) {
		return typeof options == "object" && options.hasOwnProperty("directional") && typeof options.directional == "object" && options.directional.constructor == Array && $.inArray(slide, options.directional) >= 0;
	};

	<%-- Confirms whether the selected slide is VOID (never clickable) --%>
	var isVoid = function( slide ) {
		return typeof options == "object" && options.hasOwnProperty("ignore") && typeof options.ignore == "object" && options.ignore.constructor == Array && $.inArray(slide, options.ignore) >= 0;
	};

	this.test = function() {
		if( window.hasOwnProperty('console') ) {
			console.dir(options);
		}
	};

	init();
}
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	#navContainer .navStep a {
		text-decoration: none !important;
		cursor: default !important;
	}

	#navContainer .navStep a.active {
		cursor: pointer !important;
	}

	#navContainer .navStep a.active:hover {
		text-decoration: underline !important;
	}
</go:style>