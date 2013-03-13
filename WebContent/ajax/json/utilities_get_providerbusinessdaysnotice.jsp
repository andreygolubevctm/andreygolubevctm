<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="tranId" value="123456789" />

<c:import var="utilities" url="https://websvc.switchwise.com.au:444/SwitchwiseCTM_1_5_6/SwitchwiseSearchService.svc/MoveInBusinessDayNotice/${param.providerCode}" />
					
${go:XMLtoJSON(utilities)}
