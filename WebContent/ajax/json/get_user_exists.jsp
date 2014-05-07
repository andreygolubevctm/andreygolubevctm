<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="${param.vertical}" />

<security:authentication
	emailAddress="${param.save_email}"
	vertical="${param.vertical}" />

{
	"exists": ${userData.loginExists},
	"optInMarketing": ${userData.optInMarketing}
}
