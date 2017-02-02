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
			<div class="col-sm-12 col-sm-5">
				<h2>Current location</h2>
				<h1>${locationName}</h1>
			</div>
			<div class="col-sm-12 col-sm-2">
				<img class="meerkatCrest" src="" data-defer-src="assets/brand/ctm/images/zeus/currentlocation_crest.png" alt="Meerkat Crest">
			</div>
			<div class="col-sm-12 col-sm-5">
				<h2>Kilometres to Australia</h2>
				<h1>${locationDistance}</h1>
			</div>
		</div>
	</div>
</div>

<div id="location_container">
	<div class="container">
		<div class="row">
			<div class="col-xs-0 col-sm-1">
			</div>
			<div class="col-xs-12 col-sm-10">
				<div class="globalMap map_${imageName} toy${toyType}"></div>
				<span class="mobilePostcardName">${firstName}</span>
				<div class="mobileShareLinks">
					<div class="facebookShare shareButton" url_location="https://www.comparethemarket.com.au/meerkat_toys/share/?location=${imageName}${toyType}"><img src="" data-defer-src="assets/brand/ctm/images/zeus/share_facebook.png" alt="Share on Facebook"></div>
					<a class="twitterShare shareButton" href="https://twitter.com/intent/tweet?text=My%20%23Meerkattoy%20is%20on%20his%20way.%20Click%20your%20internet%20mouse%20below%20to%20find%20how%20you%20can%20get%20yours!&url=https://www.comparethemarket.com.au/meerkat_toys/share/?location=${imageName}${toyType}"><img src="" data-defer-src="assets/brand/ctm/images/zeus/share_twitter.png" alt="Share on Twitter"></a>
				</div>
				<div class="postcardContainer">
					<img class="postcard" src="" data-defer-src="assets/brand/ctm/images/zeus/postcard_${imageName}${toyType}.png" alt="Aleksandr Russian postcard">
					<span class="postcardName">${firstName}</span>
					<div class="shareLinks">
						<div class="facebookShare shareButton" url_location="https://www.comparethemarket.com.au/meerkat_toys/share/?location=${imageName}${toyType}"><img src="" data-defer-src="assets/brand/ctm/images/zeus/share_facebook.png" alt="Share on Facebook"></div>
						<a class="twitterShare shareButton" href="https://twitter.com/intent/tweet?text=My%20%23Meerkattoy%20is%20on%20his%20way.%20Click%20your%20internet%20mouse%20below%20to%20find%20how%20you%20can%20get%20yours!&url=https://www.comparethemarket.com.au/meerkat_toys/share/?location=${imageName}${toyType}"><img src="" data-defer-src="assets/brand/ctm/images/zeus/share_twitter.png" alt="Share on Twitter"></a>
					</div>
				</div>
			</div>
			<div class="col-xs-0 col-sm-1">
			</div>
		</div>
	</div>
</div>
