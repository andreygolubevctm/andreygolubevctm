<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<session:get settings="true" />
<c:set var="whiteSpaceRegex" value="[\\r\\n\\t]+"/>
<c:set var="content">
<%--Important use JSP comments as whitespace is being removed--%>
<%--
=======================
HCF (HCF is usually setting the default values)
=======================
--%>

var healthFunds_HCF = {
  set: function(){
    <%--credit card & bank account frequency & day frequency--%>
    meerkat.modules.healthPaymentStep.overrideSettings('credit',{ 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true });
  },
  unset: function(){
  }
};
</c:set>
<c:out value="${go:replaceAll(content, whiteSpaceRegex, '')}" escapeXml="false" />