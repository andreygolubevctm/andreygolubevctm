<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="net.tanesha.recaptcha.ReCaptchaImpl" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaResponse" %>

  <%
  	String captchaResponse = "invalid";
    String remoteAddr = request.getRemoteAddr();
    ReCaptchaImpl reCaptcha = new ReCaptchaImpl();
    reCaptcha.setPrivateKey("6LeWg7sSAAAAAIBLAoU4fcFiq8OlEdPyPcjZGqie");

    String challenge = request.getParameter("recaptcha_challenge_field");
    String uresponse = request.getParameter("recaptcha_response_field");
    ReCaptchaResponse reCaptchaResponse = reCaptcha.checkAnswer(remoteAddr, challenge, uresponse);

    if (reCaptchaResponse.isValid()) {
    	captchaResponse="valid";
    }
    out.print(captchaResponse);
  %>
