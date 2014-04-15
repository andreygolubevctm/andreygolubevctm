<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<core:doctype />

<go:setData dataVar="data" xpath="login" value="*DELETE" />
<go:setData dataVar="data" xpath="messages" value="*DELETE" />

<c:set var="login"><core:login uid="${param.uid}" asim="N" /></c:set>

<go:html>
<core:head quoteType="false" title="User Stats" nonQuotePage="${true}" />
<body>
	<go:script marker="js-href" href="common/js/highcharts/highcharts.js"></go:script>
	<go:script marker="js-href" href="common/js/highcharts/themes/simples.js"></go:script>

	<go:style marker="css-head">
		html {
			background-color:#F3F3F3;
		}
	</go:style>

	<go:script marker="js-head">
	var quoteApps;
	var closing;
	$(document).ready(function() {
		quoteApps = new Highcharts.Chart({
			chart: {
				renderTo: 'quoteApps',
				type: 'column'
			},
			title: {
				text: 'Quote &amp; Application Stats - Last 2 weeks'
			},
			credits: {
				enabled:false
			},
			xAxis: {
				categories: ['Mon 02/07', 'Tue 03/07', 'Wed 04/07', 'Thur 05/07', 'Fri 06/07', 'Sat 07/07',
							'Mon 09/07', 'Tue 10/07', 'Wed 11/07', 'Thur 12/07', 'Fri 13/07', 'Sat 14/07']
			},
			yAxis: {
				min: 0,
				title: {
					text: 'Quotes / Applications'
				},
				stackLabels: {
					enabled: true,
					style: {
						fontWeight: 'bold',
						color: (Highcharts.theme && Highcharts.theme.textColor) || 'white'
					}
				}
			},
			legend: {
				align: 'right',
				x: -100,
				verticalAlign: 'top',
				y: 20,
				floating: true,
				backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColorSolid) || 'white',
				borderColor: '#CCC',
				borderWidth: 1,
				shadow: false
			},
			tooltip: {
				formatter: function() {
					return '<b>'+ this.x +'</b><br/>'+
						this.series.name +': '+ this.y +'<br/>'+
						'Total: '+ this.point.stackTotal;
				}
			},
			plotOptions: {
				column: {
					stacking: 'normal',
					dataLabels: {
						enabled: true,
						color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
					}
				}
			},
			series: [{
				name: 'Quote Only',
				data: [15, 13, 14, 17, 12, 10, 12, 18, 19, 8, 17, 14]
			}, {
				name: 'Applications',
				data: [5, 4, 4, 6, 7, 4, 3, 5, 6, 6, 4, 7]
			}]
		});
		closing = new Highcharts.Chart({
			chart: {
				renderTo: 'closing',
				type: 'spline'
			},
			credits: {
				enabled:false
			},
			title: {
				text: 'Closing % per day - last 2 weeks'
			},
			xAxis: {
				categories: ['Mon 02/07', 'Tue 03/07', 'Wed 04/07', 'Thur 05/07', 'Fri 06/07', 'Sat 07/07',
							'Mon 09/07', 'Tue 10/07', 'Wed 11/07', 'Thur 12/07', 'Fri 13/07', 'Sat 14/07']
			},
			yAxis: {
				title: {
					text: 'Closing %'
				},
				labels: {
					formatter: function() {
					}
				}
			},
			tooltip: {
				crosshairs: true,
				shared: true
			},
			plotOptions: {
				spline: {
					marker: {
						radius: 4,
						lineColor: '#666666',
						lineWidth: 1
					}
				}
			},
			series: [{
				name: 'Closing %',
				data: [25, 23.53, 22.22, 26.01, 36.84, 28.57, 20, 21.74, 24, 42.86, 19.05, 33.33 ]
			}, {
				name: 'Closing % 2 weeks prior',
				data: [22.4, 24.31, 20.4, 22.45, 34.15, 22.12, 18.7, 19.94, 22.14, 33.47, 21.04, 28.56 ]
			}]
		});

		$("#teamStats").button().click(function() {
			window.location.href='simples_stats_team.jsp';
		});
	});
	</go:script>

	<div id="teamStats" style="margin: 30px;clear:both;float:left;">Show TEAM Statistics</div>
	<div id="quoteApps" style="min-width: 800px; height: 400px; margin: 30px;clear:both;"></div>
	<div id="closing" style="min-width: 800px; height: 400px; margin: 30px;clear:both;"></div>
</body>
</go:html>