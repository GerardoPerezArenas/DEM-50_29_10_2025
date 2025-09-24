// Parsers.js - Minimal y compatible con InputMask.js
// Define NumberParser y DateParser usados por NumberMask y DateMask.

(function() {
	// Constructor de NumberParser
	function NumberParser(options) {
		options = options || {};
		this.decimalDigits = typeof options.decimalDigits === 'number' ? options.decimalDigits : 2;
		this.decimalSeparator = options.decimalSeparator || ',';
		this.groupSeparator = options.groupSeparator || '.';
		this.currencySymbol = options.currencySymbol || '';
		this.useGrouping = !!options.useGrouping;
	}

	NumberParser.prototype.format = function(n) {
		if (n === null || typeof n === 'undefined' || isNaN(n)) return '';
		var fixed = Number(n).toFixed(this.decimalDigits);
		var parts = fixed.split('.');
		var intPart = parts[0];
		var decPart = parts.length > 1 ? parts[1] : '';
		if (this.useGrouping) {
			var rgx = /\B(?=(\d{3})+(?!\d))/g;
			intPart = intPart.replace(rgx, this.groupSeparator);
		}
		var out = intPart;
		if (this.decimalDigits > 0) {
			out += this.decimalSeparator + decPart;
		}
		if (this.currencySymbol) {
			out = this.currencySymbol + ' ' + out;
		}
		return out;
	};

	NumberParser.prototype.parse = function(s) {
		if (s === null || typeof s === 'undefined') return 0;
		s = String(s);
		if (this.currencySymbol) {
			s = s.replace(this.currencySymbol, '');
		}
		if (this.useGrouping && this.groupSeparator) {
			var gs = this.groupSeparator.replace(/[-/\\^$*+?.()|[\]{}]/g, '\\$&');
			var reGs = new RegExp(gs, 'g');
			s = s.replace(reGs, '');
		}
		if (this.decimalSeparator && this.decimalSeparator !== '.') {
			var ds = this.decimalSeparator.replace(/[-/\\^$*+?.()|[\]{}]/g, '\\$&');
			var reDs = new RegExp(ds, 'g');
			s = s.replace(reDs, '.');
		}
		s = s.replace(/\s+/g, '').trim();
		var v = parseFloat(s);
		return isNaN(v) ? 0 : v;
	};

	// Constructor de DateParser
	function DateParser(options) {
		options = options || {};
		this.formatStr = options.format || 'dd/mm/yyyy';
	}

	DateParser.prototype.format = function(d) {
		if (!d || !(d instanceof Date)) return '';
		var dd = ('0' + d.getDate()).slice(-2);
		var mm = ('0' + (d.getMonth() + 1)).slice(-2);
		var yyyy = d.getFullYear();
		return dd + '/' + mm + '/' + yyyy;
	};

	DateParser.prototype.parse = function(s) {
		if (!s) return null;
		s = String(s).trim();
		var m = s.match(/^(\d{1,2})\/(\d{1,2})\/(\d{2,4})$/);
		if (!m) return null;
		var dd = parseInt(m[1], 10);
		var mm = parseInt(m[2], 10) - 1;
		var yyyy = parseInt(m[3], 10);
		if (yyyy < 100) { yyyy += 2000; }
		var d = new Date(yyyy, mm, dd);
		if (d.getFullYear() !== yyyy || d.getMonth() !== mm || d.getDate() !== dd) return null;
		return d;
	};

	// Exponer en global (compatibilidad con scripts legacy)
	window.NumberParser = NumberParser;
	window.DateParser = DateParser;
	})();
