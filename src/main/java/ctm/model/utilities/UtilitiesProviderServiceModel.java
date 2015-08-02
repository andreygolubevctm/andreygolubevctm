package com.ctm.model.utilities;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;
import com.ctm.model.formatter.JsonUtils;
import com.ctm.model.utilities.UtilitiesProviderModel;

public class UtilitiesProviderServiceModel extends AbstractJsonModel {

	public static enum ServiceType  {
		Electricity, Gas, Electricity_Gas;
	}
	private ServiceType serviceType;
	private ArrayList<UtilitiesProviderModel> electricityProviders = new ArrayList<UtilitiesProviderModel>();
	private ArrayList<UtilitiesProviderModel> gasProviders = new ArrayList<UtilitiesProviderModel>();
	private String electricityTariff;

	// Getters & setters
	public ServiceType getServiceType() {
		return serviceType;
	}
	public void setServiceType(ServiceType serviceType) {
		this.serviceType = serviceType;
	}

	public ArrayList<UtilitiesProviderModel> getElectricityProviders() {
		return electricityProviders;
	}
	public void setElectricityProviders(ArrayList<UtilitiesProviderModel> electricityProviders) {
		this.electricityProviders = electricityProviders;
	}

	public ArrayList<UtilitiesProviderModel> getGasProviders() {
		return gasProviders;
	}
	public void setGasProviders(ArrayList<UtilitiesProviderModel> gasProviders) {
		this.gasProviders = gasProviders;
	}

	public String getElectricityTariff() {
		return electricityTariff;
	}

	public void setElectricityTariff(String electricityTariff) {
		this.electricityTariff = electricityTariff;
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("serviceType", getServiceType());

		JsonUtils.addListToJsonObject(json, "electricityProviders", getElectricityProviders());
		JsonUtils.addListToJsonObject(json, "gasProviders", getGasProviders());

		json.put("electricityTariff", getElectricityTariff());

		return json;
	}

	/**
	 *
	 * @param json
	 * @return
	 */
	public Boolean populateFromThoughtWorldJson(JSONObject json) throws JSONException {

			if(json.has("el_tariff") && json.isNull("el_tariff") == false) {
				setElectricityTariff(json.getString("el_tariff"));
			}

			JSONArray fuels = new JSONArray();
			if(json.has("fuel_type") && json.isNull("fuel_type") == false) {
				fuels = json.getJSONArray("fuel_type");
			}

			boolean hasElec = false;
			boolean hasGas = false;

			int length = fuels.length();
			if (length > 0) {
				String [] fuelStrings = new String [length];
				for (int i = 0; i < length; i++) {

					fuelStrings[i] = fuels.getString(i);

					if(fuels.getString(i).equals("Electricity")){
						hasElec = true;
					}

					if(fuels.getString(i).equals("Gas")){
						hasGas = true;
					}
				}

			}

			if(hasElec == true && hasGas == true){
				setServiceType(ServiceType.Electricity_Gas);
			}else if(hasElec == true){
				setServiceType(ServiceType.Electricity);
			}else if(hasGas == true){
				setServiceType(ServiceType.Gas);
			}

			if(json.has("elec_retailers") && json.isNull("elec_retailers") == false) {
				JSONArray elecRetailers = json.getJSONArray("elec_retailers");

				for(int i = 0; i < elecRetailers.length(); i++){
					JSONObject tempJson = elecRetailers.getJSONObject(i);
					UtilitiesProviderModel provider = new UtilitiesProviderModel();
					provider.setId(tempJson.getInt("ret_id"));
					provider.setName(tempJson.getString("name"));
					electricityProviders.add(provider);
				}
			}

			if(json.has("gas_retailers") && json.isNull("gas_retailers") == false) {
				JSONArray gasRetailers = json.getJSONArray("gas_retailers");
				for(int i = 0; i < gasRetailers.length(); i++){
					JSONObject tempJson = gasRetailers.getJSONObject(i);
					UtilitiesProviderModel provider = new UtilitiesProviderModel();
					provider.setId(tempJson.getInt("ret_id"));
					provider.setName(tempJson.getString("name"));
					gasProviders.add(provider);
				}
			}

		return true;

	}

}
