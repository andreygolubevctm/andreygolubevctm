<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<div class="famous-container">
	<div class="row famous-content">
		<div class="col-xs-12 col-sm-3">
			<img src="common/images/logos/car/famous-logo.jpg" />
		</div>
		<div class="col-xs-12 col-sm-9 content-block">
			<p class="famous-thank-you">Thank you, your request has been sent to <span>Famous Insurance</span> and a consultant will be in touch.</p>
			<p class="famous-contact">If you wish, you may contact them on <span>1800 xxx xxx</span></p>
		</div>
	</div>
	<c:set var="heading">
		Find great deals across our range of products
	</c:set>
	<%-- Had to use JS to remove homeloan as it also removed HNC --%>
	<confirmation:other_products heading="${heading}"  id="famous-alt-verticals" ignore="fuel"/>
</div>