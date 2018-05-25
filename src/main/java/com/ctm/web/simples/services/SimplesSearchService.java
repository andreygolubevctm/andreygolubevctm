package com.ctm.web.simples.services;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.dao.DatabaseQueryMapping;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.health.services.HealthPriceService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.XmlNode;
import com.ctm.web.core.web.go.xml.XmlParser;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.SAXException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class SimplesSearchService {

    private String hotTransactionIdsCsv = "";
    private String coldTransactionIdsCsv = "";
    private SearchMode searchMode;
    private String searchString;
    private String consultantStyleCodeIdList;
    private final SimpleDatabaseConnection dbcon = new SimpleDatabaseConnection();
    private PageContext pageContext;
    private String error;
	private static final Logger LOGGER = LoggerFactory.getLogger(HealthPriceService.class);

    public enum SearchMode {
        TRANS, PHONE, EMAIL, POLICYNO, ADDRESS, OTHER
    }

    public SearchMode getSearchMode() {
        return searchMode;
    }

    private void setSearchMode() {
        if (searchString != null) {
            if (searchString.replaceAll("\\s","").length() == 10 && searchString.substring(0, 1).equalsIgnoreCase("0")) {
                searchString = searchString.replaceAll("\\s","");
                searchMode = SearchMode.PHONE;
            } else if (isLikeTransactionId(searchString) && transactionIdExists(searchString)) {
                searchMode = SearchMode.TRANS;
            } else if (searchString.contains("@")) {
                searchMode = SearchMode.EMAIL;
            } else if (isLikePolicyNumber(searchString) && !isLikeName(searchString)) {
                searchMode = SearchMode.POLICYNO;
            } else if (isLikeAddress(searchString)) {
                searchMode = SearchMode.ADDRESS;
            } else {
                searchMode = SearchMode.OTHER;
            }
        }
    }

    /**
     * Initialization of the service context
     * @param pageContext
     */
    public void init(PageContext pageContext) {
        this.pageContext = pageContext;
        readRequestParams((HttpServletRequest) pageContext.getRequest());
        setSearchMode();
    }

    /**
     * Main function which perform the search
     * @throws DaoException
     */
    public void SearchTransactions() throws DaoException {
        try {
            setupHotAndColdTransactions();
            if (hotTransactionIdsCsv.trim().equalsIgnoreCase("") && coldTransactionIdsCsv.trim().equalsIgnoreCase("")) {
                writeDataIntoDataBucket(false, "<empty>true</empty>", null, "no_results");
                return;
            } else {
                LOGGER.debug("Search transaction ids {},{}", kv("coldIds", coldTransactionIdsCsv), kv("hotIds", hotTransactionIdsCsv));
            }
            searchTransactionHeaderDetailsAndSave();
            searchTransactionDetailsAndSave();
        } catch (RuntimeException e) {
            LOGGER.error("Error searching transactions",e);
            error = e.getMessage();
            throw e;
        } finally {
            dbcon.closeConnection();
        }
    }

    public String getError() {
        return error;
    }

    /**
     * This function will setup hot and cold transactions in hotTransactionIdsCsv and coldTransactionIdsCsv
     * based on search string
     *
     * @throws DaoException
     */
    private void setupHotAndColdTransactions() throws DaoException {

        switch (searchMode) {
            case PHONE:
                performPhoneSearch();
                break;
            case EMAIL:
                performEMailSearch();
                break;
            case TRANS:
                performTransactionSearch();
                break;
            case POLICYNO:
                performPolicyNoSearch();
                break;
            case ADDRESS:
                performAddressSearch();
                break;
            case OTHER:
                performNameSearch();
                break;
        }
    }

    /**
     * If search string is like TransctionID  then search in transaction IDs
     * @throws DaoException
     */
    private void performTransactionSearch() throws DaoException {
        String sql;
        SqlDao<Object> sqlDao = new SqlDao<>();
        DatabaseQueryMapping<Object> mapping;
        final List<Long> transactionIDsHot = new ArrayList<>();
        final List<Long> transactionIDsCold = new ArrayList<>();
        sql = "SELECT rootId AS id\n" +
                "\t\t\t\t\tFROM aggregator.transaction_header\n" +
                "\t\t\t\t\tWHERE  TransactionID = ?\n" +
                "\t\t\t\t\t\t\tAND productType = 'HEALTH'\n" +
                "\t\t\t\t\t\t\tAND styleCodeId IN (" + consultantStyleCodeIdList + ")\n" +
                "\t\t\t\t\tUNION ALL\n" +
                "\t\t\t\t\tSELECT  rootId AS id\n" +
                "\t\t\t\t\tFROM aggregator.transaction_header2_cold\n" +
                "\t\t\t\t\tWHERE  TransactionID = ?\n" +
                "\t\t\t\t\t\t\tAND verticalId = 4\n" +
                "\t\t\t\t\t\t\tAND styleCodeId IN (" + consultantStyleCodeIdList + ");";
        mapping = new DatabaseQueryMapping<Object>() {
            @Override
            protected void mapParams() throws SQLException {
                set(searchString);
                set(searchString);
            }

            @Override
            public Object handleResult(ResultSet rs) throws SQLException {
                return rs.getLong(1);
            }
        };
        final Long rootID = (Long) sqlDao.get(mapping, sql);
        if(rootID==null){
            return;
        }
        if (rootID != 0) {
            sql = "SELECT 'HOT' as tableType , transactionId AS id\n" +
                    "\t\t\t\t\t\tFROM aggregator.transaction_header\n" +
                    "\t\t\t\t\t\twhere rootId = ?\n" +
                    "\t\t\t\t\t\tUNION ALL\n" +
                    "\t\t\t\t\t\tSELECT 'COLD' as tableType , transactionId AS id\n" +
                    "\t\t\t\t\t\tFROM aggregator.transaction_header2_cold\n" +
                    "\t\t\t\t\t\tWHERE rootId = ?";
            mapping = new DatabaseQueryMapping<Object>() {
                @Override
                protected void mapParams() throws SQLException {
                    set(rootID);
                    set(rootID);
                }

                @Override
                public Object handleResult(ResultSet rs) throws SQLException {
                    while (rs.next()) {
                        if (rs.getString("tableType") != null && rs.getString("tableType").equalsIgnoreCase("hot"))
                            transactionIDsHot.add(rs.getLong("id"));
                        else
                            transactionIDsCold.add(rs.getLong("id"));
                    }
                    return null;
                }
            };
            sqlDao.getAll(mapping, sql);
            hotTransactionIdsCsv = StringUtils.join(transactionIDsHot, ",");
            coldTransactionIdsCsv = StringUtils.join(transactionIDsCold, ",");
        }
    }

    /**
     * If search string is like phone.mobile no  then search in transaction IDs
     * @throws DaoException
     */
    private void performPhoneSearch() throws DaoException {
        String sql;
        SqlDao<Object> sqlDao = new SqlDao<>();
        DatabaseQueryMapping<Object> mapping;
        List<Long> transactionIDs;
        sql = "SELECT distinct transactionId as id\n" +
                "\t\t\t\t\tFROM aggregator.phone_lookup\n" +
                "\t\t\t\t\twhere PhoneNumber =  ?\n" +
                "\t\t\t\t\torder by transactionid desc  LIMIT 25;";
        mapping = new DatabaseQueryMapping<Object>() {
            @Override
            protected void mapParams() throws SQLException {
                set(searchString);
            }

            @Override
            public Object handleResult(ResultSet rs) throws SQLException {
                List<Long> transactionIDs = new ArrayList<>();
                while (rs.next()) {
                    transactionIDs.add(rs.getLong(1));
                }
                return transactionIDs;
            }
        };
        transactionIDs = (List<Long>) sqlDao.getAll(mapping, sql);
        hotTransactionIdsCsv = StringUtils.join(transactionIDs, ",");
    }

    /**
     * If search string is like an email address  then search transactions matching email field
     * @throws DaoException
     */
    private void performEMailSearch() throws DaoException {
        String sql;
        SqlDao<Object> sqlDao = new SqlDao<>();
        DatabaseQueryMapping<Object> mapping;
        List<Long> transactionIDs;
        sql = "\tSELECT distinct transactionId as id\n" +
                "\t\t\t\t\tFROM aggregator.email_lookup\n" +
                "\t\t\t\t\twhere emailAddress =  ?\n" +
                "\t\t\t\t\torder by transactionid desc  LIMIT 25;";
        mapping = new DatabaseQueryMapping<Object>() {
            @Override
            protected void mapParams() throws SQLException {
                set(searchString);
            }

            @Override
            public Object handleResult(ResultSet rs) throws SQLException {
                List<Long> transactionIDs = new ArrayList<>();
                while (rs.next()) {
                    transactionIDs.add(rs.getLong("id"));
                }
                return transactionIDs;
            }
        };
        transactionIDs = (List<Long>) sqlDao.getAll(mapping, sql);
        hotTransactionIdsCsv = StringUtils.join(transactionIDs, ",");
    }

    /**
     * If search string is like an name then search transactions matching name field
     * @throws DaoException
     */
    private void performNameSearch() throws DaoException {
        String sql;
        SqlDao<Object> sqlDao = new SqlDao<>();
        DatabaseQueryMapping<Object> mapping;
        List<Long> transactionIDs;
        if (searchString.split(" ").length > 1) {
            final String firstName = searchString.split(" ")[0];
            final String lastName = searchString.split(" ")[1];
            sql = "SELECT distinct p1.transactionId as id\n" +
                    "\t\t\t\t\t\t\tFROM aggregator.person_lookup p1\n" +
                    "\t\t\t\t\t\t\tJOIN aggregator.person_lookup p2\n" +
                    "\t\t\t\t\t\t\tON \tp1.transactionid = p2.transactionid\n" +
                    "\t\t\t\t\t\t\tand p2.surname is not null\n" +
                    "\t\t\t\t\t\t\tand p1.firstname is not null\n" +
                    "\t\t\t\t\t\t\twhere p1.firstname like ? or\n" +
                    "\t\t\t\t\t\t\t(p1.firstname like ? and\n" +
                    "\t\t\t\t\t\t\tp2.surname like ?)\n" +
                    "\t\t\t\t\t\t\torder by p1.transactionid desc LIMIT 25;";
            mapping = new DatabaseQueryMapping<Object>() {
                @Override
                protected void mapParams() throws SQLException {
                    set(firstName + "% " + lastName + "%");
                    set(firstName + "%");
                    set(lastName + "%");
                }

                @Override
                public Object handleResult(ResultSet rs) throws SQLException {
                    List<Long> transactionIDs = new ArrayList<>();
                    while (rs.next()) {
                        transactionIDs.add(rs.getLong(1));
                    }
                    return transactionIDs;
                }
            };
            transactionIDs = (List<Long>) sqlDao.getAll(mapping, sql);
        } else {

            sql = "SELECT distinct transactionId as id\n" +
                    "\t\t\t\t\t\t\tFROM aggregator.person_lookup\n" +
                    "\t\t\t\t\t\t\twhere firstname like ? or surname like ?\n" +
                    "\t\t\t\t\t\t\torder by transactionid desc  LIMIT 25;";
            mapping = new DatabaseQueryMapping<Object>() {
                @Override
                protected void mapParams() throws SQLException {
                    set(searchString + "%");
                    set(searchString + "%");
                }

                @Override
                public Object handleResult(ResultSet rs) throws SQLException {
                    List<Long> transactionIDs = new ArrayList<>();
                    while (rs.next()) {
                        transactionIDs.add(rs.getLong(1));
                    }
                    return transactionIDs;
                }
            };
            transactionIDs = (List<Long>) sqlDao.getAll(mapping, sql);
        }
        hotTransactionIdsCsv = StringUtils.join(transactionIDs, ",");
    }

    /**
     * If search string is like policyno then search in transaction IDs
     * @throws DaoException
     */
    private void performPolicyNoSearch() throws DaoException {
        String sql;
        SqlDao<Object> sqlDao = new SqlDao<>();
        DatabaseQueryMapping<Object> mapping;
        List<Long> transactionIDsHot = new ArrayList<>();
        List<Long> transactionIDsCold = new ArrayList<>();
        sql = "SELECT td.transactionId AS id , 'hot' AS 'src' FROM aggregator.transaction_details AS td \n" +
                "\t\t\tWHERE xpath='health/policyNo' AND td.textValue=? \n" +
                "UNION ALL\n" +
                "SELECT td.transactionId AS id, 'cold' AS 'src' FROM aggregator.transaction_details2_cold AS td \n" +
                "\t\t\tLEFT JOIN aggregator.transaction_fields AS f ON f.fieldId=td.fieldId \n" +
                "\t\t\tWHERE f.fieldCode='health/policyNo' AND td.textValue=? \n" +
                "LIMIT 25;";
        mapping = new DatabaseQueryMapping<Object>() {
            @Override
            protected void mapParams() throws SQLException {
                set(searchString);
                set(searchString);
            }

            @Override
            public Object handleResult(ResultSet rs) throws SQLException {
                while (rs.next()) {
                    if(rs.getString("src").equals("hot")) {
                        transactionIDsHot.add(rs.getLong("id"));
                    } else {
                        transactionIDsCold.add(rs.getLong("id"));
                    }
                }
                return null;
            }
        };
        sqlDao.getAll(mapping, sql);
        hotTransactionIdsCsv = StringUtils.join(transactionIDsHot, ",");
        coldTransactionIdsCsv = StringUtils.join(transactionIDsCold, ",");
    }

    /**
     * If search string is like street number and name then search in transaction IDs
     * @throws DaoException
     */
    private void performAddressSearch() throws DaoException {
        String sql;
        SqlDao<Object> sqlDao = new SqlDao<>();
        DatabaseQueryMapping<Object> mapping;
        List<Long> transactionIDsHot = new ArrayList<>();
        List<Long> transactionIDsCold = new ArrayList<>();
        sql = "SELECT td.transactionId AS id, 'hot' AS 'src' FROM aggregator.transaction_details AS td \n" +
                "\t\t\tWHERE xpath LIKE 'health/application/address/fullAddress%' AND td.textValue=? \n" +
                "UNION ALL\n" +
                "SELECT td.transactionId AS id, 'cold' AS 'src' FROM aggregator.transaction_details2_cold AS td \n" +
                "\t\t\tLEFT JOIN aggregator.transaction_fields AS f ON f.fieldId=td.fieldId \n" +
                "\t\t\tWHERE f.fieldCode LIKE 'health/application/address/fullAddress%' AND td.textValue=? \n" +
                "LIMIT 25;";
        mapping = new DatabaseQueryMapping<Object>() {
            @Override
            protected void mapParams() throws SQLException {
                set(searchString);
                set(searchString);
            }

            @Override
            public Object handleResult(ResultSet rs) throws SQLException {
                List<Long> transactionIDs = new ArrayList<>();
                while (rs.next()) {
                    if(rs.getString("src").equals("hot")) {
                        transactionIDsHot.add(rs.getLong("id"));
                    } else {
                        transactionIDsCold.add(rs.getLong("id"));
                    }
                }
                return null;
            }
        };
        sqlDao.getAll(mapping, sql);
        hotTransactionIdsCsv = StringUtils.join(transactionIDsHot, ",");
        coldTransactionIdsCsv = StringUtils.join(transactionIDsCold, ",");
    }

    /**
     * set instance variables of the class by reading request params
     * @param request
     */
    private void readRequestParams(HttpServletRequest request) {
        searchString = request.getParameter("search_terms") != null ? request.getParameter("search_terms").trim() : null;
        consultantStyleCodeIdList = CallCentreService.getConsultantStyleCodeId(request);
    }

    /**
     * Search main details of found transactionIds and save them into data bucket
     * @throws DaoException
     */
    private void searchTransactionHeaderDetailsAndSave() throws DaoException {
        String sql = "";
        SqlDao<Object> sqlDao = new SqlDao<>();
        DatabaseQueryMapping<Object> mapping;
        if (!hotTransactionIdsCsv.trim().equalsIgnoreCase("")) {
            sql = "SELECT th.styleCodeId as styleCodeId, th.TransactionId AS id, th.rootId, th.EmailAddress AS email,\n" +
                    "\t\t\t\t\t\tconcat( th.StartDate ,' ' , th.StartTime) AS quoteDateTime, th.ProductType AS productType,\n" +
                    "\t\t\t\t\t\tCASE\n" +
                    "\t\t\t\t\t\t-- If tran is not the latest then don't mark it as Failed (F)\n" +
                    "\t\t\t\t\t\tWHEN COALESCE(MAX(th2.transactionid),th.TransactionId) <> th.TransactionId\n" +
                    "\t\t\t\t\t\tTHEN COALESCE(t1.type,1)\n" +
                    "\t\t\t\t\t\tELSE COALESCE(t1.type,t2.type,1)\n" +
                    "\t\t\t\t\t\tEND AS editable,\n" +
                    "\t\t\t\t\t\tCOALESCE(MAX(th2.transactionid),th.TransactionId) AS latestID\n" +
                    "\t\t\t\t\t\tFROM aggregator.transaction_header th\n" +
                    "\t\t\t\t\t\tLEFT JOIN ctm.touches t1 ON  (th.TransactionId = t1.transaction_id) AND (t1.type = 'C')\n" +
                    "\t\t\t\t\t\tLEFT JOIN ctm.touches t2 ON  (th.TransactionId = t2.transaction_id) AND (t2.type = 'F')\n" +
                    "\t\t\t\t\t\tLEFT JOIN aggregator.transaction_header th2 ON th2.rootId = th.rootId\n" +
                    "\t\t\t\t\t\tWHERE th.TransactionId IN (" + hotTransactionIdsCsv + ")\n " +
                    "\t\t\t\t\t\t\t\t\tAND th.productType='HEALTH'" +
                    "\t\t\t\t\t\t\t\t\tAND th.styleCodeId IN (" + consultantStyleCodeIdList + ")\n" +
                    "\t\t\t\t\t\tGROUP BY id\n";
        }
        if (!hotTransactionIdsCsv.trim().equalsIgnoreCase("") && !coldTransactionIdsCsv.trim().equalsIgnoreCase("")) {
            sql += " UNION ALL ";
        }
        if (!coldTransactionIdsCsv.trim().equalsIgnoreCase("")) {
            sql += "\n" +
                    "\t\t\t\t\t\tSELECT th.styleCodeId as styleCodeId, th.TransactionId AS id, th.rootId, em.EmailAddress AS email,\n" +
                    "\t\t\t\t\t\t th.transactionStartDateTime AS quoteDateTime,\n" +
                    "\t\t\t\t\t\t'HEALTH' AS productType,\n" +
                    "\t\t\t\t\t\tCASE\n" +
                    "\t\t\t\t\t\t-- If tran is not the latest then don't mark it as Failed (F)\n" +
                    "\t\t\t\t\t\tWHEN COALESCE(MAX(th2.transactionid),th.TransactionId) <> th.TransactionId\n" +
                    "\t\t\t\t\t\tTHEN COALESCE(t1.type,1)\n" +
                    "\t\t\t\t\t\tELSE COALESCE(t1.type,t2.type,1)\n" +
                    "\t\t\t\t\t\tEND AS editable,\n" +
                    "\t\t\t\t\t\tCOALESCE(MAX(th2.transactionid),th.TransactionId) AS latestID\n" +
                    "\t\t\t\t\t\tFROM aggregator.transaction_header2_cold th\n" +
                    "\t\t\t\t\t\tLEFT JOIN aggregator.transaction_emails te USING(transactionId)\n" +
                    "\t\t\t\t\t\tLEFT JOIN aggregator.email_master AS em ON em.emailId = te.emailId\n" +
                    "\t\t\t\t\t\tLEFT JOIN ctm.touches t1 ON (th.TransactionId = t1.transaction_id) AND (t1.type = 'C')\n" +
                    "\t\t\t\t\t\tLEFT JOIN ctm.touches t2 ON (th.TransactionId = t2.transaction_id) AND (t2.type = 'F')\n" +
                    "\t\t\t\t\t\tLEFT JOIN aggregator.transaction_header2_cold th2 ON th2.rootId = th.rootId\n" +
                    "\t\t\t\t\t\tWHERE th.TransactionId IN (" + coldTransactionIdsCsv + ")\n" +
                    "\t\t\t\t\t\t\t\t\tAND th.verticalId='4'" +
                    "\t\t\t\t\t\t\t\t\tAND th.styleCodeId IN (" + consultantStyleCodeIdList + ")\n" +
                    "\t\t\t\t\t\tGROUP BY id";
        }
        sql += " ORDER BY id DESC; ";

        mapping = new DatabaseQueryMapping<Object>() {
            @Override
            protected void mapParams() throws SQLException {
            }

            @Override
            public Object handleResult(ResultSet rs) throws SQLException {
                try {
                    String trxnDetailsXml;
                    SimpleDateFormat dfXML = new SimpleDateFormat("dd/MM/yyyy HH:mm a");
                    while (rs.next()) {
                        Brand brand = ApplicationService.getBrandById(rs.getInt("styleCodeId"));
                        //Date startDateTime = df.parse(rs.getString("quoteDate") + " " + rs.getString("quoteTime"));
                        Date startDateTime = rs.getTimestamp("quoteDateTime");
                        trxnDetailsXml = "<" + rs.getString("productType").toLowerCase() + ">\n" +
                                "<id>" + rs.getString("id") + "</id>\n" +
                                "<rootid>" + rs.getString("rootId") + "</rootid>\n" +
                                "<email>" + (rs.getString("email") == null ? "" : rs.getString("email")) + "</email>\n" +
                                "<quoteBrandName>" + (brand == null ? "" : brand.getName()) + "</quoteBrandName>\n" +
                                "<quoteBrandId>" + rs.getString("styleCodeId") + "</quoteBrandId>\n" +
                                "<quoteDate>" + dfXML.format(startDateTime).split(" ")[0] + "</quoteDate>\n" +
                                "<quoteTime>" + dfXML.format(startDateTime).split(" ")[1] + " " + dfXML.format(startDateTime).split(" ")[2] + "</quoteTime>\n" +
                                "<quoteType>" + rs.getString("productType").toLowerCase() + "</quoteType>\n" +
                                "<editable>" + rs.getString("editable") + "</editable>\n" +
                                "</" + rs.getString("productType").toLowerCase() + ">\n";
                        writeDataIntoDataBucket(false, trxnDetailsXml, null, "search_results/quote[@id=" + rs.getString("id") + "]");
                    }
                    return null;
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        };
        sqlDao.getAll(mapping, sql);
    }

    /**
     * Search all details of found transaction IDs and save them into data bucket
     * @throws DaoException
     */
    private void searchTransactionDetailsAndSave() throws DaoException {
        String sql = "";
        SqlDao<Object> sqlDao = new SqlDao<>();
        DatabaseQueryMapping<Object> mapping;
        if (!hotTransactionIdsCsv.trim().equalsIgnoreCase("")) {
            sql = "SELECT details.transactionId, details.xpath,  details.productType,\n" +
                    "\t\tCASE\n" +
                    "\t\tWHEN details.xpath in ('health/situation/healthSitu','health/benefits/healthSitu','health/benefits/benefits/healthSitu')  \n" +
                    "\t\tTHEN hs.description\n" +
                    "\t\tWHEN details.xpath = 'health/situation/healthCvr'  \n" +
                    "\t\tTHEN hc.description\n" +
                    "\t\tELSE details.textValue \n" +
                    "\t\tend as textValue \n" +
                    "FROM aggregator.health_transaction_details  AS details\n" +
                    "LEFT JOIN aggregator.general hs on details.textValue = hs.code AND hs.type = 'healthSitu' \n" +
                    "LEFT JOIN    aggregator.general hc ON details.textValue = hc.code  AND hc.type = 'healthCvr'\n" +
                    "WHERE \tdetails.transactionId IN (" + hotTransactionIdsCsv + ") \n" +
                    "\t\tAND details.productType='HEALTH'   ";
        }
        if (!hotTransactionIdsCsv.trim().equalsIgnoreCase("") && !coldTransactionIdsCsv.trim().equalsIgnoreCase("")) {
            sql += " UNION ALL ";
        }
        if (!coldTransactionIdsCsv.trim().equalsIgnoreCase("")) {
            sql += "SELECT details.transactionId, tf.fieldCode AS xpath,  'HEALTH' AS productType,\n" +
                    "\t\tCASE\n" +
                    "\t\tWHEN  tf.fieldCode in ('health/situation/healthSitu','health/benefits/healthSitu','health/benefits/benefits/healthSitu')  THEN \n" +
                    "\t\t hs.description\n" +
                    "\t\tWHEN tf.fieldCode = 'health/situation/healthCvr'  \n" +
                    "\t\tTHEN hc.description\n" +
                    "\t\tELSE details.textValue end as textValue \n" +
                    "FROM aggregator.transaction_details2_cold  AS details\n" +
                    "JOIN aggregator.transaction_fields tf USING(fieldId)\n" +
                    "LEFT JOIN  aggregator.general hs on details.textValue = hs.code AND hs.type = 'healthSitu'\n" +
                    "LEFT JOIN  aggregator.general hc ON details.textValue = hc.code  AND hc.type = 'healthCvr'\n" +
                    "WHERE details.transactionId IN (" + coldTransactionIdsCsv + ")" +
                    "AND details.verticalId='4'";
        }


        mapping = new DatabaseQueryMapping<Object>() {
            @Override
            protected void mapParams() throws SQLException {
            }

            @Override
            public Object handleResult(ResultSet rs) throws SQLException {
                try {
                    while (rs.next()) {
                        writeDataIntoDataBucket(false, null, rs.getString("textValue"),
                                "search_results/quote[@id=" + rs.getString("transactionId") + "]/" + rs.getString("xpath"));
                    }
                    return null;
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        };
        sqlDao.getAll(mapping, sql);
    }

    /**
     * MEthod writes data into session's databucket
     * @param allowDuplicates
     * @param xml
     * @param value
     * @param xPath
     */
    private void writeDataIntoDataBucket(boolean allowDuplicates, String xml, String value, String xPath) {
        Data data;
        Object dataObj = pageContext.findAttribute("data");

        try {
            if (dataObj instanceof Data) {
                data = (Data) dataObj;
                if (value != null) {
                    if (xPath == null) {
                        throw new JspException(
                                "setData: Value specified without xPath! value="
                                        + value);
                    }

                    // Ensure the xpath ends with text()
                    if (!xPath.endsWith(XmlNode.TEXT)) {
                        xPath = xPath + "/" + XmlNode.TEXT;
                    }

                    // Set the text value
                    data.put(xPath, value);

                    // PARSING SOME XML ...
                } else if (xml != null && !xml.isEmpty()) {
                    XmlParser p = new XmlParser();
                    XmlNode node = p.parse(xml, true);

                    // If an xPath was passed - try and get a node at that path
                    if (xPath != null) {
                        Object o = data.get(xPath);

                        // If we found a node at that path - add the generated node
                        // to it
                        if (o instanceof XmlNode) {
                            XmlNode destNode = (XmlNode) o;
                            if (destNode.hasChild(node.getNodeName()) && !allowDuplicates) {
                                destNode.removeChild(node.getNodeName());
                            }
                            destNode.addChild(node);

                            // We didn't find a node at that path .. create a new
                            // one
                        } else {
                            data.put(xPath, node);
                        }

                        // No xPath specified, just add to data
                    } else {
                        if (allowDuplicates) {
                            data.addChild(node);
                        } else {
                            data.replaceChild(node);
                        }
                    }
                }
            }
        } catch (JspException | SAXException e) {
            LOGGER.error("Error writing data into data bucket {},{},{}", kv("allowDuplicates", allowDuplicates),
                kv("xml", xml), kv("value", value), kv("xpath", xPath));
        }
    }

    private boolean transactionIdExists(String transactionId) {
        TransactionService transactionService = new TransactionService();
        boolean exists = false;
        try {
            exists = transactionService.transactionIdExists(Long.valueOf(transactionId).longValue());
        } catch(DaoException e) {
            LOGGER.debug("Error confirming transactionId exists - " + e.getMessage(), e);
        }
        return exists;
    }

    /**
     * isLikeTransactionId passes a simple regex over the string
     * and confirms if it is like a transactionId.
     * @param str
     * @return
     */
    private boolean isLikeTransactionId(String str) {
        return isMatch("^[0-9]+$", str);
    }

    /**
     * isLikePolicyNumber passes a simple regex over the string
     * and confirms if it is like a policyNumnber ie alphanumeric.
     * @param str
     * @return
     */
    private boolean isLikePolicyNumber(String str) {
        return isMatch("^[a-zA-Z0-9]+$", str);
    }

    /**
     * isLikeName passes a simple regex over the string and confirms
     * if it is like a persons name.
     * @param str
     * @return
     */
    private boolean isLikeName(String str) {
        return isMatch("^[a-zA-Z \\'\\-\\\\s]+$", str);
    }

    /**
     * isLikeAddress passes a simple regex over the string
     * and confirms if it is like a street number and name.
     * @param str
     * @return
     */
    private boolean isLikeAddress(String str) {
        return isMatch("[0-9]+(\\s)+(\\S)+(\\s)+", str);
    }

    /**
     * isMatch tests whether the regex is found in the string.
     * @param regex
     * @param str
     * @return
     */
    private boolean isMatch(String regex, String str) {
        Pattern pattern = Pattern.compile(regex);
        Matcher  matcher = pattern.matcher(str);
        return matcher.matches();
    }
}
