<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<div class="famous-container">
	<div class="row famous-content">
		<div class="col-xs-12 col-sm-3">
			<img src="common/images/logos/car/famous-logo.jpg" />
		</div>
		<div class="col-xs-12 col-sm-9 content-block">
			${resultsHeading}
			${resultsContact}
		</div>
	</div>
	<c:set var="heading">
		Find great deals across our range of products
	</c:set>
	<%-- Had to use JS to remove homeloan as it also removed HNC. Also get free styling by using this id --%>
	<confirmation:other_products heading="${heading}"  id="confirmation-compare-options" />
</div>