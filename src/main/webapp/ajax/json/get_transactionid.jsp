<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- THIS CAN ONLY BE TO INCREMENT THE TRANSACTION ID --%>
<session:get searchPreviousIds="true" settings="true" verticalCode="${fn:toUpperCase(param.quoteType)}" />
<core_v1:get_transaction_id
	quoteType="${param.quoteType}"
	id_handler="${param.id_handler}"
	emailAddress="${param.emailAddress}" />