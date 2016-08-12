package com.ctm.web.core.utils.health;

import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.RequestService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.utils.HealthRequestParser;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Field;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class HealthRequestParserTest {

    private HttpServletRequest httpRequest;
    private PageSettings pageSettings = new PageSettings();

    @Before
    public void setup(){
        httpRequest = mock(HttpServletRequest.class);
        HttpSession session = mock(HttpSession.class);
        when(httpRequest.getSession()).thenReturn(session);
    }

    @Test
    public void testGetHealthRequestToken() throws Exception {
        HealthRequestParser healthRequestParser = new HealthRequestParser();
        Data data = new Data();
        RequestService requestService = new RequestService( httpRequest,  "",  data, pageSettings);
        healthRequestParser.getHealthRequestToken(requestService, false);

    }

    @Test
    public void test() throws Exception {
        iterate(HealthRequest.class, "");
    }

    private static String[] EXCLUDE = {"serialVersionUID", "CASE_INSENSITIVE_ORDER", "serialPersistentFields", "hash", "value"};

    private void iterate(Class cl, String str) {
        for (Field field : cl.getDeclaredFields()) {
            field.setAccessible(true);
            if (field.getDeclaringClass().getPackage().getName().startsWith("com.ctm.web.health.model.form")) {
                iterate(field.getType(), str + "/" + field.getName());
            } else {
                System.out.println(str);
            }
        }
    }

}