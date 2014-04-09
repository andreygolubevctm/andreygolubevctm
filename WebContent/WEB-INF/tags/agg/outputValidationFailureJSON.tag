<%@ tag description="Left-Hand side Filter/Sort panel"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="validationErrors" required="true"  type="java.util.List" rtexprvalue="true" %>
<%@ attribute name="origin" required="true" rtexprvalue="false" %>

{
	"error" : {
		"type":"validation",
		"message" : "It looks like some fields are incomplete please check your details and try again",
		"transactionId" : ${data.current.transactionId},
		"errorDetails": {
			"validationErrors" : [
			<c:forEach var="validationError"  items="${validationErrors}">
			<error:non_fatal_error origin="${origin}"
					errorMessage="message:${validationError.message} elementXpath:${validationError.elementXpath} elements:${validationError.elements}" errorCode="VALIDATION" />
				${prefix} {
					"message":"${validationError.message}" ,
					"elementXpath":"${validationError.elementXpath}",
					"elements":"${validationError.elements}"
				}
			<c:set var="prefix" value="," />
			</c:forEach>
			]
		}
	}
}