package com.ctm.web.school.router;

import com.ctm.web.school.services.SchoolService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.junit.Assert.*;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(MockitoJUnitRunner.class)
public class SchoolControllerTest {

    @Autowired
    private MockMvc mvc;

    @InjectMocks
    SchoolController schoolController;

    @Mock
    private SchoolService schoolService;

    @Before
    public void setUp() throws Exception {
        mvc = MockMvcBuilders.standaloneSetup(schoolController).build();
    }

        @Test
    public void testGetUser() throws Exception {
        // Given
        String response = "<option value=\"1\">One</option><option value=\"2\">Two</option>";
        when(schoolService.getSchoolsAsHtmlOptions()).thenReturn(response);
        // Then Expect
        mvc.perform(get("/rest/school/get.json")
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().string(response));
    }
}