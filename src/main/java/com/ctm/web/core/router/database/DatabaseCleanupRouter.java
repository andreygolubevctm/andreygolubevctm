package com.ctm.web.core.router.database;

import static com.ctm.web.core.utils.ResponseUtils.handleError;
import static javax.servlet.http.HttpServletResponse.SC_NOT_FOUND;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ctm.web.core.transaction.dao.TransactionLockDao;
import com.ctm.web.core.exceptions.DaoException;

@WebServlet(urlPatterns = {
		"/cron/database/transactionLockTable/cleanup.json"
})
public class DatabaseCleanupRouter extends HttpServlet {

	private static final long serialVersionUID = -1633339933742252972L;

		@Override
		public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
			String uri = request.getRequestURI().replace("/ctm" , "").replace("/cron/database/" , "");
			switch (uri) {
				case "transactionLockTable/cleanup.json":
					try {
						new TransactionLockDao().cleanupOldLocks();
					} catch (DaoException e) {
						handleError(uri, e, response, "Failed to clean up transaction locks table");
					}
					break;
				default:
					response.sendError(SC_NOT_FOUND);
			}
		}


}
