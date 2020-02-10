package com.ctm.web.simples.phone.inin.model;

import lombok.*;

import java.util.List;

/**
 * Attributes to be supplied to ICWS ( Interaction Centre Web Services ) API
 * to associate all the transaction ids to a particular interaction id.
 *
 * /icws/{sessionId}/interactions/{interactionId}
 */

@Getter
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode
public class Transaction {

    private TransactionAttributes attributes;
    private Integer appendMode;

    @Override
    public String toString() {
        return "Transaction{" +
                "attributes=" + attributes +
                ", appendMode=" + appendMode +
                '}';
    }
}
