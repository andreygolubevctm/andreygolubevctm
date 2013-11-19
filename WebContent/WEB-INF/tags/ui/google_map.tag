<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Builds a Google Map (v3 API)"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 				required="true"		rtexprvalue="true"	 description="css id attribute" %>
<%@ attribute name="sensor" 			required="false"	rtexprvalue="true"	 description="whether or not geolocation should be activated" %>

<%-- VARIABLES --%>
<c:set var="apiKey" value="AIzaSyDbeHpSRiTcLlMK535rIi4i3Km8uLC4tVs" />
<c:if test="${empty sensor}"><c:set var="sensor" value="false" /></c:if>

<%-- HTML --%>
<go:script href="https://maps.googleapis.com/maps/api/js?key=${apiKey}&sensor=${sensor}" marker="js-href"></go:script>
<div id="${id}Canvas"></div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var ${id}Handler = new Object();
${id}Handler = {

	map: false,
	markers: [],
	infowindow: false,

	<%-- all parameters are optional, map will default to Sydney with zoom=8 and mapType=Road --%>
	init: function(lat, long, zoom, type){

		<%-- DEFAULTS --%>
			<%-- position on Sydney if not set --%>
			if(isNaN(lat)){
				lat = -34.397;
			}
			if(isNaN(long)){
				long = 150.644;
			}

			if(isNaN(zoom)){
				zoom = 8;
			}
			if(isNaN(type)){
				type = google.maps.MapTypeId.ROADMAP;
			}

			var mapOptions = {
				center: new google.maps.LatLng(lat, long),
				zoom: zoom,
				mapTypeId: type
			};

		<%-- only load if not already loaded --%>
		if(!${id}Handler.map){
			${id}Handler.map = new google.maps.Map(document.getElementById("${id}Canvas"), mapOptions);
		} else {
			${id}Handler.map.panTo(mapOptions.center);
			${id}Handler.map.setZoom(zoom);
		}

	},

	<%-- title and icon are optional => No hover tooltip and default marker icon --%>
	addMarker: function(lat, long, title, icon){

		var position = new google.maps.LatLng(lat, long);

		var marker = new google.maps.Marker({
			position: position,
			map: ${id}Handler.map,
			icon: icon,
			title: title
		});

		${id}Handler.markers.push(marker);

		return marker;
	},

	<%-- add an info tooltip on click of a marker --%>
	addBubbleToMarker: function(marker, content){

		google.maps.event.addListener(marker, 'click', function() {

			<%-- always close the infowindow if it exists --%>
			if(${id}Handler.infowindow){
				${id}Handler.infowindow.close();
			}

			<%--
			sort out if we should open the bubble
			- open if different bubble (current bubble has different content than the clicked one)
			- open if no bubble was open
			- don't open if same marker has been clicked (has been closed just above so it basically toggled it)
			--%>
			if(
				!${id}Handler.infowindow ||
				!${id}Handler.infowindow.isOpen ||
				( ${id}Handler.infowindow && ${id}Handler.infowindow.getContent() != ${id}Handler.wrapInfowindowContent(content) )
			) {
				${id}Handler.addBubble(content);
				${id}Handler.infowindow.open(${id}Handler.map, marker);
				${id}Handler.infowindow.isOpen = true;
			} else {
				${id}Handler.infowindow.isOpen = false;
			}

		});

	},

	<%-- add infowindow/bubble - position is optional if you don't want to display it straight away --%>
	addBubble: function(content, lat, long){

		content = ${id}Handler.wrapInfowindowContent(content);

		var options = {
			map: ${id}Handler.map,
			content: content
		}

		if(lat && long){
			$.extend(options, {position: new google.maps.LatLng(lat, long)});
		}

		${id}Handler.infowindow = new google.maps.InfoWindow(options);

	},

	wrapInfowindowContent: function(content){

		return '<div class="infowindowContainer">' + content + '</div>';

	},

	<%-- add a button to locate the user --%>
	addCurrentLocationButton: function(){

		<%--
		Set CSS styles for the DIV containing the control
		Setting padding to 5 px will offset the control from the edge of the map
		--%>
		var controlDiv = document.createElement('div');
		controlDiv.style.padding = '5px';

		<%-- Set CSS for the control border --%>
		var controlUI = document.createElement('div');
		controlUI.style.backgroundColor = 'white';
		controlUI.style.color = 'rgb(51, 51, 51)';
		controlUI.style.WebkitBoxShadow = 'rgba(0, 0, 0, 0.4) 0px 2px 4px';
		controlUI.style.borderStyle = 'solid';
		controlUI.style.borderWidth = '1px';
		controlUI.style.cursor = 'pointer';
		controlUI.style.textAlign = 'center';
		controlUI.title = 'Click here to set the map to your current location';
		controlDiv.appendChild(controlUI);

		<%-- Set CSS for the control interior --%>
		var controlText = document.createElement('div');
		controlText.style.fontFamily = 'Arial,sans-serif';
		controlText.style.fontSize = '13px';
		controlText.style.padding = '1px 6px';
		controlText.innerHTML = 'Current location';
		controlUI.appendChild(controlText);

		controlDiv.index = 1;
		${id}Handler.map.controls[google.maps.ControlPosition.TOP_RIGHT].push(controlDiv);

		<%-- Position to current location on click --%>
		google.maps.event.addDomListener(controlUI, 'click', function() {
			${id}Handler.setCenterToCurrentLocation();
		});

	},

	<%-- set center of the map to the current location of the user --%>
	addCurrentLocationMarker: function(center){
		if(typeof center == "undefined"){
			center = true;
		}

		${id}Handler.getCurrentLocation(function(pos){

			if(!pos.error){
				var currentLocationMarker = ${id}Handler.addMarker(pos.coords.latitude, pos.coords.longitude, "Current Location");
				${id}Handler.addBubbleToMarker(currentLocationMarker, "<h1>Your current location</h1>");
				if(center){
					${id}Handler.map.setCenter(new google.maps.LatLng(pos.coords.latitude, pos.coords.longitude));
				}
			}

		});

	},

	<%-- get current location of the user --%>
	getCurrentLocation: function(callback){

		// Try HTML5 geolocation
		if(navigator.geolocation) {

			navigator.geolocation.getCurrentPosition(function(position) {

				if( typeof callback == "function" ) {
					callback(position);
				} else {
					getCurrentLocation( false, new google.maps.LatLng(position.coords.latitude, position.coords.longitude) );
				}

			}, function() {
				return {error: "The Geolocation service failed"};
			},
			{timeout:10000});

		} else {
			return {error: "Your browser doesn\'t support geolocation."};
		}

	},

	<%-- removes markers from the map but keeps them in the array --%>
	<%-- @todo = pass an array of markers to clear --%>
	clearMarkers: function(){
		if (${id}Handler.markers) {
			for (i in ${id}Handler.markers) {
				${id}Handler.markers[i].setMap(null);
			}
		}
	},

	<%-- shows the markers in the array of markers --%>
	<%-- @todo = pass an array of markers to show --%>
	showMarkers: function() {
		if (${id}Handler.markers) {
			for (i in ${id}Handler.markers) {
				${id}Handler.markers[i].setMap(${id}Handler.map);
			}
		}
	},

	<%-- delete all markers --%>
	<%-- @todo = pass an array of markers to delete --%>
	deleteMarkers: function(){
		if (${id}Handler.markers) {
			for (i in ${id}Handler.markers) {
				${id}Handler.markers[i].setMap(null);
			}
			${id}Handler.markers.length = 0;
		}
	}
};
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	#${id}Canvas{
		width: 100%;
		height: 100%;
	}
</go:style>
