package com.ctm.web.simples.helper;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.simples.admin.model.UserEditableText;
import com.ctm.web.simples.dao.UserDao;
import com.ctm.web.simples.model.User;

import java.util.List;

public class UserEditableTextHelper {
    public List<SchemaValidationError> validateUserEditableTextRowData(UserEditableText userEditableText) throws DaoException {
        List<SchemaValidationError> validationErrors = FormValidation.validate(userEditableText, "");
        return validationErrors;
    }

    public UserEditableText createUserEditableTextObject(String textType, int textId, String content, int operatorId, int styleCodeId,
                                                         String styleCodeName, String effectiveStart, String effectiveEnd) throws DaoException {

        UserDao userDao = new UserDao();
        User user = userDao.getUser(operatorId);

        UserEditableText userEditableText = new UserEditableText();
        userEditableText.setTextId(textId);
        userEditableText.setTextType(textType);
        userEditableText.setContent(content);
        userEditableText.setOperatorId(operatorId);
        userEditableText.setOperator(user.getUsername());
        userEditableText.setStyleCodeId(styleCodeId);
        userEditableText.setStyleCode(styleCodeName);
        userEditableText.setEffectiveStart(effectiveStart);
        userEditableText.setEffectiveEnd(effectiveEnd);

        return userEditableText;
    }
}
