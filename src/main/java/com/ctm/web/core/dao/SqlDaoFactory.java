package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.naming.NamingException;
import javax.servlet.ServletContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class SqlDaoFactory<T> {

	private final String context;
    private final SimpleDatabaseConnection databaseConnection;

    @Autowired
    public SqlDaoFactory(SimpleDatabaseConnection databaseConnection) {
		this.databaseConnection = databaseConnection;
		this.context = SimpleDatabaseConnection.JDBC_CTM;
	}


    public static SqlDaoFactory getInstance(ServletContext servletContext) throws DaoException {
        final WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
        return applicationContext.getBean(SqlDaoFactory.class);
    }

    public static SqlDaoFactory getInstance()  {
        return new SqlDaoFactory(SimpleDatabaseConnection.getInstance());
    }


    public SqlDao<T> createDao()  {
        return new SqlDao<T>(databaseConnection, context);
    }
}
