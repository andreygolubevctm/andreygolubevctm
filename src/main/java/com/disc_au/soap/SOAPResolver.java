/**  =========================================== */
/**  SOAPResolver SOAP XSLT Import Resolver Class with WAR compatibility
 *   $Id$
 * (c)2013 Auto & General Holdings Pty Ltd       */

package com.disc_au.soap;

import java.io.InputStream;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;

/**
 * The Class SOAPResolver SOAP XSLT Import Resolver for WAR compatibility.
 *
 * @author xplooy
 * @version 1.1
 */
public class SOAPResolver implements URIResolver {
	public Source resolve(String href, String base) throws TransformerException {
		String resolverPath = base.replaceFirst("^.*/WEB-INF/(classes/)?(.+)$", "$2");

		// Strip leading "goback" path out
		while ( href.startsWith("../") ) {
			resolverPath = resolverPath.replaceFirst("^(.+/)[^/]+/$", "$1");
			href = href.replaceFirst("../", "");
		}

		// First, try on the classpath (assume given path has a leading slash)
		InputStream xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(resolverPath + href);

		// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
		if ( xsltSourceInput == null ) {
			resolverPath= "../" + resolverPath;
			xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(resolverPath + href);
		}

		return new StreamSource(xsltSourceInput);
	}
}
