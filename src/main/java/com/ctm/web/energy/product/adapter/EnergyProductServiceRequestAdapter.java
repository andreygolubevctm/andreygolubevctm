package com.ctm.web.energy.product.adapter;

import com.ctm.energy.product.request.model.EnergyProductRequest;
import com.ctm.interfaces.common.types.ProductId;
import com.ctm.web.energy.form.model.EnergyProductInfoWebRequest;
import com.ctm.web.energy.quote.adapter.WebRequestAdapter;
import org.springframework.stereotype.Component;

@Component
public class EnergyProductServiceRequestAdapter implements WebRequestAdapter<EnergyProductInfoWebRequest, EnergyProductRequest> {

    @Override
    public EnergyProductRequest adapt(EnergyProductInfoWebRequest request) {
        return new EnergyProductRequest(ProductId.instanceOf(request.getProductId()));
    }
}
