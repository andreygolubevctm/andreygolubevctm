<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:get settings="true" />

<layout:generic_confirmation_page title="Home Loan Confirmation">

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<homeloan:footer />
	</jsp:attribute>

	<jsp:attribute name="body_end">
		<homeloan:settings />
	</jsp:attribute>

	<jsp:body>
		<p>Thanks ${data.homeloan.confirmation.firstName} for your Home Loans enquiry. We&#39;ll pass your details onto a broker who will be in touch with you within the next business day.</p>
		<p>Your reference number for your enquiry is <strong>${data.homeloan.confirmation.flexOpportunityId}</strong>. It&#39;s a good idea to keep this handy for future communications with your broker.</p>
	</jsp:body>
</layout:generic_confirmation_page>