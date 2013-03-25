package com.disc_au.soap;

import java.io.InputStream;

import javax.xml.transform.Source;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;

public class SOAPResolver implements URIResolver {
	public Source resolve(String href, String base) {
		InputStream resolverStream = this.getClass().getClassLoader().getResourceAsStream(href);
System.out.println("RESOLVARRRRR HREF " + href + " | BASE " + base + " | STREAM " + resolverStream.toString());
		return new StreamSource(resolverStream);
	}
}
