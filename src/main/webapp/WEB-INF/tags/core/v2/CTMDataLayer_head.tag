<%@ tag description="Inpiut" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script data-cfasync="false"><content:get key="initialiseCtmDataLayer" /></script>

<script data-cfasync="false" src="https://www.googleoptimize.com/optimize.js?id=${pageSettings.getSetting('VAR02_ID_OPT')}"></script>

<script data-cfasync="false">(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start': new Date().getTime(),event:'gtm.js',anonymousID:localStorage.getItem('ca_identity') || undefined,accounts:JSON.parse(localStorage.getItem('ca_accountsData')) || undefined});var f=d.getElementsByTagName(s)[0], j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src= 'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','${pageSettings.getSetting('VAR01_DL')}','${pageSettings.getSetting('VAR03_ID_GTM')}');</script>