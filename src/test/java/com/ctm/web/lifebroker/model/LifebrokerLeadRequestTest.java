package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import org.junit.Assert;
import org.junit.Test;

public class LifebrokerLeadRequestTest {


    private final XmlMapper xmlMapper = new XmlMapper();

    @Test
    public void toXml() throws Exception {
        LifebrokerLeadRequest request = new LifebrokerLeadRequest("1234567", "john.doe@email.com", "123456789", "4037", "John Doe", "CTMREF01", "2017-01-01 13:00:00");
        String xml = xmlMapper.writeValueAsString(request);
        String expected = "<request xmlns=\"urn:Lifebroker.EnterpriseAPI\"><contact><email>john.doe@email.com</email><phone>123456789</phone><postcode>4037</postcode><client><name>John Doe</name></client><additional><media_code>CTMREF01</media_code></additional><affiliate_id>1234567</affiliate_id><Call_time>2017-01-01 13:00:00</Call_time></contact></request>";
        Assert.assertEquals(expected, xml);
    }


}
