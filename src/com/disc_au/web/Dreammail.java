package com.disc_au.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

public class Dreammail {

	public static String send(String username, String password, String servername, String rtm_url, String xml_content, String debugOn ){
		boolean debug = (debugOn.equals("Y"));
		if (rtm_url.indexOf("http") != 0) {
			rtm_url = "http://" + rtm_url;
		}
		if (debug){
			System.out.println("DreamMail params:");
			System.out.println("Username=" +username);			
			System.out.println("Password=" +password);
			System.out.println("ServerName=" +servername);
			System.out.println("Url=" +rtm_url);
			System.out.println("XML=" +xml_content);
		}
		URL url;
		try {
			url = new URL(rtm_url);
			URLConnection connection = url.openConnection();
			connection.setDoOutput(true);
			
			// Set the HTTP headers
			connection.setRequestProperty("ServerName", servername);
			connection.setRequestProperty("UserName", username);
			connection.setRequestProperty("Password", password);
			
			// Write the data 
			PrintWriter out = new PrintWriter(connection.getOutputStream());
			out.print(xml_content);
			out.close();			
		
			BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			String inputLine;
			StringBuffer resp = new StringBuffer();
			while ((inputLine = in.readLine()) != null) {
				resp.append(inputLine);
			}
			if (debug){
				System.out.println("Result:");
				System.out.println(resp.toString());
			}
			return resp.toString();
			
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}
}
