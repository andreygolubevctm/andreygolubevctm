<%@ tag description="Tracker location" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ attribute name="firstName" required="false" rtexprvalue="true" description="First name" %>
<%@ attribute name="locationName" required="false" rtexprvalue="true" description="Location name" %>
<%@ attribute name="locationDistance" required="false" rtexprvalue="true" description="Location distance" %>
<%@ attribute name="toyType" required="false" rtexprvalue="true" description="Toy Type" %>
<%@ attribute name="imageName" required="false" rtexprvalue="true" description="Image name" %>

<div id="location_details">
	<div class="container">
		<div class="row">
			<div class="col-xs-5">
				<h2>Current location</h2>
				<h1>${locationName}</h1>
			</div>
			<div class="col-xs-2">
				<img class="meerkatCrest" src="" data-defer-src="assets/brand/ctm/images/zeus/currentlocation_crest.png" alt="Meerkat Crest">
			</div>
			<div class="col-xs-5">
				<h2>Kilometers to Australia</h2>
				<h1>${locationDistance}</h1>
			</div>
		</div>
	</div>
</div>

<div id="location_container">
	<div class="container">
		<div class="row">
			<div class="col-xs-12">
				<img class="globalMap" src="" data-defer-src="assets/brand/ctm/images/zeus/map_${imageName}.png" alt="Global Map">
				<span class="postcardName">${firstName}</span>
				<img class="postcard" src="" data-defer-src="assets/brand/ctm/images/zeus/postcard_${imageName}${toyType}.png" alt="Aleksandr Russian postcard">
			</div>
		</div>
	</div>
</div>
