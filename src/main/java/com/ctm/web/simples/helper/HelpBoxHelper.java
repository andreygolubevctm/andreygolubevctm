package com.ctm.web.simples.helper;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.simples.admin.model.HelpBox;
import com.ctm.web.simples.dao.UserDao;
import com.ctm.web.simples.model.User;

import javax.naming.NamingException;
import java.sql.SQLException;
import java.util.List;

public class HelpBoxHelper {
    public List<SchemaValidationError> validateHelpBoxRowData(HelpBox helpBox) throws DaoException {
        List<SchemaValidationError> validationErrors = FormValidation.validate(helpBox, "");
        return validationErrors;
    }

    public HelpBox createHelpBoxObject(int helpBoxId, String content, int operatorId, int styleCodeId,
                                       String styleCodeName, String effectiveStart, String effectiveEnd) throws DaoException {

        UserDao userDao = new UserDao();
        User user = userDao.getUser(operatorId);

        HelpBox helpBox = new HelpBox();
        helpBox.setHelpBoxId(helpBoxId);
        helpBox.setContent(content);
        helpBox.setOperatorId(operatorId);
        helpBox.setOperator(user.getUsername());
        helpBox.setStyleCodeId(styleCodeId);
        helpBox.setStyleCode(styleCodeName);
        helpBox.setEffectiveStart(effectiveStart);
        helpBox.setEffectiveEnd(effectiveEnd);

        return helpBox;
    }
}
