var IframePage = {
	_init : function() {
		$(window).resize(function(){
			$('#external_iframe').css({
				height: IframePage.getWindowHeight()
			});
		});
	},

	render : function( parent_id, url ) {

		var new_height = IframePage.getWindowHeight();

		$('#' + parent_id).empty().append($('<iframe />',{
			id :			"external_iframe",
			frameborder :	"0",
			width :			"100%",
			height :		new_height + "px",
			src :			url
		}));
	},

	getWindowHeight : function() {
		return $(window).height() - 85;
	}
};

IframePage._init();
