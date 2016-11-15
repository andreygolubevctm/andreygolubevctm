<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Builds the CSS to create a cross browser compatible box shadow" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Attributes --%>
<%@ attribute name="brandCode"  required="true"	 rtexprvalue="true"	 description="The brand code applicable to the page" %>

<%-- Variables --%>
<c:if test="contextBrandCode">
    <c:choose>
        <c:when test="${brandCode eq 'choo'}">app</c:when>
        <c:otherwise>ctm</c:otherwise>
    </c:choose>
</c:if>

<%-- CSS --%>
<style type="text/css">
    html, body {
        position:relative;
        top:0px;
        margin: 0;
        padding: 0;
        height: auto;
        min-height: 100%;
        background: #b8b28b;
        font-family: Helvetica,Arial,sans-serif;
    }
    .bkg-image {
        position: fixed;
        margin: 0;
        padding: 0;
        height: 100%;
        width: 100%;
        min-height: 100%;
        background: #b8b28b url('/${contextBrandCode}/assets/brand/${brandCode}/graphics/blocked.png') bottom right no-repeat;
        background-size:contain;
        left: 0;
    }
    .distil {
        position:relative;
    }
    .header {
        background:#FFF;
        padding: 20px 20px 20px 50px;
        border-bottom: 5px solid #c2c8cd;
    }
    .header .logo {
        width:400px;
        height:55px;
        background: #ffffff url('/${contextBrandCode}/assets/brand/${brandCode}/graphics/logo.png') center left no-repeat;
    }
    .content { padding: 25px 50px 50px 50px; }
    .content h1 { color: #1C3F94; }

    #dCF_captcha_text {
        padding: 10px;
        margin: 10px 0px;
        font-size: 10pt;
        width: 298px;
        -webkit-border-radius:5px;
        -moz-border-radius:5px;
        border-radius:5px;
        background-color: rgba(255,255,255,0.6);
    }

    @media(max-width:399px) {
        .header {
            padding: 20px;
        }
        .ctm .header .logo {
            width:300px;
            background-image: url('/${contextBrandCode}/assets/brand/${brandCode}/graphics/logo-xs.png')
        }
        .content {
            padding:20px;
        }
    }

    /** Choosi Styles */
    .choo .content h1 {
        color: #064667;
    }
    .choo .bkg-image {
        background-color: #00AFD8;
        background-image: none;
    }
    .choo #dCF_captcha_text {
        background-color: rgba(0,175,216,0.6);
    }
</style>