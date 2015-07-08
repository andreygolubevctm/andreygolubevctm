<%@ tag description="Fuel Google Map" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="google-map-canvas-template">
    <div class="row">
        <div class="col-xs-12" id="google-map-container">
            <div id="map-canvas" style="width: 100%; height: 100%"></div>
        </div>
    </div>
</core:js_template>
<core:js_template id="map-marker-template">

    {{ var urlHost = meerkat.modules.performanceProfiling.isIos() ? 'http://maps.apple.com' : 'https://maps.google.com'; }}
    <div class="map-info-window">

        <div class="map-address-container">
            <h5>{{= obj.name }}</h5>
            {{ var mapDirectionsUrl = urlHost + "/?saddr=Current%20Location&daddr=" + encodeURI(obj.address + " " + obj.postcode + " " + obj.state + " Australia"); }}
            <a href="{{= mapDirectionsUrl }}" target="_blank" title="Get Directions to {{= obj.name }}">{{= obj.address }}</a>
        </div>

        <div class="map-price-container">
            <div class="price">{{= obj.priceText }}</div>
            <div class="small-heading">{{= obj.fuelText }}</div>
            {{ if(obj.price2Text) { }}
            <div class="price push-top-10">{{= obj.price2Text }}</div>
            <div class="small-heading">{{= obj.fuel2Text }}</div>
            {{ } }}
        </div>
    </div>
</core:js_template>