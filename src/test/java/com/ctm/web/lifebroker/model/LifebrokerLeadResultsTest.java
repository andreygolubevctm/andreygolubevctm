package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import org.junit.Assert;
import org.junit.Test;

public class LifebrokerLeadResultsTest {


    private final XmlMapper xmlMapper = new XmlMapper();

    @Test
    public void fromXml() throws Exception {
        String respsonse = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                "<results xmlns=\"urn:Lifebroker.EnterpriseAPI\">\n" +
                "    <client>\n" +
                "        <reference>fea7c00759ebc77fd3bb0a</reference>\n" +
                "    </client>\n" +
                "</results>";
        LifebrokerLeadResults lifebrokerResults = xmlMapper.readValue(respsonse, LifebrokerLeadResults.class);
        Assert.assertEquals(new LifebrokerLeadResults().withClient(new LifebrokerLeadResultsClient().withReference("fea7c00759ebc77fd3bb0a")), lifebrokerResults);
    }


}
