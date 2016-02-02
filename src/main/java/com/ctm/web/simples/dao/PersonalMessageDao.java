package com.ctm.web.simples.dao;

import com.ctm.web.core.dao.CommentDao;
import com.ctm.web.core.dao.DatabaseQueryMapping;
import com.ctm.web.core.dao.DatabaseUpdateMapping;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Comment;
import com.ctm.web.simples.model.Message;
import com.ctm.web.simples.model.User;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;


public class PersonalMessageDao {

    public List<Message> getPersonalMessages(int userId) throws DaoException {
        final SqlDao<Message> sqlDao = new SqlDao<Message>();

        String sql =
                "SELECT rootId, userId, whenToAction, contactName " +
                "FROM simples.personal_messages " +
                "WHERE userId = ? " +
                "AND whenToAction >= NOW() " +
                "AND isDeleted = 0;";

        DatabaseQueryMapping<Message> databaseMapping = new DatabaseQueryMapping<Message>() {

            @Override
            public void mapParams() throws SQLException {
                set(userId);
            }

            @Override
            public Message handleResult(ResultSet rs) throws SQLException {
                return mapToObject(rs);
            }
        };

        return sqlDao.getList(databaseMapping, sql);
    }

//    public Message getPersonalMessageByRootId(Long rootId) throws  DaoException {
//        final SqlDao<Message> sqlDao = new SqlDao<Message>();
//
//        String sql =
//                "SELECT rootId, userId, whenToAction, contactName" +
//                "FROM simples.personal_messages " +
//                "WHERE rootId = ?; ";
//
//        DatabaseQueryMapping<Message> databaseMapping = new DatabaseQueryMapping<Message>() {
//
//            @Override
//            public void mapParams() throws SQLException {
//                set(rootId);
//            }
//
//            @Override
//            public Message handleResult(ResultSet rs) throws SQLException {
//                return mapToObject(rs);
//            }
//        };
//
//        return sqlDao.get(databaseMapping, sql);
//    }

    public Long insertPersonalMessage(int userId, long rootId, Date postponeTo, String contactName, String comment ) throws DaoException {

        UserDao userDao = new UserDao();
        SqlDao sqlDao = new SqlDao();

        // Add a comment?
        if (comment.length() > 0) {
            // Get the user
            User user = userDao.getUser(userId);

            Comment commentObj = new Comment();
            commentObj.setTransactionId(rootId);
            commentObj.setOperator(user.getUsername());
            commentObj.setComment(comment);

            CommentDao commentDao = new CommentDao();
            commentDao.addComment(commentObj);
        }


        return sqlDao.insert(new DatabaseUpdateMapping() {
            @Override
            protected void mapParams() throws SQLException {
                set(rootId);
                set(userId);
                set(new java.sql.Timestamp(postponeTo.getTime()));
                set(contactName);
                set(userId);
                set(new java.sql.Timestamp(postponeTo.getTime()));
                set(contactName);
            }

            @Override
            public String getStatement() {
                return "INSERT INTO simples.personal_messages (rootId, userId, whenToAction, contactName) VALUES (?,?,?,?) " +
                        "ON DUPLICATE KEY " +
                        "UPDATE userId = ?, whenToAction = ?, contactName = ?, isDeleted = 0";
            }
        });
    }

    public int postponePersonalMessage(int userId, long rootId, Date postponeTo, String comment) throws DaoException {

        UserDao userDao = new UserDao();
        SqlDao sqlDao = new SqlDao();

        // Add a comment?
        if (comment.length() > 0) {
            // Get the user
            User user = userDao.getUser(userId);

            Comment commentObj = new Comment();
            commentObj.setTransactionId(rootId);
            commentObj.setOperator(user.getUsername());
            commentObj.setComment(comment);

            CommentDao commentDao = new CommentDao();
            commentDao.addComment(commentObj);
        }

        return sqlDao.update(new DatabaseUpdateMapping() {
            @Override
            protected void mapParams() throws SQLException {
                set(new java.sql.Timestamp(postponeTo.getTime()));
                set(rootId);
            }

            @Override
            public String getStatement() {
                return "UPDATE simples.personal_messages SET postponeTo = ? " +
                        "WHERE rootId = ?";
            }
        });
    }

    public int deletePersonalMessage(long rootId) throws DaoException {
        SqlDao sqlDao = new SqlDao();

        return sqlDao.update(new DatabaseUpdateMapping() {
            @Override
            protected void mapParams() throws SQLException {
                set(rootId);
            }

            @Override
            public String getStatement() {
                return "UPDATE simples.personal_messages SET isDeleted = 1 " +
                        "WHERE rootId = ?";
            }
        });
    }


    private Message mapToObject(final ResultSet results) throws SQLException {
        final Message message = new Message();

        message.setTransactionId(results.getLong("rootId"));
        message.setUserId(results.getInt("userId"));
        message.setWhenToAction(results.getTimestamp("whenToAction"));
        message.setContactName(results.getString("contactName"));

        return message;
    }
}
