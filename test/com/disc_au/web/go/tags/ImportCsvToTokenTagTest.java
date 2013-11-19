package com.disc_au.web.go.tags;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.util.List;

import org.junit.Test;


public class ImportCsvToTokenTagTest {

	@Test
	public void testShouldParseCSVAndGetProducts() throws Exception {
		ImportCsvToTokenTag importCsvToXml = new ImportCsvToTokenTag();

		importCsvToXml.setFilePath("/test/com/disc_au/web/go/tags/test.csv");
		importCsvToXml.setXmlTemplateFilePath("/test/com/disc_au/web/go/tags/test.xml");
		importCsvToXml.setStartRow(2);
		importCsvToXml.setStartColumn(1);
		importCsvToXml.setEndColumn(200);

		List<String> products = importCsvToXml.getTokenReplacedFormat();
		assertEquals(3 ,products.size());
		String product = products.get(0);
		for(String p : products) {
			System.out.println(p);
		}
		assertTrue(product.contains("<perPerson>$0.00</perPerson>"));
	}

}
