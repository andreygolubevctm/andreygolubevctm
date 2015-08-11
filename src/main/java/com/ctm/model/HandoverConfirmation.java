package com.ctm.model;

import com.ctm.model.settings.Vertical.VerticalType;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.math.BigDecimal;
import java.util.Date;

public class HandoverConfirmation {
    public Date cookieCreate;
    public Date cookieUpdate;

    @Size(max=128)
    public String policyNo;

    @Size(max=128)
    public String policyType;

    @Size(max=128)
    public String policyName;

    public BigDecimal premium;

    @Size(max=128)
    public final String productCode;

    @NotNull
    public int providerId;

    @NotNull
    public VerticalType vertical;

    @NotNull
    public long transactionId;

    @Size(max=45)
    public String ip;

    @Size(max=5)
    public String sent;

    @NotNull
    public final boolean test;

    public HandoverConfirmation(final Date create, final Date update, final String policyNo, final String policyType,
      final String policyName, final BigDecimal premium, final String productCode, final int providerId, final VerticalType vertical,
      final long transactionId, final String ip, final String sent, final boolean test) {
        this.cookieCreate = create;
        this.cookieUpdate = update;
        this.policyNo = policyNo;
        this.policyType = policyType;
        this.policyName = policyName;
        this.premium = premium;
        this.productCode = productCode;
        this.providerId = providerId;
        this.vertical = vertical;
        this.transactionId = transactionId;
        this.ip = ip;
        this.sent = sent;
        this.test = test;
    }

    @Override
    public String toString() {
        return "HandoverConfirmation{" +
                "cookieCreate=" + cookieCreate +
                ", cookieUpdate=" + cookieUpdate +
                ", policyNo='" + policyNo + '\'' +
                ", policyType='" + policyType + '\'' +
                ", policyName='" + policyName + '\'' +
                ", premium=" + premium +
                ", productCode='" + productCode + '\'' +
                ", providerId=" + providerId +
                ", verticalCode=" + vertical +
                ", transactionId=" + transactionId +
                ", ip='" + ip + '\'' +
                ", sent='" + sent + '\'' +
                ", test=" + test +
                '}';
    }

    @Override
    @SuppressWarnings("RedundantIfStatement")
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final HandoverConfirmation that = (HandoverConfirmation) o;

        if (providerId != that.providerId) return false;
        if (test != that.test) return false;
        if (transactionId != that.transactionId) return false;
        if (cookieCreate != null ? !cookieCreate.equals(that.cookieCreate) : that.cookieCreate != null) return false;
        if (cookieUpdate != null ? !cookieUpdate.equals(that.cookieUpdate) : that.cookieUpdate != null) return false;
        if (ip != null ? !ip.equals(that.ip) : that.ip != null) return false;
        if (policyName != null ? !policyName.equals(that.policyName) : that.policyName != null) return false;
        if (policyNo != null ? !policyNo.equals(that.policyNo) : that.policyNo != null) return false;
        if (policyType != null ? !policyType.equals(that.policyType) : that.policyType != null) return false;
        if (premium != null ? !premium.equals(that.premium) : that.premium != null) return false;
        if (productCode != null ? !productCode.equals(that.productCode) : that.productCode != null) return false;
        if (sent != null ? !sent.equals(that.sent) : that.sent != null) return false;
        if (vertical != that.vertical) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = cookieCreate != null ? cookieCreate.hashCode() : 0;
        result = 31 * result + (cookieUpdate != null ? cookieUpdate.hashCode() : 0);
        result = 31 * result + (policyNo != null ? policyNo.hashCode() : 0);
        result = 31 * result + (policyType != null ? policyType.hashCode() : 0);
        result = 31 * result + (policyName != null ? policyName.hashCode() : 0);
        result = 31 * result + (premium != null ? premium.hashCode() : 0);
        result = 31 * result + (productCode != null ? productCode.hashCode() : 0);
        result = 31 * result + providerId;
        result = 31 * result + (vertical != null ? vertical.hashCode() : 0);
        result = 31 * result + (int) (transactionId ^ (transactionId >>> 32));
        result = 31 * result + (ip != null ? ip.hashCode() : 0);
        result = 31 * result + (sent != null ? sent.hashCode() : 0);
        result = 31 * result + (test ? 1 : 0);
        return result;
    }
}
