var vage;
var vstatus;
var vworking = 1;
var vchildren = 0;
var vnumChildren;
var vyoungest;
var vhomeowner;
var vmortgage;
var vmortgageAmount;
//var votherDebt;
var vlife = 0;
var vtpd = 0;
var index = new Array('d_age','d_status','d_working','d_children','d_numChildren','d_youngest','d_homeowner','d_mortgage','d_mortgageAmount','d_results'); //d_otherDebt
var selectedTab = 0;

var windowSearch = window.location.search.replace('?', '').split('=');
if(windowSearch.length && windowSearch[0] == "proceedToQuote" && windowSearch[1] == "false") {
	document.getElementById('update_qs_button').style.display = "none";
}

function navigate(divID){
  for(i = 0; i < index.length; i++){
    var layer = document.getElementById(index[i]);
    if(divID != index[i]){
      layer.style.visibility = 'hidden';
    }
    else{
      layer.style.visibility = 'visible';
    }
  }
}

function reset(){
  vworking = 1;
  vchildren = 0;
  vlife = 0;
  vtpd = 0;
  tabClick('0');
  navigate('d_age');
}

function set_age(item){
  vage = item;
  navigate('d_status');
}

function set_status(item){
  vstatus = item;
  if(vstatus == 'partner'){
    navigate('d_working');    
  }
  else{
    navigate('d_children');
  }
}

function set_working(item){
  vworking = item;
  navigate('d_children');
}

function set_children(item){
  vchildren = item;
  if(vchildren == 1){
    navigate('d_numChildren');
  }
  else{
    navigate('d_homeowner');
  }
}

function set_numChildren(item){
  vnumChildren = item;
  navigate('d_youngest');
}

function set_youngest(item){
  vyoungest = item;
  navigate('d_homeowner');
}

function set_homeowner(item){
  vhomeowner = item;
  if(vhomeowner == 1){
    navigate('d_mortgage');
  }
  else{
    //navigate('d_otherDebt');
    calculate_life();
    navigate('d_results');
  }
}

function set_mortgage(item){
  vmortgage = item;
  if(vmortgage == 1){
    navigate('d_mortgageAmount');
  }
  else{
    //navigate('d_otherDebt');
    calculate_life();
    navigate('d_results');
  }
}

function set_mortgageAmount(item){
  vmortgageAmount = item;
  //navigate('d_otherDebt');
  calculate_life();
  navigate('d_results');
}

/*function set_otherDebt(item){
  votherDebt = item;
  calculate_life();
  navigate('d_results');
}*/

function tabClick(n){
  if(n != selectedTab){
    var tab = document.getElementById('tab' + selectedTab);
    tab.className = 'tab not_selected';
    tab = document.getElementById('tab' + n);
    tab.className = 'tab selected';
    selectedTab = n;
  }
}

function calculate_life(){
  //calculate life cover
  //add sum based on age
  if(vage == 1){
    vlife = 400000;
  }
  else if(vage == 2){
    vlife = 300000;
  }
  else if(vage == 3){
    vlife = 200000;
  }
  else if(vage == 4){
    vlife = 100000;
  }
  else if(vage == 5){
    vlife = 50000
  }
  //add sum for mortgage 
  if(vmortgage == 1){
      if(vmortgageAmount == 1){
        vlife += 250000;
      }
      else if(vmortgageAmount == 2){
        vlife += 500000;
      }
      else if(vmortgageAmount == 3){
        vlife += 750000;
      }
      else if(vmortgageAmount == 4){
        vlife += 1000000;
      }
  }
/*//add sum for other debt
  if(votherDebt == 2){
    vlife += 150000;
  }
  else if(votherDebt == 3){
    vlife += 300000;
  }
  else if(votherDebt == 4){
    vlife += 500000;
  }*/
  //add sum for children
  if(vchildren > 0){
    for(i = 0; i < vnumChildren; i++){
      if(vyoungest == 1){
        vlife += 100000;
      }
      else if(vyoungest == 2){
        vlife += 75000;
      }
      else if(vyoungest == 3){
        vlife += 50000;
      }
      else if(vyoungest == 4){
	vlife += 25000;
      }
    }
  }
  //check if life cover less than $50,000
  if(vlife < 100000){
    vlife = 100000;
  }
  document.getElementById('results_body').innerHTML = 'Given your circumstances you should consider up to <b>$' + addCommas(vlife) + '</b> life insurance. <br /><br />This will provide a lump sum payment to provide financial security to loved ones in the event of death or terminal illness.';
  tabClick('0');
  
  return vlife;
}    

function calculate_ip(){
  //income protection cover
  document.getElementById('results_body').innerHTML = 'Your income is your most valuable asset; you should consider establishing cover that provides <b>75% of your income</b> in the event that you are unable to work due to sickness or injury.<br /><br /><i><b>Note:</b> Income Protection premiums are generally tax deductible.</i>';
  tabClick('1');
}

function calculate_tpd() {
  //calculate TPD cover
  if(vlife < 200000){
    vtpd = 100000;
  }
  else{
    vtpd = vlife / 2;
  }
  document.getElementById('results_body').innerHTML = 'Total and Permanent Disablement (TPD) provides protection if you are unable to work and unlikely to ever be able to work again.<br /><br />It provides a lump sum payment; <b>$' + addCommas(vtpd) + '</b> TPD insurance should be considered.';
  tabClick('2');
  
  return vtpd;
}

function calculate_trauma() {
	var vtrauma = 0;
  //calculate trauma cover
  if(vage == 1){
    document.getElementById('results_body').innerHTML = 'Based on your age, Trauma insurance should ideally be established for <b>$50,000 - $150,000</b>.<br /><br />However if you have a limited budget other insurances such as Life and Income Protection may be the preferred option.';
    vtrauma = 150000;
  }
  else if(vage == 2){
    document.getElementById('results_body').innerHTML = 'Based on your age, Trauma insurance should ideally be established for <b>$50,000 - $150,000</b>.<br /><br />However if you have a limited budget other insurances such as Life and Income Protection may be the preferred option.';
    vtrauma = 150000;
  }
  else if(vage == 3){
    document.getElementById('results_body').innerHTML = 'Based on your age, Trauma insurance should ideally be established for <b>$50,000 - $100,000</b>.<br /><br />However if you have a limited budget other insurances such as Life and Income Protection may be the preferred option.';
    vtrauma = 100000;
  }
  else if(vage == 4){
    document.getElementById('results_body').innerHTML = 'Based on your age, Trauma insurance should ideally be established for <b>$50,000 - $100,000</b>.<br /><br />However if you have a limited budget other insurances such as Life and Income Protection may be the preferred option.';
    vtrauma = 100000;
  }
  else if(vage == 5){
    document.getElementById('results_body').innerHTML = 'Unfortunately Trauma insurance is not available for your age group.<br /><br />You may wish to consider Life insurance and Income Protection as an alternative.';
  }
  tabClick('3');
  
  return vtrauma;
}

function addCommas(nStr)
{
  nStr += '';
  x = nStr.split('.');
  x1 = x[0];
  x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + ',' + '$2');
  }
  return x1 + x2;
}

function updateCTM() {	  
  try {
	  parent.QuestionSetUpdater.setLife( calculate_life() );
	  parent.QuestionSetUpdater.setTPD( calculate_tpd() );
	  parent.QuestionSetUpdater.setTrauma( calculate_trauma() );
  } catch(e) { /* IGNORE */ }	  
  try {
	  parent.QuestionSetUpdater.close();
  } catch(e) { /* IGNORE */ }	
}