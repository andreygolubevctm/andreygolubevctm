package com.ctm.web.core.web.go.tags;

import java.io.IOException;
import java.net.URL;
import java.net.URLConnection;

import javax.servlet.jsp.JspException;

import com.ctm.web.core.web.go.tags.BaseTag;
import org.apache.commons.codec.binary.Base64;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Entities.EscapeMode;
import org.jsoup.select.Elements;
import org.jsoup.safety.Cleaner;
import org.jsoup.safety.Whitelist;

//TODO: Auto-generated Javadoc
/**
* The Class ScriptTag.
* 
* @author gdebever
* @version 1.0
*/

@SuppressWarnings("serial")
public class ScrapeTag extends BaseTag {
	private String url;
	private String cssSelector = "";
	private String sourceEncoding;
	private String outputEncoding = "";
	private Boolean sanitizeHtml = false;
	private String username = "";
	private String password = "";

	// URL 
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	
	// CSS SELECTOR
	public String getCssSelector() {
		return cssSelector;
	}
	public void setCssSelector(String cssSelector) {
		this.cssSelector = cssSelector;
	}
	
	// SOURCE ENCODING
	public String getSourceEncoding() {
		return sourceEncoding;
	}
	public void setSourceEncoding(String sourceEncoding) {
		this.sourceEncoding = sourceEncoding;
	}
	
	// OUTPUT ENCODING
	public String getOutputEncoding() {
		return outputEncoding;
	}
	public void setOutputEncoding(String outputEncoding) {
		this.outputEncoding = outputEncoding;
	}
	
	// SANITIZE HTML
	public Boolean getSanitizeHtml() {
		return sanitizeHtml;
	}
	public void setSanitizeHtml(Boolean sanitizeHtml) {
		this.sanitizeHtml = sanitizeHtml;
	}
	
	// USERNAME
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	
	// PASSWORD
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	
	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doStartTag()
	 */
	@Override
	public int doStartTag() throws JspException {
		try {

			String scrape = scrape(this.url, this.cssSelector, this.sourceEncoding, this.username, this.password);
			
			if(this.sanitizeHtml){
				scrape = sanitizeHtml(scrape, this.outputEncoding);
			}
			
			pageContext.getOut().write(scrape);
			
	        return SKIP_BODY;
	        
		} catch (IOException e) {
			throw new JspException(e);
		}
    }
	
	/**
	 * Scrapes HTML from URL and returns the code matching a CSS selector
	 * 
	 * @param url the url to load
	 * @param selector a CSS selector to look for and scrape (e.g. #htmlId, .class, h1, table tr td.odd, etc.)
	 * @return the scraped element HTML content
	 */
	public static String scrape(String url, String cssSelector, String sourceEncoding, String username, String password){

		Element element = null;
		Elements elements = null;
		String scrape = "";
		
		String login;
		String base64login = "";
		
		if(username != "" && password != ""){
			login = username + ":" + password;
			base64login = new String(Base64.encodeBase64(login.getBytes()));
		}

		try{
			URL urlObject = new URL(url);
			URLConnection uc = urlObject.openConnection();
			
			if(base64login != ""){
				uc.setRequestProperty("Authorization", "Basic " + base64login);
			}

			Document doc = Jsoup.parse(uc.getInputStream(), sourceEncoding, url);
			
			if( cssSelector == "" ){
				element = doc.body();
				scrape = element.html();
			} else {
				elements = doc.select(cssSelector);
				scrape = elements.html();
			}
			
		} catch (IOException e) {
			 return e.toString();
		}
		return scrape.replaceAll("[\\u2018|\\u2019]", "'").replaceAll("[\\u201C|\\u201D]", "\"").replaceAll("\\n", "");
		
	}
	
	/**
	 * Sanitize HTML to avoid XSS attacks
	 * 
	 * @param htmlCode the HTML code to sanitize
	 * @param outputEncoding the Encoding of the output HTML code
	 * @return the sanitized HTML code
	 */
	public static String sanitizeHtml(String htmlCode, String outputEncoding){
		
		// parses String into HTML document
		Document doc = Jsoup.parse(htmlCode);
		
		// creates the HTML whitelist
		Whitelist whitelist = Whitelist.relaxed();
		whitelist.addTags("div");
		
		// Cleans the document
		doc = new Cleaner(whitelist).clean(doc);
		
		// Adjusts escape mode and charset
		if(outputEncoding != "") {
			doc.outputSettings().escapeMode(EscapeMode.xhtml).charset(outputEncoding);
		} else {
			doc.outputSettings().escapeMode(EscapeMode.xhtml);
		}
		
		// strip the \n and replace &apos; by &#39; because IE8 does not translate them
		return doc.body().html().replaceAll("\\n", "").replaceAll("&apos;", "&#39;");
	}
	
}
