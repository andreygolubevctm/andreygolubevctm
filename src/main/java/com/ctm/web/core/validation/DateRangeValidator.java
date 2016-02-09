package com.ctm.web.core.validation;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.lang.reflect.Field;
import java.util.Date;

public class DateRangeValidator implements ConstraintValidator<DateRange, Object>
{
    private String startFieldName;
    private String endFieldName;

    @Override
    public void initialize(final DateRange constraintAnnotation)
    {
        startFieldName = constraintAnnotation.start();
        endFieldName = constraintAnnotation.end();
    }

    @Override
    public boolean isValid(final Object value, final ConstraintValidatorContext context)
    {
        try
        {
            final Date startObj = getField(value, startFieldName);
            final Date endObj = getField(value, endFieldName);

            return startObj == null || endObj == null || endObj.after(startObj);
        }
        catch (final Exception ignore)
        {
            // ignore
        }
        return true;
    }

    private Date getField(Object obj, String fieldName) throws ReflectiveOperationException {
        Field field = obj.getClass().getDeclaredField(fieldName);
        boolean accessible = field.isAccessible();
        field.setAccessible(true);
        Date value = (Date) field.get(obj);
        field.setAccessible(accessible);
        return value;
    }
}