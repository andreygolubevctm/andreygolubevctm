<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="confirmData" class="com.disc_au.web.go.Data" scope="session" />
<go:setData dataVar="confirmData" xpath="confirm/email_address" value="${data['homelmi/signup/email']}" />
