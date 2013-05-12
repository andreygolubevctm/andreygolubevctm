$().ready(function() {
	function SimplesTickler(timerIntervalSeconds) {
		var timerMinSeconds = 30,
			timerMaxSeconds = 1800,
			timerDefaultSeconds = timerMinSeconds;
		this._timerInterval = timerIntervalSeconds || timerDefaultSeconds;
		this._timerInterval = Math.min(Math.max(this._timerInterval, timerMinSeconds), timerMaxSeconds) * 1000;
		this._timerObj = false;
		this._tickleIdx = 0;
		this._init();
		return this;
	}

	SimplesTickler.prototype._methodDelegate = function(obj, method) {
		return function() {
			method.apply(obj, arguments);
		};
	};

	SimplesTickler.prototype._init = function() {
		this.stop();
		this.start();
	};

	SimplesTickler.prototype._tickle = function() {
		if ( this._timerObj ) {
			var ajaxContext = {
				_tickleResponseCheck: this._tickleResponseCheck,
				_tickleResponseFail: this._tickleResponseFail,
				_tickleIdx: this._tickleIdx + 0
			};

			$.ajax({
				method: 'GET',
				url: 'security/simples_tickle.jsp?nc=' + Math.floor(Math.random() * 32768) + '.' + this._tickleIdx,
				context: ajaxContext,
				success: ajaxContext._tickleResponseCheck,
				error: ajaxContext._tickleResponseFail,
				timeout: Math.max(this._timerInterval - 200, this._timerInterval)
			});

			++this._tickleIdx;

			if ( this._tickleIdx > 32767 ) {
				this._tickleIdx = 0;
			}
		} else {
			this.stop();
		}
	};

	SimplesTickler.prototype._tickleResponseCheck = function(data, textStatus, jqXHR) {
		if ( textStatus != 'success' || data.substr(0, 1) !== 'T' || ('' + data.substr(1, data.length)) !== ('' + this._tickleIdx) ) {
			this._tickleResponseFail();
		}
	};

	SimplesTickler.prototype._tickleResponseFail = function() {
		alert('Something horrible has happened with your session information! Maybe you had a long lunch and your computer went to sleep. Whatever.\r\rAnyway, I need to refresh and get you to log in again.');
		window.top.location.assign('simples.jsp');
	};

	SimplesTickler.prototype.start = function() {
		if ( !this._timerObj ) {
			this._timerObj = window.setInterval(this._methodDelegate(this, this._tickle), this._timerInterval);
		}

		return true;
	};

	SimplesTickler.prototype.stop = function() {
		if ( this._timerObj ) {
			window.clearInterval(this._timerObj);
		}

		this._timerObj = false;
		var maxIdx = this._tickleIdx;
		this._tickleIdx = 0;
		return maxIdx;
	};

	// start a new tickler to perform the callback every 25 minutes (25 x 60 seconds)
	stickler = new SimplesTickler(1500);
});
