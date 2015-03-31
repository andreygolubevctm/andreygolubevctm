<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Credit Card Handover Form"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<h5>Compare the Market want to say Thank You for using our comparison service by offering you the chance to win $1,000.</h5>

<div class="col-xs-12 col-sm-6 col-md-4 col-md-offset-2">
	<div class="competition-banner"></div>
</div>
<div class="col-xs-12 col-sm-6 col-md-4">
	<creditcard:contact_details />
	<creditcard:optin competition="${true}" />
</div>

<div class="clearfix"></div>

<div class="col-xs-12 col-sm-6 col-md-4 col-md-offset-2 hidden-xs">
	<a class="btn btn-back btn-block hidden-xs cc-just-continue" href="${productHandoverUrl}">No thanks, continue to provider</a>
</div>
<div class="col-xs-12 col-sm-6 col-md-4">
	<a class="btn btn-next btn-block cc-submit-details" href="javascript:;">Enter competition & continue <span class="icon icon-arrow-right"></span></a>
	<a class="btn btn-back btn-block visible-xs cc-just-continue" href="${productHandoverUrl}">No thanks, continue to provider</a>
</div>
