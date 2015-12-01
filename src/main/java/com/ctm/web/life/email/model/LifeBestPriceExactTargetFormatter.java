package com.ctm.web.life.email.model;

import com.ctm.web.core.email.model.ExactTargetEmailModel;
import com.ctm.web.core.email.formatter.ExactTargetFormatter;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class LifeBestPriceExactTargetFormatter extends ExactTargetFormatter<LifeBestPriceEmailModel> {
	
	@Override
	protected ExactTargetEmailModel formatXml(LifeBestPriceEmailModel model) {
		emailModel = new ExactTargetEmailModel();
		
		SimpleDateFormat sdf = new SimpleDateFormat("d MMMMM yyyy");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, 30);
		Date validDate = cal.getTime();
		String dateString = sdf.format(validDate);
		
		emailModel.setAttribute("ValidDate", dateString);
		
		emailModel.setAttribute("FirstName", model.getFirstName());
		emailModel.setAttribute("LastName", model.getLastName());
		emailModel.setAttribute("Brand", model.getBrand());
		
		emailModel.setAttribute("TPDCover", model.getTPDCover());
		emailModel.setAttribute("LifeCover", model.getLifeCover());
		emailModel.setAttribute("TraumaCover", model.getTraumaCover());
		
		emailModel.setAttribute("Premium1", model.getPremium());
		emailModel.setAttribute("QuoteRef", model.getLeadNumber());
		
		emailModel.setAttribute("Occupation", model.getOccupation());
		
		emailModel.setAttribute("Gender", model.getGender());
		emailModel.setAttribute("Age", model.getAge());
		emailModel.setAttribute("Smoker", model.getSmoker());
		
		return emailModel;
	}

}