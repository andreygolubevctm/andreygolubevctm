package com.ctm.web.homecontents.controller;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.router.exceptionhandlers.ResponseError;
import com.ctm.web.core.security.StringEncryption;
import com.ctm.web.simples.services.TransactionDetailService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.helpers.MessageFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.NumberUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.Optional;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;


/**
 * Home contents transaction controller.
 * <p>
 * This is a temporary solution for ETL processes to migrate legacy "Transaction" to Home Contents "Journey"
 * <p>
 * Created by xna on 21/08/17.
 */
@RestController
@Api(tags = {"Everest", "Home Contents", "Transaction"}, description = "Home Contents Journey Controller")
public class HomeContentsTransactionController {

    private static final Logger LOGGER = LoggerFactory.getLogger(HomeContentsTransactionController.class);
    /**
     * The constant URI_TRANSACTION_ID.
     */
    public static final String URI_TRANSACTION_ID = "/rest/transaction/{encryptedId}";

    @Autowired
    private TransactionDetailService transactionDetailService;

    @Value("${everest.secret.key}")
    private String secretKey;

    @ApiOperation(value = "Get transaction details by encrypted ID", response = Map.class, produces = APPLICATION_JSON_VALUE)
    @RequestMapping(value = URI_TRANSACTION_ID, method = RequestMethod.GET, produces = APPLICATION_JSON_VALUE)
    public ResponseEntity getTransactionByEncryptedId(@PathVariable final String encryptedId) throws DaoException {

        // check and decrypt transaction id
        Optional<Long> optTransactionId = this.decryptTransactionId(encryptedId);
        if (!optTransactionId.isPresent()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(buildResponseError("Invalid encrypted Transaction ID [{}]", encryptedId));
        }

        // retrieve transaction details
        Optional<Map<String, Object>> optTransactionDetails = transactionDetailService.getTransactionDetailsInMap(optTransactionId.get());
        if (!optTransactionDetails.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(buildResponseError("Not Found Transaction [{}]", optTransactionId.get()));
        }

        return ResponseEntity.status(HttpStatus.OK).body(optTransactionDetails.get());
    }

    /**
     * Decrypt transaction id.
     *
     * @param encryptedId the encrypted id
     * @return the optional of transaction id
     */
    private Optional<Long> decryptTransactionId(String encryptedId) {
        try {
            final String transactionIdStr = StringEncryption.decrypt(secretKey, encryptedId);
            return Optional.of(NumberUtils.parseNumber(transactionIdStr, Long.class));
        } catch (Exception e) {
            LOGGER.error("Failed to decrypt Transaction ID [{}]. Reason: {}", encryptedId, e.getMessage(), e);
            return Optional.empty();
        }
    }

    /**
     * Build response error.
     *
     * @param message the message
     * @param args    the args
     * @return the response error
     */
    private ResponseError buildResponseError(String message, Object... args) {
        final ResponseError responseError = new ResponseError();
        responseError.addError(MessageFormatter.arrayFormat(message, args).getMessage());
        return responseError;
    }

}