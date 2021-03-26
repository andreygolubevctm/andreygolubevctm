package com.ctm.web.core.services;

import com.ctm.web.core.web.Utils;
import org.junit.Assert;
import org.junit.Test;

public class UtilsTest {

    @Test
    public void testEmail(){
        String template = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"http://exacttarget.com/wsdl/partnerAPI\" xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" xmlns:wsa=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n" +
                "    <soapenv:Header>\n" +
                "        <wsse:Security soapenv:mustUnderstand=\"1\">\n" +
                "            <wsse:UsernameToken>\n" +
                "                <wsse:Username>6212063_API_User</wsse:Username>\n" +
                "                <wsse:Password>c039@r3t3</wsse:Password>\n" +
                "            </wsse:UsernameToken>\n" +
                "        </wsse:Security>\n" +
                "    </soapenv:Header>\n" +
                "    <soapenv:Body>\n" +
                "        <CreateRequest xmlns=\"http://exacttarget.com/wsdl/partnerAPI\">\n" +
                "            <Options/>\n" +
                "            <Objects xsi:type=\"ns1:TriggeredSend\">\n" +
                "                <Client>\n" +
                "                    <ID>6212063</ID>\n" +
                "                </Client>\n" +
                "                <TriggeredSendDefinition>\n" +
                "                    <CustomerKey>QA_CTM_HC_Quote_Com_TS_Key</CustomerKey>\n" +
                "                </TriggeredSendDefinition>\n" +
                "                <Subscribers>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ProductType</Name>\n" +
                "                        <Value>HC</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ProductLabel</Name>\n" +
                "                        <Value>Home &amp; Contents Cover Insurance</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>Brand</Name>\n" +
                "                        <Value>ctm</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>FirstName</Name>\n" +
                "                        <Value>Test</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>LastName</Name>\n" +
                "                        <Value>User</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>EmailAddress</Name>\n" +
                "                        <Value>preload.testing@comparethemarket.com.au</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>OptIn</Name>\n" +
                "                        <Value>Y</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>UnsubscribeURL</Name>\n" +
                "                        <Value><![CDATA[http://localhost:8080/ctm/unsubscribe.jsp?vertical=home&token=oZw7NX6YcFuZ1jnpBtvTo7w-q3PmC53zEdDlJ18ZxOYdDgJJWxbK5j0Ly6hHpOjV5U6jhs8ACi98btLCVzPEZxYM74aPQdgv8nm5EJNqn9Wh86nWjOo4cmGSqghrO84iN74bI8zWeBzaZfYw44JPwsNDD7fNbYh34DQ8lkJ-e2FwC0Qa4GjhpFcQvUr3NWHazoJi8DFKfBJ6X3Xh5Pjz9NvG4CvvZao8K8F4gvcR3BA]]></Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>CallcentreHours_Text</Name>\n" +
                "                        <Value><![CDATA[Monday to Friday (8am-8pm EST) and Saturday (8am-5pm EST)]]></Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>CallcentreHours</Name>\n" +
                "                        <Value><![CDATA[Monday to Friday (8am-8pm EST) and Saturday (8am-5pm EST)]]></Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>CoverType1</Name>\n" +
                "                        <Value>Smart Home And Contents Insurance</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ValidDate1</Name>\n" +
                "                        <Value>14 September 2017</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>Provider1</Name>\n" +
                "                        <Value>BUDGET DIRECT</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>SmallLogo1</Name>\n" +
                "                        <Value>http://image.e.comparethemarket.com.au/lib/fe9b12727466047b76/m/1/hc_budd.png</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>Premium1</Name>\n" +
                "                        <Value>$1047</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ExcessHome1</Name>\n" +
                "                        <Value>$500</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ExcessContents1</Name>\n" +
                "                        <Value>$500</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ApplyURL1</Name>\n" +
                "                        <Value><![CDATA[http://localhost:8080/ctm/email/incoming/gateway.json?gaclientid=1610065762.1496023410&cid=em:cm:hc:500195:hnc_bp&et_rid=172883275&utm_source=hnc_quote_bp&utm_medium=email&utm_campaign=hnc_quote_bp&token=oZw7NX6YcFuZ1jnpBtvTo7w-q3PmC53zEdDlJ18ZxOYdDgJJWxbK5j0Ly6hHpOjV5U6jhs8ACi98btLCVzPEZyk0qYuEyc7Z_QDi90B7TNtQk6s8jYVONR77WaFGXUe5X0n_kZ1dqZd8zPCG3VBVT_PF_D7g_l2_orl3xArSfmat1_8LjxJhk3UwTicyBrEOM4sa7o92oF7oOtjlHdQSDrphE0BlyhDqxRFB8Y5BuUI]]></Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>PremiumLabel1</Name>\n" +
                "                        <Value><![CDATA[Annual Online Premium]]></Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>PhoneNumber1</Name>\n" +
                "                        <Value>1800 042 757</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>QuoteRef1</Name>\n" +
                "                        <Value>Z7H007259</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>CoverType2</Name>\n" +
                "                        <Value>Home and Contents Insurance</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ValidDate2</Name>\n" +
                "                        <Value>14 September 2017</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>Provider2</Name>\n" +
                "                        <Value>Home and Contents Insurance</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>SmallLogo2</Name>\n" +
                "                        <Value>http://image.e.comparethemarket.com.au/lib/fe9b12727466047b76/m/1/hc_exdd.png</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>Premium2</Name>\n" +
                "                        <Value>$1053</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ExcessHome2</Name>\n" +
                "                        <Value>$500</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ExcessContents2</Name>\n" +
                "                        <Value>$500</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ApplyURL2</Name>\n" +
                "                        <Value><![CDATA[http://localhost:8080/ctm/email/incoming/gateway.json?gaclientid=1610065762.1496023410&cid=em:cm:hc:500195:hnc_bp&et_rid=172883275&utm_source=hnc_quote_bp&utm_medium=email&utm_campaign=hnc_quote_bp&token=oZw7NX6YcFuZ1jnpBtvTo7w-q3PmC53zEdDlJ18ZxOYdDgJJWxbK5j0Ly6hHpOjV5U6jhs8ACi98btLCVzPEZyk0qYuEyc7Z_QDi90B7TNuK_Cz5wqdKiZvo-dRUuH71X0n_kZ1dqZd8zPCG3VBVT_PF_D7g_l2_orl3xArSfmat1_8LjxJhk3UwTicyBrEOM4sa7o92oF7oOtjlHdQSDrphE0BlyhDqxRFB8Y5BuUI]]></Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>PremiumLabel2</Name>\n" +
                "                        <Value><![CDATA[Annual Online Premium]]></Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>PhoneNumber2</Name>\n" +
                "                        <Value>1800 003 631</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>QuoteRef2</Name>\n" +
                "                        <Value>Z7H007261</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>CoverType3</Name>\n" +
                "                        <Value>Gold Home and Contents Insurance</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ValidDate3</Name>\n" +
                "                        <Value>14 September 2017</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>Provider3</Name>\n" +
                "                        <Value>Gold Home and Contents Insurance</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>SmallLogo3</Name>\n" +
                "                        <Value>http://image.e.comparethemarket.com.au/lib/fe9b12727466047b76/m/1/hc_expo.png</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>Premium3</Name>\n" +
                "                        <Value>$1079</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ExcessHome3</Name>\n" +
                "                        <Value>$500</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ExcessContents3</Name>\n" +
                "                        <Value>$500</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ApplyURL3</Name>\n" +
                "                        <Value><![CDATA[http://localhost:8080/ctm/email/incoming/gateway.json?gaclientid=1610065762.1496023410&cid=em:cm:hc:500195:hnc_bp&et_rid=172883275&utm_source=hnc_quote_bp&utm_medium=email&utm_campaign=hnc_quote_bp&token=oZw7NX6YcFuZ1jnpBtvTo7w-q3PmC53zEdDlJ18ZxOYdDgJJWxbK5j0Ly6hHpOjV5U6jhs8ACi98btLCVzPEZyk0qYuEyc7Z_QDi90B7TNt51bHHwdil5LksW1ufJD1PX0n_kZ1dqZd8zPCG3VBVT_PF_D7g_l2_orl3xArSfmat1_8LjxJhk3UwTicyBrEOM4sa7o92oF7oOtjlHdQSDrphE0BlyhDqxRFB8Y5BuUI]]></Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>PremiumLabel3</Name>\n" +
                "                        <Value><![CDATA[Annual Online Premium]]></Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>PhoneNumber3</Name>\n" +
                "                        <Value>1800 220 044</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>QuoteRef3</Name>\n" +
                "                        <Value>Z7H007262</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>CoverType4</Name>\n" +
                "                        <Value>Virgin Home &amp; Contents Insurance Price Saver</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ValidDate4</Name>\n" +
                "                        <Value>14 September 2017</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>Provider4</Name>\n" +
                "                        <Value>Virgin Home &amp; Contents Insurance Price Saver</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>SmallLogo4</Name>\n" +
                "                        <Value>http://image.e.comparethemarket.com.au/lib/fe9b12727466047b76/m/1/hc_virg.png</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>Premium4</Name>\n" +
                "                        <Value>$1100</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ExcessHome4</Name>\n" +
                "                        <Value>$500</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ExcessContents4</Name>\n" +
                "                        <Value>$500</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>ApplyURL4</Name>\n" +
                "                        <Value><![CDATA[http://localhost:8080/ctm/email/incoming/gateway.json?gaclientid=1610065762.1496023410&cid=em:cm:hc:500195:hnc_bp&et_rid=172883275&utm_source=hnc_quote_bp&utm_medium=email&utm_campaign=hnc_quote_bp&token=oZw7NX6YcFuZ1jnpBtvTo7w-q3PmC53zEdDlJ18ZxOYdDgJJWxbK5j0Ly6hHpOjV5U6jhs8ACi98btLCVzPEZyk0qYuEyc7Z_QDi90B7TNtiTp_qsnqMEjwN-OiZiYcytQxXVKbHYGuRe83ttn6MJvPF_D7g_l2_orl3xArSfmat1_8LjxJhk3UwTicyBrEOM4sa7o92oF7oOtjlHdQSDrphE0BlyhDqxRFB8Y5BuUI]]></Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>PremiumLabel4</Name>\n" +
                "                        <Value><![CDATA[Annual Online Premium]]></Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>PhoneNumber4</Name>\n" +
                "                        <Value>1800 010 414</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>QuoteRef4</Name>\n" +
                "                        <Value>Z7H007260</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>SubscriberKey</Name>\n" +
                "                        <Value>preload.testing@comparethemarket.com.au</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>Address</Name>\n" +
                "                        <Value>22 Peregrine Cres, Coomera QLD 4209</Value>\n" +
                "                    </Attributes>\n" +
                "                    <Attributes>\n" +
                "                        <Name>PremiumFrequency</Name>\n" +
                "                        <Value>Annual</Value>\n" +
                "                    </Attributes>\n" +
                "                    <SubscriberKey>preload.testing@comparethemarket.com.au</SubscriberKey>\n" +
                "                    <EmailAddress>preload.testing@comparethemarket.com.au</EmailAddress>\n" +
                "                </Subscribers>\n" +
                "            </Objects>\n" +
                "        </CreateRequest>\n" +
                "    </soapenv:Body>\n" +
                "</soapenv:Envelope>";


        String email = Utils.getEmailAddress(template);
        Assert.assertEquals("preload.testing@comparethemarket.com.au", email);
    }
}
