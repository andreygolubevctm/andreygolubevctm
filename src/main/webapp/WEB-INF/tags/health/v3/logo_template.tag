<%@ tag description="The Health Logo template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
{{ if (!obj.hasOwnProperty('premium')) {return;} }}
{{ if(typeof obj.displayLogo === 'undefined' || obj.displayLogo == true) { }}
<div class="companyLogo {{= info.provider ? info.provider : info.fundCode }}"></div>
{{ } }}