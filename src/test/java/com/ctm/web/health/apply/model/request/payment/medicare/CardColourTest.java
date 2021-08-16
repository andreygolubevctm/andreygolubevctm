package com.ctm.web.health.apply.model.request.payment.medicare;

import com.ctm.web.health.apply.model.request.payment.medicare.CardColour;
import org.junit.Assert;
import org.junit.Test;

public class CardColourTest {

    @Test
    public void testCardColourYellow() {
        CardColour yellow = new CardColour("Yellow");
        Assert.assertEquals("Yellow", yellow.get());
    }

    @Test
    public void testCardColourBlue() {
        CardColour yellow = new CardColour("Blue");
        Assert.assertEquals("Blue", yellow.get());
    }

    @Test
    public void testCardColourGreen() {
        CardColour yellow = new CardColour("Green");
        Assert.assertEquals("Green", yellow.get());
    }
}
