
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Used to capture the details of a person"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="personXpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="idx" 		required="true"  rtexprvalue="true"	 description="Index to the persons data" %>

<%--
	Make sure that "request" is clear in the data bucket
	Then copy the child nodes from the xpath into our temporary "request" variable.
	xpath could look something like 'admin/persons/person[@idx=1]'
	So that the input fields prepoulate correctly 
--%>
<go:setData dataVar="data" xpath="request" value="*DELETE" />
<go:setData dataVar="data" xpath="request" value="data[xpath]" />


<%-- HTML for the panel --%>
<field:hidden xpath="request/person/@idx" constantValue="${idx}" />
<field:person_name required="true" title="Person's name" className="${className}" xpath="request/person/name" />
<field:person_dob required="true" title="Person's DOB" className="${className}" xpath="request/person/dob" /> 







