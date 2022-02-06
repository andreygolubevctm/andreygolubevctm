package com.ctm.web.simples.admin.services;

import com.ctm.web.core.exceptions.CrudValidationException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.utils.common.utils.DateUtils;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.simples.admin.dao.UserEditableTextDao;
import com.ctm.web.simples.admin.model.UserEditableText;
import com.ctm.web.simples.admin.model.UserEditableTextType;
import com.ctm.web.simples.helper.UserEditableTextHelper;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class UserEditableTextService {
    private final UserEditableTextDao userEditableTextDao = new UserEditableTextDao();
    private final UserEditableTextHelper userEditableTextHelper = new UserEditableTextHelper();
    private final IPAddressHandler ipAddressHandler;
    private final SimpleDateFormat sdf = new SimpleDateFormat("EEE MMM d HH:mm:ss Z yyyy");

    public UserEditableTextService() {
        ipAddressHandler =  IPAddressHandler.getInstance();
    }

    public List<SchemaValidationError> validateUserEditableTextData(HttpServletRequest request, AuthenticatedData authenticatedData) {
        try {
            UserEditableText userEditableText = new UserEditableText();
            userEditableText = RequestUtils.createObjectFromRequest(request, userEditableText);
            userEditableText.setOperatorId(authenticatedData.getSimplesUid());
            return userEditableTextHelper.validateUserEditableTextRowData(userEditableText);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    public List<UserEditableText> getAllUserEditableText(UserEditableTextType textType) {
        try {
            List<UserEditableText> userEditableTextList;
            userEditableTextList = userEditableTextDao.fetchUserEditableText(0, textType, "","", -1);
            return userEditableTextList;
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    public UserEditableText getCurrentUserEditableText(String textType, int styleCodeId, Date applicationDate) {
        UserEditableTextType userEditableTextType = getUserEditableTextType(textType);
        try {
            java.sql.Date serverDate = new java.sql.Date(DateUtils.setTimeInDate(sdf.parse(applicationDate.toString()), 0, 0, 1).getTime());
            return userEditableTextDao.fetchSingleRecUserEditableText(userEditableTextType, serverDate.toString(), styleCodeId);
        } catch (DaoException | ParseException d) {
            throw new RuntimeException(d);
        }
    }

    public UserEditableText createUserEditableText(HttpServletRequest request, AuthenticatedData authenticatedData) throws CrudValidationException {
        try {
            UserEditableText userEditableText = new UserEditableText();
            userEditableText = RequestUtils.createObjectFromRequest(request, userEditableText);
            userEditableText.setOperatorId(authenticatedData.getSimplesUid());
            final String userName = authenticatedData.getUid();
            final String ipAddress = ipAddressHandler.getIPAddress(request);

            checkUserEditableTextValidation(userEditableText, false);

            return userEditableTextDao.createUserEditableText(userEditableText, userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    public UserEditableText updateUserEditableText(HttpServletRequest request, AuthenticatedData authenticatedData) throws CrudValidationException {
        try {
            UserEditableText userEditableText = new UserEditableText();
            userEditableText = RequestUtils.createObjectFromRequest(request, userEditableText);
            userEditableText.setOperatorId(authenticatedData.getSimplesUid());
            final String userName = authenticatedData.getUid();
            final String ipAddress = ipAddressHandler.getIPAddress(request);

            checkUserEditableTextValidation(userEditableText, true);

            return userEditableTextDao.updateUserEditableText(userEditableText, userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    private List<SchemaValidationError> checkUserEditableTextValidation(UserEditableText userEditableText, Boolean isUpdate) throws DaoException, CrudValidationException {
        UserEditableTextType userEditableTextType = getUserEditableTextType(userEditableText.getTextType());
        List<UserEditableText> userEditableTextList = userEditableTextDao.fetchUserEditableText(0, userEditableTextType, userEditableText.getEffectiveStart(), userEditableText.getEffectiveEnd(), userEditableText.getStyleCodeId());
        List<SchemaValidationError> validationErrors = new ArrayList<>();
        Boolean addValidation = false;

        if (!userEditableTextList.isEmpty()) {
            if (isUpdate) {
                // loop through found userEditableText and if there's one that is not the updated record.. add the validation
                for (UserEditableText hb : userEditableTextList) {
                    if (userEditableText.getTextId() != hb.getTextId()) {
                        addValidation = true;
                    }
                }
            } else {
                addValidation = true;
            }
        }

        if (addValidation) {
            SchemaValidationError error = new SchemaValidationError();
            error.setElements("effectiveStart , effectiveEnd");
            error.setMessage(UserEditableTextType.getEnum(userEditableText.getTextType()).getDescription() + " effective date range invalid");
            validationErrors.add(error);
        }

        if (!validationErrors.isEmpty()) {
            throw new CrudValidationException(validationErrors);
        }

        return validationErrors;
    }

    public String deleteUserEditableText(HttpServletRequest request, AuthenticatedData authenticatedData) {
        try {
            final String userName = authenticatedData.getUid();
            final String ipAddress = ipAddressHandler.getIPAddress(request);
            return userEditableTextDao.deleteUserEditableText(request.getParameter("textId"), userName, ipAddress);
        } catch (DaoException d) {
            throw new RuntimeException(d);
        }
    }

    private UserEditableTextType getUserEditableTextType(String textType) {
        UserEditableTextType userEditableTextType = UserEditableTextType.getEnum(textType);
        if (userEditableTextType == null) {
            throw new RuntimeException("Wrong type of user editable text: " + textType);
        }
        return userEditableTextType;
    }
}
