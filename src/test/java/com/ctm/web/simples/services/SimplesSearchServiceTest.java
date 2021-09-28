package com.ctm.web.simples.services;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.web.go.Data;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.springframework.test.util.ReflectionTestUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest( {SimpleDatabaseConnection.class} )
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

    @Test
    public void searchTransactionDetailsAndSave() throws Exception {
        ResultSet resultSet = mockResultSet("hospital.benefits.BONE_JOINT_AND_MUSCLE.covered",
                "health/benefits/benefitsExtras/BONE/JOINT/AND/MUSCLE", "Bone, joint and muscle");
        Connection connection = Mockito.mock(Connection.class);
        PreparedStatement statement = Mockito.mock(PreparedStatement.class);
        SimpleDatabaseConnection simpleDatabaseConnection = Mockito.mock(SimpleDatabaseConnection.class);
        PageContext context = Mockito.mock(PageContext.class);
        Data data = Mockito.mock(Data.class);

        Mockito.when(simpleDatabaseConnection.getConnection(Mockito.anyString(), Mockito.anyBoolean())).thenReturn(connection);
        Mockito.when(connection.prepareStatement(Mockito.anyString())).thenReturn(statement);
        Mockito.when(statement.executeQuery()).thenReturn(resultSet);
        Mockito.when(context.findAttribute(Mockito.anyString())).thenReturn(data);

        PowerMockito.mockStatic(SimpleDatabaseConnection.class);
        PowerMockito.when(SimpleDatabaseConnection.getInstance()).thenReturn(simpleDatabaseConnection);

        SimplesSearchService simplesSearchService = new SimplesSearchService();
        ReflectionTestUtils.setField(simplesSearchService, "pageContext", context);
        simplesSearchService.searchTransactionDetailsAndSave();

        Mockito.verify(data).put("search_results/quote[@id=transactionId]/health/benefitTypes/BONE/JOINT/AND/MUSCLE/type/text()", "hospital");
        Mockito.verify(data).put("search_results/quote[@id=transactionId]/health/benefitTypes/BONE/JOINT/AND/MUSCLE/name/text()", "Bone, joint and muscle");
        Mockito.verify(data).put("search_results/quote[@id=transactionId]/health/benefits/benefitsExtras/BONE/JOINT/AND/MUSCLE/text()", "textValue");

        resultSet = mockResultSet("extras.DentalMajor.covered",
                "health/benefits/benefitsExtras/DentalMajor", "Major Dental");
        Mockito.when(statement.executeQuery()).thenReturn(resultSet);
        simplesSearchService.searchTransactionDetailsAndSave();
        Mockito.verify(data).put("search_results/quote[@id=transactionId]/health/benefitTypes/DentalMajor/type/text()", "extras");
        Mockito.verify(data).put("search_results/quote[@id=transactionId]/health/benefitTypes/DentalMajor/name/text()", "Major Dental");
        Mockito.verify(data).put("search_results/quote[@id=transactionId]/health/benefits/benefitsExtras/DentalMajor/text()", "textValue");

        resultSet = mockResultSet(null,"health/benefits/benefitsExtras/DentalMajor", "Major Dental");
        Mockito.when(statement.executeQuery()).thenReturn(resultSet);
        Mockito.verify(data).put("search_results/quote[@id=transactionId]/health/benefits/benefitsExtras/DentalMajor/text()", "textValue");

        resultSet = mockResultSet("something without full stop","health/benefits/benefitsExtras/DentalMajor", "Major Dental");
        Mockito.when(statement.executeQuery()).thenReturn(resultSet);
        Mockito.verify(data).put("search_results/quote[@id=transactionId]/health/benefits/benefitsExtras/DentalMajor/text()", "textValue");

        resultSet = mockResultSet("something with full stop at the end.","health/benefits/benefitsExtras/DentalMajor", "Major Dental");
        Mockito.when(statement.executeQuery()).thenReturn(resultSet);
        Mockito.verify(data).put("search_results/quote[@id=transactionId]/health/benefits/benefitsExtras/DentalMajor/text()", "textValue");

        resultSet = mockResultSet("hospital.benefits.BONE_JOINT_AND_MUSCLE.covered",
                "health/benefits/benefitsExtras/BONE/JOINT/AND/MUSCLE", "");
        Mockito.when(statement.executeQuery()).thenReturn(resultSet);
        Mockito.verify(data).put("search_results/quote[@id=transactionId]/health/benefitTypes/BONE/JOINT/AND/MUSCLE/type/text()", "hospital");
        Mockito.verify(data).put("search_results/quote[@id=transactionId]/health/benefits/benefitsExtras/DentalMajor/text()", "textValue");
    }

    private ResultSet mockResultSet(String resultPath, String xpath, String name) throws SQLException {
        ResultSet resultSet = Mockito.mock(ResultSet.class);
        Mockito.when(resultSet.getString("resultPath")).thenReturn(resultPath);
        Mockito.when(resultSet.getString("xpath")).thenReturn(xpath);
        Mockito.when(resultSet.getString("name")).thenReturn(name);
        Mockito.when(resultSet.getString("transactionId")).thenReturn("transactionId");
        Mockito.when(resultSet.getString("textValue")).thenReturn("textValue");
        Mockito.when(resultSet.next()).thenReturn(true).thenReturn(false);
        return resultSet;
    }

}