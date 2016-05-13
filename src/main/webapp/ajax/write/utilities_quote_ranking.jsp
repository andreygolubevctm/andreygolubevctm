<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<agg_v1:write_rank rootPath="utilities" rankBy="${param.rankBy}" rankParamName="rank_product_id" />