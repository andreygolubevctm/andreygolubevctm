package com.ctm.web.core.openinghours.api.controller;

import com.ctm.test.controller.BaseControllerTest;
import com.ctm.web.core.openinghours.model.OpeningHours;
import com.ctm.web.core.openinghours.services.OpeningHoursService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Matchers;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.mock.web.MockServletContext;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;

import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(MockitoJUnitRunner.class)
@SpringApplicationConfiguration(classes = MockServletContext.class)
@WebAppConfiguration
public class OpeningHoursControllerTest extends BaseControllerTest {

    @Mock
    private OpeningHoursService openingHoursService;

    @InjectMocks
    private OpeningHoursController openingHoursController;

    @Before
    public void setup() throws Exception {
        initMocks(this);
        setUp(openingHoursController);
    }

    @Test
    public void testGetOpeningHoursData() throws Exception {
        when(openingHoursService.getAllOpeningHoursForDisplay(Matchers.any(HttpServletRequest.class))).thenReturn(new ArrayList<OpeningHours>());
        mvc.perform(
                MockMvcRequestBuilders
                        .get("/openinghours/data.json?vertical=health")
                        .accept(APPLICATION_JSON_VALUE))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().contentType(APPLICATION_JSON_VALUE));
    }

    @Test
    public void testGetOpeningHours() throws Exception {
        when(openingHoursService.getCurrentOpeningHoursForEmail(Matchers.any(HttpServletRequest.class))).thenReturn("test");
        mvc.perform(
                MockMvcRequestBuilders
                        .get("/openinghours/get.json?vertical=health")
                        .accept(APPLICATION_JSON_VALUE))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().contentType(APPLICATION_JSON_VALUE));
    }
}
