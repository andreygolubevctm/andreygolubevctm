<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<security:authentication
	emailAddress="${param.save_email}"
	vertical="${param.vertical}"
	brand="ctm" />

{
	"exists":${data.userData.loginExists},
	"optInMarketing":${data.userData.optInMarketing}
}
