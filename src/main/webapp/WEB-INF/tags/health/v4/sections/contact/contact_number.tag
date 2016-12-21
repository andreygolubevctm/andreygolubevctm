<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Number"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<field_v4:contact_number xpath="${xpath}/contactNumber" className="contact-details-contact-number" />
<field_v1:hidden xpath="${xpath}/flexiContactNumber" />