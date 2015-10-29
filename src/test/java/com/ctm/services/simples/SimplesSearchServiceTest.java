package com.ctm.services.simples;

import com.ctm.web.simples.services.SimplesSearchService;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class SimplesSearchServiceTest {

    @Test
    public void shouldHandleWhitespace() throws Exception {
        SimplesSearchService simplesSearchService = new SimplesSearchService();
        PageContext pageContext = mock(PageContext.class);
        HttpServletRequest request = mock(HttpServletRequest.class);
        when(pageContext.getRequest()).thenReturn(request);
        when(request.getParameter("search_terms")).thenReturn("Bobby McTest");
        simplesSearchService.init(pageContext);
        assertEquals(SimplesSearchService.SearchMode.OTHER, simplesSearchService.getSearchMode());

        when(request.getParameter("search_terms")).thenReturn(" Bobby McSpace");
        simplesSearchService.init(pageContext);
        assertEquals(SimplesSearchService.SearchMode.OTHER, simplesSearchService.getSearchMode());

        when(request.getParameter("search_terms")).thenReturn(null);
        simplesSearchService.init(pageContext);
        assertEquals(SimplesSearchService.SearchMode.OTHER, simplesSearchService.getSearchMode());

        when(request.getParameter("search_terms")).thenReturn("0455555555");
        simplesSearchService.init(pageContext);
        assertEquals(SimplesSearchService.SearchMode.PHONE, simplesSearchService.getSearchMode());

        when(request.getParameter("search_terms")).thenReturn(" 0455555505");
        simplesSearchService.init(pageContext);
        assertEquals(SimplesSearchService.SearchMode.PHONE, simplesSearchService.getSearchMode());

    }
}