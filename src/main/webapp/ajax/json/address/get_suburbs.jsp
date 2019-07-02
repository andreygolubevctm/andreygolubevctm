<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<jsp:useBean id="addressService" class="com.ctm.web.core.address.AddressService" scope="page" />

<c:set var="result">${addressService.getSuburbs(param.postCode)}</c:set>

${result}