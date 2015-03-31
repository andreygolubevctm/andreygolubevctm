<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Credit Card Handover Form"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<h5>Stay up to date with news and offers direct to your inbox.</h5>

<div class="col-xs-12 col-sm-6 col-sm-offset-3 col-md-4 col-md-offset-4">

	<creditcard:contact_details />
	<creditcard:optin />

	<a class="btn btn-next btn-block cc-submit-details" href="javascript:;">Sign up & continue <span class="icon icon-arrow-right"></span></a>
	<a class="btn btn-back btn-block cc-just-continue" href="${productHandoverUrl}">No thanks, continue to provider</a>
</div>
