package com.ctm.web.email.health;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.commons.lang3.StringUtils;

@Getter
@Setter
@EqualsAndHashCode
@ToString
public class EmailParameters implements Comparable<EmailParameters> {
    String premium;
    String providerName;
    String providerPhoneNumber;
    String quoteUrl;
    String openingHour;
    String productDes;
    String brandCode;
    String excess;
    String discountOffer;
    String headlineOffer;
    String productId;
    String validDate;
    String quoteRef;

    @Override
    public int compareTo(EmailParameters that) {
        if(StringUtils.isNotBlank(this.getPremium()) && StringUtils.isNotBlank(that.getPremium())) {
            Integer thisPremium = Integer.parseInt(this.getPremium());
            Integer thatPremium = Integer.parseInt(that.getPremium());
            if(thisPremium > thatPremium) return 1;
            else if(thisPremium < thatPremium) return -1;
            else return 0;
        }
        throw new IllegalArgumentException("Premium not present for provider:" + providerName + " productId: " + productId);
    }
}
