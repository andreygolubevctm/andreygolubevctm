package com.ctm.web.simples.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.exceptions.TokenSecurityException;
import com.ctm.model.session.SessionToken;
import com.ctm.services.AuthenticationService;
import com.ctm.utils.SessionUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

public class SimplesAuthenticationService {

    static AuthenticationService authenticationService = new AuthenticationService();

    /**
     * Generate a token for a simples users. This is using their LDAP user id.
     *
     * @param uid
     * @return
     * @throws DaoException
     * @throws NoSuchAlgorithmException
     * @throws InvalidKeyException
     */
    public static String generateTokenForSimplesUser(String uid) throws DaoException, InvalidKeyException, NoSuchAlgorithmException {
        return AuthenticationService.generateLastTouchToken(SessionToken.IdentityType.LDAP, uid, null);
    }

    /**
     * Authenticate a user using a token - creates a databucket for the user as if they logged in.
     * This doesn't replace the Tomcat Security layer so the user is not 'fully' logged in, but have enough in their databucket
     * to make their way through a journey.
     *
     * @param session
     * @param token
     * @return
     * @throws DaoException
     * @throws Exception
     */
    public static boolean authenticateWithTokenForSimplesUser(HttpServletRequest request, String token) throws DaoException {
        String uid = authenticationService.consumeLastTouchToken(SessionToken.IdentityType.LDAP, token);
        HttpSession session = request.getSession();

        if (uid != null) {
            AuthenticationService.getUserDetailsFromLdap(session, uid);
            // These would have been set in the login tag but because we are not using proper JSESSION log in they are not.
            session.setAttribute("isLoggedIn", true);
            SessionUtils.setIsCallCentre(session, true);
            return true;
        }
        else {
            throw new TokenSecurityException("Token mismatch");
        }
    }
}
