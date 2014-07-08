<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="userDao" class="com.ctm.dao.UserDao" scope="page" />

<core_new:no_cache_header />

<settings:setVertical verticalCode="SIMPLES" />
<session:get authenticated="true" />

<c:set var="simplesUid" value="${authenticatedData['login/user/simplesUid']}" />
${ userDao.tickleUser(simplesUid) }

<c:out value="OK" />