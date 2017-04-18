package com.ctm.web.creditcards.services.creditcards;

import com.ctm.web.creditcards.model.UploadRequest;
import org.hamcrest.text.IsEqualIgnoringCase;
import org.hamcrest.text.IsEqualIgnoringWhiteSpace;
import org.junit.Test;

import static com.ctm.common.test.TestUtil.readResource;
import static com.ctm.common.test.TestUtil.readResourceStream;
import static org.hamcrest.Matchers.equalToIgnoringWhiteSpace;
import static org.junit.Assert.*;


public class UploadServiceTest {

    @Test
    public void getRates() throws Exception {
        UploadRequest file = new UploadRequest();
        file.providerCode = "1";
        file.uploadedStream  = readResourceStream("com/ctm/creditcard/creditcardwithmschars.csv");
        String expect  = readResource("com/ctm/creditcard/expect.txt");
        String result = UploadService.getRates(file);
        assertThat(result, equalToIgnoringWhiteSpace(expect));
    }


    @Test
    public void getRatesExtraLines() throws Exception {
        UploadRequest file = new UploadRequest();
        file.providerCode = "1";
        file.uploadedStream  = readResourceStream("com/ctm/creditcard/creditcardwithextralines.csv");
        String expect  = readResource("com/ctm/creditcard/expect.txt");
        String result = UploadService.getRates(file);
        assertThat(result, equalToIgnoringWhiteSpace(expect));
    }

    @Test
    public void replaceMsCharactersTest() throws Exception {
        String text = "The promotional balance transfer rate is available when you apply for a new Westpac credit card between 12th October 2016 and 30th January 2017 and request at application to transfer balance(s) from up to 3 non-Westpac Australian issued credit, charge or store cards. The rates will apply to balance(s) transferred (min $200 up to 95% of your approved available credit limit) for the promotional period, unless the amount is paid off earlier. Card activation will trigger the processing of the balance transfer. The variable purchase rate will apply to balance(s) transferred but left unpaid at the end of the promotional period. Westpac will not be responsible for any delays that may occur in processing payment to your other card account(s) and will not close the account(s). The variable purchase interest rate applies to balance transfers requested at any other time. " +
                "Interest free days don’t apply to balance transfers.\n";
        String expect = "The promotional balance transfer rate is available when you apply for a new Westpac credit card between 12th October 2016 and 30th January 2017 and request at application to transfer balance(s) from up to 3 non-Westpac Australian issued credit, charge or store cards. The rates will apply to balance(s) transferred (min $200 up to 95% of your approved available credit limit) for the promotional period, unless the amount is paid off earlier. Card activation will trigger the processing of the balance transfer. The variable purchase rate will apply to balance(s) transferred but left unpaid at the end of the promotional period. Westpac will not be responsible for any delays that may occur in processing payment to your other card account(s) and will not close the account(s). The variable purchase interest rate applies to balance transfers requested at any other time. " +
                "Interest free days don't apply to balance transfers.\n";
        assertEquals(expect, UploadService.replaceMsCharacters(text));
    }

}