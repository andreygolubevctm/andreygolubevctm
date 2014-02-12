package com.disc_au.soap;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.URL;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

public class SOAPOutputWriter {

	Logger logger = Logger.getLogger(SOAPOutputWriter.class.getName());

	private String debugPath;
	private String name;

	private XsltTranslator translator;

	private String tranId;

	public SOAPOutputWriter(String name, XsltTranslator translator, String tranId) {
		this.name = name;
		this.translator = translator;
		this.tranId = tranId;
	}


	public void writeXmlToFile(String xml , String type, String maskingXslt) {
		if(maskingXslt != null && !maskingXslt.isEmpty()) {
			Map<String , Object> params = new HashMap<String , Object>();
			if (this.tranId!=null){
				params.put("transactionId",this.tranId);
			}
			logger.debug("masking file content for " + type + " " + maskingXslt);
			writeFile(translator.translate(maskingXslt, xml, null,  params , false), type);
		} else {
			writeFile(xml, type);
		}
	}

	/**
	 * Write file.
	 *
	 * @param data the data
	 * @param fileType the file type
	 */
	private void writeFile(String output, String type) {
		if (this.debugPath != null) {
			SimpleDateFormat sdf  = new SimpleDateFormat("yyyyMMdd-HH");
			String debugPathLocal = this.debugPath;
			String debugDateFolder = sdf.format(new Date());
			String debugFolder = debugPathLocal + "/" + debugDateFolder;

			// If path is absolute (leading slash), load it directly
			if ( !debugFolder.startsWith("/") ) {
				// Otherwise: first, try on the classpath
				URL debugPathURL = this.getClass().getClassLoader().getResource(debugPathLocal);

				// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
				if ( debugPathURL == null ) {
					debugPathLocal = "../" + debugPathLocal;
					debugPathURL = this.getClass().getClassLoader().getResource(debugPathLocal);
				}

				debugFolder = (debugPathURL.toString() + debugDateFolder).replaceFirst("^file:", "");
			}

			File dbf = new File(debugFolder);
			if (!dbf.exists() || !dbf.isDirectory()) {
				dbf.mkdir();
			}

			String filename = debugFolder + "/"
					+ this.name.replace(' ', '_')
					+ "_" + String.valueOf(System.currentTimeMillis())
					+ "_" + type
					+ ".xml";
			FileWriter w;
			try {
				w = new FileWriter(filename);
				w.write(output);
				w.close();
			} catch (IOException e) {
				logger.error("failed to write to file"  , e);
			}
		}
	}

	public void setDebugPath(String debugPath) {
		this.debugPath = debugPath;
	}

}
