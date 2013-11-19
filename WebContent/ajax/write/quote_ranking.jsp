<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%--
	Used to send the values chosen on the toggles back to the iSeries.
	Called whenever the user changes the "importance" of any of the toggles.
--%>

<agg:write_rank rootPath="${param.rootPath}" rankBy="${param.rankBy}" />