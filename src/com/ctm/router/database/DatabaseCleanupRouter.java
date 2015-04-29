package com.ctm.router.database;

import com.ctm.dao.transaction.TransactionLockDao;
import com.ctm.exceptions.DaoException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import static com.ctm.utils.ResponseUtils.handleError;
import static javax.servlet.http.HttpServletResponse.SC_NOT_FOUND;

@WebServlet(urlPatterns = {
        "/cron/database/transactionLockTable/cleanup.json"
})
public class DatabaseCleanupRouter extends HttpServlet {

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
