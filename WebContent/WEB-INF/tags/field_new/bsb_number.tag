<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's name on credit card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>

<%-- VARIABLES --%>
<c:set var="bsbnumber" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- HTML --%>
<input type="hidden" name="${bsbnumber}" id="${bsbnumber}" class="" value="${value}">
<field_new:input pattern="[0-9]*" xpath="${xpath}input" className="bsb_number numeric ${className}" required="${required}" size="8" maxlength="7" title="${title}" />

<%-- JAVASCRIPT --%>
<go:script marker="onready">
$("#${bsbnumber}input").on("focus blur", function(){
	$("#${bsbnumber}").val( String($("#${bsbnumber}input").val()).replace(/[^0-9]/g, '') );
});
</go:script>

<go:validate selector="${bsbnumber}input" rule="regex" parm="'[0-9]{3}[- ]?[0-9]{3}'" message="BSB must be six numbers e.g. 999-999" />
