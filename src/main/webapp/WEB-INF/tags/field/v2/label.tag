<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Form label"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true" rtexprvalue="true"	 description="optional id for this row"%>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="widthClass"			required="false" rtexprvalue="true"	 description="The Bootstrap width class" %>
<%@ attribute name="value" 				required="false" rtexprvalue="true"	 description="Label value" %>
<%@ attribute name="addForAttr" 		required="false" rtexprvalue="true"	 description="Bool to add or not the for attribute" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="className"><c:out value="${className} ${widthClass} control-label" /></c:set>
<c:if test="${not empty name}"><c:set var="forAttr" value='for="${name}"' /></c:if>

<label <c:if test="${addForAttr eq 'true'}">${forAttr}</c:if> class="${className}">${value}</label>