var Popup = new Object();
Popup = {
	_origZ : {},
	_overlays : {},
	_popupCount : 0,

	// needed when there's other overlays present whose
	// zindex is irrelevent (eg loading layer)
	_ignored_overlays : false,

	show : function(id, ignored_overlays){
		this._ignored_overlays = ignored_overlays || false;
		this._popupCount ++;
		// If we're not already showing an overlay .. create one.
		if (!$(".ui-widget-overlay").is(":visible")) {
			var overlay = $("<div>").attr("id",id + "-overlay")
									.addClass("ui-widget-overlay")
									.css({	"height":$(document).height() + "px",
											"width":$(document).width()+"px",
											"z-index":3000 + this._popupCount
										});
			this._overlays[this._popupCount]=overlay;
			$("body").append(overlay);
			$(overlay).fadeIn("fast");

		// Otherwise just mess with the existing overlay's z-index
		} else {
			if(!this._ignored_overlays)
			{
				this._origZ[this._popupCount] = $(".ui-widget-overlay").css("z-index");
				$(".ui-widget-overlay").css("z-index",3000 + this._popupCount);
			}
			else
			{
				this._origZ[this._popupCount] = $(".ui-widget-overlay").not(this._ignored_overlays).css("z-index");
				$(".ui-widget-overlay").not(this._ignored_overlays).css("z-index",3000 + this._popupCount);
			}
			this._overlays[this._popupCount]=false;
		}

		// Show the popup
		$(id).css("z-index", 3001 + this._popupCount);
		$(id).center().show("slide",{"direction":"down"},300);

		// Activate the close button
		$(id).find(".close-button").each(function(){
			$(this).off('click.close').on('click.close', function(){
				Popup.hide(id);
			});
		});

	},
	hide : function(id){
		$(id).hide("slide",{"direction":"down"},300);

		// Did we add a specific overlay? if so remove.
		if (this._overlays[this._popupCount]) {
			$(this._overlays[this._popupCount]).remove();
		} else {
			$(".ui-widget-overlay").css("z-index",this._origZ[this._popupCount]);
		}
		this._popupCount--;
	}
}