package com.ctm.web.life.email.model;

import com.ctm.web.core.email.model.ExactTargetEmailModel;
import org.junit.Before;
import org.junit.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.hasKey;
import static org.hamcrest.collection.IsMapContaining.hasEntry;

public class LifeBestPriceExactTargetFormatterTest {

    private LifeBestPriceExactTargetFormatter formatter;
    private String age = "50";

    @Before
    public void setup(){
        formatter = new LifeBestPriceExactTargetFormatter();
    }

    @Test
    public void testFormatXml() throws Exception {
        LifeBestPriceEmailModel model = new LifeBestPriceEmailModel();
        model.setAge(age);
        ExactTargetEmailModel result = formatter.formatXml(model);

        assertThat(result.getAttributes(), hasKey("ValidDate"));
        assertThat(result.getAttributes(), hasKey("FirstName"));
        assertThat(result.getAttributes(), hasKey("LastName"));
        assertThat(result.getAttributes(), hasKey("Brand"));
        assertThat(result.getAttributes(), hasKey("TPDCover"));
        assertThat(result.getAttributes(), hasKey("LifeCover"));
        assertThat(result.getAttributes(), hasKey("TraumaCover"));
        assertThat(result.getAttributes(), hasKey("Premium1"));
        assertThat(result.getAttributes(), hasKey("QuoteRef"));
        assertThat(result.getAttributes(), hasKey("Occupation"));
        assertThat(result.getAttributes(), hasKey("Gender"));
        assertThat(result.getAttributes(), hasEntry("Age",age));
        assertThat(result.getAttributes(), hasKey("Smoker"));
    }
}