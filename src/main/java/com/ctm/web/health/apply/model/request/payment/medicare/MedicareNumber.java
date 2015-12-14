package com.ctm.web.health.apply.model.request.payment.medicare;

import java.util.function.Supplier;

public class MedicareNumber implements Supplier<String> {

    private final String medicareNumber;

    public MedicareNumber(final String medicareNumber) {
        this.medicareNumber = medicareNumber;
    }

    @Override
    public String get() {
        return medicareNumber;
    }

//    public static String validateMedicare(final String medicareNumber){
//        if(medicareNumber.matches("^[2-6][\\d]{9}$")){
//            //9th digit is checksum
//            final int checksum = (Integer.parseInt(medicareNumber.substring(0,1)))
//                    + (Integer.parseInt(medicareNumber.substring(1,2)) * 3)
//                    + (Integer.parseInt(medicareNumber.substring(2,3)) * 7)
//                    + (Integer.parseInt(medicareNumber.substring(3,4)) * 9)
//                    + (Integer.parseInt(medicareNumber.substring(4,5)))
//                    + (Integer.parseInt(medicareNumber.substring(5,6)) * 3)
//                    + (Integer.parseInt(medicareNumber.substring(6,7)) * 7)
//                    + (Integer.parseInt(medicareNumber.substring(7,8)) * 9);
//            if(checksum % 10 == Integer.parseInt(medicareNumber.substring(9,10))){
//                return medicareNumber;
//            }
//        }
//        throw new InvalidApplicationException("Invalid medicare number: " + medicareNumber);
//    }
}