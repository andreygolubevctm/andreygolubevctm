<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- HTML --%>
<go:script marker="js-href" href="https://www.google.com/jsapi" />
<script type="text/javascript">google.load("visualization", "1", {packages:["corechart"]});</script>
<div id="lifebroker-graph-dialog" class="lifebroker-graph-dialog" title="Premium Graph">
	<div class="wrapper">
		<div id="lifebroker-graph-dialog-content" style="width:790px;height:400px;"><!-- empty --></div>
		<div class="popup-buttons">
			<a href="javascript:$('#lifebroker-graph-dialog').dialog('close');" class="bigbtn close-error"><span>Ok</span></a>
		</div>
	</div>
	<div class="dialog_footer"><!-- empty --></div>
</div>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var compareGraph = {

	_graph_data : 		null,
	_close_callback : 	null,

	init: function() {

		// Initialise the search quotes dialog box
		// =======================================
		$('#lifebroker-graph-dialog').dialog({
			autoOpen: false,
			show: {
				effect: 'clip',
				complete: function(){
					$(".ui-dialog.lifebroker-graph-dialog").first().center();
					//QuoteEngine.scrollTo('.ui-dialog:visible');
				}
			},
			hide: 			'clip',
			'modal':		true,
			'width':		820,
			'minWidth':		820,
			'autoOpen': 	false,
			'draggable':	false,
			'resizable':	false,
			'dialogClass':	'lifebroker-graph-dialog',
			'title':		'Premium Graph',
			open: function() {
				compareGraph.show();
				$('.ui-widget-overlay').bind('click', function () { $("#lifebroker-graph-dialog").dialog('close'); });
			},
			close: function(){
				compareGraph.hide();
			}
		});
	},

	launch: function( data ) {
		compareGraph.graph_data = data;
		$('#lifebroker-graph-dialog').dialog("open");
	},

	close: function( callback ) {
		if( typeof callback == "function" )
		{
			compareGraph._close_callback = callback;
		}
		$('#lifebroker-graph-dialog').dialog("close");
	},

	hide: function() {

		// Re-enable the more button on the results page
		btnInit.enable();

		$("#lifebroker-graph-dialog").hide("fast", compareGraph._close_callback);
	},

	show: function() {

		$("#lifebroker-graph-dialog").show('fast', function() {
			var data = google.visualization.arrayToDataTable( compareGraph.graph_data );
			//Set up currency format for all lines
			var formatter = new google.visualization.NumberFormat({prefix: '$'});
			for (i = 1; i < data.getNumberOfColumns(); i++) {
				formatter.format(data, i);
			}
			var options = {
					title: 				'Premium Graph',
					legend:				{
						position:	'top'
					},
					hAxis:				{
						title:		'Age'
					},
					vAxis:				{
						title:		'Premium'
					},
					axisTitlesPosition:	'out',
					titleTextStyle:		{
						fontSize:	20
					}
			};
			var chart = new	google.visualization.LineChart(document.getElementById('lifebroker-graph-dialog-content'));
			chart.draw(data, options);
		});
	},

	callMeBack : function()
	{
		IPQuote.submitApplication(compareGraph._product);
	}
};
</go:script>
<go:script marker="onready">
compareGraph.init();
</go:script>

<%-- CSS --%>
<go:style marker="css-head">

.ui-dialog.lifebroker-graph-dialog{ position: absolute; overflow:hidden; background-image: none; }

#lifebroker-graph-dialog {
	min-width:				820px;
	max-width:				820px;
	width:					820px;
	display: 				none;
	overflow:				hidden;
}

#lifebroker-graph-dialog .clear
{clear:both;}

#lifebroker-graph-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_820.png") no-repeat scroll left top transparent;
	width: 					820px;
	height: 				15px;
	clear: 					both;
}

.ui-dialog.lifebroker-graph-dialog .ui-dialog-titlebar {
	padding: 				0 !important;
	height: 				25px !important;
	overflow:
}

.ui-dialog.lifebroker-graph-dialog .ui-dialog-titlebar .ui-dialog-title {
	display: 				none !important;
}

.ui-dialog.lifebroker-graph-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				none !important;
}
.ui-dialog.lifebroker-graph-dialog .message-form,
.ui-dialog #lifebroker-graph-dialog {
	padding:				0;
}

.lifebroker-graph-dialog .ui-dialog-titlebar {
	background-image:		url("common/images/dialog/header_820.png") !important;
	height:					26px;
	-moz-border-radius-bottomright: 0;
	-webkit-border-bottom-right-radius: 0;
	-khtml-border-bottom-right-radius: 0;
	border-bottom-right-radius: 0;
	-moz-border-radius-bottomleft: 0;
	-webkit-border-bottom-left-radius: 0;
	-khtml-border-bottom-left-radius: 0;
	border-bottom-left-radius: 0;
}

.lifebroker-graph-dialog .ui-dialog-content {
	background-image:		url("common/images/dialog/content_820.png") !important;
}

.lifebroker-graph-dialog .ui-dialog-content .wrapper {
	padding:					15px 15px;
}

#lifebroker-graph-dialog-content {
	background:					#CCC;
}

#lifebroker-graph-dialog .wrapper .popup-buttons a {
	margin-bottom:				15px;
}

</go:style>