<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" />

<p>
	Your privacy is important to us. And you may be wondering about the information we are collecting when you get quotes and compare products on our site.
</p>

<c:choose>
	<c:when test="${pageSettings.getVerticalCode() == 'homeloan'}">
		
		<p>
			The information we collect depends on what products and quotes you are comparing and without this information, we wouldn't be able to offer our service. Information about persons named must be given with their consent. We use your information, some of which may be sensitive, to provide you with quotes and/or comparisons. If you submit an enquiry to us regarding home loans, we'll pass this information on to Australian Finance Group Ltd ACN 066 385 822 (AFG) and its mortgage broker/s to enable a broker to contact you to discuss your finance needs. We may also use it to keep you up-to-date with our services and products.
		</p>
		<p>
			Your personal information (but not your sensitive information) may be held by some of our (or AFG’s) service providers in an overseas location, the details of which can be found in our (or AFG’s) privacy policy. In these privacy policies, you can also find out more about the information we hold and how to correct it, as well as how to make a complaint and how this complaint will be handled. <a href="${pageSettings.getSetting('privacyPolicyUrl')}" target="_blank">View CTM Privacy Policy</a>. <a href="${pageSettings.getSetting('argPrivacyPolicyUrl')}" target="_blank">View AFG Privacy Policy</a>.
		</p>

	</c:when>
	<c:otherwise>
	
		<p>
			The information we collect depends on what products and quotes you are comparing and without this information, we wouldn't be able to offer our service. Information about persons named must be given with their consent. We use your information, some of which may be sensitive, to provide you with quotes and/or comparisons. If you choose to apply for a product, we'll pass this information on to the chosen product provider. We may also use it to keep you up-to-date with our services and products.
		</p>
		<p>
			Your personal information (but not your sensitive information) may be held by some of our service providers in an overseas location, the details of which can be found in our privacy policy. In this privacy policy, you can also find out more about the information we hold and how to correct it, as well as how to make a complaint and how this complaint will be handled.&nbsp;&nbsp;<a href="${pageSettings.getSetting('privacyPolicyUrl')}" target="_blank">View Privacy Policy</a>
		</p>
		
	</c:otherwise>
</c:choose>

