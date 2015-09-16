package com.ctm.providers.health.healthapply.model.request.payment.medicare;

import com.ctm.healthapply.exception.InvalidApplicationException;
import com.ctm.interfaces.common.types.ValueType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MedicareNumber extends ValueType<String> {

    private static final Logger LOGGER = LoggerFactory.getLogger(MedicareNumber.class);

    private MedicareNumber(final String value) {
        super(value);
    }

    public static MedicareNumber instanceOf(final String value) {
        return new MedicareNumber(validateMedicare(value));
    }

    public static String validateMedicare(final String medicareNumber){
        if(medicareNumber.matches("^[2-6][\\d]{9}$")){
            //9th digit is checksum
            final int checksum = (Integer.parseInt(medicareNumber.substring(0,1)))
                    + (Integer.parseInt(medicareNumber.substring(1,2)) * 3)
                    + (Integer.parseInt(medicareNumber.substring(2,3)) * 7)
                    + (Integer.parseInt(medicareNumber.substring(3,4)) * 9)
                    + (Integer.parseInt(medicareNumber.substring(4,5)))
                    + (Integer.parseInt(medicareNumber.substring(5,6)) * 3)
                    + (Integer.parseInt(medicareNumber.substring(6,7)) * 7)
                    + (Integer.parseInt(medicareNumber.substring(7,8)) * 9);
            if(checksum % 10 == Integer.parseInt(medicareNumber.substring(9,10))){
                return medicareNumber;
            } else {
                LOGGER.debug("Invalid checksum: {} not equal {}", checksum % 10, Integer.parseInt(medicareNumber.substring(9,10)));
            }
        }
        throw new InvalidApplicationException("Invalid medicare number: " + medicareNumber);
    }
}