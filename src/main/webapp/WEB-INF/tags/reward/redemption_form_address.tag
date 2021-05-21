<%@ tag description="Redemption address tempalte" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="elasticSearchTypeaheadComponent elasticsearch_container_order_address" data-address-id="order_address" data-suburbSeqNo="" data-search-type="P" data-address-streetNum="" data-address-unitShop="">
    <div class="form-group row fieldrow " id="order_address_error_container">
        <div class="col-sm-6 col-xs-10  col-sm-offset-4 row-content">
            <div class="error-field"></div>
            <div class="fieldrow_legend" id="order_address_error_container_row_legend"></div>
        </div>
        <div class="col-sm-2 col-xs-2"></div>
    </div>
    <div class="form-group row fieldrow  required_input " id="order_address_autofilllessSearchRow">
        <label  class="col-sm-4 col-xs-10  control-label">Address for delivery</label>
        <div class="col-xs-2 visible-xs helpIconXSColumn "></div>
        <div class="col-sm-6 col-xs-12   row-content">
            <input type="text" name="order_address_autofilllessSearch" id="order_address_autofilllessSearch" class="form-control typeahead typeahead-address typeahead-autofilllessSearch show-loading sessioncamexclude placeholder"  value="{{= orderAddress.fullAddress }}"  placeholder="e.g. 5/20 Sample St" data-rule-validAutofilllessSearch='order_address' data-msg-validAutofilllessSearch='Please select a valid address' >
            <div class="fieldrow_legend" id="order_address_autofilllessSearchRow_row_legend"></div>
        </div>
        <div class="col-sm-2 hidden-xs"></div>
    </div>
    <div class="form-group row fieldrow  required_input  order_address_nonStdFieldRow" id="order_address_postCode_suburb">
        <label for="order_address_nonStdPostCode" class="col-sm-4 col-xs-10  control-label">Postcode</label>
        <div class="col-xs-2 visible-xs helpIconXSColumn "></div>
        <div class="col-sm-6 col-xs-12   row-content">
            <input type="text"  required data-msg-required="Please enter postcode" name="order_address_nonStdPostCode" pattern="[0-9]*" maxlength="4" id="order_address_nonStdPostCode" class="form-control " value="{{= orderAddress.postcode }}" size="4" data-rule-minlength="4" data-msg-minlength="Postcode should be 4 characters long" data-rule-number="true" data-msg-number="Postcode must contain numbers only."  autocomplete='false' placeholder="Postcode" />
            <div class="fieldrow_legend" id="order_address_postCode_suburb_row_legend"></div>
        </div>
        <div class="col-sm-2 hidden-xs"></div>
    </div>
    <div class="form-group row fieldrow  required_input  order_address_nonStdFieldRow">
        <label for="order_address_suburb" class="col-sm-4 col-xs-10  control-label">Suburb</label>
        <div class="col-xs-2 visible-xs helpIconXSColumn "></div>
        <div class="col-sm-6 col-xs-12   row-content">
            <div class="select">
					<span class=" input-group-addon" data-target="order_address">
						<i class="icon-angle-down"></i>
					</span>
                <select name="order_address_suburb" id="order_address_suburb" class="form-control" data-attach="true" disabled="disabled" data-rule-validSuburb="order_address"  autocomplete='false'>
                    <option value=''>Enter Postcode</option>
                </select>
            </div>
            <div class="fieldrow_legend"></div>
        </div>
        <div class="col-sm-2 hidden-xs"></div>
    </div>
    <div class="cleardiv"></div>
    <div class="form-group row fieldrow  required_input  order_address_nonStdFieldRow">
        <label for="order_address_nonStdStreet" class="col-sm-4 col-xs-10  control-label">Street</label>
        <div class="col-xs-2 visible-xs helpIconXSColumn "></div>
        <div class="col-sm-6 col-xs-12   row-content">
            <input type="text" name="order_address_nonStdStreet" id="order_address_nonStdStreet" class="form-control sessioncamexclude"  value="{{= orderAddress.streetName }}"  data-rule-validAddress='order_address' data-rule-validAddress='Please enter the residential street' >
            <div class="fieldrow_legend"></div>
        </div>
        <div class="col-sm-2 hidden-xs"></div>
    </div>
    <div class="form-group row fieldrow order_address_nonStdFieldRow" id="order_address_streetNumRow">
        <label for="order_address_streetNum" class="col-sm-4 col-xs-10  control-label">Street No. or PO Box</label>
        <div class="col-xs-2 visible-xs helpIconXSColumn "></div>
        <div class="col-sm-6 col-xs-12   row-content">
            <div class="order_address_streetNum_container">
                <input type="text" name="order_address_streetNum" id="order_address_streetNum" class="form-control typeahead typeahead-address typeahead-streetNum blur-on-select show-loading sessioncamexclude"  value="{{= orderAddress.streetNumber }}"  data-attach="true"  data-rule-validAddress='order_address' data-msg-validAddress='Please enter a valid street number'>
            </div>
            <div class="fieldrow_legend" id="order_address_streetNumRow_row_legend"></div>
        </div>
        <div class="col-sm-2 hidden-xs"></div>
    </div>
    <div class="form-group row fieldrow order_address_nonStdFieldRow" id="order_address_unitShopRow">
        <label for="order_address_unitShop" class="col-sm-4 col-xs-10  control-label">Unit/Shop/Level</label>
        <div class="col-xs-2 visible-xs helpIconXSColumn "></div>
        <div class="col-sm-6 col-xs-12   row-content">
            <input type="text" name="order_address_unitShop" id="order_address_unitShop" class="form-control typeahead typeahead-address typeahead-unitShop blur-on-select show-loading sessioncamexclude"  value="{{= orderAddress.unitNumber }}"  data-attach="true" >
            <div class="fieldrow_legend" id="order_address_unitShopRow_row_legend"></div>
        </div>
        <div class="col-sm-2 hidden-xs"></div>
    </div>
    <div class="form-group row fieldrow order_address_nonStdFieldRow">
        <label for="order_address_nonStdUnitType" class="col-sm-4 col-xs-10  control-label">Unit Type</label>
        <div class="col-xs-2 visible-xs helpIconXSColumn "></div>
        <div class="col-sm-6 col-xs-12   row-content">
            <div class="select ">
								<span class=" input-group-addon">
									<i class="icon-angle-down"></i>
								</span>
                <select class="form-control array_select " id="order_address_nonStdUnitType" name="order_address_nonStdUnitType"  data-msg-required="Please choose the unit type"  data-attach="true" >
                    <option id="order_address_nonStdUnitType_" value="">Please choose...</option>
                    <option id="order_address_nonStdUnitType_CO" value="CO">Cottage</option>
                    <option id="order_address_nonStdUnitType_DU" value="DU">Duplex</option>
                    <option id="order_address_nonStdUnitType_FA" value="FA">Factory</option>
                    <option id="order_address_nonStdUnitType_HO" value="HO">House</option>
                    <option id="order_address_nonStdUnitType_KI" value="KI">Kiosk</option>
                    <option id="order_address_nonStdUnitType_L" value="L">Level</option>
                    <option id="order_address_nonStdUnitType_M" value="M">Maisonette</option>
                    <option id="order_address_nonStdUnitType_MA" value="MA">Marine Berth</option>
                    <option id="order_address_nonStdUnitType_OF" value="OF">Office</option>
                    <option id="order_address_nonStdUnitType_PE" value="PE">Penthouse</option>
                    <option id="order_address_nonStdUnitType_RE" value="RE">Rear</option>
                    <option id="order_address_nonStdUnitType_RO" value="RO">Room</option>
                    <option id="order_address_nonStdUnitType_SH" value="SH">Shop</option>
                    <option id="order_address_nonStdUnitType_ST" value="ST">Stall</option>
                    <option id="order_address_nonStdUnitType_SI" value="SI">Site</option>
                    <option id="order_address_nonStdUnitType_SU" value="SU">Suite</option>
                    <option id="order_address_nonStdUnitType_TO" value="TO">Townhouse</option>
                    <option id="order_address_nonStdUnitType_UN" value="UN">Unit</option>
                    <option id="order_address_nonStdUnitType_VI" value="VI">Villa</option>
                    <option id="order_address_nonStdUnitType_WA" value="WA">Ward</option>
                    <option id="order_address_nonStdUnitType_OT" value="OT">Other</option>
                </select>
            </div>
            <div class="fieldrow_legend"></div>
        </div>
        <div class="col-sm-2 hidden-xs"></div>
    </div>
    <!-- NON STANDARD CHECKBOX -->
    <div class="form-group row fieldrow nonStd" id="order_address_nonStd_row">
        <div class="col-sm-6 col-xs-10  col-sm-offset-4 row-content">
            <div class=" checkbox">
                <input type="checkbox" name="order_address_nonStd" id="order_address_nonStd" class="checkbox-custom  checkbox" value="Y">
                <label for="order_address_nonStd" >
                    Tick here if you are unable to find the address or your address is a PO Box</label>
            </div>
            <div class="fieldrow_legend" id="order_address_nonStd_row_row_legend"></div>
        </div>
        <div class="col-sm-2 col-xs-2"></div>
    </div>
    <div class="cleardiv"></div>
    <!-- HIDDEN FIELDS (Populated in autocomplete.js or elastic_search.js) -->
    <input type="hidden" name="order_address_type" id="order_address_type" class="" value="P"  />
    <input type="hidden" name="order_address_elasticSearch" id="order_address_elasticSearch" class="" value="Y"  />
    <input type="hidden" name="order_address_lastSearch" id="order_address_lastSearch" class="" value=""  />
    <input type="hidden" name="order_address_fullAddressLineOne" id="order_address_fullAddressLineOne" class="" value=""  />
    <input type="hidden" name="order_address_fullAddress" id="order_address_fullAddress" class="" value="{{= orderAddress.fullAddress }}"  />
    <input type="hidden" name="order_address_dpId" id="order_address_dpId" class="" value="{{= orderAddress.dpid }}"  />
    <input type="hidden" name="order_address_unitType" id="order_address_unitType" class="" value="{{= orderAddress.unitType }}"  />
    <input type="hidden" name="order_address_unitSel" id="order_address_unitSel" class="" value="{{= orderAddress.unitNumber }}"  />
    <input type="hidden" name="order_address_houseNoSel" id="order_address_houseNoSel" class="" value="{{= orderAddress.streetNumber }}"  />
    <input type="hidden" name="order_address_floorNo" id="order_address_floorNo" class="" value=""  />
    <input type="hidden" name="order_address_streetName" id="order_address_streetName" class="" value="{{= orderAddress.streetName }}"  />
    <input type="hidden" name="order_address_streetId" id="order_address_streetId" class="" value=""  />
    <input type="hidden" name="order_address_suburbName" id="order_address_suburbName" class=""  value=""  />
    <input type="hidden" name="order_address_suburbNamePrefill" id="order_address_suburbNamePrefill" class=""  value="{{= orderAddress.suburb }}"  />
    <input type="hidden" name="order_address_postCode" id="order_address_postCode" class="" value="{{= orderAddress.postcode }}"  />
    <input type="hidden" name="order_address_state" id="order_address_state" class="" value="{{= orderAddress.state }}"  />
</div>