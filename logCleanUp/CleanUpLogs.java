import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;

import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactoryConfigurationError;

// HLT-858 throw me away when done
public class CleanUpLogs {


	public static String logDir =      "C:/Dev/web_ctm/WebContent/database/application_logs/";
	public static String maskedDir =   logDir+ "masked/";
	public static String baseXSLTDir = "C:/Dev/web_ctm/WebContent/WEB-INF/aggregator/health_application/";
	/**
	 * @param args
	 * @throws TransformerException
	 * @throws IOException
	 */
	public static void main(String[] args) throws TransformerException, IOException {
		File dir = new File(logDir);
		File[] files = dir.listFiles();
		for (File file : files) {
			String fileName = file.getName();
			System.out.println("fileName: " + fileName);
			if(fileName.contains(".xml")) {
				String fundCode = fileName.split("_")[1];
				if(fileName.contains("_req_in")) {
					String xsltFileName = baseXSLTDir + "maskRequestIn.xsl";
					process(file, fileName, xsltFileName);
				} else if(fileName.contains("_req_out")) {
					String xsltFileName;
					if(fundCode.equals("THF") || fundCode.equals("CUA") || fundCode.equals("FRA") || fundCode.equals("GMF") || fundCode.equals("GMH")) {
						xsltFileName = baseXSLTDir + "/maskRequestOutHSL.xsl";
					} else {
						xsltFileName = baseXSLTDir + fundCode.toLowerCase()+"/maskRequestOut.xsl";
					}
					process(file, fileName, xsltFileName);
				} else if(fileName.contains("_resp_in") && fundCode.equals("NIB")) {
					String xsltFileName = baseXSLTDir + "nib/maskRespIn.xsl";
					process(file, fileName, xsltFileName);
				} else {
					Files.copy( file.toPath(), new File( maskedDir + fileName ).toPath());
				}
			}
		}
	}
	protected static void process(File file, String fileName,
			String xsltFileName) throws TransformerFactoryConfigurationError,
			TransformerConfigurationException, TransformerException,
			FileNotFoundException {
		javax.xml.transform.TransformerFactory tFactory =
				javax.xml.transform.TransformerFactory.newInstance();

// 2. Use the TransformerFactory to process the stylesheet Source and
//		    generate a Transformer.
javax.xml.transform.Transformer transformer = tFactory.newTransformer
				(new javax.xml.transform.stream.StreamSource(xsltFileName));

// 3. Use the Transformer to transform an XML Source and send the
//		    output to a Result object.
transformer.transform
(new javax.xml.transform.stream.StreamSource(file),
new javax.xml.transform.stream.StreamResult( new
								java.io.FileOutputStream(maskedDir + fileName)));
	}

}
