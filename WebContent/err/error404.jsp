<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="date" class="java.util.Date" />


<c:set var="pageTitle" value="404" />

<%@ include file="/WEB-INF/err/errorHeader.jsp" %>

		<div class="clearfix normal-header" id="header">
			<div class="inner-header">
				<h1><a title="Compare the Market" href="http://www.comparethemarket.com.au/">Compare the Market</a></h1>
			</div>
		</div>
		<div id="wrapper" class="clearfix">
			<div id="page" class="clearfix">
				<div id="content">
					<h1 class="error_title">Whoops, sorry… </h1>
					<div class="error_message">
						<h2>looks like you're looking for something that isn't there!</h2>
						<p>Sorry about that, but the page you're looking for can't be found. Either you've typed the web address incorrectly, or the page you were looking for has been moved or deleted.</p>
						<p>Try checking the URL you used for errors.</p>
					</div>
				</div>
				<div class="clearfix"></div>
			</div>
		</div>
		<div class="clearfix" id="footer">
			<div class="container">
				<div id="footer_mcafee">
					<a href="https://www.mcafeesecure.com/RatingVerify?ref=ecommerce.disconline.com.au&amp;lang=AU" target="_blank"><img border="0" oncontextmenu="alert('Copying Prohibited by Law - McAfee Secure is a Trademark of McAfee, Inc.'); return false;" alt="McAfee Secure sites help keep you safe from identity theft, credit card fraud, spyware, spam, viruses and online scams" src="https://images.scanalert.com/meter/ecommerce.disconline.com.au/13.gif?lang=AU"></a>
				</div>
				<p class="first">The Compare the Market website and call centre and the Compare the Market brand and trading name are owned by, licensed to and/or operated by Compare The Market Pty Ltd (“CTM”) ACN 117323 378, AFSL 422926 (and in respect of life insurance and income protection insurance (“Life Products”), AR 434310). This website provides a service to compare certain products and services on the basis of particular criteria you select including brand, price, and coverage.</p>
				<p>Comprehensive car insurance, travel insurance, health insurance, Life Products, energy plans and roadside assistance product comparisons for participating providers are provided by CTM. The car insurance features comparison (involving participating and non-participating providers) is provided by LMI Group Pty Ltd (ACN 086 256 171). The fuel price comparison is based on information provided by MotorMouth Pty Ltd (ACN 095 755 052). The energy plan comparison is based on data provided by Switchwise Pty Ltd (ACN 117 323 378) (“Switchwise”)</p>
				<p>In respect of Life Products, CTM is an authorised representative (AR 434310) of Lifebroker Pty Ltd ACN 115 153 243(“Lifebroker”); AFSL 400209.</p>
				<p>The products and services compared on this site are not representative of all products and services available in the market.</p>
				<p>Several of the car insurance brands featured on this website are policies arranged by Auto &amp; General Services Pty Ltd (“AGS”), for and on behalf of the insurer, Auto &amp; General Insurance Company Limited (“Auto &amp; General”). AGS, Auto &amp; General and CTM are related entities. Please see our pages relating to car insurance for a list of the products arranged by AGS and offered by Auto &amp; General.</p>
				<p>Several of the travel insurance brands featured on this website are policies arranged by AGS for and on behalf of the travel insurer. AGS and CTM are related entities. Please see our pages relating to travel insurance for a list of the products arranged by AGS.</p>
				<p>This site provides you with factual information and general recommendations about products and services and what to consider when buying. The comparison service is not a personal recommendation suggestion or advice about the suitability of a particular product or service for you and your needs. You must evaluate which products or services are suitable for you.</p>
				<p>Each brand may have differing terms and features as well as price. For insurance products (other than compulsory third party insurance), always read the Product Disclosure Statement or policy documentation for each brand before making a decision to buy. For all other products, read the relevant terms and conditions supplied by the provider.</p>
				<p><i>If you decide to purchase a particular product or service, you will be provided with a link to connect you to the provider’s website (or in the case of health insurance or CarSure car insurance, web pages operated by CTM for it to arrange insurance on behalf of the underwriter or in the case of energy plans, for plans that can be applied for online on this website your application will be provided to Switchwise who will liaise with the provider and for energy plans that cannot be applied for online on this website you will be provided with a link to learn more about such plans ) or for products and services (other than travel insurance, health insurance, energy plans and Life Products), given that provider’s telephone contact details to make your application and/or payment. In respect of health insurance, you will be given the CTM telephone contact details to make your application and/or payment. In respect of Life Products, you will be given telephone contact details for a call centre operated by Lifebroker (or you can request Lifebroker contact you by telephone).</i></p>
			</div>
		</div>
		<div id="copyright">
			<p>&copy; 2006-<fmt:formatDate value="${date}" pattern="yyyy" /> Compare the Market. All rights reserved.
				<a href="javascript:showDoc('${data['settings/privacy-policy-url']}','Privacy_Policy')">Privacy Policy</a>.
				<a href="javascript:showDoc('${data['settings/website-terms-url']}','Website_Terms_of_Use')">Website Terms of Use</a>.
			</p>
		</div>

<%@ include file="/WEB-INF/err/errorFooter.jsp" %>