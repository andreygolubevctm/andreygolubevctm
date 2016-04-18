package com.ctm.web.health.model.request;

import org.junit.Test;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import java.util.Set;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.beans.HasPropertyWithValue.hasProperty;
import static org.hamcrest.collection.IsEmptyCollection.empty;
import static org.hamcrest.core.Is.is;

public class PaymentTest {

    Validator validator = Validation.buildDefaultValidatorFactory().getValidator();


    @Test
    public void shouldValidatePaymentGatewayName(){
        String validName = "Bobby Tables";
        String validNameWithHyphen = "Bobby Hacky-Tables";

        Payment payment = new Payment();
        payment.gatewayName = validName;
        Set<ConstraintViolation<Payment>> result = validator.validate(payment);
        assertThat(result, is(empty()));

        payment.gatewayName = validNameWithHyphen;
        result = validator.validate(payment);
        assertThat(result, is(empty()));
    }

    @Test
    public void shouldValidateInvalidPaymentGatewayName(){
        String invalidName = "'  -- drop table; Select 1 = '1";
        Payment payment = new Payment();

        payment.gatewayName = invalidName;
        Set<ConstraintViolation<Payment>> result = validator.validate(payment);

        assertThat( result, org.hamcrest.Matchers.contains(
                hasProperty("message",
                        is("Please enter alphabetic characters only. Unfortunately, international alphabetic characters, " +
                                "numbers and symbols are not supported by many of our partners at this time."))
        ));
    }


}