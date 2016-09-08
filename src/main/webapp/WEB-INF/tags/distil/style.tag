<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Builds the CSS to create a cross browser compatible box shadow" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

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
        background: #b8b28b url('assets/brand/${pageSettings.getBrandCode()}/graphics/blocked.png') bottom right no-repeat;
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
        background: #ffffff url('${pageSettings.getBrandCode()}/assets/brand/${pageSettings.getBrandCode()}/graphics/logo.png') center left no-repeat;
    }
    .content { padding: 25px 50px 50px 50px; }
    .content h1 { color: #1C3F94; }

    @media(max-width:399px) {
        .header {
            padding: 20px;
        }
        .header .logo {
            width:300px;
            background-image: url('${pageSettings.getBrandCode()}/assets/brand/${pageSettings.getBrandCode()}/graphics/logo-xs.png')
        }
        .content {
            padding:20px;
        }
    }
</style>