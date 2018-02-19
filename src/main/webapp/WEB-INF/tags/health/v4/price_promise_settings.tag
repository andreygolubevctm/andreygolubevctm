<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="key" value="pricePromiseURL" />
<c:set var="pricePromiseXSHeight" scope="application"><content:get key="${key}" suppKey="xsHeight"/></c:set>
<c:set var="pricePromiseSMHeight" scope="application"><content:get key="${key}" suppKey="smHeight"/></c:set>
<c:set var="pricePromiseMDHeight" scope="application"><content:get key="${key}" suppKey="mdHeight"/></c:set>
<c:set var="pricePromiseLGHeight" scope="application"><content:get key="${key}" suppKey="lgHeight"/></c:set>