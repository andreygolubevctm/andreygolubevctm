<%@ tag description="The Results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="noResultsCompany" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "companyIdAndPhone")}' />
<c:set var="noResultsCompany" value='${miscUtils:randomiseContent(noResultsCompany)}' />

<div id="noResultsContainer" class="container-fluid">

	<div class="row">
		<div class="col-xs-12">
			<h2>Unfortunately the providers on our panel chose not to quote.</h2>
		</div>
	</div>

	<div class="row">
		<div class="col-xs-12">
			<p>Some of the more common reasons why the insurers on our panel may not have given a car insurance quote today could be due to one or more of the following:</p>
		</div>
	</div>

	<div class="row knockOutReasonsRow">
		<div class="col-xs-12">
			<ul class="knockOutReasons">
				<li>- Age restrictions</li>
				<li>- Vehicle Type</li>
				<li>- Modifications to a vehicle</li>
			</ul>
			<ul class="knockOutReasons">
				<li>- Claims</li>
				<li>- Driving history</li>
			</ul>
		</div>
	</div>

	<div class="row">
		<div class="col-xs-12">
			<p>If you were unable to get a quote today, you may like to contact the provider directly to reconfirm your details and chat through your car insurance options.</p>
		</div>
	</div>

	<div class="row companyRow">
		<div class="col-xs-12">
			<c:forEach items="${noResultsCompany.getSupplementary()}" var="company" >
				<div class="companyContainer">
					<div class="companyLogo logo_${company.getSupplementaryKey()}"></div>
					<div class="callContainer">
						<p><strong>call</strong></p>
						<a href="tel:${company.getSupplementaryValue()}">${company.getSupplementaryValue()}</a>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>

	<div class="row findAnInsurerRow">
		<div class="col-xs-12">
			<p>Alternatively, you may want to refer to the <strong>Insurance Council of Australia</strong>'s "Find an Insurer" website at <a href="http://www.findaninsurer.com.au/" target="_blank">www.findaninsurer.com.au</a> and they may be able to provide you with a list of companies who can assist you with cover.</p>
		</div>
	</div>

</div>