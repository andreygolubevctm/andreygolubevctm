package com.ctm.services.simples;

import com.ctm.dao.UserDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.services.FatalErrorService;
import com.ctm.services.SessionDataService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import static com.ctm.logging.LoggingArguments.kv;


public class SimplesTickleService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SimplesTickleService.class);
    private final SessionDataService sessionDataService;

    public SimplesTickleService(SessionDataService sessionDataService) {
        this.sessionDataService = sessionDataService;

    }


    public boolean simplesTickle(HttpServletRequest request, Long transactionId,
                                 AuthenticatedData authenticatedData,
                                 UserDao userDao, FatalErrorService fatalErrorService) throws ServletException {
        boolean success = false;
        try {
            // Keep the transaction fresh in user's session
            sessionDataService.getDataForTransactionId(request, transactionId.toString(), false);
            // Keep user fresh
            final int simplesUid = authenticatedData.getSimplesUid();
            if (simplesUid != -1) {
                userDao.tickleUser(simplesUid);
                success = true;
            } else {
                fatalErrorService.logFatalError(0, "simplesTickle", false, "Not Found", "Could not find simplesUid", transactionId);
            }
        } catch (DaoException | SessionException e) {
            fatalErrorService.logFatalError(e, 0, "simplesTickle", false, transactionId);
            LOGGER.error("Error performing simples tickle {}", kv("simplesUid",  authenticatedData.getSimplesUid()), e);
            throw new ServletException(e);
        }
        return success;
    }
}
