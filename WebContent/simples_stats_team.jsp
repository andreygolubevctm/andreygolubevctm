<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<core:doctype />

<go:setData dataVar="data" xpath="login" value="*DELETE" />
<go:setData dataVar="data" xpath="messages" value="*DELETE" />
<core:load_settings conflictMode="false" />

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
	var teamQuotes;
	var teamSales;
	$(document).ready(function() {
		teamQuotes = new Highcharts.Chart({
			chart: {
				renderTo: 'teamQuotes',
				plotBackgroundColor: null,
				plotBorderWidth: null,
				plotShadow: false
			},
			title: {
				text: 'Quotes by Team Member last 2 weeks'
			},
			credits: {
				enabled:false
			},
			tooltip: {
				formatter: function() {
					return '<b>'+ this.point.name +'</b>: '+ this.y + ' (' + this.percentage.toFixed(2) +'%)';
				}
			},
			plotOptions: {
				pie: {
					allowPointSelect: true,
					cursor: 'pointer',
					dataLabels: {
						enabled: true,
						color: '#fff',
						connectorColor: '#fff',
						formatter: function() {
							return '<b>'+ this.point.name +'</b>: '+ this.y;
						}
					}
				}
			},
			series: [{
				type: 'pie',
				name: 'Quotes by Team Member',
				data: [
					['Malcolm Reynolds',   204],
					['Zoe Washburne',      184],
					{
						name: 'Hoban Washburne',
						y: 234,
						sliced: true,
						selected: true
					},
					['Inara Serra',   192],
					['Jayne Cobb',    198],
					['Kaylee Frye',   212]
				]
			}]
		});

		teamApps = new Highcharts.Chart({
			chart: {
				renderTo: 'teamApps',
				plotBackgroundColor: null,
				plotBorderWidth: null,
				plotShadow: false
			},
			title: {
				text: 'Applications by Team Member last 2 weeks'
			},
			credits: {
				enabled:false
			},
			tooltip: {
				formatter: function() {
					return '<b>'+ this.point.name +'</b>: '+ this.y + ' (' + this.percentage.toFixed(2) +'%)';
				}
			},
			plotOptions: {
				pie: {
					allowPointSelect: true,
					cursor: 'pointer',
					dataLabels: {
						enabled: true,
						color: '#fff',
						connectorColor: '#fff',
						formatter: function() {
							return '<b>'+ this.point.name +'</b>: '+ this.y;
						}
					}
				}
			},
			series: [{
				type: 'pie',
				name: 'Applications by Team Member',
				data: [
					{
						name:'Malcolm Reynolds',
						y: 62,
						sliced: true,
						selected: true
					},
					['Zoe Washburne',      58],
					['Hoban Washburne', 44],
					['Inara Serra',   38],
					['Jayne Cobb',    41],
					['Kaylee Frye',   55]
				]
			}]
		});
		$("#userStats").button().click(function() {
			window.location.href='simples_stats_user.jsp';
		});
	});
	</go:script>

	<div id="userStats" style="margin: 30px;clear:both;float:left;">Show YOUR Statistics</div>
	<div id="teamQuotes" style="width: 600px; height: 400px; margin: 30px; float:left;clear:left;"></div>
	<div id="teamApps" style="width: 600px; height: 400px; margin: 30px; float:left;"></div>

</body>
</go:html>