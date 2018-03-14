hoja = function () {
	this.keyval = [];
	this.recnum = [];
	this.prevLf = null;
	this.nextLf = null;};

nodo = function () {
	this.keyval = [];
	this.nodptr = [];};

tree = function (order) {
	this.root = new hoja();
	this.maxkey = order-1;
	this.minkyl = Math.floor(order/2);
	this.minkyn = Math.floor(this.maxkey/2);
	this.hoja = null;
	this.item = -1;
	this.keyval = '';
	this.recnum = -1;
	this.length = 0;
	this.eof = true;
	this.found = false;};

hoja.prototype.addKey = function (key,rec) {
	var vals = this.keyval;
	var itm = vals.length;
	for (var i=0, len=itm; i<len; i++) {
		if (key === vals[i]) {
			itm = -1;
			break;
		}
		if (key <= vals[i]) {
			itm = i;
			break;
		}
	}
	if (itm != -1) {
		for (var i=vals.length; i>itm; i--) {
			vals[i] = vals[i-1];
			this.recnum[i] = this.recnum[i-1];
		}
		vals[itm] = key;
		this.recnum[itm] = rec;
	}
	return itm;
};

hoja.prototype.split = function () {
	var mov = Math.floor(this.keyval.length/2);
	var newL = new hoja();
	for (var i=mov-1; i>=0; i--) {
		newL.keyval[i] = this.keyval.pop();
		newL.recnum[i] = this.recnum.pop();
	}
	newL.prevLf = this;
	newL.nextLf = this.nextLf;
	if (this.nextLf !== null) this.nextLf.prevLf = newL;
	this.nextLf = newL;
	return newL;
};

hoja.prototype.merge = function (frNod, paNod, frKey) {
	for (var i=0, len=frNod.keyval.length; i<len; i++) {
		this.keyval.push(frNod.keyval[i]);
		this.recnum.push(frNod.recnum[i]);
	}
	this.nextLf = frNod.nextLf;
	if (frNod.nextLf !== null) frNod.nextLf.prevLf = this;
	frNod.prevLf = null;
	frNod.nextLf = null;
	var itm = paNod.keyval.length-1;
	for (var i=itm; i>=0; i--) {
		if (paNod.keyval[i] == frKey) {
			itm = i;
			break;
		}
	}
	for (var i=itm, len=paNod.keyval.length-1; i<len; i++) {
		paNod.keyval[i] = paNod.keyval[i+1];
		paNod.nodptr[i+1] = paNod.nodptr[i+2];
	}
	paNod.keyval.pop();
	paNod.nodptr.pop();
};


hoja.prototype.esHoja = function() {return true;};

hoja.prototype.getItem = function (key,near) {
	var vals = this.keyval;
	if (near) {
		for (var i=0, len=vals.length; i<len; i++) {
			if (key <= vals[i]) return i;
		}
	} else {
		for (var i=0, len=vals.length; i<len; i++) {
			if (key === vals[i]) return i;
		}
	}
	return -1;
};

nodo.prototype.esHoja = function() {return false;};

nodo.prototype.getItem = function (key) {
	var vals = this.keyval;
	for (var i=0, len=vals.length; i<len; i++) {
		if (key < vals[i]) return i;
	}
	return vals.length;
};

nodo.prototype.addKey = function (key,ptrL,ptrR) {
	var vals = this.keyval;
	var itm = vals.length;
	for (var i=0, len=vals.length; i<len; i++) {
		if (key <= vals[i]) {
			itm = i;
			break;
		}
	}
	for (var i=vals.length; i>itm; i--) {
		vals[i] = vals[i-1];
		this.nodptr[i+1] = this.nodptr[i];
	}
	vals[itm] = key;
	this.nodptr[itm] = ptrL;
	this.nodptr[itm+1] = ptrR;
};

nodo.prototype.split = function () {
	var mov = Math.ceil(this.keyval.length/2) - 1;
	var newN = new nodo();
	newN.nodptr[mov] = this.nodptr.pop();
	for (var i=mov-1; i>=0; i--) {
		newN.keyval[i] = this.keyval.pop();
		newN.nodptr[i] = this.nodptr.pop();
	}
	return newN;
};

nodo.prototype.merge = function (frNod, paNod, paItm) {
	var del = paNod.keyval[paItm];
	this.keyval.push(del);
	for (var i=0, len=frNod.keyval.length; i<len; i++) {
		this.keyval.push(frNod.keyval[i]);
		this.nodptr.push(frNod.nodptr[i]);
	}
	this.nodptr.push(frNod.nodptr[frNod.nodptr.length-1]);
	for (var i=paItm, len=paNod.keyval.length-1; i<len; i++) {
		paNod.keyval[i] = paNod.keyval[i+1];
		paNod.nodptr[i+1] = paNod.nodptr[i+2];
	}
	paNod.keyval.pop();
	paNod.nodptr.pop();
	return del;
};

tree.prototype.insert = function (key,rec) {
	var stack = [];
	this.hoja = this.root;
	while (!this.hoja.esHoja()) {
		stack.push(this.hoja);
		this.item = this.hoja.getItem(key);
		this.hoja = this.hoja.nodptr[this.item];
	}
	this.item = this.hoja.addKey(key,rec);
	this.keyval = key;
	this.eof = false;
	if (this.item === -1) {
		this.found = true;
		this.item = this.hoja.getItem(key,false);
		this.recnum = this.hoja.recnum[this.item];
	} else {
		this.found = false;
		this.recnum = rec;
		this.length++;
		if (this.hoja.keyval.length > this.maxkey) {
			var pL = this.hoja;
			var pR = this.hoja.split();
			var ky = pR.keyval[0];
			this.item = this.hoja.getItem(key,false);
			if (this.item === -1) {
				this.hoja = this.hoja.nextLf;
				this.item = this.hoja.getItem(key,false);
			}
			while (true) {
				if (stack.length === 0) {
					var newN = new nodo();
					newN.keyval[0] = ky;
					newN.nodptr[0] = pL;
					newN.nodptr[1] = pR;
					this.root = newN;
					break;
				}
				var nod = stack.pop();
				nod.addKey(ky,pL,pR);
				if (nod.keyval.length <= this.maxkey) break;
				pL = nod;
				pR = nod.split();
				ky = nod.keyval.pop();
			}
		}
	}
	return (!this.found);
};