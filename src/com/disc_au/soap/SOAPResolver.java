package com.disc_au.soap;

import java.io.InputStream;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;

public class SOAPResolver implements URIResolver {
	public Source resolve(String href, String base) throws TransformerException {
System.out.print("SOAPResolver called: HREF " + href + " | BASE " + base + " | ");
		String basePathOnly = base.replaceFirst("^(.+/)[^/+]$", "$1");
System.out.print("PATH " + basePathOnly);
		InputStream resolverStream = this.getClass().getResourceAsStream(basePathOnly + href);
System.out.println("STREAMOBJ " + resolverStream.toString());
		return new StreamSource(resolverStream);
	}
}
