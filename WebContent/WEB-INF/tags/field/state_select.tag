<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built from general table."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 		required="false" rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className"	 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 			required="false" rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="useFullNames" 	required="false" rtexprvalue="true"	 description="whether to use full state names in the select options" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />

<%-- HTML --%>
<select name="${name}" id="${name}" class="${className}">

   	<c:choose>
	   	<c:when test="${empty useFullNames}">
	   		<c:set var="states">=Please choose...,ACT=ACT,NSW=NSW,NT=NT,QLD=QLD,SA=SA,TAS=TAS,VIC=VIC,WA=WA</c:set>
	   	</c:when>
	   	<c:otherwise>
	   		<c:set var="states">=Please choose...,ACT=Australian Capital Territory,NSW=New South Wales,NT=Northern Territory,QLD=Queensland,SA=South Australia,TAS=Tasmania,VIC=Victoria,WA=Western Australia</c:set>
	   	</c:otherwise>
	</c:choose>
   	
   	
   	<c:forTokens items="${states}" delims="," var="state">
   	
   		<c:set var="val" value="${fn:substringBefore(state,'=')}" />
		<c:set var="des" value="${fn:substringAfter(state,'=')}" />
		
   		<c:set var="selected">
   			<c:choose>
	   			<c:when test="${value eq val}">
	   				selected="selected"
	   			</c:when>
	   			<c:otherwise></c:otherwise>
	   		</c:choose>
   		</c:set>
		<option value="${val}"${selected}>${des}</option>
	</c:forTokens>
	
</select>	

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title}"/>

