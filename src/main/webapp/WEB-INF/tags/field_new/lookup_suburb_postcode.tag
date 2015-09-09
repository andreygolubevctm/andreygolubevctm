<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Suburb/postcode autocomplete lookup input"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="placeholder" 	required="true"	 rtexprvalue="true"	 description="Placeholder text" %>
<%@ attribute name="required" 		required="false" rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="extraDataAttributes" required="false" rtexprvalue="true" description="additional data attributes" %>

<%-- HTML --%>
<field_new:autocomplete xpath="${xpath}" className="blur-on-select show-loading" title="Postcode/Suburb" required="${required}" source="ajax/json/get_suburbs.jsp?fields=postcode%2C+suburb%2C+state&term="  placeholder="${placeholder}" extraDataAttributes="${extraDataAttributes}" />
