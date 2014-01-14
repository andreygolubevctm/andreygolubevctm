function returnAge(_dobString, round){
	var _now = new Date;
		_now.setHours(00,00,00);
	var _dob = returnDate(_dobString);
	var _years = _now.getFullYear() - _dob.getFullYear();

	if(_years < 1){
		return (_now - _dob) / (1000 * 60 * 60 * 24 * 365);
	};

	//leap year offset
	var _leapYears = _years - ( _now.getFullYear() % 4);
	_leapYears = (_leapYears - ( _leapYears % 4 )) /4;
	var _offset1 = ((_leapYears * 366) + ((_years - _leapYears) * 365)) / _years;

	//birthday offset - as it's always so close
	if(  (_dob.getMonth() == _now.getMonth()) && (_dob.getDate() > _now.getDate()) ){
		var _offset2 = -.005;
	} else {
		var _offset2 = +.005;
	};

	var _age = (_now - _dob) / (1000 * 60 * 60 * 24 * _offset1) + _offset2;
	if (round) {
		return Math.floor(_age);
	}
	else {
		return _age;
	}
};
function returnDate(_dateString){
	return new Date(_dateString.substring(6,10), _dateString.substring(3,5) - 1, _dateString.substring(0,2));
};