package com.ctm.web.health.duplicateTransCheck;

import com.ctm.web.health.duplicateTransCheck.model.query.DuplicateTransactionsCheckQuery;
import com.ctm.web.health.duplicateTransCheck.model.response.DuplicateTransactionsCheckDetails;
import com.ctm.web.health.duplicateTransCheck.model.response.DuplicateTransactionsCheckResponse;
import io.swagger.annotations.Api;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;

@Api(basePath = "/dupetranscheck", value = "Duplicate Transactions Check API")
@RestController
@RequestMapping("/dupetranscheck")
public class DuplicateTransactionsCheckerController {

    @RequestMapping(value = "/duplicate-transactions-check/post.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_JSON_VALUE},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public static DuplicateTransactionsCheckResponse duplicateTransactionsCheck(@RequestBody @Valid DuplicateTransactionsCheckQuery duplicateTransactionsCheckQuery) {
        DuplicateTransactionsCheckDetails dupeTransCheckDetails = DuplicateTransactionsCheckDetails.checkDuplicates(duplicateTransactionsCheckQuery.getRootId(), duplicateTransactionsCheckQuery.getTransactionId(), duplicateTransactionsCheckQuery.getEmailAddress(), duplicateTransactionsCheckQuery.getFullAddress(), duplicateTransactionsCheckQuery.getMobile(), duplicateTransactionsCheckQuery.getHomePhone());
        return new DuplicateTransactionsCheckResponse(dupeTransCheckDetails);
    }
}