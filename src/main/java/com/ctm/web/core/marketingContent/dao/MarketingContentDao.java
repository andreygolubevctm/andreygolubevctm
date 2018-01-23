package com.ctm.web.core.marketingContent.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.marketingContent.model.MarketingContent;
import com.ctm.web.core.marketingContent.model.request.MarketingContentRequest;

import javax.naming.NamingException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MarketingContentDao {

    public MarketingContent getMarketingContent(MarketingContentRequest marketingContentRequest) throws DaoException {
        final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

        try {
            String sql = "SELECT * " +
                    "FROM ctm.marketing_content " +
                    "WHERE (styleCodeId = ? OR styleCodeId = 0) " +
                    "AND verticalId = ? " +
                    "AND ? BETWEEN effectiveStart AND effectiveEnd;";

            PreparedStatement stmt = dbSource.getConnection().prepareStatement(sql);

            stmt.setInt(1, marketingContentRequest.styleCodeId);
            stmt.setInt(2, marketingContentRequest.verticalId);
            stmt.setTimestamp(3, new Timestamp(marketingContentRequest.effectiveDate.getTime()));

            List<MarketingContent> marketingContents = mapFieldsFromResultsToMarketingContent(stmt.executeQuery());

            if (!marketingContents.isEmpty()) {
                return marketingContents.get(0);
            }

            return new MarketingContent();
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
        finally {
            dbSource.closeConnection();
        }
    }

    private List<MarketingContent> mapFieldsFromResultsToMarketingContent(final ResultSet results) throws SQLException {
        final List<MarketingContent> marketingContents = new ArrayList<>();

        while (results.next()) {
            marketingContents.add(marketingContent(results));
        }

        return marketingContents;
    }

    private MarketingContent marketingContent(final ResultSet results) throws SQLException {
        final MarketingContent marketingContent = new MarketingContent();

        marketingContent.setMarketingContentId(results.getInt("marketingContentId"));
        marketingContent.setStyleCodeId(results.getInt("styleCodeId"));
        marketingContent.setVerticalId(results.getInt("verticalId"));
        marketingContent.setUrl(results.getString("url"));
        marketingContent.setEffectiveStart(results.getDate("effectiveStart"));
        marketingContent.setEffectiveEnd(results.getDate("effectiveEnd"));

        return marketingContent;
    }
}
