package com.disc_au.soap;

import java.io.InputStream;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;

public class SOAPResolver implements URIResolver {
	public Source resolve(String href, String base) throws TransformerException {
//System.out.print("SOAPResolver called: HREF " + href + " | BASE " + base + " | VOODOO DOLL " + base.replaceFirst("^.*/WEB-INF(/classes)?(.+)$", "$2") + href + " KITTENS | ");
		String resolverFile = base.replaceFirst("^.*/WEB-INF/(classes/)?(.+)$", "$2");

		// Strip leading "goback" path out
		while ( href.startsWith("../") ) {
			resolverFile = resolverFile.replaceFirst("^(.+/)[^/]+/$", "$1");
			href = href.replaceFirst("../", "");
		}

		resolverFile += href;
System.out.println("RESOLVAR " + resolverFile);

		// First, try on the classpath (assume given path has a leading slash)
		InputStream xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(resolverFile);

		// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
		if ( xsltSourceInput == null ) {
			resolverFile = "../" + resolverFile;
System.out.println("FAILED AT PATH, GOING UP: " + resolverFile);
			xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(resolverFile);
		}

		return new StreamSource(xsltSourceInput);
	}
}
