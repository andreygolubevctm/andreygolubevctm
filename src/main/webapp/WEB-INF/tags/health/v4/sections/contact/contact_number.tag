<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Number"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<field_v4:contact_number mobileXpath="${xpath}/contactNumber/mobile" otherXpath="${xpath}/contactNumber/other" className="contact-details-contact-number" checkMobileBlacklist="true" />
<field_v1:hidden xpath="${xpath}/flexiContactNumber" />