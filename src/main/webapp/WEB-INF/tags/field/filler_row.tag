<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's name."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>

<%-- HTML --%>
<input type="text" name="void" id="blank" value="">

