<%@ tag description="The Comparison Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<ui:horizontal-bar-element className="filtersBar">
	<div class="quickFilters">
		<span class="quickFiltersTitle" >Quick Filters</span>
		<span class="quickFiltersArrow"><img src="brand/ctm/images/filter-arrow.png" /></span>
			<core:clear />
	</div>

	<div class="filtersContainer">
		<jsp:doBody />
	</div>
</ui:horizontal-bar-element>

<go:script marker="js-head">
	var Filters = new Object();
	Filters = {

		init: function( userSettings ){

			var settings = {
				animation: {

				},
				elements: {
					filtersBar: ".filtersBar",
					price: ".price",
					frequency: ".frequency"
				}
			};
			$.extend(true, settings, userSettings);

			Filters.settings = settings;
		}

	};

</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	.filtersBar{
		<css:box_shadow horizontalOffset="0" verticalOffset="1" blurRadius="10" spread="0" color="#A9A9A9" />
		<css:gradient topColor="#9C9C9C" bottomColor="#ABABAB" />
		width: 100%;
		height: auto;
		padding: 5px 0;
		display: none;
	}
		.quickFilters {
			float: left;
		}
		.home .quickFilters {
			margin-top:2px;
		}
			.quickFiltersTitle {
				color: #FFFFFF;
				padding-top: 8px;
				float: left;
				font-size: 1.5em;
				font-family: "SunLTBoldRegular", Arial, Helvetica, sans-serif;
				margin-right: 10px;
			}
			.quickFiltersArrow {
				float: left;
			}
		.filtersContainer {
			font-size: 1.3em;
		}

</go:style>