<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- THIS CAN ONLY BE TO INCREMENT THE TRANSACTION ID --%>
<session:get searchPreviousIds="true" />
<core:get_transaction_id
	quoteType="${param.quoteType}"
	id_handler="${param.id_handler}"
	emailAddress="${param.emailAddress}" />