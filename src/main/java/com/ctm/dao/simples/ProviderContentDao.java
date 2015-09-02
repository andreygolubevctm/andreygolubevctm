package com.ctm.dao.simples;

import com.ctm.dao.AuditTableDao;
import com.ctm.dao.DatabaseQueryMapping;
import com.ctm.dao.DatabaseUpdateMapping;
import com.ctm.dao.SqlDao;
import com.ctm.exceptions.DaoException;
import com.ctm.helper.simples.ProviderContentHelper;
import com.ctm.model.ProviderContent;
import com.ctm.model.ProviderContentType;
import com.ctm.utils.common.utils.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ProviderContentDao {
    private static final Logger logger = LoggerFactory.getLogger(ProviderContentDao.class.getName());
    private final ProviderContentHelper helper = new ProviderContentHelper();
    private final SqlDao sqlDao = new SqlDao();

    /**
     * This function finds provider content from database based on parameters passed.
     * The function uses the ctm.provider_contents. Right now there can be only one content per contentType per provider during same period of the time if multiple found it will only return first one
     *
     * @param providerId   must not be blank
     * @param providerContentTypeCode must not be blank
     *@param verticalCode must not be blank or 0
     * @param currentDate  must not be null   @return String
     * @throws DaoException
     */
    @SuppressWarnings("unchecked")
    public String getProviderContentText(final int providerId, final String providerContentTypeCode, final String verticalCode, final Date currentDate) throws DaoException {
        DatabaseQueryMapping mapping = new DatabaseQueryMapping() {
            @Override
            public void mapParams() throws SQLException {
                set(providerId);
                set(verticalCode);
                set(providerContentTypeCode);
                set( new java.sql.Timestamp(currentDate.getTime()));
            }

            @Override
            public Object handleResult(ResultSet rs) throws SQLException {
                return rs.getString(1);
            }
        };
        String sql = "SELECT providerContentText " +
                        "FROM ctm.provider_contents pc " +
                        "INNER JOIN ctm.vertical_master vm ON pc.verticalId = vm.verticalId " +
                        "INNER JOIN ctm.provider_content_types pct ON pct.providerContentTypeId = pc.providerContentTypeId " +
                        "WHERE " +
                        "(pc.providerId = ? OR pc.providerId = '0' ) AND " +
                        "vm.verticalCode = ? AND " +
                        "pct.providerContentTypeCode = ? AND " +
                        "? between effectiveStart AND effectiveEnd order by providerId desc " +
                        "limit 1";
        //noinspection unchecked
        return (String) sqlDao.get(mapping, sql);
    }

    /**
     * this method will return single record if ID exist else return null
     *
     * @param providerContentId : Unique identifier of provider content record
     * @return ProviderContent
     * @throws DaoException
     */
    public ProviderContent fetchSingleProviderContent(int providerContentId) throws DaoException {
        DatabaseQueryMapping mapping = new DatabaseQueryMapping() {
            @Override
            public void mapParams() throws SQLException {
                set(providerContentId);
            }

            @Override
            public Object handleResult(ResultSet resultSet) throws SQLException {
                return helper.createProviderContentObject(
                        resultSet.getInt("providerContentId"), resultSet.getInt("providerContentTypeId"),
                        resultSet.getString("providerContentText"), resultSet.getDate("effectiveStart"),
                        resultSet.getDate("effectiveEnd"), resultSet.getInt("providerID"), resultSet.getInt("verticalId")
                );
            }
        };

        String sql = "SELECT    providerContentId,      providerContentTypeId,    providerContentText, " +
                    "           providerId,     verticalId,     effectiveStart,     effectiveEnd " +
                    "FROM ctm.provider_contents " +
                    "WHERE providerContentId = ? ";

        //noinspection unchecked
        return (ProviderContent) sqlDao.get(mapping, sql);
    }

    /**
     * this method will fetch all the provider content records for a specified contentType from database
     *
     *
     * @param providerContentTypeCode : must not be blank
     * @return List<ProviderContent>
     * @throws DaoException
     */
    public List<ProviderContent> fetchProviderContents(String providerContentTypeCode) throws DaoException {
        try {
            DatabaseQueryMapping mapping = new DatabaseQueryMapping() {
                @Override
                public void mapParams() throws SQLException {
                    set(providerContentTypeCode);
                }

                @Override
                public Object handleResult(ResultSet resultSet) throws SQLException {
                    List<ProviderContent> list = new ArrayList<>();
                    while (resultSet.next()) {
                        ProviderContent providerContent = helper.createProviderContentObject(
                                resultSet.getInt("providerContentId"), resultSet.getInt("providerContentTypeId"),
                                resultSet.getString("providerContentText"), resultSet.getDate("effectiveStart"),
                                resultSet.getDate("effectiveEnd"), resultSet.getInt("providerID"), resultSet.getInt("verticalId")
                        );
                        list.add(providerContent);
                    }
                    return list;
                }
            };

            String sql = "SELECT    providerContentId,      pc.providerContentTypeId,    providerContentText, " +
                        "           providerId,     verticalId,     effectiveStart,     effectiveEnd " +
                        "FROM ctm.provider_contents pc " +
                        "INNER JOIN ctm.provider_content_types pct ON pct.providerContentTypeId = pc.providerContentTypeId " +
                        "WHERE pct.providerContentTypeCode = ? ";

            //noinspection unchecked
            return (List<ProviderContent>) sqlDao.getAll(mapping, sql);
        } catch (DaoException e) {
            logger.error("Failed to retrieve Provider content Record", e);
            throw e;
        }
    }

    /**
     * This method will delete record associated with supplied ID
     *
     * @param providerContentId : Unique identifier of provider contents
     * @param userName  : userName of the user who has logged in during the session
     * @param ipAddress : IP address of user's machine
     * @return String : with success of failure message
     * @throws DaoException
     */
    public String deleteProviderContent(final int providerContentId, String userName, String ipAddress) throws DaoException {
        if (providerContentId == 0) {
            return "Provider Content Record Id is 0";
        }
        try {
            String sql = "DELETE FROM ctm.provider_contents WHERE providerContentId = ?";
            DatabaseUpdateMapping mapping = new DatabaseUpdateMapping() {
                @Override
                public String getStatement() {
                    return null;
                }

                @Override
                public void mapParams() throws SQLException {
                    set(providerContentId);
                }
            };
            sqlDao.executeUpdateAudit(mapping, sql, userName, ipAddress, AuditTableDao.DELETE, "provider_contents", "providerContentId", providerContentId);
            return "success";
        } catch (DaoException e) {
            logger.error("Failed to delete Provider Content Record", e);
            throw new DaoException(e.getMessage(), e);
        }
    }

    /**
     * This method will update record as per data in "providerContentParam"
     *
     * @param providerContentParam : ProviderContent object
     * @param userName             : userName of the user who has logged in during the session
     * @param ipAddress            : IP address of user's machine
     * @return ProviderContent
     * @throws DaoException
     */
    public ProviderContent updateProviderContent(final ProviderContent providerContentParam, String userName, String ipAddress) throws DaoException {
        int providerContentId;
        final java.sql.Timestamp startDate = new java.sql.Timestamp(DateUtils.setTimeInDate(providerContentParam.getEffectiveStart(), 0, 0, 1).getTime());
        final java.sql.Timestamp endDate = new java.sql.Timestamp(DateUtils.setTimeInDate(providerContentParam.getEffectiveEnd(), 23, 59, 59).getTime());
        try {
            providerContentId = providerContentParam.getProviderContentId();
            if (providerContentId == 0) {
                throw new DaoException("failed : providerContentId is 0");
            }
            String sql = " UPDATE ctm.provider_contents SET  " +
                        "providerContentText = ?," +
                        "providerId = ?, " +
                        "providerContentTypeId = ?, " +
                        "verticalId = ?, " +
                        "effectiveStart = ?, " +
                        "effectiveEnd = ? " +
                        "WHERE providerContentId = ?";
            final int finalProviderContentId = providerContentId;
            DatabaseUpdateMapping mapping = new DatabaseUpdateMapping() {
                @Override
                public String getStatement() {
                    return null;
                }

                @Override
                public void mapParams() throws SQLException {
                    set(providerContentParam.getProviderContentText());
                    set(providerContentParam.getProviderId());
                    set(providerContentParam.getProviderContentTypeId());
                    set(providerContentParam.getVerticalId());
                    set(startDate);
                    set(endDate);
                    set(finalProviderContentId);
                }
            };
            sqlDao.executeUpdateAudit(mapping, sql, userName, ipAddress, AuditTableDao.UPDATE, "provider_contents", "providerContentId", providerContentId);
            return fetchSingleProviderContent(providerContentId);
        } catch (DaoException e) {
            logger.error("Failed to update Provider Content Record", e);
            throw e;
        }
    }

    /**
     * This method will create new record in the table and also returns the
     * created record in the object
     *
     * @param providerContentParam : ProviderContent object
     * @param userName             : userName of the user who has logged in during the session
     * @param ipAddress            : IP address of user's machine
     * @return ProviderContent
     * @throws DaoException
     */
    public ProviderContent createProviderContent(final ProviderContent providerContentParam, String userName, String ipAddress) throws DaoException {
        try {
            final java.sql.Timestamp startDate = new java.sql.Timestamp(DateUtils.setTimeInDate(providerContentParam.getEffectiveStart(), 0, 0, 1).getTime());
            final java.sql.Timestamp endDate = new java.sql.Timestamp(DateUtils.setTimeInDate(providerContentParam.getEffectiveEnd(), 23, 59, 59).getTime());

            String sql = " INSERT INTO ctm.provider_contents " +
                         "(providerContentTypeId, providerContentText, providerId, verticalId, effectiveStart, effectiveEnd)" +
                         " VALUES " +
                         "(?, ?, ?, ?, ?, ?)";
            DatabaseUpdateMapping mapping = new DatabaseUpdateMapping() {
                @Override
                public String getStatement() {
                    return null;
                }

                @Override
                public void mapParams() throws SQLException {
                    set(providerContentParam.getProviderContentTypeId());
                    set(providerContentParam.getProviderContentText());
                    set(providerContentParam.getProviderId());
                    set(providerContentParam.getVerticalId());
                    set(startDate);
                    set(endDate);
                }
            };
            int id = sqlDao.executeUpdateAudit(mapping, sql, userName, ipAddress, AuditTableDao.CREATE, "provider_contents", "providerContentId", 0);
            return fetchSingleProviderContent(id);
        } catch (DaoException e) {
            logger.error("Failed to create Provider Content Record", e);
            throw new DaoException(e.getMessage(), e);
        }
    }

    /**
     * Get all provider content types from database
     *
     * @return List<ProviderContentType>
     * @throws DaoException
     */
    public List<ProviderContentType> fetchProviderContentTypes() throws DaoException {
        DatabaseQueryMapping mapping = new DatabaseQueryMapping() {

            @Override
            protected void mapParams() throws SQLException {}

            @Override
            public Object handleResult(ResultSet resultSet) throws SQLException {
                List<ProviderContentType> list = new ArrayList<>();
                while (resultSet.next()) {
                    ProviderContentType providerContentType = new ProviderContentType();
                    providerContentType.setId(resultSet.getInt("providerContentTypeId"));
                    providerContentType.setCode(resultSet.getString("providerContentTypeCode"));
                    providerContentType.setDescription(resultSet.getString("description"));
                    list.add(providerContentType);
                }
                return list;
            }
        };
        String sql = "SELECT providerContentTypeId, providerContentTypeCode, description " +
                    "FROM ctm.provider_content_types ";
        //noinspection unchecked
        return (List<ProviderContentType>) sqlDao.getAll(mapping, sql);
    }
}
