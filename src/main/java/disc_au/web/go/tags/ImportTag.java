package com.disc_au.web.go.tags;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;

import javax.servlet.jsp.JspException;

import org.apache.commons.codec.binary.Base64;


@SuppressWarnings("serial")
public class ImportTag extends BaseTag {
	public static final int HTTP_OK = 200;

	String url;
	String var; 
	String username; 
	String password; 
	
	 
	public void setUrl(String url) {
		this.url = url;
	}

	public void setVar(String var) {
		this.var = var;
	}

	public void setUsername(String user) {
		this.username = user;
	}
	
	public void setPassword(String password) {
		this.password = password;
	}

	@Override
	public int doEndTag() throws JspException {
		URL u;
		try {
			u = new URL(this.url);
			HttpURLConnection connection = (HttpURLConnection) u.openConnection();
	
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setRequestMethod("GET");
			//connection.setRequestProperty("Content-Type","text/html; charset=\"utf-8\"");
			
			// If a user and password given, encode and set the user/password
			if (this.username != null && !this.username.isEmpty()
					&& this.password != null && !this.password.isEmpty()) {
	
				String userPassword = this.username + ":" + this.password;
				String encoded = Base64.encodeBase64String(userPassword.getBytes());
				connection.setRequestProperty("Authorization", "Basic "
						+ encoded);
			}
			
			StringBuffer data = new StringBuffer(); 
			if (connection.getResponseCode() == HTTP_OK){
 
				// Receive the result
				InputStreamReader rin = new InputStreamReader(connection
						.getInputStream());
				BufferedReader response = new BufferedReader(rin);
				String line;
				
				while ((line = response.readLine()) != null) {
					data.append(line);
				}

				// Clean up the streams and the connection
				rin.close();
				
				if (this.var!=null){
					pageContext.setAttribute(var, data.toString());
				} else {
					
					pageContext.getOut().write(data.toString());
				}
			} else {
				System.err.println("HTTP Error code: ("+url+") " + String.valueOf(connection.getResponseCode()) + " : " + connection.getResponseMessage());
			}
			
			connection.disconnect();
		
		} catch (MalformedURLException e) {
			System.err.println("ImportTag Failed: (" + url + ") " + e.getMessage());
			
		} catch (ProtocolException e) {
			System.err.println("ImportTag Failed: (" + url + ") " + e.getMessage());
			
		} catch (IOException e) {
			System.err.println("ImportTag Failed: ("+url+") " + e.getMessage());
		}
		
		return SKIP_BODY;
	}
}