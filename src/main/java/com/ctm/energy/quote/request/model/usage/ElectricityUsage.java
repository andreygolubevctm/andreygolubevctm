package com.ctm.energy.quote.request.model.usage;

import com.ctm.energy.quote.request.model.ElectricityMeterType;


public interface ElectricityUsage extends Usage {
    ElectricityMeterType getMeterType();
}
