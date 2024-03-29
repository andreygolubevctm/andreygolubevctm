<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="${fn:toUpperCase(param.vertical)}" />

<security:authentication
	justChecking="true"
	emailAddress="${param.save_email}"
	vertical="${param.vertical}" />

{
	"exists": ${userData.loginExists},
	"optInMarketing": ${userData.optInMarketing}
}
