<%@ tag description="Fuel Google Map" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="map-marker-template">

    {{ var urlHost = meerkat.modules.performanceProfiling.isIos() ? 'http://maps.apple.com' : 'https://maps.google.com'; }}
    <div id="iw_content" class="map-info-window row">

        <div class="col-xs-4 col-sm-4 fuel-site-logo">
            {{ if (obj.brandId) { }}
            <img src="assets/brand/ctm/graphics/fuel/brands/{{= obj.brandId}}@2x.png" />
            {{ } }}
        </div>
        <div class="col-xs-7 col-sm-8">
            <div class="map-address-container">
                <h5>{{= obj.name }}</h5>
                {{ var mapDirectionsUrl = urlHost + "/?saddr=Current%20Location&daddr=" + encodeURI(obj.address + " " + obj.cityName + " Australia"); }}
                <a href="{{= mapDirectionsUrl }}" target="_blank" title="Get Directions to {{= obj.name }}">{{= obj.address }}</a>
            </div>

            {{ if(obj.bandId) { }}
            <div class="map-price-container fuel-band-{{= obj.bandId }}">
                <span class="circle"><span class="icon icon-vert-fuel"></span></span>
                {{ var band = meerkat.modules.fuelResults.getBand(obj.bandId); }}
                <span class="price">
                {{ if (!band.toPrice){ }}
                ≤ {{= band.fromPrice}}
                {{ } else if (!band.fromPrice){ }}
                ≥ {{= band.toPrice}}
                {{ } else { }}
                {{= band.fromPrice }} - {{= band.toPrice }}
                {{ } }}
                </span>
            </div>
            {{ } }}
        </div>
        <div class="col-xs-1">

        </div>
    </div>
</core_v1:js_template>