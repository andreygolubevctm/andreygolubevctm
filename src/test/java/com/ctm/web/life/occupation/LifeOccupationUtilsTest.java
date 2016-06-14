package com.ctm.web.life.occupation;

import com.ctm.life.occupation.model.response.Occupation;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.life.services.LifeOccupationService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.springframework.web.context.WebApplicationContext;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;


public class LifeOccupationUtilsTest {

    @Mock
    private HttpServletRequest request;
    @Mock
    private javax.servlet.ServletContext servletContext;
    @Mock
    private WebApplicationContext applicationContext;
    @Mock
    private ApplicationService applicationService;
    @Mock
    private LifeOccupationService lifeOccupationService;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        when(request.getServletContext()).thenReturn(servletContext);
        when(servletContext.getAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE)).thenReturn(applicationContext);
        when(applicationContext.getBean(LifeOccupationService.class)).thenReturn(lifeOccupationService);
        when(applicationContext.getBean(ApplicationService.class)).thenReturn(applicationService);
    }

    @Test
    public void testOccupations() throws Exception {
        List<Occupation> expectedOccupations = new ArrayList<>();
        Occupation occupation = Occupation.newBuilder().build();
        expectedOccupations.add(occupation);
        when(lifeOccupationService.getOccupations(null)).thenReturn(expectedOccupations);
        List<Occupation> result = LifeOccupationUtils.occupations(request);
        assertEquals(expectedOccupations, result);
    }
}