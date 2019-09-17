(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

console.warn('Compiled in DEV mode. Follow the advice at https://elm-lang.org/0.19.0/optimize for better performance and smaller assets.');


var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



var _List_Nil_UNUSED = { $: 0 };
var _List_Nil = { $: '[]' };

function _List_Cons_UNUSED(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === elm$core$Basics$EQ ? 0 : ord === elm$core$Basics$LT ? -1 : 1;
	}));
});



// LOG

var _Debug_log_UNUSED = F2(function(tag, value)
{
	return value;
});

var _Debug_log = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString_UNUSED(value)
{
	return '<internals>';
}

function _Debug_toString(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File === 'function' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[94m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash_UNUSED(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.start.line === region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'on lines ' + region.start.line + ' through ' + region.end.line;
}



// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	/**/
	if (x.$ === 'Set_elm_builtin')
	{
		x = elm$core$Set$toList(x);
		y = elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = elm$core$Dict$toList(x);
		y = elm$core$Dict$toList(y);
	}
	//*/

	/**_UNUSED/
	if (x.$ < 0)
	{
		x = elm$core$Dict$toList(x);
		y = elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**_UNUSED/
	if (typeof x.$ === 'undefined')
	//*/
	/**/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? elm$core$Basics$LT : n ? elm$core$Basics$GT : elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0_UNUSED = 0;
var _Utils_Tuple0 = { $: '#0' };

function _Utils_Tuple2_UNUSED(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3_UNUSED(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr_UNUSED(c) { return c; }
function _Utils_chr(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return word
		? elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? elm$core$Maybe$Nothing
		: elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? elm$core$Maybe$Just(n) : elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




/**/
function _Json_errorToString(error)
{
	return elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? elm$core$Result$Ok(value)
		: (value instanceof String)
			? elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return (elm$core$Result$isOk(result)) ? result : elm$core$Result$Err(A2(elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return (elm$core$Result$isOk(result)) ? result : elm$core$Result$Err(A2(elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!elm$core$Result$isOk(result))
					{
						return elm$core$Result$Err(A2(elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return elm$core$Result$Ok(elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if (elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return elm$core$Result$Err(elm$json$Json$Decode$OneOf(elm$core$List$reverse(errors)));

		case 1:
			return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!elm$core$Result$isOk(result))
		{
			return elm$core$Result$Err(A2(elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2(elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap(value) { return { $: 0, a: value }; }
function _Json_unwrap(value) { return value.a; }

function _Json_wrap_UNUSED(value) { return value; }
function _Json_unwrap_UNUSED(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	elm$core$Result$isOk(result) || _Debug_crash(2 /**/, _Json_errorToString(result.a) /**/);
	var managers = {};
	result = init(result.a);
	var model = result.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		result = A2(update, msg, model);
		stepper(model = result.a, viewMetadata);
		_Platform_dispatchEffects(managers, result.b, subscriptions(model));
	}

	_Platform_dispatchEffects(managers, result.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				p: bag.n,
				q: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.q)
		{
			x = temp.p(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		r: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].r;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		r: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].r;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**_UNUSED/
	var node = args['node'];
	//*/
	/**/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS


function _VirtualDom_noScript(tag)
{
	return tag == 'script' ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return /^(on|formAction$)/i.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri_UNUSED(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,'')) ? '' : value;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,''))
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri_UNUSED(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value) ? '' : value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value)
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2(elm$json$Json$Decode$map, func, handler.a)
				:
			A3(elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		message: func(record.message),
		stopPropagation: record.stopPropagation,
		preventDefault: record.preventDefault
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		((key !== 'value' && key !== 'checked') || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		typeof value !== 'undefined'
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		typeof value !== 'undefined'
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.message;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.stopPropagation;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.preventDefault) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		var newMatch = undefined;
		var oldMatch = undefined;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}




// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var view = impl.view;
			/**_UNUSED/
			var domNode = args['node'];
			//*/
			/**/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.setup && impl.setup(sendToApp)
			var view = impl.view;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.body);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.title) && (_VirtualDom_doc.title = title = doc.title);
			});
		}
	);
});



// ANIMATION


var _Browser_cancelAnimationFrame =
	typeof cancelAnimationFrame !== 'undefined'
		? cancelAnimationFrame
		: function(id) { clearTimeout(id); };

var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { return setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.onUrlChange;
	var onUrlRequest = impl.onUrlRequest;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		setup: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.hasAttribute('download'))
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.protocol === next.protocol
							&& curr.host === next.host
							&& curr.port_.a === next.port_.a
						)
							? elm$browser$Browser$Internal(next)
							: elm$browser$Browser$External(href)
					));
				}
			});
		},
		init: function(flags)
		{
			return A3(impl.init, flags, _Browser_getUrl(), key);
		},
		view: impl.view,
		update: impl.update,
		subscriptions: impl.subscriptions
	});
}

function _Browser_getUrl()
{
	return elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return elm$core$Result$isOk(result) ? elm$core$Maybe$Just(result.a) : elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { hidden: 'hidden', change: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { hidden: 'mozHidden', change: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { hidden: 'msHidden', change: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { hidden: 'webkitHidden', change: 'webkitvisibilitychange' }
		: { hidden: 'hidden', change: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = _Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			_Browser_cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail(elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		scene: _Browser_getScene(),
		viewport: {
			x: _Browser_window.pageXOffset,
			y: _Browser_window.pageYOffset,
			width: _Browser_doc.documentElement.clientWidth,
			height: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		width: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		height: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			scene: {
				width: node.scrollWidth,
				height: node.scrollHeight
			},
			viewport: {
				x: node.scrollLeft,
				y: node.scrollTop,
				width: node.clientWidth,
				height: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			scene: _Browser_getScene(),
			viewport: {
				x: x,
				y: y,
				width: _Browser_doc.documentElement.clientWidth,
				height: _Browser_doc.documentElement.clientHeight
			},
			element: {
				x: x + rect.left,
				y: y + rect.top,
				width: rect.width,
				height: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}



var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});
var elm$core$Dict$RBEmpty_elm_builtin = {$: 'RBEmpty_elm_builtin'};
var elm$core$Dict$empty = elm$core$Dict$RBEmpty_elm_builtin;
var aforemny$elm_mdc$Material$defaultModel = {button: elm$core$Dict$empty, checkbox: elm$core$Dict$empty, chip: elm$core$Dict$empty, dialog: elm$core$Dict$empty, drawer: elm$core$Dict$empty, fab: elm$core$Dict$empty, iconButton: elm$core$Dict$empty, list: elm$core$Dict$empty, menu: elm$core$Dict$empty, radio: elm$core$Dict$empty, ripple: elm$core$Dict$empty, select: elm$core$Dict$empty, slider: elm$core$Dict$empty, snackbar: elm$core$Dict$empty, _switch: elm$core$Dict$empty, tabbar: elm$core$Dict$empty, textfield: elm$core$Dict$empty, toolbar: elm$core$Dict$empty, topAppBar: elm$core$Dict$empty};
var elm$core$Basics$True = {$: 'True'};
var elm$core$Maybe$Nothing = {$: 'Nothing'};
var aforemny$elm_mdc$Main$defaultModel = {authenticated: true, drawerOpen: true, mdc: aforemny$elm_mdc$Material$defaultModel, profile: elm$core$Maybe$Nothing};
var aforemny$elm_mdc$Main$Mdc = function (a) {
	return {$: 'Mdc', a: a};
};
var aforemny$elm_mdc$Internal$Ripple$Model$Idle = {$: 'Idle'};
var elm$core$Basics$False = {$: 'False'};
var aforemny$elm_mdc$Internal$Ripple$Model$defaultModel = {animationCounter: 0, animationState: aforemny$elm_mdc$Internal$Ripple$Model$Idle, clientRect: elm$core$Maybe$Nothing, focused: false};
var aforemny$elm_mdc$Internal$Button$Model$defaultModel = {ripple: aforemny$elm_mdc$Internal$Ripple$Model$defaultModel};
var elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var elm$core$Array$foldr = F3(
	function (func, baseCase, _n0) {
		var tree = _n0.c;
		var tail = _n0.d;
		var helper = F2(
			function (node, acc) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3(elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3(elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			elm$core$Elm$JsArray$foldr,
			helper,
			A3(elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var elm$core$Basics$EQ = {$: 'EQ'};
var elm$core$Basics$LT = {$: 'LT'};
var elm$core$List$cons = _List_cons;
var elm$core$Array$toList = function (array) {
	return A3(elm$core$Array$foldr, elm$core$List$cons, _List_Nil, array);
};
var elm$core$Basics$GT = {$: 'GT'};
var elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3(elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var elm$core$Dict$toList = function (dict) {
	return A3(
		elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var elm$core$Dict$keys = function (dict) {
	return A3(
		elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2(elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var elm$core$Set$toList = function (_n0) {
	var dict = _n0.a;
	return elm$core$Dict$keys(dict);
};
var elm$core$Basics$compare = _Utils_compare;
var elm$core$Maybe$Just = function (a) {
	return {$: 'Just', a: a};
};
var elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _n1 = A2(elm$core$Basics$compare, targetKey, key);
				switch (_n1.$) {
					case 'LT':
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 'EQ':
						return elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var elm$core$Dict$Black = {$: 'Black'};
var elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: 'RBNode_elm_builtin', a: a, b: b, c: c, d: d, e: e};
	});
var elm$core$Dict$Red = {$: 'Red'};
var elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Red')) {
			var _n1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
				var _n3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Red,
					key,
					value,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, rK, rV, rLeft, rRight));
			} else {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) && (left.d.$ === 'RBNode_elm_builtin')) && (left.d.a.$ === 'Red')) {
				var _n5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _n6 = left.d;
				var _n7 = _n6.a;
				var llK = _n6.b;
				var llV = _n6.c;
				var llLeft = _n6.d;
				var llRight = _n6.e;
				var lRight = left.e;
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Red,
					lK,
					lV,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, llK, llV, llLeft, llRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, key, value, lRight, right));
			} else {
				return A5(elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, key, value, elm$core$Dict$RBEmpty_elm_builtin, elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _n1 = A2(elm$core$Basics$compare, key, nKey);
			switch (_n1.$) {
				case 'LT':
					return A5(
						elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3(elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 'EQ':
					return A5(elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3(elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _n0 = A3(elm$core$Dict$insertHelp, key, value, dict);
		if ((_n0.$ === 'RBNode_elm_builtin') && (_n0.a.$ === 'Red')) {
			var _n1 = _n0.a;
			var k = _n0.b;
			var v = _n0.c;
			var l = _n0.d;
			var r = _n0.e;
			return A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _n0;
			return x;
		}
	});
var elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var aforemny$elm_mdc$Internal$Component$indexed = F3(
	function (get_model, set_model, model0) {
		var set_ = F3(
			function (idx, store, model) {
				return A2(
					set_model,
					A3(
						elm$core$Dict$insert,
						idx,
						model,
						get_model(store)),
					store);
			});
		var get_ = F2(
			function (idx, store) {
				return A2(
					elm$core$Maybe$withDefault,
					model0,
					A2(
						elm$core$Dict$get,
						idx,
						get_model(store)));
			});
		return {get: get_, set: set_};
	});
var aforemny$elm_mdc$Internal$Button$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.button;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{button: x});
		}),
	aforemny$elm_mdc$Internal$Button$Model$defaultModel);
var aforemny$elm_mdc$Internal$Button$Model$RippleMsg = function (a) {
	return {$: 'RippleMsg', a: a};
};
var elm$core$Basics$always = F2(
	function (a, _n0) {
		return a;
	});
var elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var elm$core$Process$sleep = _Process_sleep;
var elm$core$Basics$identity = function (x) {
	return x;
};
var elm$core$Task$Perform = function (a) {
	return {$: 'Perform', a: a};
};
var elm$core$Task$succeed = _Scheduler_succeed;
var elm$core$Task$init = elm$core$Task$succeed(_Utils_Tuple0);
var elm$core$Basics$add = _Basics_add;
var elm$core$Basics$gt = _Utils_gt;
var elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var elm$core$List$reverse = function (list) {
	return A3(elm$core$List$foldl, elm$core$List$cons, _List_Nil, list);
};
var elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							elm$core$List$foldl,
							fn,
							acc,
							elm$core$List$reverse(r4)) : A4(elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4(elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var elm$core$Task$andThen = _Scheduler_andThen;
var elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			elm$core$Task$andThen,
			function (a) {
				return elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			elm$core$Task$andThen,
			function (a) {
				return A2(
					elm$core$Task$andThen,
					function (b) {
						return elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var elm$core$Task$sequence = function (tasks) {
	return A3(
		elm$core$List$foldr,
		elm$core$Task$map2(elm$core$List$cons),
		elm$core$Task$succeed(_List_Nil),
		tasks);
};
var elm$core$Result$isOk = function (result) {
	if (result.$ === 'Ok') {
		return true;
	} else {
		return false;
	}
};
var elm$core$Array$branchFactor = 32;
var elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 'Array_elm_builtin', a: a, b: b, c: c, d: d};
	});
var elm$core$Basics$ceiling = _Basics_ceiling;
var elm$core$Basics$fdiv = _Basics_fdiv;
var elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var elm$core$Basics$toFloat = _Basics_toFloat;
var elm$core$Array$shiftStep = elm$core$Basics$ceiling(
	A2(elm$core$Basics$logBase, 2, elm$core$Array$branchFactor));
var elm$core$Elm$JsArray$empty = _JsArray_empty;
var elm$core$Array$empty = A4(elm$core$Array$Array_elm_builtin, 0, elm$core$Array$shiftStep, elm$core$Elm$JsArray$empty, elm$core$Elm$JsArray$empty);
var elm$core$Array$Leaf = function (a) {
	return {$: 'Leaf', a: a};
};
var elm$core$Array$SubTree = function (a) {
	return {$: 'SubTree', a: a};
};
var elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _n0 = A2(elm$core$Elm$JsArray$initializeFromList, elm$core$Array$branchFactor, nodes);
			var node = _n0.a;
			var remainingNodes = _n0.b;
			var newAcc = A2(
				elm$core$List$cons,
				elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var elm$core$Basics$eq = _Utils_equal;
var elm$core$Tuple$first = function (_n0) {
	var x = _n0.a;
	return x;
};
var elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = elm$core$Basics$ceiling(nodeListSize / elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2(elm$core$Elm$JsArray$initializeFromList, elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2(elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var elm$core$Basics$floor = _Basics_floor;
var elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var elm$core$Basics$mul = _Basics_mul;
var elm$core$Basics$sub = _Basics_sub;
var elm$core$Elm$JsArray$length = _JsArray_length;
var elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.nodeListSize) {
			return A4(
				elm$core$Array$Array_elm_builtin,
				elm$core$Elm$JsArray$length(builder.tail),
				elm$core$Array$shiftStep,
				elm$core$Elm$JsArray$empty,
				builder.tail);
		} else {
			var treeLen = builder.nodeListSize * elm$core$Array$branchFactor;
			var depth = elm$core$Basics$floor(
				A2(elm$core$Basics$logBase, elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? elm$core$List$reverse(builder.nodeList) : builder.nodeList;
			var tree = A2(elm$core$Array$treeFromBuilder, correctNodeList, builder.nodeListSize);
			return A4(
				elm$core$Array$Array_elm_builtin,
				elm$core$Elm$JsArray$length(builder.tail) + treeLen,
				A2(elm$core$Basics$max, 5, depth * elm$core$Array$shiftStep),
				tree,
				builder.tail);
		}
	});
var elm$core$Basics$idiv = _Basics_idiv;
var elm$core$Basics$lt = _Utils_lt;
var elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					elm$core$Array$builderToArray,
					false,
					{nodeList: nodeList, nodeListSize: (len / elm$core$Array$branchFactor) | 0, tail: tail});
			} else {
				var leaf = elm$core$Array$Leaf(
					A3(elm$core$Elm$JsArray$initialize, elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2(elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var elm$core$Basics$le = _Utils_le;
var elm$core$Basics$remainderBy = _Basics_remainderBy;
var elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return elm$core$Array$empty;
		} else {
			var tailLen = len % elm$core$Array$branchFactor;
			var tail = A3(elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - elm$core$Array$branchFactor;
			return A5(elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var elm$core$Result$Err = function (a) {
	return {$: 'Err', a: a};
};
var elm$core$Result$Ok = function (a) {
	return {$: 'Ok', a: a};
};
var elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 'Index', a: a, b: b};
	});
var elm$json$Json$Decode$OneOf = function (a) {
	return {$: 'OneOf', a: a};
};
var elm$core$Basics$and = _Basics_and;
var elm$core$Basics$append = _Utils_append;
var elm$core$Basics$or = _Basics_or;
var elm$core$Char$toCode = _Char_toCode;
var elm$core$Char$isLower = function (_char) {
	var code = elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var elm$core$Char$isUpper = function (_char) {
	var code = elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var elm$core$Char$isAlpha = function (_char) {
	return elm$core$Char$isLower(_char) || elm$core$Char$isUpper(_char);
};
var elm$core$Char$isDigit = function (_char) {
	var code = elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var elm$core$Char$isAlphaNum = function (_char) {
	return elm$core$Char$isLower(_char) || (elm$core$Char$isUpper(_char) || elm$core$Char$isDigit(_char));
};
var elm$core$List$length = function (xs) {
	return A3(
		elm$core$List$foldl,
		F2(
			function (_n0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var elm$core$List$map2 = _List_map2;
var elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2(elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var elm$core$List$range = F2(
	function (lo, hi) {
		return A3(elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			elm$core$List$map2,
			f,
			A2(
				elm$core$List$range,
				0,
				elm$core$List$length(xs) - 1),
			xs);
	});
var elm$core$String$all = _String_all;
var elm$core$String$fromInt = _String_fromNumber;
var elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var elm$core$String$uncons = _String_uncons;
var elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var elm$json$Json$Decode$indent = function (str) {
	return A2(
		elm$core$String$join,
		'\n    ',
		A2(elm$core$String$split, '\n', str));
};
var elm$json$Json$Encode$encode = _Json_encode;
var elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + (elm$core$String$fromInt(i + 1) + (') ' + elm$json$Json$Decode$indent(
			elm$json$Json$Decode$errorToString(error))));
	});
var elm$json$Json$Decode$errorToString = function (error) {
	return A2(elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 'Field':
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _n1 = elm$core$String$uncons(f);
						if (_n1.$ === 'Nothing') {
							return false;
						} else {
							var _n2 = _n1.a;
							var _char = _n2.a;
							var rest = _n2.b;
							return elm$core$Char$isAlpha(_char) && A2(elm$core$String$all, elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2(elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'Index':
					var i = error.a;
					var err = error.b;
					var indexName = '[' + (elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2(elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'OneOf':
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									elm$core$String$join,
									'',
									elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										elm$core$String$join,
										'',
										elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + (elm$core$String$fromInt(
								elm$core$List$length(errors)) + ' ways:'));
							return A2(
								elm$core$String$join,
								'\n\n',
								A2(
									elm$core$List$cons,
									introduction,
									A2(elm$core$List$indexedMap, elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								elm$core$String$join,
								'',
								elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + (elm$json$Json$Decode$indent(
						A2(elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var elm$core$Platform$sendToApp = _Platform_sendToApp;
var elm$core$Task$spawnCmd = F2(
	function (router, _n0) {
		var task = _n0.a;
		return _Scheduler_spawn(
			A2(
				elm$core$Task$andThen,
				elm$core$Platform$sendToApp(router),
				task));
	});
var elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			elm$core$Task$map,
			function (_n0) {
				return _Utils_Tuple0;
			},
			elm$core$Task$sequence(
				A2(
					elm$core$List$map,
					elm$core$Task$spawnCmd(router),
					commands)));
	});
var elm$core$Task$onSelfMsg = F3(
	function (_n0, _n1, _n2) {
		return elm$core$Task$succeed(_Utils_Tuple0);
	});
var elm$core$Task$cmdMap = F2(
	function (tagger, _n0) {
		var task = _n0.a;
		return elm$core$Task$Perform(
			A2(elm$core$Task$map, tagger, task));
	});
_Platform_effectManagers['Task'] = _Platform_createManager(elm$core$Task$init, elm$core$Task$onEffects, elm$core$Task$onSelfMsg, elm$core$Task$cmdMap);
var elm$core$Task$command = _Platform_leaf('Task');
var elm$core$Task$perform = F2(
	function (toMessage, task) {
		return elm$core$Task$command(
			elm$core$Task$Perform(
				A2(elm$core$Task$map, toMessage, task)));
	});
var aforemny$elm_mdc$Internal$Helpers$delayedCmd = F2(
	function (time, msg) {
		return A2(
			elm$core$Task$perform,
			elm$core$Basics$always(msg),
			elm$core$Process$sleep(time));
	});
var aforemny$elm_mdc$Internal$Ripple$Implementation$normalizedEventCoords = F3(
	function (event, pageOffset, clientRect) {
		var _n0 = pageOffset;
		var x = _n0.x;
		var y = _n0.y;
		var documentX = x + clientRect.x;
		var documentY = x + clientRect.y;
		var _n1 = event.pagePoint;
		var pageX = _n1.pageX;
		var pageY = _n1.pageY;
		return {x: pageX - documentX, y: pageY - documentY};
	});
var aforemny$elm_mdc$Internal$Ripple$Implementation$fgTranslationCoords = F2(
	function (isUnbounded, _n0) {
		var frame = _n0.frame;
		var activationEvent = _n0.activationEvent;
		var windowPageOffset = _n0.windowPageOffset;
		var wasActivatedByPointer = _n0.wasActivatedByPointer;
		var maxDimension = A2(elm$core$Basics$max, frame.width, frame.height);
		var initialSize = maxDimension * 0.6;
		var startPoint = function () {
			var _n1 = A3(aforemny$elm_mdc$Internal$Ripple$Implementation$normalizedEventCoords, activationEvent, windowPageOffset, frame);
			var x = _n1.x;
			var y = _n1.y;
			return {x: x - (initialSize / 2), y: y - (initialSize / 2)};
		}();
		var endPoint = {x: (frame.width - initialSize) / 2, y: (frame.height - initialSize) / 2};
		return {endPoint: endPoint, startPoint: startPoint};
	});
var elm$core$String$fromFloat = _String_fromNumber;
var aforemny$elm_mdc$Internal$Ripple$Implementation$animateActivation = F4(
	function (isUnbounded, frame, windowPageOffset, activationEvent) {
		var wasActivatedByPointer = true;
		var _n0 = A2(
			aforemny$elm_mdc$Internal$Ripple$Implementation$fgTranslationCoords,
			isUnbounded,
			{activationEvent: activationEvent, frame: frame, wasActivatedByPointer: wasActivatedByPointer, windowPageOffset: windowPageOffset});
		var startPoint = _n0.startPoint;
		var endPoint = _n0.endPoint;
		var translateEnd = isUnbounded ? '' : (elm$core$String$fromFloat(endPoint.x) + ('px, ' + (elm$core$String$fromFloat(endPoint.y) + 'px')));
		var translateStart = isUnbounded ? '' : (elm$core$String$fromFloat(startPoint.x) + ('px, ' + (elm$core$String$fromFloat(startPoint.y) + 'px')));
		return {translateEnd: translateEnd, translateStart: translateStart};
	});
var aforemny$elm_mdc$Internal$Ripple$Model$numbers = {deactivationTimeoutMs: 225, fgDeactivationMs: 150, initialOriginScale: 0.6, padding: 10, tapDelayMs: 300};
var elm$core$Basics$pow = _Basics_pow;
var elm$core$Basics$sqrt = _Basics_sqrt;
var aforemny$elm_mdc$Internal$Ripple$Implementation$layoutInternal = F2(
	function (isUnbounded, frame) {
		var maxDim = A2(elm$core$Basics$max, frame.width, frame.height);
		var initialSize = elm$core$Basics$floor(maxDim * aforemny$elm_mdc$Internal$Ripple$Model$numbers.initialOriginScale);
		var hypotenuse = elm$core$Basics$sqrt(
			A2(elm$core$Basics$pow, frame.width, 2) + A2(elm$core$Basics$pow, frame.height, 2));
		var boundedRadius = hypotenuse + aforemny$elm_mdc$Internal$Ripple$Model$numbers.padding;
		var maxRadius = isUnbounded ? maxDim : boundedRadius;
		var fgScale = maxRadius / initialSize;
		return {fgScale: fgScale, initialSize: initialSize};
	});
var aforemny$elm_mdc$Internal$Ripple$Model$Activate = F2(
	function (a, b) {
		return {$: 'Activate', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Ripple$Model$Activated = function (a) {
	return {$: 'Activated', a: a};
};
var aforemny$elm_mdc$Internal$Ripple$Model$ActivationEnded = function (a) {
	return {$: 'ActivationEnded', a: a};
};
var aforemny$elm_mdc$Internal$Ripple$Model$Deactivated = function (a) {
	return {$: 'Deactivated', a: a};
};
var aforemny$elm_mdc$Internal$Ripple$Model$DeactivationEnded = function (a) {
	return {$: 'DeactivationEnded', a: a};
};
var aforemny$elm_mdc$Internal$Ripple$Model$Reactivate = F2(
	function (a, b) {
		return {$: 'Reactivate', a: a, b: b};
	});
var elm$browser$Browser$External = function (a) {
	return {$: 'External', a: a};
};
var elm$browser$Browser$Internal = function (a) {
	return {$: 'Internal', a: a};
};
var elm$browser$Browser$Dom$NotFound = function (a) {
	return {$: 'NotFound', a: a};
};
var elm$core$Basics$never = function (_n0) {
	never:
	while (true) {
		var nvr = _n0.a;
		var $temp$_n0 = nvr;
		_n0 = $temp$_n0;
		continue never;
	}
};
var elm$json$Json$Decode$map = _Json_map1;
var elm$json$Json$Decode$map2 = _Json_map2;
var elm$json$Json$Decode$succeed = _Json_succeed;
var elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 'Normal':
			return 0;
		case 'MayStopPropagation':
			return 1;
		case 'MayPreventDefault':
			return 2;
		default:
			return 3;
	}
};
var elm$core$String$length = _String_length;
var elm$core$String$slice = _String_slice;
var elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			elm$core$String$slice,
			n,
			elm$core$String$length(string),
			string);
	});
var elm$core$String$startsWith = _String_startsWith;
var elm$url$Url$Http = {$: 'Http'};
var elm$url$Url$Https = {$: 'Https'};
var elm$core$String$indexes = _String_indexes;
var elm$core$String$isEmpty = function (string) {
	return string === '';
};
var elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3(elm$core$String$slice, 0, n, string);
	});
var elm$core$String$contains = _String_contains;
var elm$core$String$toInt = _String_toInt;
var elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {fragment: fragment, host: host, path: path, port_: port_, protocol: protocol, query: query};
	});
var elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if (elm$core$String$isEmpty(str) || A2(elm$core$String$contains, '@', str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, ':', str);
			if (!_n0.b) {
				return elm$core$Maybe$Just(
					A6(elm$url$Url$Url, protocol, str, elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_n0.b.b) {
					var i = _n0.a;
					var _n1 = elm$core$String$toInt(
						A2(elm$core$String$dropLeft, i + 1, str));
					if (_n1.$ === 'Nothing') {
						return elm$core$Maybe$Nothing;
					} else {
						var port_ = _n1;
						return elm$core$Maybe$Just(
							A6(
								elm$url$Url$Url,
								protocol,
								A2(elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return elm$core$Maybe$Nothing;
				}
			}
		}
	});
var elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '/', str);
			if (!_n0.b) {
				return A5(elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _n0.a;
				return A5(
					elm$url$Url$chompBeforePath,
					protocol,
					A2(elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '?', str);
			if (!_n0.b) {
				return A4(elm$url$Url$chompBeforeQuery, protocol, elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _n0.a;
				return A4(
					elm$url$Url$chompBeforeQuery,
					protocol,
					elm$core$Maybe$Just(
						A2(elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '#', str);
			if (!_n0.b) {
				return A3(elm$url$Url$chompBeforeFragment, protocol, elm$core$Maybe$Nothing, str);
			} else {
				var i = _n0.a;
				return A3(
					elm$url$Url$chompBeforeFragment,
					protocol,
					elm$core$Maybe$Just(
						A2(elm$core$String$dropLeft, i + 1, str)),
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$fromString = function (str) {
	return A2(elm$core$String$startsWith, 'http://', str) ? A2(
		elm$url$Url$chompAfterProtocol,
		elm$url$Url$Http,
		A2(elm$core$String$dropLeft, 7, str)) : (A2(elm$core$String$startsWith, 'https://', str) ? A2(
		elm$url$Url$chompAfterProtocol,
		elm$url$Url$Https,
		A2(elm$core$String$dropLeft, 8, str)) : elm$core$Maybe$Nothing);
};
var elm$browser$Browser$Dom$getElement = _Browser_getElement;
var elm$core$Platform$Cmd$batch = _Platform_batch;
var elm$core$Platform$Cmd$none = elm$core$Platform$Cmd$batch(_List_Nil);
var elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var elm$core$Task$onError = _Scheduler_onError;
var elm$core$Task$attempt = F2(
	function (resultToMessage, task) {
		return elm$core$Task$command(
			elm$core$Task$Perform(
				A2(
					elm$core$Task$onError,
					A2(
						elm$core$Basics$composeL,
						A2(elm$core$Basics$composeL, elm$core$Task$succeed, resultToMessage),
						elm$core$Result$Err),
					A2(
						elm$core$Task$andThen,
						A2(
							elm$core$Basics$composeL,
							A2(elm$core$Basics$composeL, elm$core$Task$succeed, resultToMessage),
							elm$core$Result$Ok),
						task))));
	});
var aforemny$elm_mdc$Internal$Ripple$Implementation$update = F2(
	function (msg, model) {
		var _n0 = _Utils_Tuple2(msg, model.animationState);
		_n0$13:
		while (true) {
			switch (_n0.a.$) {
				case 'Focus':
					var _n1 = _n0.a;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{focused: true}),
						elm$core$Platform$Cmd$none);
				case 'Blur':
					var _n2 = _n0.a;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{focused: false}),
						elm$core$Platform$Cmd$none);
				case 'SetCssVariables':
					var _n3 = _n0.a;
					var isUnbounded = _n3.a;
					var clientRect = _n3.b;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								clientRect: elm$core$Maybe$Just(clientRect)
							}),
						elm$core$Platform$Cmd$none);
				case 'Activate0':
					if (_n0.b.$ === 'Idle') {
						var _n4 = _n0.a;
						var domId = _n4.a;
						var activateData = _n4.b;
						var _n5 = _n0.b;
						return _Utils_Tuple2(
							model,
							A2(
								elm$core$Task$attempt,
								aforemny$elm_mdc$Internal$Ripple$Model$Activate(activateData),
								elm$browser$Browser$Dom$getElement(domId)));
					} else {
						var _n6 = _n0.a;
						var domId = _n6.a;
						var activateData = _n6.b;
						return _Utils_Tuple2(
							model,
							A2(
								elm$core$Task$attempt,
								aforemny$elm_mdc$Internal$Ripple$Model$Reactivate(activateData),
								elm$browser$Browser$Dom$getElement(domId)));
					}
				case 'Reactivate':
					switch (_n0.b.$) {
						case 'Activated':
							var _n7 = _n0.a;
							var activateData = _n7.a;
							var element = _n7.b;
							var activationEvent = _n0.b.a.activationEvent;
							return _Utils_eq(activateData.event.eventType, activationEvent.eventType) ? _Utils_Tuple2(
								_Utils_update(
									model,
									{animationState: aforemny$elm_mdc$Internal$Ripple$Model$Idle}),
								A2(
									elm$core$Task$perform,
									function (_n8) {
										return A2(aforemny$elm_mdc$Internal$Ripple$Model$Activate, activateData, element);
									},
									elm$core$Task$succeed(_Utils_Tuple0))) : _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
						case 'Deactivated':
							var _n9 = _n0.a;
							var activateData = _n9.a;
							var element = _n9.b;
							var activationEvent = _n0.b.a.activationEvent;
							return _Utils_eq(activateData.event.eventType, activationEvent.eventType) ? _Utils_Tuple2(
								_Utils_update(
									model,
									{animationState: aforemny$elm_mdc$Internal$Ripple$Model$Idle}),
								A2(
									elm$core$Task$perform,
									function (_n10) {
										return A2(aforemny$elm_mdc$Internal$Ripple$Model$Activate, activateData, element);
									},
									elm$core$Task$succeed(_Utils_Tuple0))) : _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
						default:
							var _n11 = _n0.a;
							var activateData = _n11.a;
							var element = _n11.b;
							var _n12 = _n0.b;
							return _Utils_Tuple2(
								_Utils_update(
									model,
									{animationState: aforemny$elm_mdc$Internal$Ripple$Model$Idle}),
								A2(
									elm$core$Task$perform,
									function (_n13) {
										return A2(aforemny$elm_mdc$Internal$Ripple$Model$Activate, activateData, element);
									},
									elm$core$Task$succeed(_Utils_Tuple0)));
					}
				case 'Activate':
					if (_n0.a.b.$ === 'Err') {
						var _n14 = _n0.a;
						var activateData = _n14.a;
						return _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
					} else {
						var _n15 = _n0.a;
						var activateData = _n15.a;
						var element = _n15.b.a.element;
						var viewport = _n15.b.a.viewport;
						var newAnimationCounter = model.animationCounter + 1;
						var _n16 = A4(aforemny$elm_mdc$Internal$Ripple$Implementation$animateActivation, activateData.isUnbounded, element, viewport, activateData.event);
						var translateStart = _n16.translateStart;
						var translateEnd = _n16.translateEnd;
						var _n17 = A2(aforemny$elm_mdc$Internal$Ripple$Implementation$layoutInternal, activateData.isUnbounded, element);
						var fgScale = _n17.fgScale;
						var initialSize = _n17.initialSize;
						var activatedData = {
							activationEvent: activateData.event,
							activationHasEnded: false,
							deactivated: false,
							fgScale: fgScale,
							frame: {height: element.height, left: element.x, top: element.y, width: element.width},
							initialSize: initialSize,
							translateEnd: translateEnd,
							translateStart: translateStart,
							wasElementMadeActive: activateData.wasElementMadeActive
						};
						return _Utils_Tuple2(
							_Utils_update(
								model,
								{
									animationCounter: newAnimationCounter,
									animationState: aforemny$elm_mdc$Internal$Ripple$Model$Activated(activatedData)
								}),
							A2(
								elm$core$Task$perform,
								function (_n18) {
									return aforemny$elm_mdc$Internal$Ripple$Model$ActivationEnded(newAnimationCounter);
								},
								elm$core$Process$sleep(aforemny$elm_mdc$Internal$Ripple$Model$numbers.deactivationTimeoutMs)));
					}
				case 'ActivationEnded':
					if (_n0.b.$ === 'Activated') {
						var animationCount = _n0.a.a;
						var activatedData = _n0.b.a;
						if (_Utils_eq(animationCount, model.animationCounter)) {
							if (activatedData.deactivated) {
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											animationState: aforemny$elm_mdc$Internal$Ripple$Model$Deactivated(activatedData)
										}),
									A2(
										elm$core$Task$perform,
										function (_n19) {
											return aforemny$elm_mdc$Internal$Ripple$Model$DeactivationEnded(model.animationCounter);
										},
										elm$core$Process$sleep(aforemny$elm_mdc$Internal$Ripple$Model$numbers.tapDelayMs)));
							} else {
								var newActivatedData = _Utils_update(
									activatedData,
									{activationHasEnded: true});
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											animationState: aforemny$elm_mdc$Internal$Ripple$Model$Activated(newActivatedData)
										}),
									elm$core$Platform$Cmd$none);
							}
						} else {
							return _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
						}
					} else {
						break _n0$13;
					}
				case 'Deactivate':
					if (_n0.b.$ === 'Activated') {
						var _n20 = _n0.a;
						var activatedData = _n0.b.a;
						if (activatedData.activationHasEnded) {
							return _Utils_Tuple2(
								_Utils_update(
									model,
									{
										animationState: aforemny$elm_mdc$Internal$Ripple$Model$Deactivated(activatedData)
									}),
								A2(
									elm$core$Task$perform,
									function (_n21) {
										return aforemny$elm_mdc$Internal$Ripple$Model$DeactivationEnded(model.animationCounter);
									},
									elm$core$Process$sleep(aforemny$elm_mdc$Internal$Ripple$Model$numbers.tapDelayMs)));
						} else {
							var newActivatedData = _Utils_update(
								activatedData,
								{deactivated: true});
							return _Utils_Tuple2(
								_Utils_update(
									model,
									{
										animationState: aforemny$elm_mdc$Internal$Ripple$Model$Activated(newActivatedData)
									}),
								elm$core$Platform$Cmd$none);
						}
					} else {
						break _n0$13;
					}
				default:
					if (_n0.b.$ === 'Deactivated') {
						var animationCount = _n0.a.a;
						return _Utils_eq(animationCount, model.animationCounter) ? _Utils_Tuple2(
							_Utils_update(
								model,
								{animationState: aforemny$elm_mdc$Internal$Ripple$Model$Idle}),
							elm$core$Platform$Cmd$none) : _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
					} else {
						break _n0$13;
					}
			}
		}
		return _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
	});
var elm$core$Platform$Cmd$map = _Platform_map;
var aforemny$elm_mdc$Internal$Button$Implementation$update = F3(
	function (lift, msg, model) {
		if (msg.$ === 'RippleMsg') {
			var msg_ = msg.a;
			var _n1 = A2(aforemny$elm_mdc$Internal$Ripple$Implementation$update, msg_, model.ripple);
			var rippleState = _n1.a;
			var rippleCmd = _n1.b;
			return _Utils_Tuple2(
				elm$core$Maybe$Just(
					_Utils_update(
						model,
						{ripple: rippleState})),
				A2(
					elm$core$Platform$Cmd$map,
					A2(elm$core$Basics$composeL, lift, aforemny$elm_mdc$Internal$Button$Model$RippleMsg),
					rippleCmd));
		} else {
			var doRipple = msg.a;
			var msg_ = msg.b;
			return _Utils_Tuple2(
				elm$core$Maybe$Nothing,
				A2(
					aforemny$elm_mdc$Internal$Helpers$delayedCmd,
					doRipple ? 150 : 0,
					msg_));
		}
	});
var elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return elm$core$Maybe$Just(
				f(value));
		} else {
			return elm$core$Maybe$Nothing;
		}
	});
var elm$core$Tuple$mapFirst = F2(
	function (func, _n0) {
		var x = _n0.a;
		var y = _n0.b;
		return _Utils_Tuple2(
			func(x),
			y);
	});
var aforemny$elm_mdc$Internal$Component$react = F8(
	function (get, set, ctor, update, lift, msg, idx, store) {
		return A2(
			elm$core$Tuple$mapFirst,
			elm$core$Maybe$map(
				A2(set, idx, store)),
			A3(
				update,
				A2(
					elm$core$Basics$composeL,
					lift,
					ctor(idx)),
				msg,
				A2(get, idx, store)));
	});
var aforemny$elm_mdc$Internal$Msg$ButtonMsg = F2(
	function (a, b) {
		return {$: 'ButtonMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Button$Implementation$react = A4(aforemny$elm_mdc$Internal$Component$react, aforemny$elm_mdc$Internal$Button$Implementation$getSet.get, aforemny$elm_mdc$Internal$Button$Implementation$getSet.set, aforemny$elm_mdc$Internal$Msg$ButtonMsg, aforemny$elm_mdc$Internal$Button$Implementation$update);
var aforemny$elm_mdc$Internal$Checkbox$Model$defaultModel = {animation: elm$core$Maybe$Nothing, isFocused: false, lastKnownState: elm$core$Maybe$Nothing};
var aforemny$elm_mdc$Internal$Checkbox$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.checkbox;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{checkbox: x});
		}),
	aforemny$elm_mdc$Internal$Checkbox$Model$defaultModel);
var aforemny$elm_mdc$Internal$Checkbox$Model$CheckedIndeterminate = {$: 'CheckedIndeterminate'};
var aforemny$elm_mdc$Internal$Checkbox$Model$CheckedUnchecked = {$: 'CheckedUnchecked'};
var aforemny$elm_mdc$Internal$Checkbox$Model$IndeterminateChecked = {$: 'IndeterminateChecked'};
var aforemny$elm_mdc$Internal$Checkbox$Model$IndeterminateUnchecked = {$: 'IndeterminateUnchecked'};
var aforemny$elm_mdc$Internal$Checkbox$Model$UncheckedChecked = {$: 'UncheckedChecked'};
var aforemny$elm_mdc$Internal$Checkbox$Model$UncheckedIndeterminate = {$: 'UncheckedIndeterminate'};
var aforemny$elm_mdc$Internal$Checkbox$Implementation$animationState = F2(
	function (oldState, state) {
		var _n0 = _Utils_Tuple2(oldState, state);
		_n0$6:
		while (true) {
			if (_n0.a.$ === 'Nothing') {
				if (_n0.b.$ === 'Just') {
					if (_n0.b.a.$ === 'Checked') {
						var _n5 = _n0.a;
						var _n6 = _n0.b.a;
						return elm$core$Maybe$Just(aforemny$elm_mdc$Internal$Checkbox$Model$IndeterminateChecked);
					} else {
						var _n7 = _n0.a;
						var _n8 = _n0.b.a;
						return elm$core$Maybe$Just(aforemny$elm_mdc$Internal$Checkbox$Model$IndeterminateUnchecked);
					}
				} else {
					break _n0$6;
				}
			} else {
				if (_n0.a.a.$ === 'Unchecked') {
					if (_n0.b.$ === 'Nothing') {
						var _n1 = _n0.a.a;
						var _n2 = _n0.b;
						return elm$core$Maybe$Just(aforemny$elm_mdc$Internal$Checkbox$Model$UncheckedIndeterminate);
					} else {
						if (_n0.b.a.$ === 'Checked') {
							var _n9 = _n0.a.a;
							var _n10 = _n0.b.a;
							return elm$core$Maybe$Just(aforemny$elm_mdc$Internal$Checkbox$Model$UncheckedChecked);
						} else {
							break _n0$6;
						}
					}
				} else {
					if (_n0.b.$ === 'Nothing') {
						var _n3 = _n0.a.a;
						var _n4 = _n0.b;
						return elm$core$Maybe$Just(aforemny$elm_mdc$Internal$Checkbox$Model$CheckedIndeterminate);
					} else {
						if (_n0.b.a.$ === 'Unchecked') {
							var _n11 = _n0.a.a;
							var _n12 = _n0.b.a;
							return elm$core$Maybe$Just(aforemny$elm_mdc$Internal$Checkbox$Model$CheckedUnchecked);
						} else {
							break _n0$6;
						}
					}
				}
			}
		}
		return elm$core$Maybe$Nothing;
	});
var elm$core$Maybe$andThen = F2(
	function (callback, maybeValue) {
		if (maybeValue.$ === 'Just') {
			var value = maybeValue.a;
			return callback(value);
		} else {
			return elm$core$Maybe$Nothing;
		}
	});
var aforemny$elm_mdc$Internal$Checkbox$Implementation$update = F3(
	function (_n0, msg, model) {
		switch (msg.$) {
			case 'NoOp':
				return _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
			case 'SetFocus':
				var focus = msg.a;
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{isFocused: focus})),
					elm$core$Platform$Cmd$none);
			case 'Init':
				var lastKnownState = msg.a;
				var state = msg.b;
				var animation = A2(
					elm$core$Maybe$andThen,
					function (lastKnownState_) {
						return A2(aforemny$elm_mdc$Internal$Checkbox$Implementation$animationState, lastKnownState_, state);
					},
					lastKnownState);
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{
								animation: animation,
								lastKnownState: elm$core$Maybe$Just(state)
							})),
					elm$core$Platform$Cmd$none);
			default:
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{animation: elm$core$Maybe$Nothing})),
					elm$core$Platform$Cmd$none);
		}
	});
var aforemny$elm_mdc$Internal$Msg$CheckboxMsg = F2(
	function (a, b) {
		return {$: 'CheckboxMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Checkbox$Implementation$react = A4(aforemny$elm_mdc$Internal$Component$react, aforemny$elm_mdc$Internal$Checkbox$Implementation$getSet.get, aforemny$elm_mdc$Internal$Checkbox$Implementation$getSet.set, aforemny$elm_mdc$Internal$Msg$CheckboxMsg, aforemny$elm_mdc$Internal$Checkbox$Implementation$update);
var aforemny$elm_mdc$Internal$Chip$Model$defaultModel = {ripple: aforemny$elm_mdc$Internal$Ripple$Model$defaultModel};
var aforemny$elm_mdc$Internal$Chip$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.chip;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{chip: x});
		}),
	aforemny$elm_mdc$Internal$Chip$Model$defaultModel);
var aforemny$elm_mdc$Internal$Chip$Model$RippleMsg = function (a) {
	return {$: 'RippleMsg', a: a};
};
var aforemny$elm_mdc$Internal$Chip$Implementation$update = F3(
	function (lift, msg, model) {
		if (msg.$ === 'RippleMsg') {
			var msg_ = msg.a;
			var _n1 = A2(aforemny$elm_mdc$Internal$Ripple$Implementation$update, msg_, model.ripple);
			var ripple = _n1.a;
			var cmd = _n1.b;
			return _Utils_Tuple2(
				elm$core$Maybe$Just(
					_Utils_update(
						model,
						{ripple: ripple})),
				A2(
					elm$core$Platform$Cmd$map,
					A2(elm$core$Basics$composeL, lift, aforemny$elm_mdc$Internal$Chip$Model$RippleMsg),
					cmd));
		} else {
			var msg_ = msg.a;
			return _Utils_Tuple2(
				elm$core$Maybe$Nothing,
				A2(aforemny$elm_mdc$Internal$Helpers$delayedCmd, 150, msg_));
		}
	});
var aforemny$elm_mdc$Internal$Msg$ChipMsg = F2(
	function (a, b) {
		return {$: 'ChipMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Chip$Implementation$react = A4(aforemny$elm_mdc$Internal$Component$react, aforemny$elm_mdc$Internal$Chip$Implementation$getSet.get, aforemny$elm_mdc$Internal$Chip$Implementation$getSet.set, aforemny$elm_mdc$Internal$Msg$ChipMsg, aforemny$elm_mdc$Internal$Chip$Implementation$update);
var aforemny$elm_mdc$Internal$Dialog$Model$defaultModel = {animating: false, open: false};
var aforemny$elm_mdc$Internal$Dialog$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.dialog;
	},
	F2(
		function (x, c) {
			return _Utils_update(
				c,
				{dialog: x});
		}),
	aforemny$elm_mdc$Internal$Dialog$Model$defaultModel);
var elm$core$Basics$neq = _Utils_notEqual;
var aforemny$elm_mdc$Internal$Dialog$Implementation$update = F3(
	function (_n0, msg, model) {
		switch (msg.$) {
			case 'NoOp':
				return _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
			case 'StartAnimation':
				var isOpen = msg.a;
				return (!_Utils_eq(isOpen, model.open)) ? _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{animating: true, open: isOpen})),
					elm$core$Platform$Cmd$none) : _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
			default:
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{animating: false})),
					elm$core$Platform$Cmd$none);
		}
	});
var aforemny$elm_mdc$Internal$Msg$DialogMsg = F2(
	function (a, b) {
		return {$: 'DialogMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Dialog$Implementation$react = A4(aforemny$elm_mdc$Internal$Component$react, aforemny$elm_mdc$Internal$Dialog$Implementation$getSet.get, aforemny$elm_mdc$Internal$Dialog$Implementation$getSet.set, aforemny$elm_mdc$Internal$Msg$DialogMsg, aforemny$elm_mdc$Internal$Dialog$Implementation$update);
var aforemny$elm_mdc$Internal$Dispatch$forward = function (msgs) {
	return elm$core$Platform$Cmd$batch(
		A2(
			elm$core$List$map,
			A2(
				elm$core$Basics$composeL,
				elm$core$Task$perform(elm$core$Basics$identity),
				elm$core$Task$succeed),
			msgs));
};
var aforemny$elm_mdc$Internal$Drawer$Model$defaultModel = {animating: false, closeOnAnimationEnd: false, open: false};
var aforemny$elm_mdc$Internal$Drawer$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.drawer;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{drawer: x});
		}),
	aforemny$elm_mdc$Internal$Drawer$Model$defaultModel);
var elm$core$Basics$not = _Basics_not;
var aforemny$elm_mdc$Internal$Drawer$Implementation$update = F3(
	function (lift, msg, model) {
		switch (msg.$) {
			case 'NoOp':
				return _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
			case 'StartAnimation':
				var isOpen = msg.a;
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{animating: true, closeOnAnimationEnd: !isOpen, open: true})),
					elm$core$Platform$Cmd$none);
			default:
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{
								animating: false,
								closeOnAnimationEnd: false,
								open: model.closeOnAnimationEnd ? false : model.open
							})),
					elm$core$Platform$Cmd$none);
		}
	});
var aforemny$elm_mdc$Internal$Msg$DrawerMsg = F2(
	function (a, b) {
		return {$: 'DrawerMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Drawer$Implementation$react = A4(aforemny$elm_mdc$Internal$Component$react, aforemny$elm_mdc$Internal$Drawer$Implementation$getSet.get, aforemny$elm_mdc$Internal$Drawer$Implementation$getSet.set, aforemny$elm_mdc$Internal$Msg$DrawerMsg, aforemny$elm_mdc$Internal$Drawer$Implementation$update);
var elm$core$Tuple$mapSecond = F2(
	function (func, _n0) {
		var x = _n0.a;
		var y = _n0.b;
		return _Utils_Tuple2(
			x,
			func(y));
	});
var aforemny$elm_mdc$Internal$Component$generalise = F4(
	function (update, lift, msg, model) {
		return A2(
			elm$core$Tuple$mapSecond,
			elm$core$Platform$Cmd$map(lift),
			A2(
				elm$core$Tuple$mapFirst,
				elm$core$Maybe$Just,
				A2(update, msg, model)));
	});
var aforemny$elm_mdc$Internal$Fab$Model$defaultModel = {ripple: aforemny$elm_mdc$Internal$Ripple$Model$defaultModel};
var aforemny$elm_mdc$Internal$Fab$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.fab;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{fab: x});
		}),
	aforemny$elm_mdc$Internal$Fab$Model$defaultModel);
var aforemny$elm_mdc$Internal$Fab$Model$RippleMsg = function (a) {
	return {$: 'RippleMsg', a: a};
};
var aforemny$elm_mdc$Internal$Fab$Implementation$update = F2(
	function (msg, model) {
		if (msg.$ === 'RippleMsg') {
			var msg_ = msg.a;
			var _n1 = A2(aforemny$elm_mdc$Internal$Ripple$Implementation$update, msg_, model.ripple);
			var rippleState = _n1.a;
			var rippleCmd = _n1.b;
			return _Utils_Tuple2(
				_Utils_update(
					model,
					{ripple: rippleState}),
				A2(elm$core$Platform$Cmd$map, aforemny$elm_mdc$Internal$Fab$Model$RippleMsg, rippleCmd));
		} else {
			return _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
		}
	});
var aforemny$elm_mdc$Internal$Msg$FabMsg = F2(
	function (a, b) {
		return {$: 'FabMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Fab$Implementation$react = A4(
	aforemny$elm_mdc$Internal$Component$react,
	aforemny$elm_mdc$Internal$Fab$Implementation$getSet.get,
	aforemny$elm_mdc$Internal$Fab$Implementation$getSet.set,
	aforemny$elm_mdc$Internal$Msg$FabMsg,
	aforemny$elm_mdc$Internal$Component$generalise(aforemny$elm_mdc$Internal$Fab$Implementation$update));
var aforemny$elm_mdc$Internal$IconButton$Model$defaultModel = {on: false, ripple: aforemny$elm_mdc$Internal$Ripple$Model$defaultModel};
var aforemny$elm_mdc$Internal$IconButton$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.iconButton;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{iconButton: x});
		}),
	aforemny$elm_mdc$Internal$IconButton$Model$defaultModel);
var aforemny$elm_mdc$Internal$IconButton$Model$RippleMsg = function (a) {
	return {$: 'RippleMsg', a: a};
};
var aforemny$elm_mdc$Internal$IconButton$Implementation$update = F2(
	function (msg, model) {
		var msg_ = msg.a;
		var _n1 = A2(aforemny$elm_mdc$Internal$Ripple$Implementation$update, msg_, model.ripple);
		var ripple = _n1.a;
		var effects = _n1.b;
		return _Utils_Tuple2(
			_Utils_update(
				model,
				{ripple: ripple}),
			A2(elm$core$Platform$Cmd$map, aforemny$elm_mdc$Internal$IconButton$Model$RippleMsg, effects));
	});
var aforemny$elm_mdc$Internal$Msg$IconButtonMsg = F2(
	function (a, b) {
		return {$: 'IconButtonMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$IconButton$Implementation$react = A4(
	aforemny$elm_mdc$Internal$Component$react,
	aforemny$elm_mdc$Internal$IconButton$Implementation$getSet.get,
	aforemny$elm_mdc$Internal$IconButton$Implementation$getSet.set,
	aforemny$elm_mdc$Internal$Msg$IconButtonMsg,
	aforemny$elm_mdc$Internal$Component$generalise(aforemny$elm_mdc$Internal$IconButton$Implementation$update));
var aforemny$elm_mdc$Internal$List$Model$defaultModel = {focused: elm$core$Maybe$Nothing, ripples: elm$core$Dict$empty};
var aforemny$elm_mdc$Internal$List$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.list;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{list: x});
		}),
	aforemny$elm_mdc$Internal$List$Model$defaultModel);
var aforemny$elm_mdc$Internal$List$Implementation$send = function (msg) {
	return A2(
		elm$core$Task$perform,
		elm$core$Basics$identity,
		elm$core$Task$succeed(msg));
};
var aforemny$elm_mdc$Internal$List$Model$NoOp = {$: 'NoOp'};
var aforemny$elm_mdc$Internal$List$Model$RippleMsg = F2(
	function (a, b) {
		return {$: 'RippleMsg', a: a, b: b};
	});
var elm$browser$Browser$Dom$focus = _Browser_call('focus');
var aforemny$elm_mdc$Internal$List$Implementation$update = F3(
	function (lift, msg, model) {
		switch (msg.$) {
			case 'RippleMsg':
				var index = msg.a;
				var msg_ = msg.b;
				var _n1 = A2(
					aforemny$elm_mdc$Internal$Ripple$Implementation$update,
					msg_,
					A2(
						elm$core$Maybe$withDefault,
						aforemny$elm_mdc$Internal$Ripple$Model$defaultModel,
						A2(elm$core$Dict$get, index, model.ripples)));
				var ripple = _n1.a;
				var effects = _n1.b;
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{
								ripples: A3(elm$core$Dict$insert, index, ripple, model.ripples)
							})),
					A2(
						elm$core$Platform$Cmd$map,
						A2(
							elm$core$Basics$composeL,
							lift,
							aforemny$elm_mdc$Internal$List$Model$RippleMsg(index)),
						effects));
			case 'ResetFocusedItem':
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{focused: elm$core$Maybe$Nothing})),
					elm$core$Platform$Cmd$none);
			case 'FocusItem':
				var id = msg.b;
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{focused: elm$core$Maybe$Nothing})),
					A2(
						elm$core$Task$attempt,
						function (_n2) {
							return lift(aforemny$elm_mdc$Internal$List$Model$NoOp);
						},
						elm$browser$Browser$Dom$focus(id)));
			case 'SelectItem':
				var index = msg.a;
				var m = msg.b;
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{focused: elm$core$Maybe$Nothing})),
					aforemny$elm_mdc$Internal$List$Implementation$send(
						m(index)));
			default:
				return _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
		}
	});
var aforemny$elm_mdc$Internal$Msg$ListMsg = F2(
	function (a, b) {
		return {$: 'ListMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$List$Implementation$react = A4(aforemny$elm_mdc$Internal$Component$react, aforemny$elm_mdc$Internal$List$Implementation$getSet.get, aforemny$elm_mdc$Internal$List$Implementation$getSet.set, aforemny$elm_mdc$Internal$Msg$ListMsg, aforemny$elm_mdc$Internal$List$Implementation$update);
var aforemny$elm_mdc$Internal$Menu$Model$defaultModel = {animating: false, geometry: elm$core$Maybe$Nothing, index: elm$core$Maybe$Nothing, keyDownWithinMenu: false, list: aforemny$elm_mdc$Internal$List$Model$defaultModel, open: false, quickOpen: elm$core$Maybe$Nothing};
var aforemny$elm_mdc$Internal$Menu$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.menu;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{menu: x});
		}),
	aforemny$elm_mdc$Internal$Menu$Model$defaultModel);
var aforemny$elm_mdc$Internal$Menu$Model$AnimationEnd = {$: 'AnimationEnd'};
var aforemny$elm_mdc$Internal$Menu$Model$Close = {$: 'Close'};
var aforemny$elm_mdc$Internal$Menu$Model$ListMsg = function (a) {
	return {$: 'ListMsg', a: a};
};
var aforemny$elm_mdc$Internal$Menu$Model$NoOp = {$: 'NoOp'};
var aforemny$elm_mdc$Internal$Menu$Model$Open = {$: 'Open'};
var aforemny$elm_mdc$Internal$Menu$Implementation$update = F3(
	function (lift, msg, model) {
		update:
		while (true) {
			switch (msg.$) {
				case 'NoOp':
					return _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
				case 'Toggle':
					var $temp$lift = lift,
						$temp$msg = model.open ? aforemny$elm_mdc$Internal$Menu$Model$Close : aforemny$elm_mdc$Internal$Menu$Model$Open,
						$temp$model = model;
					lift = $temp$lift;
					msg = $temp$msg;
					model = $temp$model;
					continue update;
				case 'Open':
					return (!model.open) ? _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{animating: true, geometry: elm$core$Maybe$Nothing, open: true})),
						elm$core$Platform$Cmd$none) : _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
				case 'Close':
					return model.open ? _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{animating: true, open: false})),
						A2(elm$core$Maybe$withDefault, false, model.quickOpen) ? A2(
							aforemny$elm_mdc$Internal$Helpers$delayedCmd,
							70,
							lift(aforemny$elm_mdc$Internal$Menu$Model$AnimationEnd)) : A2(
							aforemny$elm_mdc$Internal$Helpers$delayedCmd,
							0,
							lift(aforemny$elm_mdc$Internal$Menu$Model$AnimationEnd))) : _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
				case 'CloseDelayed':
					return _Utils_Tuple2(
						elm$core$Maybe$Nothing,
						A2(
							aforemny$elm_mdc$Internal$Helpers$delayedCmd,
							50,
							lift(aforemny$elm_mdc$Internal$Menu$Model$Close)));
				case 'Init':
					var config = msg.a;
					var geometry = msg.b;
					return _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{
									geometry: elm$core$Maybe$Just(geometry),
									quickOpen: elm$core$Maybe$Just(config.quickOpen)
								})),
						elm$core$Platform$Cmd$batch(
							_List_fromArray(
								[
									A2(
									elm$core$Task$attempt,
									function (_n1) {
										return lift(aforemny$elm_mdc$Internal$Menu$Model$NoOp);
									},
									elm$browser$Browser$Dom$focus(config.focusedItemId)),
									config.quickOpen ? A2(
									aforemny$elm_mdc$Internal$Helpers$delayedCmd,
									120,
									lift(aforemny$elm_mdc$Internal$Menu$Model$AnimationEnd)) : A2(
									aforemny$elm_mdc$Internal$Helpers$delayedCmd,
									0,
									lift(aforemny$elm_mdc$Internal$Menu$Model$AnimationEnd))
								])));
				case 'AnimationEnd':
					return _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{animating: false})),
						elm$core$Platform$Cmd$none);
				case 'DocumentClick':
					if (model.open && (!_Utils_eq(model.geometry, elm$core$Maybe$Nothing))) {
						var $temp$lift = lift,
							$temp$msg = aforemny$elm_mdc$Internal$Menu$Model$Close,
							$temp$model = model;
						lift = $temp$lift;
						msg = $temp$msg;
						model = $temp$model;
						continue update;
					} else {
						return _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
					}
				case 'KeyDown':
					var shiftKey = msg.a.shiftKey;
					var altKey = msg.a.altKey;
					var ctrlKey = msg.a.ctrlKey;
					var metaKey = msg.a.metaKey;
					var key = msg.b;
					var keyCode = msg.c;
					var isSpace = (key === 'Space') || (keyCode === 32);
					var isEscape = (key === 'Escape') || (keyCode === 27);
					var isEnter = (key === 'Enter') || (keyCode === 13);
					return (isEscape || (isSpace || isEnter)) ? _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{keyDownWithinMenu: true})),
						elm$core$Platform$Cmd$none) : _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
				case 'KeyUp':
					var shiftKey = msg.a.shiftKey;
					var altKey = msg.a.altKey;
					var ctrlKey = msg.a.ctrlKey;
					var metaKey = msg.a.metaKey;
					var key = msg.b;
					var keyCode = msg.c;
					var isSpace = (key === 'Space') || (keyCode === 32);
					var isEscape = (key === 'Escape') || (keyCode === 27);
					var isEnter = (key === 'Enter') || (keyCode === 13);
					return A2(
						elm$core$Tuple$mapFirst,
						elm$core$Maybe$map(
							function (newModel) {
								return _Utils_update(
									newModel,
									{keyDownWithinMenu: false});
							}),
						((isEscape || (isSpace || isEnter)) && ((!(altKey || (ctrlKey || metaKey))) && model.keyDownWithinMenu)) ? A3(aforemny$elm_mdc$Internal$Menu$Implementation$update, lift, aforemny$elm_mdc$Internal$Menu$Model$Close, model) : _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none));
				default:
					var msg_ = msg.a;
					return A2(
						elm$core$Tuple$mapFirst,
						function (maybeNewList) {
							if (maybeNewList.$ === 'Just') {
								var newList = maybeNewList.a;
								return elm$core$Maybe$Just(
									_Utils_update(
										model,
										{list: newList}));
							} else {
								return elm$core$Maybe$Nothing;
							}
						},
						A3(
							aforemny$elm_mdc$Internal$List$Implementation$update,
							A2(elm$core$Basics$composeL, lift, aforemny$elm_mdc$Internal$Menu$Model$ListMsg),
							msg_,
							model.list));
			}
		}
	});
var aforemny$elm_mdc$Internal$Msg$MenuMsg = F2(
	function (a, b) {
		return {$: 'MenuMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Menu$Implementation$react = A4(aforemny$elm_mdc$Internal$Component$react, aforemny$elm_mdc$Internal$Menu$Implementation$getSet.get, aforemny$elm_mdc$Internal$Menu$Implementation$getSet.set, aforemny$elm_mdc$Internal$Msg$MenuMsg, aforemny$elm_mdc$Internal$Menu$Implementation$update);
var aforemny$elm_mdc$Internal$Msg$RadioButtonMsg = F2(
	function (a, b) {
		return {$: 'RadioButtonMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$RadioButton$Model$defaultModel = {isFocused: false, ripple: aforemny$elm_mdc$Internal$Ripple$Model$defaultModel};
var aforemny$elm_mdc$Internal$RadioButton$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.radio;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{radio: x});
		}),
	aforemny$elm_mdc$Internal$RadioButton$Model$defaultModel);
var aforemny$elm_mdc$Internal$RadioButton$Model$RippleMsg = function (a) {
	return {$: 'RippleMsg', a: a};
};
var aforemny$elm_mdc$Internal$RadioButton$Implementation$update = F3(
	function (lift, msg, model) {
		switch (msg.$) {
			case 'RippleMsg':
				var msg_ = msg.a;
				var _n1 = A2(aforemny$elm_mdc$Internal$Ripple$Implementation$update, msg_, model.ripple);
				var ripple = _n1.a;
				var effects = _n1.b;
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{ripple: ripple})),
					A2(
						elm$core$Platform$Cmd$map,
						A2(elm$core$Basics$composeL, lift, aforemny$elm_mdc$Internal$RadioButton$Model$RippleMsg),
						effects));
			case 'NoOp':
				return _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
			default:
				var focus = msg.a;
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{isFocused: focus})),
					elm$core$Platform$Cmd$none);
		}
	});
var aforemny$elm_mdc$Internal$RadioButton$Implementation$react = A4(aforemny$elm_mdc$Internal$Component$react, aforemny$elm_mdc$Internal$RadioButton$Implementation$getSet.get, aforemny$elm_mdc$Internal$RadioButton$Implementation$getSet.set, aforemny$elm_mdc$Internal$Msg$RadioButtonMsg, aforemny$elm_mdc$Internal$RadioButton$Implementation$update);
var aforemny$elm_mdc$Internal$Msg$RippleMsg = F2(
	function (a, b) {
		return {$: 'RippleMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Ripple$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.ripple;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{ripple: x});
		}),
	aforemny$elm_mdc$Internal$Ripple$Model$defaultModel);
var aforemny$elm_mdc$Internal$Ripple$Implementation$react = A4(
	aforemny$elm_mdc$Internal$Component$react,
	aforemny$elm_mdc$Internal$Ripple$Implementation$getSet.get,
	aforemny$elm_mdc$Internal$Ripple$Implementation$getSet.set,
	aforemny$elm_mdc$Internal$Msg$RippleMsg,
	aforemny$elm_mdc$Internal$Component$generalise(aforemny$elm_mdc$Internal$Ripple$Implementation$update));
var aforemny$elm_mdc$Internal$Msg$SelectMsg = F2(
	function (a, b) {
		return {$: 'SelectMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Select$Model$defaultModel = {focused: false, isDirty: false, ripple: aforemny$elm_mdc$Internal$Ripple$Model$defaultModel};
var aforemny$elm_mdc$Internal$Select$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.select;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{select: x});
		}),
	aforemny$elm_mdc$Internal$Select$Model$defaultModel);
var aforemny$elm_mdc$Internal$Select$Model$RippleMsg = function (a) {
	return {$: 'RippleMsg', a: a};
};
var aforemny$elm_mdc$Internal$Select$Implementation$update = F3(
	function (lift, msg, model) {
		switch (msg.$) {
			case 'Change':
				var changedValue = msg.a;
				var dirty = changedValue !== '';
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{isDirty: dirty})),
					elm$core$Platform$Cmd$none);
			case 'Blur':
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{focused: false})),
					elm$core$Platform$Cmd$none);
			case 'Focus':
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{focused: true})),
					elm$core$Platform$Cmd$none);
			default:
				var msg_ = msg.a;
				var _n1 = A2(aforemny$elm_mdc$Internal$Ripple$Implementation$update, msg_, model.ripple);
				var ripple = _n1.a;
				var effects = _n1.b;
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{ripple: ripple})),
					A2(
						elm$core$Platform$Cmd$map,
						A2(elm$core$Basics$composeL, lift, aforemny$elm_mdc$Internal$Select$Model$RippleMsg),
						effects));
		}
	});
var aforemny$elm_mdc$Internal$Select$Implementation$react = A4(aforemny$elm_mdc$Internal$Component$react, aforemny$elm_mdc$Internal$Select$Implementation$getSet.get, aforemny$elm_mdc$Internal$Select$Implementation$getSet.set, aforemny$elm_mdc$Internal$Msg$SelectMsg, aforemny$elm_mdc$Internal$Select$Implementation$update);
var aforemny$elm_mdc$Internal$Msg$SliderMsg = F2(
	function (a, b) {
		return {$: 'SliderMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Slider$Model$defaultModel = {active: false, activeValue: elm$core$Maybe$Nothing, focus: false, geometry: elm$core$Maybe$Nothing, inTransit: false, preventFocus: false};
var aforemny$elm_mdc$Internal$Slider$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.slider;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{slider: x});
		}),
	aforemny$elm_mdc$Internal$Slider$Model$defaultModel);
var aforemny$elm_mdc$Internal$Slider$Implementation$valueFromPageX = F2(
	function (geometry, pageX) {
		var xPos = pageX - geometry.rect.left;
		var isRtl = false;
		var pctComplete = isRtl ? (1 - (xPos / geometry.rect.width)) : (xPos / geometry.rect.width);
		return geometry.min + (pctComplete * (geometry.max - geometry.min));
	});
var aforemny$elm_mdc$Internal$Slider$Model$ActualUp = {$: 'ActualUp'};
var aforemny$elm_mdc$Internal$Slider$Model$Init = function (a) {
	return {$: 'Init', a: a};
};
var aforemny$elm_mdc$Internal$Slider$Model$defaultGeometry = {
	discrete: false,
	max: 100,
	min: 0,
	rect: {left: 0, width: 0},
	step: elm$core$Maybe$Nothing
};
var aforemny$elm_mdc$Internal$Slider$Implementation$update = F3(
	function (lift, msg, model) {
		update:
		while (true) {
			switch (msg.$) {
				case 'NoOp':
					return _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
				case 'Focus':
					return (!model.preventFocus) ? _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{focus: true})),
						elm$core$Platform$Cmd$none) : _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
				case 'Blur':
					return _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{focus: false, preventFocus: false})),
						elm$core$Platform$Cmd$none);
				case 'TransitionEnd':
					return _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{inTransit: false})),
						elm$core$Platform$Cmd$none);
				case 'InteractionStart':
					var pageX = msg.b.pageX;
					var geometry = A2(elm$core$Maybe$withDefault, aforemny$elm_mdc$Internal$Slider$Model$defaultGeometry, model.geometry);
					var activeValue = A2(aforemny$elm_mdc$Internal$Slider$Implementation$valueFromPageX, geometry, pageX);
					return _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{
									active: true,
									activeValue: elm$core$Maybe$Just(activeValue),
									inTransit: true,
									preventFocus: true
								})),
						elm$core$Platform$Cmd$none);
				case 'ThumbContainerPointer':
					var pageX = msg.b.pageX;
					var geometry = A2(elm$core$Maybe$withDefault, aforemny$elm_mdc$Internal$Slider$Model$defaultGeometry, model.geometry);
					var activeValue = A2(aforemny$elm_mdc$Internal$Slider$Implementation$valueFromPageX, geometry, pageX);
					return _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{
									active: true,
									activeValue: elm$core$Maybe$Just(activeValue),
									inTransit: false,
									preventFocus: true
								})),
						elm$core$Platform$Cmd$none);
				case 'Drag':
					var pageX = msg.a.pageX;
					if (model.active) {
						var geometry = A2(elm$core$Maybe$withDefault, aforemny$elm_mdc$Internal$Slider$Model$defaultGeometry, model.geometry);
						var activeValue = A2(aforemny$elm_mdc$Internal$Slider$Implementation$valueFromPageX, geometry, pageX);
						return _Utils_Tuple2(
							elm$core$Maybe$Just(
								_Utils_update(
									model,
									{
										activeValue: elm$core$Maybe$Just(activeValue),
										inTransit: false
									})),
							elm$core$Platform$Cmd$none);
					} else {
						return _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
					}
				case 'Init':
					var geometry = msg.a;
					return _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{
									geometry: elm$core$Maybe$Just(geometry)
								})),
						elm$core$Platform$Cmd$none);
				case 'Resize':
					var geometry = msg.a;
					var $temp$lift = lift,
						$temp$msg = aforemny$elm_mdc$Internal$Slider$Model$Init(geometry),
						$temp$model = model;
					lift = $temp$lift;
					msg = $temp$msg;
					model = $temp$model;
					continue update;
				case 'KeyDown':
					return _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{focus: true})),
						elm$core$Platform$Cmd$none);
				case 'Up':
					return _Utils_Tuple2(
						elm$core$Maybe$Just(model),
						A2(
							elm$core$Task$perform,
							lift,
							elm$core$Task$succeed(aforemny$elm_mdc$Internal$Slider$Model$ActualUp)));
				default:
					return _Utils_Tuple2(
						elm$core$Maybe$Just(
							_Utils_update(
								model,
								{active: false, activeValue: elm$core$Maybe$Nothing})),
						elm$core$Platform$Cmd$none);
			}
		}
	});
var aforemny$elm_mdc$Internal$Slider$Implementation$react = A4(aforemny$elm_mdc$Internal$Component$react, aforemny$elm_mdc$Internal$Slider$Implementation$getSet.get, aforemny$elm_mdc$Internal$Slider$Implementation$getSet.set, aforemny$elm_mdc$Internal$Msg$SliderMsg, aforemny$elm_mdc$Internal$Slider$Implementation$update);
var aforemny$elm_mdc$Internal$Msg$SnackbarMsg = F2(
	function (a, b) {
		return {$: 'SnackbarMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Snackbar$Model$Inert = {$: 'Inert'};
var elm$core$Basics$negate = function (n) {
	return -n;
};
var aforemny$elm_mdc$Internal$Snackbar$Model$defaultModel = {open: false, queue: _List_Nil, seq: -1, state: aforemny$elm_mdc$Internal$Snackbar$Model$Inert};
var aforemny$elm_mdc$Internal$Snackbar$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.snackbar;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{snackbar: x});
		}),
	aforemny$elm_mdc$Internal$Snackbar$Model$defaultModel);
var aforemny$elm_mdc$Internal$Helpers$cmd = function (msg) {
	return A2(
		elm$core$Task$perform,
		elm$core$Basics$identity,
		elm$core$Task$succeed(msg));
};
var aforemny$elm_mdc$Internal$Snackbar$Model$Move = F2(
	function (a, b) {
		return {$: 'Move', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Snackbar$Implementation$next = function (model) {
	return elm$core$Platform$Cmd$map(
		aforemny$elm_mdc$Internal$Snackbar$Model$Move(model.seq));
};
var aforemny$elm_mdc$Internal$Snackbar$Model$Active = function (a) {
	return {$: 'Active', a: a};
};
var aforemny$elm_mdc$Internal$Snackbar$Model$Timeout = {$: 'Timeout'};
var aforemny$elm_mdc$Internal$Snackbar$Implementation$tryDequeue = function (model) {
	var _n0 = _Utils_Tuple2(model.state, model.queue);
	if ((_n0.a.$ === 'Inert') && _n0.b.b) {
		var _n1 = _n0.a;
		var _n2 = _n0.b;
		var c = _n2.a;
		var cs = _n2.b;
		return _Utils_Tuple2(
			_Utils_update(
				model,
				{
					open: false,
					queue: cs,
					seq: model.seq + 1,
					state: aforemny$elm_mdc$Internal$Snackbar$Model$Active(c)
				}),
			A2(
				elm$core$Platform$Cmd$map,
				aforemny$elm_mdc$Internal$Snackbar$Model$Move(model.seq + 1),
				A2(aforemny$elm_mdc$Internal$Helpers$delayedCmd, c.timeout, aforemny$elm_mdc$Internal$Snackbar$Model$Timeout)));
	} else {
		return _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
	}
};
var aforemny$elm_mdc$Internal$Snackbar$Model$Fading = function (a) {
	return {$: 'Fading', a: a};
};
var aforemny$elm_mdc$Internal$Snackbar$Implementation$move = F2(
	function (transition, model) {
		var _n0 = _Utils_Tuple2(model.state, transition);
		if (_n0.b.$ === 'Clicked') {
			if (_n0.a.$ === 'Active') {
				var contents = _n0.a.a;
				var _n3 = _n0.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							state: aforemny$elm_mdc$Internal$Snackbar$Model$Fading(contents)
						}),
					A2(
						aforemny$elm_mdc$Internal$Snackbar$Implementation$next,
						model,
						A2(aforemny$elm_mdc$Internal$Helpers$delayedCmd, contents.fade, aforemny$elm_mdc$Internal$Snackbar$Model$Timeout)));
			} else {
				return _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
			}
		} else {
			switch (_n0.a.$) {
				case 'Inert':
					var _n1 = _n0.a;
					var _n2 = _n0.b;
					return aforemny$elm_mdc$Internal$Snackbar$Implementation$tryDequeue(model);
				case 'Active':
					var contents = _n0.a.a;
					var _n4 = _n0.b;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								state: aforemny$elm_mdc$Internal$Snackbar$Model$Fading(contents)
							}),
						A2(
							aforemny$elm_mdc$Internal$Snackbar$Implementation$next,
							model,
							A2(aforemny$elm_mdc$Internal$Helpers$delayedCmd, contents.fade, aforemny$elm_mdc$Internal$Snackbar$Model$Timeout)));
				default:
					var contents = _n0.a.a;
					var _n5 = _n0.b;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{state: aforemny$elm_mdc$Internal$Snackbar$Model$Inert}),
						A2(
							aforemny$elm_mdc$Internal$Snackbar$Implementation$next,
							model,
							aforemny$elm_mdc$Internal$Helpers$cmd(aforemny$elm_mdc$Internal$Snackbar$Model$Timeout)));
			}
		}
	});
var aforemny$elm_mdc$Internal$Snackbar$Model$Clicked = {$: 'Clicked'};
var aforemny$elm_mdc$Internal$Snackbar$Implementation$update = F3(
	function (fwd, msg, model) {
		switch (msg.$) {
			case 'Move':
				var seq = msg.a;
				var transition = msg.b;
				return _Utils_eq(seq, model.seq) ? A2(
					elm$core$Tuple$mapSecond,
					elm$core$Platform$Cmd$map(fwd),
					A2(aforemny$elm_mdc$Internal$Snackbar$Implementation$move, transition, model)) : _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
			case 'Dismiss':
				var dismissOnAction = msg.a;
				var actionOnDismiss = msg.b;
				var fwdEffect = function () {
					if (actionOnDismiss.$ === 'Just') {
						var msg_ = actionOnDismiss.a;
						return aforemny$elm_mdc$Internal$Helpers$cmd(msg_);
					} else {
						return elm$core$Platform$Cmd$none;
					}
				}();
				return A2(
					elm$core$Tuple$mapSecond,
					function (cmd) {
						return elm$core$Platform$Cmd$batch(
							_List_fromArray(
								[cmd, fwdEffect]));
					},
					dismissOnAction ? A3(
						aforemny$elm_mdc$Internal$Snackbar$Implementation$update,
						fwd,
						A2(aforemny$elm_mdc$Internal$Snackbar$Model$Move, model.seq, aforemny$elm_mdc$Internal$Snackbar$Model$Clicked),
						model) : _Utils_Tuple2(model, elm$core$Platform$Cmd$none));
			default:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{open: true}),
					elm$core$Platform$Cmd$none);
		}
	});
var aforemny$elm_mdc$Internal$Snackbar$Implementation$react = A4(
	aforemny$elm_mdc$Internal$Component$react,
	aforemny$elm_mdc$Internal$Snackbar$Implementation$getSet.get,
	aforemny$elm_mdc$Internal$Snackbar$Implementation$getSet.set,
	aforemny$elm_mdc$Internal$Msg$SnackbarMsg,
	F3(
		function (fwd, msg, model) {
			return A2(
				elm$core$Tuple$mapFirst,
				elm$core$Maybe$Just,
				A3(aforemny$elm_mdc$Internal$Snackbar$Implementation$update, fwd, msg, model));
		}));
var aforemny$elm_mdc$Internal$Msg$SwitchMsg = F2(
	function (a, b) {
		return {$: 'SwitchMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Switch$Model$defaultModel = {isFocused: false, ripple: aforemny$elm_mdc$Internal$Ripple$Model$defaultModel};
var aforemny$elm_mdc$Internal$Switch$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $._switch;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{_switch: x});
		}),
	aforemny$elm_mdc$Internal$Switch$Model$defaultModel);
var aforemny$elm_mdc$Internal$Switch$Model$RippleMsg = function (a) {
	return {$: 'RippleMsg', a: a};
};
var aforemny$elm_mdc$Internal$Switch$Implementation$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'RippleMsg':
				var msg_ = msg.a;
				var _n1 = A2(aforemny$elm_mdc$Internal$Ripple$Implementation$update, msg_, model.ripple);
				var rippleState = _n1.a;
				var rippleCmd = _n1.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{ripple: rippleState}),
					A2(elm$core$Platform$Cmd$map, aforemny$elm_mdc$Internal$Switch$Model$RippleMsg, rippleCmd));
			case 'SetFocus':
				var focus = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{isFocused: focus}),
					elm$core$Platform$Cmd$none);
			default:
				return _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
		}
	});
var aforemny$elm_mdc$Internal$Switch$Implementation$react = A4(
	aforemny$elm_mdc$Internal$Component$react,
	aforemny$elm_mdc$Internal$Switch$Implementation$getSet.get,
	aforemny$elm_mdc$Internal$Switch$Implementation$getSet.set,
	aforemny$elm_mdc$Internal$Msg$SwitchMsg,
	aforemny$elm_mdc$Internal$Component$generalise(aforemny$elm_mdc$Internal$Switch$Implementation$update));
var aforemny$elm_mdc$Internal$Msg$TabBarMsg = F2(
	function (a, b) {
		return {$: 'TabBarMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$TabBar$Model$defaultModel = {activeTab: 0, geometry: elm$core$Maybe$Nothing, ripples: elm$core$Dict$empty, translateOffset: 0};
var aforemny$elm_mdc$Internal$TabBar$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.tabbar;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{tabbar: x});
		}),
	aforemny$elm_mdc$Internal$TabBar$Model$defaultModel);
var elm$core$Basics$min = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) < 0) ? x : y;
	});
var elm$core$List$drop = F2(
	function (n, list) {
		drop:
		while (true) {
			if (n <= 0) {
				return list;
			} else {
				if (!list.b) {
					return list;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs;
					n = $temp$n;
					list = $temp$list;
					continue drop;
				}
			}
		}
	});
var elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return elm$core$Maybe$Just(x);
	} else {
		return elm$core$Maybe$Nothing;
	}
};
var aforemny$elm_mdc$Internal$TabBar$Implementation$calculateScrollIncrement = F5(
	function (geometry, index, nextIndex, scrollPosition, barWidth) {
		var maybe_next_tab = elm$core$List$head(
			A2(elm$core$List$drop, nextIndex, geometry.tabs));
		var extraScrollAmount = 20;
		if (maybe_next_tab.$ === 'Just') {
			var next_tab = maybe_next_tab.a;
			var relativeContentRight = next_tab.contentRight - scrollPosition;
			var relativeContentLeft = (next_tab.contentLeft - scrollPosition) - barWidth;
			var rightIncrement = relativeContentLeft + extraScrollAmount;
			var leftIncrement = relativeContentRight - extraScrollAmount;
			return (_Utils_cmp(nextIndex, index) < 0) ? A2(elm$core$Basics$min, leftIncrement, 0) : A2(elm$core$Basics$max, rightIncrement, 0);
		} else {
			return 0;
		}
	});
var aforemny$elm_mdc$Internal$TabBar$Implementation$findAdjacentTabIndexClosestToEdge = F4(
	function (index, tab_, scrollPosition, barWidth) {
		var rootRight = tab_.offsetLeft + tab_.offsetWidth;
		var rootLeft = tab_.offsetLeft;
		var relativeRootRight = (rootRight - scrollPosition) - barWidth;
		var relativeRootLeft = rootLeft - scrollPosition;
		var relativeRootDelta = relativeRootLeft + relativeRootRight;
		var rightEdgeIsCloser = (relativeRootRight > 0) || (relativeRootDelta > 0);
		var leftEdgeIsCloser = (relativeRootLeft < 0) || (relativeRootDelta < 0);
		return leftEdgeIsCloser ? (index - 1) : (rightEdgeIsCloser ? (index + 1) : (-1));
	});
var aforemny$elm_mdc$Internal$TabBar$Model$NoOp = {$: 'NoOp'};
var aforemny$elm_mdc$Internal$TabBar$Model$RippleMsg = F2(
	function (a, b) {
		return {$: 'RippleMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$TabBar$Model$defaultGeometry = {
	scrollArea: {offsetWidth: 0},
	tabBar: {offsetWidth: 0},
	tabs: _List_Nil
};
var elm$browser$Browser$Dom$setViewportOf = _Browser_setViewportOf;
var aforemny$elm_mdc$Internal$TabBar$Implementation$update = F3(
	function (lift, msg, model) {
		switch (msg.$) {
			case 'RippleMsg':
				var index = msg.a;
				var msg_ = msg.b;
				var _n1 = A2(
					aforemny$elm_mdc$Internal$Ripple$Implementation$update,
					msg_,
					A2(
						elm$core$Maybe$withDefault,
						aforemny$elm_mdc$Internal$Ripple$Model$defaultModel,
						A2(elm$core$Dict$get, index, model.ripples)));
				var ripple = _n1.a;
				var effects = _n1.b;
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{
								ripples: A3(elm$core$Dict$insert, index, ripple, model.ripples)
							})),
					A2(
						elm$core$Platform$Cmd$map,
						A2(
							elm$core$Basics$composeL,
							lift,
							aforemny$elm_mdc$Internal$TabBar$Model$RippleMsg(index)),
						effects));
			case 'Dispatch':
				var msgs = msg.a;
				return _Utils_Tuple2(
					elm$core$Maybe$Nothing,
					aforemny$elm_mdc$Internal$Dispatch$forward(msgs));
			case 'NoOp':
				return _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Platform$Cmd$none);
			case 'Init':
				var geometry = msg.a;
				return _Utils_Tuple2(
					function () {
						var tabBarWidth = geometry.tabBar.offsetWidth;
						var scrollAreaWidth = geometry.scrollArea.offsetWidth;
						var isOverflowing = _Utils_cmp(tabBarWidth, scrollAreaWidth) > 0;
						var translateOffset = (!isOverflowing) ? 0 : model.translateOffset;
						return elm$core$Maybe$Just(
							_Utils_update(
								model,
								{
									geometry: elm$core$Maybe$Just(geometry),
									translateOffset: translateOffset
								}));
					}(),
					elm$core$Platform$Cmd$none);
			default:
				var domId = msg.a;
				var tab_index = msg.b;
				var scrollPosition = msg.c;
				var geometry = A2(elm$core$Maybe$withDefault, aforemny$elm_mdc$Internal$TabBar$Model$defaultGeometry, model.geometry);
				var tabAtIndex = function (i) {
					return A2(
						elm$core$Maybe$withDefault,
						{contentLeft: 0, contentRight: 0, offsetLeft: 0, offsetWidth: 0},
						elm$core$List$head(
							A2(elm$core$List$drop, i, geometry.tabs)));
				};
				var tab_ = tabAtIndex(tab_index);
				var barWidth = geometry.tabBar.offsetWidth;
				var next_tab_index = A4(aforemny$elm_mdc$Internal$TabBar$Implementation$findAdjacentTabIndexClosestToEdge, tab_index, tab_, scrollPosition, barWidth);
				var scrollIncrement = A5(aforemny$elm_mdc$Internal$TabBar$Implementation$calculateScrollIncrement, geometry, tab_index, next_tab_index, scrollPosition, barWidth);
				var newScrollPosition = (!tab_index) ? 0 : (_Utils_eq(
					tab_index,
					elm$core$List$length(geometry.tabs) - 1) ? geometry.scrollArea.offsetWidth : (scrollPosition + scrollIncrement));
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{activeTab: tab_index})),
					A2(
						elm$core$Task$perform,
						lift,
						A2(
							elm$core$Task$onError,
							function (_n3) {
								return elm$core$Task$succeed(aforemny$elm_mdc$Internal$TabBar$Model$NoOp);
							},
							A2(
								elm$core$Task$map,
								function (_n2) {
									return aforemny$elm_mdc$Internal$TabBar$Model$NoOp;
								},
								A3(elm$browser$Browser$Dom$setViewportOf, domId + '__scroll-area', newScrollPosition, 0)))));
		}
	});
var aforemny$elm_mdc$Internal$TabBar$Implementation$react = A4(aforemny$elm_mdc$Internal$Component$react, aforemny$elm_mdc$Internal$TabBar$Implementation$getSet.get, aforemny$elm_mdc$Internal$TabBar$Implementation$getSet.set, aforemny$elm_mdc$Internal$Msg$TabBarMsg, aforemny$elm_mdc$Internal$TabBar$Implementation$update);
var aforemny$elm_mdc$Internal$Msg$TextFieldMsg = F2(
	function (a, b) {
		return {$: 'TextFieldMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$TextField$Model$defaultModel = {focused: false, geometry: elm$core$Maybe$Nothing, isDirty: false, value: elm$core$Maybe$Nothing};
var aforemny$elm_mdc$Internal$TextField$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.textfield;
	},
	F2(
		function (x, c) {
			return _Utils_update(
				c,
				{textfield: x});
		}),
	aforemny$elm_mdc$Internal$TextField$Model$defaultModel);
var aforemny$elm_mdc$Internal$TextField$Implementation$update = F3(
	function (lift, msg, model) {
		switch (msg.$) {
			case 'Input':
				var str = msg.a;
				var dirty = str !== '';
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{
								isDirty: dirty,
								value: elm$core$Maybe$Just(str)
							})),
					elm$core$Platform$Cmd$none);
			case 'Blur':
				var geometry = function () {
					var _n1 = model.value;
					if (_n1.$ === 'Nothing') {
						return elm$core$Maybe$Nothing;
					} else {
						return model.geometry;
					}
				}();
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{focused: false, geometry: geometry})),
					elm$core$Platform$Cmd$none);
			case 'Focus':
				var geometry = msg.a;
				return _Utils_Tuple2(
					elm$core$Maybe$Just(
						_Utils_update(
							model,
							{
								focused: true,
								geometry: elm$core$Maybe$Just(geometry)
							})),
					elm$core$Platform$Cmd$none);
			default:
				return _Utils_Tuple2(
					elm$core$Maybe$Just(model),
					elm$core$Platform$Cmd$none);
		}
	});
var aforemny$elm_mdc$Internal$TextField$Implementation$react = A4(aforemny$elm_mdc$Internal$Component$react, aforemny$elm_mdc$Internal$TextField$Implementation$getSet.get, aforemny$elm_mdc$Internal$TextField$Implementation$getSet.set, aforemny$elm_mdc$Internal$Msg$TextFieldMsg, aforemny$elm_mdc$Internal$TextField$Implementation$update);
var aforemny$elm_mdc$Internal$Msg$ToolbarMsg = F2(
	function (a, b) {
		return {$: 'ToolbarMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Toolbar$Model$defaultModel = {calculations: elm$core$Maybe$Nothing, config: elm$core$Maybe$Nothing, geometry: elm$core$Maybe$Nothing, scrollTop: 0};
var aforemny$elm_mdc$Internal$Toolbar$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.toolbar;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{toolbar: x});
		}),
	aforemny$elm_mdc$Internal$Toolbar$Model$defaultModel);
var aforemny$elm_mdc$Internal$Toolbar$Model$defaultCalculations = {flexibleExpansionHeight: 0, flexibleExpansionRatio: 0, maxTranslateYDistance: 0, maxTranslateYRatio: 0, scrollThreshold: 0, scrollThresholdRatio: 0, toolbarHeight: 0, toolbarRatio: 0, toolbarRowHeight: 0};
var aforemny$elm_mdc$Internal$Toolbar$Implementation$initKeyRatio = F2(
	function (config, geometry) {
		var toolbarRowHeight = geometry.getRowHeight;
		var toolbarRatio = (!toolbarRowHeight) ? 0 : (geometry.getOffsetHeight / toolbarRowHeight);
		var firstRowMaxRatio = (!toolbarRowHeight) ? 0 : (geometry.getFirstRowElementOffsetHeight / toolbarRowHeight);
		var flexibleExpansionRatio_ = firstRowMaxRatio - 1;
		var maxTranslateYRatio = config.fixedLastrow ? (toolbarRatio - firstRowMaxRatio) : 0;
		var scrollThresholdRatio = config.fixedLastrow ? (toolbarRatio - 1) : (firstRowMaxRatio - 1);
		return _Utils_update(
			aforemny$elm_mdc$Internal$Toolbar$Model$defaultCalculations,
			{flexibleExpansionRatio: flexibleExpansionRatio_, maxTranslateYRatio: maxTranslateYRatio, scrollThresholdRatio: scrollThresholdRatio, toolbarRatio: toolbarRatio});
	});
var aforemny$elm_mdc$Internal$Toolbar$Implementation$setKeyHeights = F2(
	function (geometry, calculations) {
		var toolbarRowHeight = geometry.getRowHeight;
		var toolbarHeight = calculations.toolbarRatio * toolbarRowHeight;
		var scrollThreshold = calculations.scrollThresholdRatio * toolbarRowHeight;
		var maxTranslateYDistance = calculations.maxTranslateYRatio * toolbarRowHeight;
		var flexibleExpansionHeight = calculations.flexibleExpansionRatio * toolbarRowHeight;
		return _Utils_update(
			calculations,
			{flexibleExpansionHeight: flexibleExpansionHeight, maxTranslateYDistance: maxTranslateYDistance, scrollThreshold: scrollThreshold, toolbarHeight: toolbarHeight, toolbarRowHeight: toolbarRowHeight});
	});
var aforemny$elm_mdc$Internal$Toolbar$Implementation$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'Init':
				var config = msg.a;
				var geometry = msg.b;
				var calculations = A2(
					aforemny$elm_mdc$Internal$Toolbar$Implementation$setKeyHeights,
					geometry,
					A2(aforemny$elm_mdc$Internal$Toolbar$Implementation$initKeyRatio, config, geometry));
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							calculations: elm$core$Maybe$Just(calculations),
							config: elm$core$Maybe$Just(config),
							geometry: elm$core$Maybe$Just(geometry)
						}),
					elm$core$Platform$Cmd$none);
			case 'Resize':
				var config = msg.a;
				var geometry = msg.b;
				var calculations = A2(
					elm$core$Maybe$map,
					aforemny$elm_mdc$Internal$Toolbar$Implementation$setKeyHeights(geometry),
					model.calculations);
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							calculations: calculations,
							config: elm$core$Maybe$Just(config),
							geometry: elm$core$Maybe$Just(geometry)
						}),
					elm$core$Platform$Cmd$none);
			default:
				var config = msg.a;
				var scrollTop = msg.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							config: elm$core$Maybe$Just(config),
							scrollTop: scrollTop
						}),
					elm$core$Platform$Cmd$none);
		}
	});
var aforemny$elm_mdc$Internal$Toolbar$Implementation$react = A4(
	aforemny$elm_mdc$Internal$Component$react,
	aforemny$elm_mdc$Internal$Toolbar$Implementation$getSet.get,
	aforemny$elm_mdc$Internal$Toolbar$Implementation$getSet.set,
	aforemny$elm_mdc$Internal$Msg$ToolbarMsg,
	aforemny$elm_mdc$Internal$Component$generalise(aforemny$elm_mdc$Internal$Toolbar$Implementation$update));
var aforemny$elm_mdc$Internal$Msg$TopAppBarMsg = F2(
	function (a, b) {
		return {$: 'TopAppBarMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$TopAppBar$Model$defaultModel = {currentAppBarOffsetTop: 0, isDockedShowing: true, lastScrollPosition: elm$core$Maybe$Nothing, ripples: elm$core$Dict$empty, styleTop: elm$core$Maybe$Nothing, topAppBarHeight: elm$core$Maybe$Nothing, wasDocked: true};
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$getSet = A3(
	aforemny$elm_mdc$Internal$Component$indexed,
	function ($) {
		return $.topAppBar;
	},
	F2(
		function (x, y) {
			return _Utils_update(
				y,
				{topAppBar: x});
		}),
	aforemny$elm_mdc$Internal$TopAppBar$Model$defaultModel);
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$checkForUpdate = function (model) {
	return A2(
		elm$core$Maybe$map,
		function (topAppBarHeight) {
			var offscreenBoundaryTop = -topAppBarHeight;
			var hasAnyPixelsOnscreen = _Utils_cmp(model.currentAppBarOffsetTop, offscreenBoundaryTop) > 0;
			var hasAnyPixelsOffscreen = model.currentAppBarOffsetTop < 0;
			var partiallyShowing = hasAnyPixelsOffscreen && hasAnyPixelsOnscreen;
			return partiallyShowing ? _Utils_Tuple2(
				_Utils_update(
					model,
					{wasDocked: false}),
				true) : ((!model.wasDocked) ? _Utils_Tuple2(
				_Utils_update(
					model,
					{wasDocked: true}),
				true) : ((!_Utils_eq(model.isDockedShowing, hasAnyPixelsOnscreen)) ? _Utils_Tuple2(
				_Utils_update(
					model,
					{isDockedShowing: hasAnyPixelsOnscreen}),
				true) : _Utils_Tuple2(model, false)));
		},
		model.topAppBarHeight);
};
var elm$core$Basics$abs = function (n) {
	return (n < 0) ? (-n) : n;
};
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$moveTopAppBar = function (model) {
	return A2(
		elm$core$Maybe$andThen,
		function (_n0) {
			var updatedModel = _n0.a;
			var partiallyShowing = _n0.b;
			return partiallyShowing ? A2(
				elm$core$Maybe$map,
				function (topAppBarHeight) {
					var styleTop = function () {
						var maxTopAppBarHeight = 128;
						return (_Utils_cmp(
							elm$core$Basics$abs(updatedModel.currentAppBarOffsetTop),
							topAppBarHeight) > 0) ? (-maxTopAppBarHeight) : updatedModel.currentAppBarOffsetTop;
					}();
					return _Utils_update(
						updatedModel,
						{
							styleTop: elm$core$Maybe$Just(styleTop)
						});
				},
				updatedModel.topAppBarHeight) : elm$core$Maybe$Just(updatedModel);
		},
		aforemny$elm_mdc$Internal$TopAppBar$Implementation$checkForUpdate(model));
};
var elm$core$Maybe$map2 = F3(
	function (func, ma, mb) {
		if (ma.$ === 'Nothing') {
			return elm$core$Maybe$Nothing;
		} else {
			var a = ma.a;
			if (mb.$ === 'Nothing') {
				return elm$core$Maybe$Nothing;
			} else {
				var b = mb.a;
				return elm$core$Maybe$Just(
					A2(func, a, b));
			}
		}
	});
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$topAppBarScrollHandler = F2(
	function (scrollPosition, model) {
		return A2(
			elm$core$Maybe$withDefault,
			model,
			A2(
				elm$core$Maybe$andThen,
				aforemny$elm_mdc$Internal$TopAppBar$Implementation$moveTopAppBar,
				A2(
					elm$core$Maybe$map,
					function (_n0) {
						var topAppBarHeight = _n0.a;
						var lastScrollPosition = _n0.b;
						var isCurrentlyBeingResized = false;
						var currentScrollPosition = A2(elm$core$Basics$max, scrollPosition, 0);
						var diff = currentScrollPosition - lastScrollPosition;
						var currentAppBarOffsetTop = model.currentAppBarOffsetTop - diff;
						var updatedAppBarOffsetTop = (!isCurrentlyBeingResized) ? ((currentAppBarOffsetTop > 0) ? 0 : ((_Utils_cmp(
							elm$core$Basics$abs(currentAppBarOffsetTop),
							topAppBarHeight) > 0) ? (-topAppBarHeight) : currentAppBarOffsetTop)) : model.currentAppBarOffsetTop;
						var updatedModel = _Utils_update(
							model,
							{
								currentAppBarOffsetTop: updatedAppBarOffsetTop,
								lastScrollPosition: elm$core$Maybe$Just(currentScrollPosition)
							});
						return A2(
							elm$core$Maybe$withDefault,
							updatedModel,
							aforemny$elm_mdc$Internal$TopAppBar$Implementation$moveTopAppBar(updatedModel));
					},
					A3(
						elm$core$Maybe$map2,
						F2(
							function (topAppBarHeight, lastScrollPosition) {
								return _Utils_Tuple2(topAppBarHeight, lastScrollPosition);
							}),
						model.topAppBarHeight,
						model.lastScrollPosition))));
	});
var aforemny$elm_mdc$Internal$TopAppBar$Model$RippleMsg = F2(
	function (a, b) {
		return {$: 'RippleMsg', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'RippleMsg':
				var index = msg.a;
				var msg_ = msg.b;
				var _n1 = A2(
					aforemny$elm_mdc$Internal$Ripple$Implementation$update,
					msg_,
					A2(
						elm$core$Maybe$withDefault,
						aforemny$elm_mdc$Internal$Ripple$Model$defaultModel,
						A2(elm$core$Dict$get, index, model.ripples)));
				var ripple = _n1.a;
				var effects = _n1.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							ripples: A3(elm$core$Dict$insert, index, ripple, model.ripples)
						}),
					A2(
						elm$core$Platform$Cmd$map,
						aforemny$elm_mdc$Internal$TopAppBar$Model$RippleMsg(index),
						effects));
			case 'Init':
				var scrollPosition = msg.a.scrollPosition;
				var topAppBarHeight = msg.a.topAppBarHeight;
				return _Utils_Tuple2(
					A2(
						aforemny$elm_mdc$Internal$TopAppBar$Implementation$topAppBarScrollHandler,
						scrollPosition,
						_Utils_update(
							model,
							{
								lastScrollPosition: elm$core$Maybe$Just(scrollPosition),
								topAppBarHeight: elm$core$Maybe$Just(topAppBarHeight)
							})),
					elm$core$Platform$Cmd$none);
			case 'Scroll':
				var scrollPosition = msg.a.scrollPosition;
				return _Utils_Tuple2(
					A2(aforemny$elm_mdc$Internal$TopAppBar$Implementation$topAppBarScrollHandler, scrollPosition, model),
					elm$core$Platform$Cmd$none);
			default:
				var scrollPosition = msg.a.scrollPosition;
				var topAppBarHeight = msg.a.topAppBarHeight;
				var currentHeight = topAppBarHeight;
				var currentAppBarOffsetTop = model.currentAppBarOffsetTop - (topAppBarHeight - currentHeight);
				var updatedModel = (!_Utils_eq(
					elm$core$Maybe$Just(topAppBarHeight),
					model.topAppBarHeight)) ? _Utils_update(
					model,
					{
						currentAppBarOffsetTop: currentAppBarOffsetTop,
						topAppBarHeight: elm$core$Maybe$Just(currentHeight),
						wasDocked: false
					}) : model;
				return _Utils_Tuple2(
					A2(aforemny$elm_mdc$Internal$TopAppBar$Implementation$topAppBarScrollHandler, scrollPosition, updatedModel),
					elm$core$Platform$Cmd$none);
		}
	});
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$react = A4(
	aforemny$elm_mdc$Internal$Component$react,
	aforemny$elm_mdc$Internal$TopAppBar$Implementation$getSet.get,
	aforemny$elm_mdc$Internal$TopAppBar$Implementation$getSet.set,
	aforemny$elm_mdc$Internal$Msg$TopAppBarMsg,
	aforemny$elm_mdc$Internal$Component$generalise(aforemny$elm_mdc$Internal$TopAppBar$Implementation$update));
var aforemny$elm_mdc$Material$update_ = F3(
	function (lift, msg, store) {
		switch (msg.$) {
			case 'Dispatch':
				var msgs = msg.a;
				return _Utils_Tuple2(
					elm$core$Maybe$Nothing,
					aforemny$elm_mdc$Internal$Dispatch$forward(msgs));
			case 'ButtonMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Button$Implementation$react, lift, msg_, idx, store);
			case 'CheckboxMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Checkbox$Implementation$react, lift, msg_, idx, store);
			case 'ChipMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Chip$Implementation$react, lift, msg_, idx, store);
			case 'DialogMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Dialog$Implementation$react, lift, msg_, idx, store);
			case 'DrawerMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Drawer$Implementation$react, lift, msg_, idx, store);
			case 'FabMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Fab$Implementation$react, lift, msg_, idx, store);
			case 'IconButtonMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$IconButton$Implementation$react, lift, msg_, idx, store);
			case 'ListMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$List$Implementation$react, lift, msg_, idx, store);
			case 'MenuMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Menu$Implementation$react, lift, msg_, idx, store);
			case 'RadioButtonMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$RadioButton$Implementation$react, lift, msg_, idx, store);
			case 'RippleMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Ripple$Implementation$react, lift, msg_, idx, store);
			case 'SelectMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Select$Implementation$react, lift, msg_, idx, store);
			case 'SliderMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Slider$Implementation$react, lift, msg_, idx, store);
			case 'SnackbarMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Snackbar$Implementation$react, lift, msg_, idx, store);
			case 'SwitchMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Switch$Implementation$react, lift, msg_, idx, store);
			case 'TabBarMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$TabBar$Implementation$react, lift, msg_, idx, store);
			case 'TextFieldMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$TextField$Implementation$react, lift, msg_, idx, store);
			case 'ToolbarMsg':
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$Toolbar$Implementation$react, lift, msg_, idx, store);
			default:
				var idx = msg.a;
				var msg_ = msg.b;
				return A4(aforemny$elm_mdc$Internal$TopAppBar$Implementation$react, lift, msg_, idx, store);
		}
	});
var aforemny$elm_mdc$Material$update = F3(
	function (lift, msg, container) {
		return A2(
			elm$core$Tuple$mapFirst,
			elm$core$Maybe$withDefault(container),
			A2(
				elm$core$Tuple$mapFirst,
				elm$core$Maybe$map(
					function (mdc) {
						return _Utils_update(
							container,
							{mdc: mdc});
					}),
				A3(
					aforemny$elm_mdc$Material$update_,
					lift,
					msg,
					function ($) {
						return $.mdc;
					}(container))));
	});
var elm$core$Debug$log = _Debug_log;
var aforemny$elm_mdc$Main$update = F2(
	function (msg, model) {
		var _n0 = A2(elm$core$Debug$log, 'Msg', msg);
		if (_n0.$ === 'Mdc') {
			var msg_ = _n0.a;
			return A3(aforemny$elm_mdc$Material$update, aforemny$elm_mdc$Main$Mdc, msg_, model);
		} else {
			return _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
		}
	});
var aforemny$elm_mdc$Main$LoginRequest = {$: 'LoginRequest'};
var aforemny$elm_mdc$Internal$Options$Class = function (a) {
	return {$: 'Class', a: a};
};
var aforemny$elm_mdc$Internal$Options$cs = function (c) {
	return aforemny$elm_mdc$Internal$Options$Class(c);
};
var aforemny$elm_mdc$Internal$Button$Implementation$raised = aforemny$elm_mdc$Internal$Options$cs('mdc-button--raised');
var aforemny$elm_mdc$Material$Button$raised = aforemny$elm_mdc$Internal$Button$Implementation$raised;
var aforemny$elm_mdc$Internal$Options$Set = function (a) {
	return {$: 'Set', a: a};
};
var aforemny$elm_mdc$Internal$Options$option = aforemny$elm_mdc$Internal$Options$Set;
var aforemny$elm_mdc$Internal$Button$Implementation$ripple = aforemny$elm_mdc$Internal$Options$option(
	function (options) {
		return _Utils_update(
			options,
			{ripple: true});
	});
var aforemny$elm_mdc$Material$Button$ripple = aforemny$elm_mdc$Internal$Button$Implementation$ripple;
var aforemny$elm_mdc$Internal$Button$Implementation$defaultConfig = {disabled: false, icon: elm$core$Maybe$Nothing, link: elm$core$Maybe$Nothing, onClick: elm$core$Maybe$Nothing, ripple: false, trailingIcon: false};
var aforemny$elm_mdc$Internal$Button$Model$Click = F2(
	function (a, b) {
		return {$: 'Click', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Icon$Implementation$defaultConfig = {node: 'i'};
var elm$core$Result$toMaybe = function (result) {
	if (result.$ === 'Ok') {
		var v = result.a;
		return elm$core$Maybe$Just(v);
	} else {
		return elm$core$Maybe$Nothing;
	}
};
var elm$json$Json$Decode$decodeValue = _Json_run;
var elm$json$Json$Decode$value = _Json_decodeValue;
var aforemny$elm_mdc$Internal$Dispatch$flatten = function (decoders) {
	var tryMergeStep = F3(
		function (value, decoder, result) {
			return A2(
				elm$core$Maybe$withDefault,
				result,
				A2(
					elm$core$Maybe$map,
					function (_n0) {
						var message = _n0.message;
						var stopPropagation = _n0.stopPropagation;
						var preventDefault = _n0.preventDefault;
						return {
							message: A2(elm$core$List$cons, message, result.message),
							preventDefault: preventDefault || result.preventDefault,
							stopPropagation: stopPropagation || result.stopPropagation
						};
					},
					elm$core$Result$toMaybe(
						A2(elm$json$Json$Decode$decodeValue, decoder, value))));
		});
	var tryMerge = function (value) {
		return A3(
			elm$core$List$foldl,
			tryMergeStep(value),
			{message: _List_Nil, preventDefault: false, stopPropagation: false},
			decoders);
	};
	return A2(elm$json$Json$Decode$map, tryMerge, elm$json$Json$Decode$value);
};
var elm$core$Dict$map = F2(
	function (func, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				A2(func, key, value),
				A2(elm$core$Dict$map, func, left),
				A2(elm$core$Dict$map, func, right));
		}
	});
var elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3(elm$core$List$foldr, elm$core$List$cons, ys, xs);
		}
	});
var elm$core$List$concat = function (lists) {
	return A3(elm$core$List$foldr, elm$core$List$append, _List_Nil, lists);
};
var elm$core$List$concatMap = F2(
	function (f, list) {
		return elm$core$List$concat(
			A2(elm$core$List$map, f, list));
	});
var elm$virtual_dom$VirtualDom$Custom = function (a) {
	return {$: 'Custom', a: a};
};
var elm$virtual_dom$VirtualDom$on = _VirtualDom_on;
var elm$html$Html$Events$custom = F2(
	function (event, decoder) {
		return A2(
			elm$virtual_dom$VirtualDom$on,
			event,
			elm$virtual_dom$VirtualDom$Custom(decoder));
	});
var aforemny$elm_mdc$Internal$Dispatch$toAttributes = function (_n0) {
	var config = _n0.a;
	var _n1 = config.lift;
	if (_n1.$ === 'Just') {
		var lift = _n1.a;
		return A2(
			elm$core$List$map,
			function (_n3) {
				var event = _n3.a;
				var flatDecoder = _n3.b;
				return A2(
					elm$html$Html$Events$custom,
					event,
					lift(flatDecoder));
			},
			elm$core$Dict$toList(
				A2(
					elm$core$Dict$map,
					function (_n2) {
						return aforemny$elm_mdc$Internal$Dispatch$flatten;
					},
					config.decoders)));
	} else {
		return A2(
			elm$core$List$concatMap,
			function (_n4) {
				var event = _n4.a;
				var decoders = _n4.b;
				return A2(
					elm$core$List$map,
					elm$html$Html$Events$custom(event),
					decoders);
			},
			elm$core$Dict$toList(config.decoders));
	}
};
var elm$virtual_dom$VirtualDom$attribute = F2(
	function (key, value) {
		return A2(
			_VirtualDom_attribute,
			_VirtualDom_noOnOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var elm$html$Html$Attributes$attribute = elm$virtual_dom$VirtualDom$attribute;
var elm$json$Json$Encode$string = _Json_wrap;
var elm$html$Html$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			_VirtualDom_property,
			key,
			elm$json$Json$Encode$string(string));
	});
var elm$html$Html$Attributes$class = elm$html$Html$Attributes$stringProperty('className');
var aforemny$elm_mdc$Internal$Options$addAttributes = F2(
	function (summary, attrs) {
		var styleText = A2(
			elm$core$String$join,
			'; ',
			A2(
				elm$core$List$map,
				function (_n0) {
					var key = _n0.a;
					var value = _n0.b;
					return A2(
						elm$core$String$join,
						': ',
						_List_fromArray(
							[key, value]));
				},
				summary.css));
		var style = (styleText !== '') ? _List_fromArray(
			[
				A2(elm$html$Html$Attributes$attribute, 'style', styleText)
			]) : _List_Nil;
		var all = _Utils_ap(
			summary.attrs,
			_Utils_ap(
				style,
				_Utils_ap(
					A2(
						elm$core$List$map,
						elm$html$Html$Attributes$class,
						elm$core$List$reverse(summary.classes)),
					_Utils_ap(
						attrs,
						_Utils_ap(
							summary.internal,
							aforemny$elm_mdc$Internal$Dispatch$toAttributes(summary.dispatch))))));
		return all;
	});
var aforemny$elm_mdc$Internal$Dispatch$Config = function (a) {
	return {$: 'Config', a: a};
};
var elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var elm$core$Dict$getMin = function (dict) {
	getMin:
	while (true) {
		if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
			var left = dict.d;
			var $temp$dict = left;
			dict = $temp$dict;
			continue getMin;
		} else {
			return dict;
		}
	}
};
var elm$core$Dict$moveRedLeft = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.e.d.$ === 'RBNode_elm_builtin') && (dict.e.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _n1 = dict.d;
			var lClr = _n1.a;
			var lK = _n1.b;
			var lV = _n1.c;
			var lLeft = _n1.d;
			var lRight = _n1.e;
			var _n2 = dict.e;
			var rClr = _n2.a;
			var rK = _n2.b;
			var rV = _n2.c;
			var rLeft = _n2.d;
			var _n3 = rLeft.a;
			var rlK = rLeft.b;
			var rlV = rLeft.c;
			var rlL = rLeft.d;
			var rlR = rLeft.e;
			var rRight = _n2.e;
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				elm$core$Dict$Red,
				rlK,
				rlV,
				A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					rlL),
				A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, rK, rV, rlR, rRight));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _n4 = dict.d;
			var lClr = _n4.a;
			var lK = _n4.b;
			var lV = _n4.c;
			var lLeft = _n4.d;
			var lRight = _n4.e;
			var _n5 = dict.e;
			var rClr = _n5.a;
			var rK = _n5.b;
			var rV = _n5.c;
			var rLeft = _n5.d;
			var rRight = _n5.e;
			if (clr.$ === 'Black') {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var elm$core$Dict$moveRedRight = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.d.d.$ === 'RBNode_elm_builtin') && (dict.d.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _n1 = dict.d;
			var lClr = _n1.a;
			var lK = _n1.b;
			var lV = _n1.c;
			var _n2 = _n1.d;
			var _n3 = _n2.a;
			var llK = _n2.b;
			var llV = _n2.c;
			var llLeft = _n2.d;
			var llRight = _n2.e;
			var lRight = _n1.e;
			var _n4 = dict.e;
			var rClr = _n4.a;
			var rK = _n4.b;
			var rV = _n4.c;
			var rLeft = _n4.d;
			var rRight = _n4.e;
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				elm$core$Dict$Red,
				lK,
				lV,
				A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, llK, llV, llLeft, llRight),
				A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					lRight,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight)));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _n5 = dict.d;
			var lClr = _n5.a;
			var lK = _n5.b;
			var lV = _n5.c;
			var lLeft = _n5.d;
			var lRight = _n5.e;
			var _n6 = dict.e;
			var rClr = _n6.a;
			var rK = _n6.b;
			var rV = _n6.c;
			var rLeft = _n6.d;
			var rRight = _n6.e;
			if (clr.$ === 'Black') {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var elm$core$Dict$removeHelpPrepEQGT = F7(
	function (targetKey, dict, color, key, value, left, right) {
		if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
			var _n1 = left.a;
			var lK = left.b;
			var lV = left.c;
			var lLeft = left.d;
			var lRight = left.e;
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				color,
				lK,
				lV,
				lLeft,
				A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, key, value, lRight, right));
		} else {
			_n2$2:
			while (true) {
				if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Black')) {
					if (right.d.$ === 'RBNode_elm_builtin') {
						if (right.d.a.$ === 'Black') {
							var _n3 = right.a;
							var _n4 = right.d;
							var _n5 = _n4.a;
							return elm$core$Dict$moveRedRight(dict);
						} else {
							break _n2$2;
						}
					} else {
						var _n6 = right.a;
						var _n7 = right.d;
						return elm$core$Dict$moveRedRight(dict);
					}
				} else {
					break _n2$2;
				}
			}
			return dict;
		}
	});
var elm$core$Dict$removeMin = function (dict) {
	if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
		var color = dict.a;
		var key = dict.b;
		var value = dict.c;
		var left = dict.d;
		var lColor = left.a;
		var lLeft = left.d;
		var right = dict.e;
		if (lColor.$ === 'Black') {
			if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
				var _n3 = lLeft.a;
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					color,
					key,
					value,
					elm$core$Dict$removeMin(left),
					right);
			} else {
				var _n4 = elm$core$Dict$moveRedLeft(dict);
				if (_n4.$ === 'RBNode_elm_builtin') {
					var nColor = _n4.a;
					var nKey = _n4.b;
					var nValue = _n4.c;
					var nLeft = _n4.d;
					var nRight = _n4.e;
					return A5(
						elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						elm$core$Dict$removeMin(nLeft),
						nRight);
				} else {
					return elm$core$Dict$RBEmpty_elm_builtin;
				}
			}
		} else {
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				value,
				elm$core$Dict$removeMin(left),
				right);
		}
	} else {
		return elm$core$Dict$RBEmpty_elm_builtin;
	}
};
var elm$core$Dict$removeHelp = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_cmp(targetKey, key) < 0) {
				if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Black')) {
					var _n4 = left.a;
					var lLeft = left.d;
					if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
						var _n6 = lLeft.a;
						return A5(
							elm$core$Dict$RBNode_elm_builtin,
							color,
							key,
							value,
							A2(elm$core$Dict$removeHelp, targetKey, left),
							right);
					} else {
						var _n7 = elm$core$Dict$moveRedLeft(dict);
						if (_n7.$ === 'RBNode_elm_builtin') {
							var nColor = _n7.a;
							var nKey = _n7.b;
							var nValue = _n7.c;
							var nLeft = _n7.d;
							var nRight = _n7.e;
							return A5(
								elm$core$Dict$balance,
								nColor,
								nKey,
								nValue,
								A2(elm$core$Dict$removeHelp, targetKey, nLeft),
								nRight);
						} else {
							return elm$core$Dict$RBEmpty_elm_builtin;
						}
					}
				} else {
					return A5(
						elm$core$Dict$RBNode_elm_builtin,
						color,
						key,
						value,
						A2(elm$core$Dict$removeHelp, targetKey, left),
						right);
				}
			} else {
				return A2(
					elm$core$Dict$removeHelpEQGT,
					targetKey,
					A7(elm$core$Dict$removeHelpPrepEQGT, targetKey, dict, color, key, value, left, right));
			}
		}
	});
var elm$core$Dict$removeHelpEQGT = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBNode_elm_builtin') {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_eq(targetKey, key)) {
				var _n1 = elm$core$Dict$getMin(right);
				if (_n1.$ === 'RBNode_elm_builtin') {
					var minKey = _n1.b;
					var minValue = _n1.c;
					return A5(
						elm$core$Dict$balance,
						color,
						minKey,
						minValue,
						left,
						elm$core$Dict$removeMin(right));
				} else {
					return elm$core$Dict$RBEmpty_elm_builtin;
				}
			} else {
				return A5(
					elm$core$Dict$balance,
					color,
					key,
					value,
					left,
					A2(elm$core$Dict$removeHelp, targetKey, right));
			}
		} else {
			return elm$core$Dict$RBEmpty_elm_builtin;
		}
	});
var elm$core$Dict$remove = F2(
	function (key, dict) {
		var _n0 = A2(elm$core$Dict$removeHelp, key, dict);
		if ((_n0.$ === 'RBNode_elm_builtin') && (_n0.a.$ === 'Red')) {
			var _n1 = _n0.a;
			var k = _n0.b;
			var v = _n0.c;
			var l = _n0.d;
			var r = _n0.e;
			return A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _n0;
			return x;
		}
	});
var elm$core$Dict$update = F3(
	function (targetKey, alter, dictionary) {
		var _n0 = alter(
			A2(elm$core$Dict$get, targetKey, dictionary));
		if (_n0.$ === 'Just') {
			var value = _n0.a;
			return A3(elm$core$Dict$insert, targetKey, value, dictionary);
		} else {
			return A2(elm$core$Dict$remove, targetKey, dictionary);
		}
	});
var aforemny$elm_mdc$Internal$Dispatch$add = F3(
	function (event, decoder, _n0) {
		var config = _n0.a;
		return aforemny$elm_mdc$Internal$Dispatch$Config(
			_Utils_update(
				config,
				{
					decoders: A3(
						elm$core$Dict$update,
						event,
						A2(
							elm$core$Basics$composeR,
							elm$core$Maybe$map(
								elm$core$List$cons(decoder)),
							A2(
								elm$core$Basics$composeR,
								elm$core$Maybe$withDefault(
									_List_fromArray(
										[decoder])),
								elm$core$Maybe$Just)),
						config.decoders)
				}));
	});
var aforemny$elm_mdc$Internal$Dispatch$setLift = F2(
	function (lift, _n0) {
		var decoders = _n0.a.decoders;
		return aforemny$elm_mdc$Internal$Dispatch$Config(
			{
				decoders: decoders,
				lift: elm$core$Maybe$Just(lift)
			});
	});
var aforemny$elm_mdc$Internal$Options$collect1 = F2(
	function (opt, acc) {
		switch (opt.$) {
			case 'Class':
				var x = opt.a;
				return _Utils_update(
					acc,
					{
						classes: A2(elm$core$List$cons, x, acc.classes)
					});
			case 'CSS':
				var x = opt.a;
				return _Utils_update(
					acc,
					{
						css: A2(elm$core$List$cons, x, acc.css)
					});
			case 'Attribute':
				var x = opt.a;
				return _Utils_update(
					acc,
					{
						attrs: A2(elm$core$List$cons, x, acc.attrs)
					});
			case 'Internal':
				var x = opt.a;
				return _Utils_update(
					acc,
					{
						internal: A2(elm$core$List$cons, x, acc.internal)
					});
			case 'Many':
				var opts = opt.a;
				return A3(elm$core$List$foldl, aforemny$elm_mdc$Internal$Options$collect1, acc, opts);
			case 'Set':
				var g = opt.a;
				return _Utils_update(
					acc,
					{
						config: g(acc.config)
					});
			case 'Listener':
				var event = opt.a;
				var decoder = opt.b;
				return _Utils_update(
					acc,
					{
						dispatch: A3(aforemny$elm_mdc$Internal$Dispatch$add, event, decoder, acc.dispatch)
					});
			case 'Lift':
				var lift = opt.a;
				return _Utils_update(
					acc,
					{
						dispatch: A2(aforemny$elm_mdc$Internal$Dispatch$setLift, lift, acc.dispatch)
					});
			default:
				return acc;
		}
	});
var aforemny$elm_mdc$Internal$Options$recollect = elm$core$List$foldl(aforemny$elm_mdc$Internal$Options$collect1);
var aforemny$elm_mdc$Internal$Options$apply = F4(
	function (summary, ctor, options, attrs) {
		return ctor(
			A2(
				aforemny$elm_mdc$Internal$Options$addAttributes,
				A2(aforemny$elm_mdc$Internal$Options$recollect, summary, options),
				attrs));
	});
var aforemny$elm_mdc$Internal$Options$Attribute = function (a) {
	return {$: 'Attribute', a: a};
};
var aforemny$elm_mdc$Internal$Options$aria = F2(
	function (key, val) {
		return aforemny$elm_mdc$Internal$Options$Attribute(
			A2(elm$html$Html$Attributes$attribute, 'aria-' + key, val));
	});
var aforemny$elm_mdc$Internal$Dispatch$defaultConfig = aforemny$elm_mdc$Internal$Dispatch$Config(
	{decoders: elm$core$Dict$empty, lift: elm$core$Maybe$Nothing});
var aforemny$elm_mdc$Internal$Options$Summary = F6(
	function (classes, css, attrs, internal, dispatch, config) {
		return {attrs: attrs, classes: classes, config: config, css: css, dispatch: dispatch, internal: internal};
	});
var aforemny$elm_mdc$Internal$Options$collect = A2(
	elm$core$Basics$composeR,
	A5(aforemny$elm_mdc$Internal$Options$Summary, _List_Nil, _List_Nil, _List_Nil, _List_Nil, aforemny$elm_mdc$Internal$Dispatch$defaultConfig),
	aforemny$elm_mdc$Internal$Options$recollect);
var elm$virtual_dom$VirtualDom$node = function (tag) {
	return _VirtualDom_node(
		_VirtualDom_noScript(tag));
};
var elm$html$Html$node = elm$virtual_dom$VirtualDom$node;
var elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var elm$html$Html$text = elm$virtual_dom$VirtualDom$text;
var aforemny$elm_mdc$Internal$Icon$Implementation$view = F2(
	function (options, name) {
		var summary = A2(aforemny$elm_mdc$Internal$Options$collect, aforemny$elm_mdc$Internal$Icon$Implementation$defaultConfig, options);
		var config = summary.config;
		return A5(
			aforemny$elm_mdc$Internal$Options$apply,
			summary,
			elm$html$Html$node(config.node),
			_List_fromArray(
				[
					aforemny$elm_mdc$Internal$Options$cs('material-icons'),
					A2(aforemny$elm_mdc$Internal$Options$aria, 'hidden', 'true')
				]),
			_List_Nil,
			_List_fromArray(
				[
					elm$html$Html$text(name)
				]));
	});
var elm$virtual_dom$VirtualDom$mapAttribute = _VirtualDom_mapAttribute;
var elm$html$Html$Attributes$map = elm$virtual_dom$VirtualDom$mapAttribute;
var aforemny$elm_mdc$Internal$Options$attribute = A2(
	elm$core$Basics$composeL,
	aforemny$elm_mdc$Internal$Options$Attribute,
	elm$html$Html$Attributes$map(elm$core$Basics$never));
var aforemny$elm_mdc$Internal$Options$Many = function (a) {
	return {$: 'Many', a: a};
};
var aforemny$elm_mdc$Internal$Options$many = aforemny$elm_mdc$Internal$Options$Many;
var aforemny$elm_mdc$Internal$Options$None = {$: 'None'};
var aforemny$elm_mdc$Internal$Options$nop = aforemny$elm_mdc$Internal$Options$None;
var aforemny$elm_mdc$Internal$Options$Listener = F2(
	function (a, b) {
		return {$: 'Listener', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Options$on = F2(
	function (event, decodeMessage) {
		return A2(
			aforemny$elm_mdc$Internal$Options$Listener,
			event,
			A2(
				elm$json$Json$Decode$map,
				function (message) {
					return {message: message, preventDefault: false, stopPropagation: false};
				},
				decodeMessage));
	});
var aforemny$elm_mdc$Internal$Options$onClick = function (msg) {
	return A2(
		aforemny$elm_mdc$Internal$Options$on,
		'click',
		elm$json$Json$Decode$succeed(msg));
};
var aforemny$elm_mdc$Internal$Options$when = F2(
	function (guard, prop) {
		return guard ? prop : aforemny$elm_mdc$Internal$Options$nop;
	});
var aforemny$elm_mdc$Internal$Options$data = F2(
	function (key, val) {
		return aforemny$elm_mdc$Internal$Options$Attribute(
			A2(elm$html$Html$Attributes$attribute, 'data-' + key, val));
	});
var aforemny$elm_mdc$Material$Options$data = aforemny$elm_mdc$Internal$Options$data;
var aforemny$elm_mdc$Material$Options$many = aforemny$elm_mdc$Internal$Options$many;
var aforemny$elm_mdc$Material$Options$on = aforemny$elm_mdc$Internal$Options$on;
var aforemny$elm_mdc$Internal$GlobalEvents$listener = F2(
	function (name, decoder) {
		return aforemny$elm_mdc$Material$Options$many(
			_List_fromArray(
				[
					A2(aforemny$elm_mdc$Material$Options$on, name, decoder),
					A2(aforemny$elm_mdc$Material$Options$data, name, '{}')
				]));
	});
var aforemny$elm_mdc$Internal$GlobalEvents$onMouseUp = aforemny$elm_mdc$Internal$GlobalEvents$listener('globalmouseup');
var aforemny$elm_mdc$Internal$GlobalEvents$onPointerUp = aforemny$elm_mdc$Internal$GlobalEvents$listener('globalpointerup');
var aforemny$elm_mdc$Internal$GlobalEvents$onTick = aforemny$elm_mdc$Internal$GlobalEvents$listener('globaltick');
var aforemny$elm_mdc$Internal$GlobalEvents$onTouchEnd = aforemny$elm_mdc$Internal$GlobalEvents$listener('globaltouchend');
var elm$html$Html$Attributes$id = elm$html$Html$Attributes$stringProperty('id');
var aforemny$elm_mdc$Internal$Options$id = A2(elm$core$Basics$composeL, aforemny$elm_mdc$Internal$Options$Attribute, elm$html$Html$Attributes$id);
var aforemny$elm_mdc$Internal$Options$CSS = function (a) {
	return {$: 'CSS', a: a};
};
var aforemny$elm_mdc$Internal$Options$css = F2(
	function (key, value) {
		return aforemny$elm_mdc$Internal$Options$CSS(
			_Utils_Tuple2(key, value));
	});
var aforemny$elm_mdc$Internal$Ripple$Model$strings = {varFgScale: '--mdc-ripple-fg-scale', varFgSize: '--mdc-ripple-fg-size', varFgTranslateEnd: '--mdc-ripple-fg-translate-end', varFgTranslateStart: '--mdc-ripple-fg-translate-start', varLeft: '--mdc-ripple-left', varTop: '--mdc-ripple-top'};
var elm$core$Basics$round = _Basics_round;
var aforemny$elm_mdc$Internal$Ripple$Implementation$cssVariables = F2(
	function (isUnbounded, _n0) {
		var fgScale = _n0.fgScale;
		var translateStart = _n0.translateStart;
		var translateEnd = _n0.translateEnd;
		var initialSize = _n0.initialSize;
		var frame = _n0.frame;
		var unboundedCoords = isUnbounded ? {
			left: elm$core$Basics$round((frame.width - initialSize) / 2),
			top: elm$core$Basics$round((frame.height - initialSize) / 2)
		} : {left: 0, top: 0};
		var fgSize = elm$core$String$fromInt(initialSize) + 'px';
		var variables = elm$core$List$concat(
			_List_fromArray(
				[
					_List_fromArray(
					[
						A2(aforemny$elm_mdc$Internal$Options$css, aforemny$elm_mdc$Internal$Ripple$Model$strings.varFgSize, fgSize),
						A2(
						aforemny$elm_mdc$Internal$Options$css,
						aforemny$elm_mdc$Internal$Ripple$Model$strings.varFgScale,
						elm$core$String$fromFloat(fgScale))
					]),
					isUnbounded ? _List_fromArray(
					[
						A2(
						aforemny$elm_mdc$Internal$Options$css,
						aforemny$elm_mdc$Internal$Ripple$Model$strings.varTop,
						elm$core$String$fromFloat(unboundedCoords.top) + 'px'),
						A2(
						aforemny$elm_mdc$Internal$Options$css,
						aforemny$elm_mdc$Internal$Ripple$Model$strings.varLeft,
						elm$core$String$fromFloat(unboundedCoords.left) + 'px')
					]) : _List_fromArray(
					[
						A2(aforemny$elm_mdc$Internal$Options$css, aforemny$elm_mdc$Internal$Ripple$Model$strings.varFgTranslateStart, translateStart),
						A2(aforemny$elm_mdc$Internal$Options$css, aforemny$elm_mdc$Internal$Ripple$Model$strings.varFgTranslateEnd, translateEnd)
					])
				]));
		return variables;
	});
var aforemny$elm_mdc$Internal$Ripple$Model$Activate0 = F2(
	function (a, b) {
		return {$: 'Activate0', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Ripple$Model$Event = F2(
	function (eventType, pagePoint) {
		return {eventType: eventType, pagePoint: pagePoint};
	});
var elm$json$Json$Decode$andThen = _Json_andThen;
var elm$json$Json$Decode$field = _Json_decodeField;
var elm$json$Json$Decode$at = F2(
	function (fields, decoder) {
		return A3(elm$core$List$foldr, elm$json$Json$Decode$field, decoder, fields);
	});
var elm$json$Json$Decode$fail = _Json_fail;
var elm$json$Json$Decode$float = _Json_decodeFloat;
var elm$json$Json$Decode$list = _Json_decodeList;
var elm$json$Json$Decode$map3 = _Json_map3;
var elm$json$Json$Decode$oneOf = _Json_oneOf;
var elm$json$Json$Decode$string = _Json_decodeString;
var aforemny$elm_mdc$Internal$Ripple$Implementation$decodeActivate = function (_n0) {
	var domId = _n0.domId;
	var isUnbounded = _n0.isUnbounded;
	var isActivated = _n0.isActivated;
	var previousActivationEvent = _n0.previousActivationEvent;
	var decodePagePoint = A3(
		elm$json$Json$Decode$map2,
		F2(
			function (pageX, pageY) {
				return {pageX: pageX, pageY: pageY};
			}),
		A2(
			elm$json$Json$Decode$at,
			_List_fromArray(
				['pageX']),
			elm$json$Json$Decode$float),
		A2(
			elm$json$Json$Decode$at,
			_List_fromArray(
				['pageY']),
			elm$json$Json$Decode$float));
	var firstChangedTouch = A2(
		elm$json$Json$Decode$andThen,
		function (changedTouches) {
			var _n3 = elm$core$List$head(changedTouches);
			if (_n3.$ === 'Just') {
				var pagePoint = _n3.a;
				return elm$json$Json$Decode$succeed(pagePoint);
			} else {
				return elm$json$Json$Decode$fail('');
			}
		},
		A2(
			elm$json$Json$Decode$at,
			_List_fromArray(
				['changedTouches']),
			elm$json$Json$Decode$list(decodePagePoint)));
	var decodeIsSurfaceDisabled = elm$json$Json$Decode$oneOf(
		_List_fromArray(
			[
				A2(
				elm$json$Json$Decode$map,
				elm$core$Basics$always(true),
				A2(
					elm$json$Json$Decode$at,
					_List_fromArray(
						['disabled']),
					elm$json$Json$Decode$string)),
				elm$json$Json$Decode$succeed(false)
			]));
	var decodeEventType = A2(
		elm$json$Json$Decode$at,
		_List_fromArray(
			['type']),
		elm$json$Json$Decode$string);
	var decodeIsSameInteraction = function () {
		if (previousActivationEvent.$ === 'Nothing') {
			return elm$json$Json$Decode$succeed(false);
		} else {
			var event = previousActivationEvent.a;
			return A2(
				elm$json$Json$Decode$map,
				elm$core$Basics$eq(event.eventType),
				decodeEventType);
		}
	}();
	var decodeEvent = A2(
		elm$json$Json$Decode$andThen,
		function (eventType) {
			if (eventType === 'touchstart') {
				return A2(
					elm$json$Json$Decode$map,
					aforemny$elm_mdc$Internal$Ripple$Model$Event(eventType),
					firstChangedTouch);
			} else {
				return A2(
					elm$json$Json$Decode$map,
					aforemny$elm_mdc$Internal$Ripple$Model$Event(eventType),
					decodePagePoint);
			}
		},
		decodeEventType);
	return A2(
		elm$json$Json$Decode$andThen,
		A2(
			elm$core$Basics$composeR,
			elm$core$Maybe$map(elm$json$Json$Decode$succeed),
			elm$core$Maybe$withDefault(
				elm$json$Json$Decode$fail(''))),
		A4(
			elm$json$Json$Decode$map3,
			F3(
				function (isSurfaceDisabled, isSameInteraction, event) {
					return (isActivated || (isSurfaceDisabled || isSameInteraction)) ? elm$core$Maybe$Nothing : elm$core$Maybe$Just(
						A2(
							aforemny$elm_mdc$Internal$Ripple$Model$Activate0,
							domId,
							{event: event, isSurfaceDisabled: false, isUnbounded: isUnbounded, wasElementMadeActive: false}));
				}),
			decodeIsSurfaceDisabled,
			decodeIsSameInteraction,
			decodeEvent));
};
var aforemny$elm_mdc$Internal$Ripple$Model$ClientRect = F4(
	function (top, left, width, height) {
		return {height: height, left: left, top: top, width: width};
	});
var debois$elm_dom$DOM$offsetHeight = A2(elm$json$Json$Decode$field, 'offsetHeight', elm$json$Json$Decode$float);
var debois$elm_dom$DOM$offsetLeft = A2(elm$json$Json$Decode$field, 'offsetLeft', elm$json$Json$Decode$float);
var debois$elm_dom$DOM$offsetTop = A2(elm$json$Json$Decode$field, 'offsetTop', elm$json$Json$Decode$float);
var debois$elm_dom$DOM$offsetWidth = A2(elm$json$Json$Decode$field, 'offsetWidth', elm$json$Json$Decode$float);
var debois$elm_dom$DOM$target = function (decoder) {
	return A2(elm$json$Json$Decode$field, 'target', decoder);
};
var elm$json$Json$Decode$map4 = _Json_map4;
var aforemny$elm_mdc$Internal$Ripple$Implementation$decodeClientRect = debois$elm_dom$DOM$target(
	A5(elm$json$Json$Decode$map4, aforemny$elm_mdc$Internal$Ripple$Model$ClientRect, debois$elm_dom$DOM$offsetTop, debois$elm_dom$DOM$offsetLeft, debois$elm_dom$DOM$offsetWidth, debois$elm_dom$DOM$offsetHeight));
var aforemny$elm_mdc$Internal$Ripple$Model$Blur = {$: 'Blur'};
var aforemny$elm_mdc$Internal$Ripple$Model$Deactivate = {$: 'Deactivate'};
var aforemny$elm_mdc$Internal$Ripple$Model$Focus = {$: 'Focus'};
var aforemny$elm_mdc$Internal$Ripple$Model$SetCssVariables = F2(
	function (a, b) {
		return {$: 'SetCssVariables', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Ripple$Model$activationEventTypes = _List_fromArray(
	['touchstart', 'pointerdown', 'mousedown']);
var aforemny$elm_mdc$Internal$Ripple$Model$cssClasses = {bgFocused: 'mdc-ripple-upgraded--background-focused', fgActivation: 'mdc-ripple-upgraded--foreground-activation', fgDeactivation: 'mdc-ripple-upgraded--foreground-deactivation', root: 'mdc-ripple-upgraded', unbounded: 'mdc-ripple-upgraded--unbounded'};
var aforemny$elm_mdc$Internal$Ripple$Implementation$view = F5(
	function (isUnbounded, domId, lift, model, options) {
		var noStyle = elm$html$Html$text('');
		var focusHandler = A2(
			aforemny$elm_mdc$Internal$Options$on,
			'focus',
			elm$json$Json$Decode$succeed(
				lift(aforemny$elm_mdc$Internal$Ripple$Model$Focus)));
		var deactivateHandler = function (event) {
			var deactivate = elm$json$Json$Decode$succeed(
				lift(aforemny$elm_mdc$Internal$Ripple$Model$Deactivate));
			return aforemny$elm_mdc$Internal$Options$many(
				_List_fromArray(
					[
						aforemny$elm_mdc$Internal$GlobalEvents$onTouchEnd(deactivate),
						aforemny$elm_mdc$Internal$GlobalEvents$onMouseUp(deactivate),
						aforemny$elm_mdc$Internal$GlobalEvents$onPointerUp(deactivate)
					]));
		};
		var blurHandler = A2(
			aforemny$elm_mdc$Internal$Options$on,
			'blur',
			elm$json$Json$Decode$succeed(
				lift(aforemny$elm_mdc$Internal$Ripple$Model$Blur)));
		var baseProperties = aforemny$elm_mdc$Internal$Options$many(
			_List_fromArray(
				[
					aforemny$elm_mdc$Internal$Options$id(domId),
					aforemny$elm_mdc$Internal$Options$cs(aforemny$elm_mdc$Internal$Ripple$Model$cssClasses.root),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					isUnbounded,
					aforemny$elm_mdc$Internal$Options$cs(aforemny$elm_mdc$Internal$Ripple$Model$cssClasses.unbounded)),
					model.focused ? aforemny$elm_mdc$Internal$Options$cs(aforemny$elm_mdc$Internal$Ripple$Model$cssClasses.bgFocused) : aforemny$elm_mdc$Internal$Options$nop
				]));
		var baseInteractionHandler = aforemny$elm_mdc$Internal$Options$many(
			_List_fromArray(
				[focusHandler, blurHandler]));
		var activateHandler = aforemny$elm_mdc$Internal$Options$many(
			A2(
				elm$core$List$map,
				function (tipe) {
					return A2(
						aforemny$elm_mdc$Internal$Options$on,
						tipe,
						A2(
							elm$json$Json$Decode$map,
							lift,
							aforemny$elm_mdc$Internal$Ripple$Implementation$decodeActivate(
								{
									domId: domId,
									isActivated: function () {
										var _n3 = model.animationState;
										if (_n3.$ === 'Activated') {
											var activationState = _n3.a;
											return !activationState.deactivated;
										} else {
											return false;
										}
									}(),
									isUnbounded: isUnbounded,
									previousActivationEvent: function () {
										var _n4 = model.animationState;
										if (_n4.$ === 'Activated') {
											var activationEvent = _n4.a.activationEvent;
											return elm$core$Maybe$Just(activationEvent);
										} else {
											return elm$core$Maybe$Nothing;
										}
									}()
								})));
				},
				aforemny$elm_mdc$Internal$Ripple$Model$activationEventTypes));
		var _n0 = model.animationState;
		switch (_n0.$) {
			case 'Idle':
				var interactionHandler = aforemny$elm_mdc$Internal$Options$many(
					_List_fromArray(
						[baseInteractionHandler, activateHandler]));
				var cssVars = function () {
					var _n1 = model.clientRect;
					if (_n1.$ === 'Just') {
						var clientRect = _n1.a;
						var _n2 = A2(aforemny$elm_mdc$Internal$Ripple$Implementation$layoutInternal, isUnbounded, clientRect);
						var fgScale = _n2.fgScale;
						var initialSize = _n2.initialSize;
						return A2(
							aforemny$elm_mdc$Internal$Ripple$Implementation$cssVariables,
							isUnbounded,
							{fgScale: fgScale, frame: clientRect, initialSize: initialSize, translateEnd: '0px', translateStart: '0px'});
					} else {
						return _List_Nil;
					}
				}();
				var properties = aforemny$elm_mdc$Internal$Options$many(
					_List_fromArray(
						[
							baseProperties,
							aforemny$elm_mdc$Internal$Options$many(cssVars),
							A2(
							aforemny$elm_mdc$Internal$Options$when,
							_Utils_eq(model.clientRect, elm$core$Maybe$Nothing),
							aforemny$elm_mdc$Internal$GlobalEvents$onTick(
								A2(
									elm$json$Json$Decode$map,
									A2(
										elm$core$Basics$composeL,
										lift,
										aforemny$elm_mdc$Internal$Ripple$Model$SetCssVariables(isUnbounded)),
									aforemny$elm_mdc$Internal$Ripple$Implementation$decodeClientRect)))
						]));
				return {interactionHandler: interactionHandler, properties: properties, style: noStyle};
			case 'Activated':
				var activatedData = _n0.a;
				var interactionHandler = aforemny$elm_mdc$Internal$Options$many(
					_List_fromArray(
						[
							baseInteractionHandler,
							activateHandler,
							deactivateHandler(activatedData.activationEvent)
						]));
				var cssVars = A2(
					aforemny$elm_mdc$Internal$Ripple$Implementation$cssVariables,
					isUnbounded,
					{fgScale: activatedData.fgScale, frame: activatedData.frame, initialSize: activatedData.initialSize, translateEnd: activatedData.translateEnd, translateStart: activatedData.translateStart});
				var properties = aforemny$elm_mdc$Internal$Options$many(
					_List_fromArray(
						[
							baseProperties,
							aforemny$elm_mdc$Internal$Options$many(cssVars),
							aforemny$elm_mdc$Internal$Options$cs(aforemny$elm_mdc$Internal$Ripple$Model$cssClasses.fgActivation),
							A2(
							aforemny$elm_mdc$Internal$Options$when,
							isUnbounded,
							A2(aforemny$elm_mdc$Internal$Options$data, 'mdc-ripple-is-unbounded', '1'))
						]));
				return {interactionHandler: interactionHandler, properties: properties, style: noStyle};
			default:
				var activatedData = _n0.a;
				var interactionHandler = aforemny$elm_mdc$Internal$Options$many(
					_List_fromArray(
						[baseInteractionHandler, activateHandler]));
				var cssVars = A2(
					aforemny$elm_mdc$Internal$Ripple$Implementation$cssVariables,
					isUnbounded,
					{fgScale: activatedData.fgScale, frame: activatedData.frame, initialSize: activatedData.initialSize, translateEnd: activatedData.translateEnd, translateStart: activatedData.translateStart});
				var properties = aforemny$elm_mdc$Internal$Options$many(
					_List_fromArray(
						[
							baseProperties,
							aforemny$elm_mdc$Internal$Options$many(cssVars),
							aforemny$elm_mdc$Internal$Options$cs(aforemny$elm_mdc$Internal$Ripple$Model$cssClasses.fgDeactivation)
						]));
				return {interactionHandler: interactionHandler, properties: properties, style: noStyle};
		}
	});
var elm$html$Html$a = _VirtualDom_node('a');
var elm$html$Html$button = _VirtualDom_node('button');
var elm$json$Json$Encode$bool = _Json_wrap;
var elm$html$Html$Attributes$boolProperty = F2(
	function (key, bool) {
		return A2(
			_VirtualDom_property,
			key,
			elm$json$Json$Encode$bool(bool));
	});
var elm$html$Html$Attributes$disabled = elm$html$Html$Attributes$boolProperty('disabled');
var elm$html$Html$Attributes$href = function (url) {
	return A2(
		elm$html$Html$Attributes$stringProperty,
		'href',
		_VirtualDom_noJavaScriptUri(url));
};
var aforemny$elm_mdc$Internal$Button$Implementation$button = F5(
	function (domId, lift, model, options, nodes) {
		var rippleInterface = A5(
			aforemny$elm_mdc$Internal$Ripple$Implementation$view,
			false,
			domId,
			A2(elm$core$Basics$composeL, lift, aforemny$elm_mdc$Internal$Button$Model$RippleMsg),
			model.ripple,
			_List_Nil);
		var summary = A2(aforemny$elm_mdc$Internal$Options$collect, aforemny$elm_mdc$Internal$Button$Implementation$defaultConfig, options);
		var config = summary.config;
		return A5(
			aforemny$elm_mdc$Internal$Options$apply,
			summary,
			(!_Utils_eq(config.link, elm$core$Maybe$Nothing)) ? elm$html$Html$a : elm$html$Html$button,
			_List_fromArray(
				[
					aforemny$elm_mdc$Internal$Options$cs('mdc-button'),
					aforemny$elm_mdc$Internal$Options$cs('mdc-js-button'),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					summary.config.ripple,
					aforemny$elm_mdc$Internal$Options$cs('mdc-js-ripple-effect')),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					(!_Utils_eq(config.link, elm$core$Maybe$Nothing)) && (!config.disabled),
					aforemny$elm_mdc$Internal$Options$attribute(
						elm$html$Html$Attributes$href(
							A2(elm$core$Maybe$withDefault, '', config.link)))),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.disabled,
					aforemny$elm_mdc$Internal$Options$attribute(
						elm$html$Html$Attributes$disabled(true))),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.disabled,
					aforemny$elm_mdc$Internal$Options$cs('mdc-button--disabled')),
					A3(
					elm$core$Basics$composeL,
					aforemny$elm_mdc$Internal$Options$when(config.ripple),
					aforemny$elm_mdc$Internal$Options$many,
					_List_fromArray(
						[rippleInterface.interactionHandler, rippleInterface.properties])),
					A2(
					elm$core$Maybe$withDefault,
					aforemny$elm_mdc$Internal$Options$nop,
					A2(
						elm$core$Maybe$map,
						A2(
							elm$core$Basics$composeL,
							A2(elm$core$Basics$composeL, aforemny$elm_mdc$Internal$Options$onClick, lift),
							aforemny$elm_mdc$Internal$Button$Model$Click(config.ripple)),
						config.onClick))
				]),
			_List_Nil,
			elm$core$List$concat(
				_List_fromArray(
					[
						(!config.trailingIcon) ? A2(
						elm$core$Maybe$withDefault,
						_List_Nil,
						A2(
							elm$core$Maybe$map,
							function (icon_) {
								return _List_fromArray(
									[
										A2(
										aforemny$elm_mdc$Internal$Icon$Implementation$view,
										_List_fromArray(
											[
												aforemny$elm_mdc$Internal$Options$cs('mdc-button__icon')
											]),
										icon_)
									]);
							},
							config.icon)) : _List_Nil,
						nodes,
						config.trailingIcon ? A2(
						elm$core$Maybe$withDefault,
						_List_Nil,
						A2(
							elm$core$Maybe$map,
							function (icon_) {
								return _List_fromArray(
									[
										A2(
										aforemny$elm_mdc$Internal$Icon$Implementation$view,
										_List_fromArray(
											[
												aforemny$elm_mdc$Internal$Options$cs('mdc-button__icon')
											]),
										icon_)
									]);
							},
							config.icon)) : _List_Nil
					])));
	});
var aforemny$elm_mdc$Internal$Msg$Dispatch = function (a) {
	return {$: 'Dispatch', a: a};
};
var aforemny$elm_mdc$Internal$Options$Lift = function (a) {
	return {$: 'Lift', a: a};
};
var aforemny$elm_mdc$Internal$Options$dispatch = function (lift) {
	return aforemny$elm_mdc$Internal$Options$Lift(
		elm$json$Json$Decode$map(
			function (_n0) {
				var message = _n0.message;
				var stopPropagation = _n0.stopPropagation;
				var preventDefault = _n0.preventDefault;
				return {
					message: lift(
						aforemny$elm_mdc$Internal$Msg$Dispatch(message)),
					preventDefault: preventDefault,
					stopPropagation: stopPropagation
				};
			}));
};
var aforemny$elm_mdc$Internal$Component$render = F3(
	function (get_model, view, ctor) {
		return F4(
			function (lift, idx, store, options) {
				return A3(
					view,
					A2(
						elm$core$Basics$composeL,
						lift,
						ctor(idx)),
					A2(get_model, idx, store),
					A2(
						elm$core$List$cons,
						aforemny$elm_mdc$Internal$Options$dispatch(lift),
						options));
			});
	});
var aforemny$elm_mdc$Internal$Button$Implementation$view = F2(
	function (lift, index) {
		return A5(
			aforemny$elm_mdc$Internal$Component$render,
			aforemny$elm_mdc$Internal$Button$Implementation$getSet.get,
			aforemny$elm_mdc$Internal$Button$Implementation$button(index),
			aforemny$elm_mdc$Internal$Msg$ButtonMsg,
			lift,
			index);
	});
var aforemny$elm_mdc$Material$Button$view = aforemny$elm_mdc$Internal$Button$Implementation$view;
var aforemny$elm_mdc$Material$Options$onClick = aforemny$elm_mdc$Internal$Options$onClick;
var elm$html$Html$div = _VirtualDom_node('div');
var elm$html$Html$p = _VirtualDom_node('p');
var aforemny$elm_mdc$Main$loginPage = function (model) {
	return A2(
		elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				elm$html$Html$p,
				_List_Nil,
				_List_fromArray(
					[
						elm$html$Html$text('You have logged out!')
					])),
				A5(
				aforemny$elm_mdc$Material$Button$view,
				aforemny$elm_mdc$Main$Mdc,
				'login-button',
				model.mdc,
				_List_fromArray(
					[
						aforemny$elm_mdc$Material$Button$ripple,
						aforemny$elm_mdc$Material$Button$raised,
						aforemny$elm_mdc$Material$Options$onClick(aforemny$elm_mdc$Main$LoginRequest)
					]),
				_List_fromArray(
					[
						elm$html$Html$text('Login')
					]))
			]));
};
var aforemny$elm_mdc$Main$ToggleDrawer = {$: 'ToggleDrawer'};
var aforemny$elm_mdc$Internal$Checkbox$Model$Checked = {$: 'Checked'};
var aforemny$elm_mdc$Internal$Checkbox$Model$Unchecked = {$: 'Unchecked'};
var aforemny$elm_mdc$Internal$Checkbox$Implementation$checked = function (value) {
	var state = value ? aforemny$elm_mdc$Internal$Checkbox$Model$Checked : aforemny$elm_mdc$Internal$Checkbox$Model$Unchecked;
	return aforemny$elm_mdc$Internal$Options$option(
		function (config) {
			return _Utils_update(
				config,
				{
					state: elm$core$Maybe$Just(state)
				});
		});
};
var aforemny$elm_mdc$Material$Checkbox$checked = aforemny$elm_mdc$Internal$Checkbox$Implementation$checked;
var aforemny$elm_mdc$Internal$Checkbox$Implementation$defaultConfig = {disabled: false, id_: '', nativeControl: _List_Nil, state: elm$core$Maybe$Nothing};
var aforemny$elm_mdc$Internal$Checkbox$Model$AnimationEnd = {$: 'AnimationEnd'};
var aforemny$elm_mdc$Internal$Checkbox$Model$Init = F2(
	function (a, b) {
		return {$: 'Init', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Checkbox$Model$NoOp = {$: 'NoOp'};
var aforemny$elm_mdc$Internal$Checkbox$Model$SetFocus = function (a) {
	return {$: 'SetFocus', a: a};
};
var aforemny$elm_mdc$Internal$Dispatch$clear = function (_n0) {
	var config = _n0.a;
	return aforemny$elm_mdc$Internal$Dispatch$Config(
		_Utils_update(
			config,
			{decoders: elm$core$Dict$empty}));
};
var aforemny$elm_mdc$Internal$Options$applyNativeControl = F3(
	function (summary, ctor, options) {
		return ctor(
			A2(
				aforemny$elm_mdc$Internal$Options$addAttributes,
				A2(
					aforemny$elm_mdc$Internal$Options$recollect,
					{
						attrs: _List_Nil,
						classes: _List_Nil,
						config: _Utils_Tuple0,
						css: _List_Nil,
						dispatch: aforemny$elm_mdc$Internal$Dispatch$clear(summary.dispatch),
						internal: _List_Nil
					},
					_Utils_ap(summary.config.nativeControl, options)),
				_List_Nil));
	});
var aforemny$elm_mdc$Internal$Options$onBlur = function (msg) {
	return A2(
		aforemny$elm_mdc$Internal$Options$on,
		'blur',
		elm$json$Json$Decode$succeed(msg));
};
var aforemny$elm_mdc$Internal$Options$onFocus = function (msg) {
	return A2(
		aforemny$elm_mdc$Internal$Options$on,
		'focus',
		elm$json$Json$Decode$succeed(msg));
};
var aforemny$elm_mdc$Internal$Options$onWithOptions = function (evt) {
	return aforemny$elm_mdc$Internal$Options$Listener(evt);
};
var aforemny$elm_mdc$Internal$Options$collect1_ = F2(
	function (options, acc) {
		switch (options.$) {
			case 'Class':
				var x = options.a;
				return _Utils_update(
					acc,
					{
						classes: A2(elm$core$List$cons, x, acc.classes)
					});
			case 'CSS':
				var x = options.a;
				return _Utils_update(
					acc,
					{
						css: A2(elm$core$List$cons, x, acc.css)
					});
			case 'Attribute':
				var x = options.a;
				return _Utils_update(
					acc,
					{
						attrs: A2(elm$core$List$cons, x, acc.attrs)
					});
			case 'Internal':
				var x = options.a;
				return _Utils_update(
					acc,
					{
						internal: A2(elm$core$List$cons, x, acc.internal)
					});
			case 'Listener':
				var event = options.a;
				var decoder = options.b;
				return _Utils_update(
					acc,
					{
						dispatch: A3(aforemny$elm_mdc$Internal$Dispatch$add, event, decoder, acc.dispatch)
					});
			case 'Many':
				var opts = options.a;
				return A3(elm$core$List$foldl, aforemny$elm_mdc$Internal$Options$collect1_, acc, opts);
			case 'Lift':
				var lift = options.a;
				return _Utils_update(
					acc,
					{
						dispatch: A2(aforemny$elm_mdc$Internal$Dispatch$setLift, lift, acc.dispatch)
					});
			case 'Set':
				return acc;
			default:
				return acc;
		}
	});
var aforemny$elm_mdc$Internal$Options$collect_ = A2(
	elm$core$List$foldl,
	aforemny$elm_mdc$Internal$Options$collect1_,
	A6(aforemny$elm_mdc$Internal$Options$Summary, _List_Nil, _List_Nil, _List_Nil, _List_Nil, aforemny$elm_mdc$Internal$Dispatch$defaultConfig, _Utils_Tuple0));
var aforemny$elm_mdc$Internal$Options$styled = F2(
	function (ctor, props) {
		return ctor(
			A2(
				aforemny$elm_mdc$Internal$Options$addAttributes,
				aforemny$elm_mdc$Internal$Options$collect_(props),
				_List_Nil));
	});
var elm$html$Html$input = _VirtualDom_node('input');
var elm$html$Html$Attributes$checked = elm$html$Html$Attributes$boolProperty('checked');
var elm$virtual_dom$VirtualDom$property = F2(
	function (key, value) {
		return A2(
			_VirtualDom_property,
			_VirtualDom_noInnerHtmlOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var elm$html$Html$Attributes$property = elm$virtual_dom$VirtualDom$property;
var elm$html$Html$Attributes$type_ = elm$html$Html$Attributes$stringProperty('type');
var elm$svg$Svg$trustedNode = _VirtualDom_nodeNS('http://www.w3.org/2000/svg');
var elm$svg$Svg$path = elm$svg$Svg$trustedNode('path');
var elm$svg$Svg$svg = elm$svg$Svg$trustedNode('svg');
var elm$svg$Svg$Attributes$class = _VirtualDom_attribute('class');
var elm$svg$Svg$Attributes$d = _VirtualDom_attribute('d');
var elm$svg$Svg$Attributes$fill = _VirtualDom_attribute('fill');
var elm$svg$Svg$Attributes$stroke = _VirtualDom_attribute('stroke');
var elm$svg$Svg$Attributes$viewBox = _VirtualDom_attribute('viewBox');
var aforemny$elm_mdc$Internal$Checkbox$Implementation$checkbox = F4(
	function (lift, model, options, _n0) {
		var animationClass = function (animation) {
			if (animation.$ === 'Just') {
				switch (animation.a.$) {
					case 'UncheckedChecked':
						var _n2 = animation.a;
						return aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox--anim-unchecked-checked');
					case 'UncheckedIndeterminate':
						var _n3 = animation.a;
						return aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox--anim-unchecked-indeterminate');
					case 'CheckedUnchecked':
						var _n4 = animation.a;
						return aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox--anim-checked-unchecked');
					case 'CheckedIndeterminate':
						var _n5 = animation.a;
						return aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox--anim-checked-indeterminate');
					case 'IndeterminateChecked':
						var _n6 = animation.a;
						return aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox--anim-indeterminate-checked');
					default:
						var _n7 = animation.a;
						return aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox--anim-indeterminate-unchecked');
				}
			} else {
				return aforemny$elm_mdc$Internal$Options$nop;
			}
		};
		var summary = A2(aforemny$elm_mdc$Internal$Options$collect, aforemny$elm_mdc$Internal$Checkbox$Implementation$defaultConfig, options);
		var config = summary.config;
		var configState = config.state;
		var currentState = A2(elm$core$Maybe$withDefault, configState, model.lastKnownState);
		var stateChangedOrUninitialized = _Utils_eq(model.lastKnownState, elm$core$Maybe$Nothing) || (!_Utils_eq(currentState, configState));
		return A5(
			aforemny$elm_mdc$Internal$Options$apply,
			summary,
			elm$html$Html$div,
			_List_fromArray(
				[
					aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox mdc-checkbox--upgraded'),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					_Utils_eq(currentState, elm$core$Maybe$Nothing),
					aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox--indeterminate')),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					_Utils_eq(
						currentState,
						elm$core$Maybe$Just(aforemny$elm_mdc$Internal$Checkbox$Model$Checked)),
					aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox--checked')),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.disabled,
					aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox--disabled')),
					animationClass(model.animation),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					stateChangedOrUninitialized,
					aforemny$elm_mdc$Internal$GlobalEvents$onTick(
						elm$json$Json$Decode$succeed(
							lift(
								A2(aforemny$elm_mdc$Internal$Checkbox$Model$Init, model.lastKnownState, configState))))),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					!_Utils_eq(model.animation, elm$core$Maybe$Nothing),
					A2(
						aforemny$elm_mdc$Internal$Options$on,
						'animationend',
						elm$json$Json$Decode$succeed(
							lift(aforemny$elm_mdc$Internal$Checkbox$Model$AnimationEnd))))
				]),
			_List_Nil,
			_List_fromArray(
				[
					A4(
					aforemny$elm_mdc$Internal$Options$applyNativeControl,
					summary,
					elm$html$Html$input,
					_List_fromArray(
						[
							aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox__native-control'),
							A3(
							elm$core$Basics$composeL,
							aforemny$elm_mdc$Internal$Options$many,
							elm$core$List$map(aforemny$elm_mdc$Internal$Options$attribute),
							_List_fromArray(
								[
									elm$html$Html$Attributes$type_('checkbox'),
									elm$html$Html$Attributes$id(config.id_),
									A2(
									elm$html$Html$Attributes$property,
									'indeterminate',
									elm$json$Json$Encode$bool(
										_Utils_eq(currentState, elm$core$Maybe$Nothing))),
									elm$html$Html$Attributes$checked(
									_Utils_eq(
										currentState,
										elm$core$Maybe$Just(aforemny$elm_mdc$Internal$Checkbox$Model$Checked))),
									elm$html$Html$Attributes$disabled(config.disabled)
								])),
							A2(
							aforemny$elm_mdc$Internal$Options$onWithOptions,
							'click',
							elm$json$Json$Decode$succeed(
								{
									message: lift(aforemny$elm_mdc$Internal$Checkbox$Model$NoOp),
									preventDefault: true,
									stopPropagation: false
								})),
							A2(
							aforemny$elm_mdc$Internal$Options$onWithOptions,
							'change',
							elm$json$Json$Decode$succeed(
								{
									message: lift(aforemny$elm_mdc$Internal$Checkbox$Model$NoOp),
									preventDefault: true,
									stopPropagation: false
								})),
							aforemny$elm_mdc$Internal$Options$onFocus(
							lift(
								aforemny$elm_mdc$Internal$Checkbox$Model$SetFocus(true))),
							aforemny$elm_mdc$Internal$Options$onBlur(
							lift(
								aforemny$elm_mdc$Internal$Checkbox$Model$SetFocus(false)))
						]),
					_List_Nil),
					A3(
					aforemny$elm_mdc$Internal$Options$styled,
					elm$html$Html$div,
					_List_fromArray(
						[
							aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox__background')
						]),
					_List_fromArray(
						[
							A2(
							elm$svg$Svg$svg,
							_List_fromArray(
								[
									elm$svg$Svg$Attributes$class('mdc-checkbox__checkmark'),
									elm$svg$Svg$Attributes$viewBox('0 0 24 24')
								]),
							_List_fromArray(
								[
									A2(
									elm$svg$Svg$path,
									_List_fromArray(
										[
											elm$svg$Svg$Attributes$class('mdc-checkbox__checkmark-path'),
											elm$svg$Svg$Attributes$fill('none'),
											elm$svg$Svg$Attributes$stroke('white'),
											elm$svg$Svg$Attributes$d('M1.73,12.91 8.1,19.28 22.79,4.59')
										]),
									_List_Nil)
								])),
							A3(
							aforemny$elm_mdc$Internal$Options$styled,
							elm$html$Html$div,
							_List_fromArray(
								[
									aforemny$elm_mdc$Internal$Options$cs('mdc-checkbox__mixedmark')
								]),
							_List_Nil)
						]))
				]));
	});
var aforemny$elm_mdc$Internal$Options$internalId = function (id_) {
	return aforemny$elm_mdc$Internal$Options$option(
		function (config) {
			return _Utils_update(
				config,
				{id_: id_});
		});
};
var aforemny$elm_mdc$Internal$Checkbox$Implementation$view = F4(
	function (lift, index, store, options) {
		return A7(
			aforemny$elm_mdc$Internal$Component$render,
			aforemny$elm_mdc$Internal$Checkbox$Implementation$getSet.get,
			aforemny$elm_mdc$Internal$Checkbox$Implementation$checkbox,
			aforemny$elm_mdc$Internal$Msg$CheckboxMsg,
			lift,
			index,
			store,
			A2(
				elm$core$List$cons,
				aforemny$elm_mdc$Internal$Options$internalId(index),
				options));
	});
var aforemny$elm_mdc$Material$Checkbox$view = aforemny$elm_mdc$Internal$Checkbox$Implementation$view;
var aforemny$elm_mdc$Internal$FormField$Implementation$view = function (options) {
	return A2(
		aforemny$elm_mdc$Internal$Options$styled,
		elm$html$Html$div,
		A2(
			elm$core$List$cons,
			aforemny$elm_mdc$Internal$Options$cs('mdc-form-field'),
			options));
};
var aforemny$elm_mdc$Material$FormField$view = aforemny$elm_mdc$Internal$FormField$Implementation$view;
var aforemny$elm_mdc$Internal$LayoutGrid$Implementation$cell = function (options) {
	return A2(
		aforemny$elm_mdc$Internal$Options$styled,
		elm$html$Html$div,
		A2(
			elm$core$List$cons,
			aforemny$elm_mdc$Internal$Options$cs('mdc-layout-grid__cell'),
			options));
};
var aforemny$elm_mdc$Material$LayoutGrid$cell = aforemny$elm_mdc$Internal$LayoutGrid$Implementation$cell;
var aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span = F2(
	function (device, value) {
		if (device.$ === 'Just') {
			var device_ = device.a;
			return aforemny$elm_mdc$Internal$Options$cs(
				'mdc-layout-grid__cell--span-' + (elm$core$String$fromInt(value) + ('-' + device_)));
		} else {
			return aforemny$elm_mdc$Internal$Options$cs(
				'mdc-layout-grid__cell--span-' + elm$core$String$fromInt(value));
		}
	});
var aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span3 = A2(aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span, elm$core$Maybe$Nothing, 3);
var aforemny$elm_mdc$Material$LayoutGrid$span3 = aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span3;
var aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span4Phone = A2(
	aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span,
	elm$core$Maybe$Just('phone'),
	4);
var aforemny$elm_mdc$Material$LayoutGrid$span4Phone = aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span4Phone;
var aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span6 = A2(aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span, elm$core$Maybe$Nothing, 6);
var aforemny$elm_mdc$Material$LayoutGrid$span6 = aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span6;
var aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span6Tablet = A2(
	aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span,
	elm$core$Maybe$Just('tablet'),
	6);
var aforemny$elm_mdc$Material$LayoutGrid$span6Tablet = aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span6Tablet;
var aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span8Tablet = A2(
	aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span,
	elm$core$Maybe$Just('tablet'),
	8);
var aforemny$elm_mdc$Material$LayoutGrid$span8Tablet = aforemny$elm_mdc$Internal$LayoutGrid$Implementation$span8Tablet;
var aforemny$elm_mdc$Internal$LayoutGrid$Implementation$inner = function (options) {
	return A2(
		aforemny$elm_mdc$Internal$Options$styled,
		elm$html$Html$div,
		A2(
			elm$core$List$cons,
			aforemny$elm_mdc$Internal$Options$cs('mdc-layout-grid__inner'),
			options));
};
var elm$core$List$singleton = function (value) {
	return _List_fromArray(
		[value]);
};
var aforemny$elm_mdc$Internal$LayoutGrid$Implementation$view = function (options) {
	return A2(
		elm$core$Basics$composeL,
		A2(
			elm$core$Basics$composeL,
			A2(
				aforemny$elm_mdc$Internal$Options$styled,
				elm$html$Html$div,
				A2(
					elm$core$List$cons,
					aforemny$elm_mdc$Internal$Options$cs('mdc-layout-grid'),
					options)),
			elm$core$List$singleton),
		aforemny$elm_mdc$Internal$LayoutGrid$Implementation$inner(_List_Nil));
};
var aforemny$elm_mdc$Material$LayoutGrid$view = aforemny$elm_mdc$Internal$LayoutGrid$Implementation$view;
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$fixedAdjust = aforemny$elm_mdc$Internal$Options$cs('mdc-top-app-bar--fixed-adjust');
var aforemny$elm_mdc$Material$TopAppBar$fixedAdjust = aforemny$elm_mdc$Internal$TopAppBar$Implementation$fixedAdjust;
var elm$html$Html$label = _VirtualDom_node('label');
var elm$virtual_dom$VirtualDom$Normal = function (a) {
	return {$: 'Normal', a: a};
};
var elm$html$Html$Events$on = F2(
	function (event, decoder) {
		return A2(
			elm$virtual_dom$VirtualDom$on,
			event,
			elm$virtual_dom$VirtualDom$Normal(decoder));
	});
var elm$html$Html$Events$onClick = function (msg) {
	return A2(
		elm$html$Html$Events$on,
		'click',
		elm$json$Json$Decode$succeed(msg));
};
var aforemny$elm_mdc$Main$viewContent = function (model) {
	return A2(
		aforemny$elm_mdc$Material$LayoutGrid$view,
		_List_fromArray(
			[aforemny$elm_mdc$Material$TopAppBar$fixedAdjust]),
		_List_fromArray(
			[
				A2(
				aforemny$elm_mdc$Material$LayoutGrid$cell,
				_List_fromArray(
					[aforemny$elm_mdc$Material$LayoutGrid$span3, aforemny$elm_mdc$Material$LayoutGrid$span8Tablet]),
				_List_Nil),
				A2(
				aforemny$elm_mdc$Material$LayoutGrid$cell,
				_List_fromArray(
					[aforemny$elm_mdc$Material$LayoutGrid$span6, aforemny$elm_mdc$Material$LayoutGrid$span6Tablet]),
				_List_fromArray(
					[
						A5(
						aforemny$elm_mdc$Material$Button$view,
						aforemny$elm_mdc$Main$Mdc,
						'my-button',
						model.mdc,
						_List_fromArray(
							[
								aforemny$elm_mdc$Material$Button$ripple,
								aforemny$elm_mdc$Material$Button$raised,
								aforemny$elm_mdc$Material$Options$onClick(aforemny$elm_mdc$Main$ToggleDrawer)
							]),
						_List_fromArray(
							[
								elm$html$Html$text('ka me!')
							])),
						A2(
						aforemny$elm_mdc$Material$FormField$view,
						_List_Nil,
						_List_fromArray(
							[
								A5(
								aforemny$elm_mdc$Material$Checkbox$view,
								aforemny$elm_mdc$Main$Mdc,
								'my-checkbox',
								model.mdc,
								_List_fromArray(
									[
										aforemny$elm_mdc$Material$Checkbox$checked(true),
										aforemny$elm_mdc$Material$Options$onClick(aforemny$elm_mdc$Main$ToggleDrawer)
									]),
								_List_Nil),
								A2(
								elm$html$Html$label,
								_List_fromArray(
									[
										elm$html$Html$Events$onClick(aforemny$elm_mdc$Main$ToggleDrawer)
									]),
								_List_fromArray(
									[
										elm$html$Html$text('My checkbox')
									]))
							]))
					])),
				A2(
				aforemny$elm_mdc$Material$LayoutGrid$cell,
				_List_fromArray(
					[aforemny$elm_mdc$Material$LayoutGrid$span3, aforemny$elm_mdc$Material$LayoutGrid$span4Phone]),
				_List_Nil)
			]));
};
var aforemny$elm_mdc$Internal$Drawer$Implementation$content = function (options) {
	return A2(
		aforemny$elm_mdc$Internal$Options$styled,
		elm$html$Html$div,
		A2(
			elm$core$List$cons,
			aforemny$elm_mdc$Internal$Options$cs('mdc-drawer__content'),
			options));
};
var aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$content = aforemny$elm_mdc$Internal$Drawer$Implementation$content;
var aforemny$elm_mdc$Material$Drawer$Dismissible$content = aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$content;
var elm$html$Html$header = _VirtualDom_node('header');
var aforemny$elm_mdc$Internal$Drawer$Implementation$header = function (options) {
	return A2(
		aforemny$elm_mdc$Internal$Options$styled,
		elm$html$Html$header,
		A2(
			elm$core$List$cons,
			aforemny$elm_mdc$Internal$Options$cs('mdc-drawer__header'),
			options));
};
var aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$header = aforemny$elm_mdc$Internal$Drawer$Implementation$header;
var aforemny$elm_mdc$Material$Drawer$Dismissible$header = aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$header;
var aforemny$elm_mdc$Internal$Drawer$Implementation$onClose = function (handler) {
	return aforemny$elm_mdc$Internal$Options$option(
		function (config) {
			return _Utils_update(
				config,
				{
					onClose: elm$core$Maybe$Just(handler)
				});
		});
};
var aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$onClose = aforemny$elm_mdc$Internal$Drawer$Implementation$onClose;
var aforemny$elm_mdc$Material$Drawer$Dismissible$onClose = aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$onClose;
var aforemny$elm_mdc$Internal$Drawer$Implementation$open = aforemny$elm_mdc$Internal$Options$option(
	function (config) {
		return _Utils_update(
			config,
			{open: true});
	});
var aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$open = aforemny$elm_mdc$Internal$Drawer$Implementation$open;
var aforemny$elm_mdc$Material$Drawer$Dismissible$open = aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$open;
var aforemny$elm_mdc$Internal$Drawer$Implementation$subTitle = aforemny$elm_mdc$Internal$Options$cs('mdc-drawer__subtitle');
var aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$subTitle = aforemny$elm_mdc$Internal$Drawer$Implementation$subTitle;
var aforemny$elm_mdc$Material$Drawer$Dismissible$subTitle = aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$subTitle;
var aforemny$elm_mdc$Internal$Drawer$Implementation$title = aforemny$elm_mdc$Internal$Options$cs('mdc-drawer__title');
var aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$title = aforemny$elm_mdc$Internal$Drawer$Implementation$title;
var aforemny$elm_mdc$Material$Drawer$Dismissible$title = aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$title;
var aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$className = 'mdc-drawer--dismissible';
var aforemny$elm_mdc$Internal$Drawer$Implementation$defaultConfig = {onClose: elm$core$Maybe$Nothing, open: false};
var aforemny$elm_mdc$Internal$Drawer$Model$EndAnimation = {$: 'EndAnimation'};
var aforemny$elm_mdc$Internal$Drawer$Model$NoOp = {$: 'NoOp'};
var aforemny$elm_mdc$Internal$Drawer$Model$StartAnimation = function (a) {
	return {$: 'StartAnimation', a: a};
};
var elm$html$Html$aside = _VirtualDom_node('aside');
var elm$json$Json$Decode$int = _Json_decodeInt;
var aforemny$elm_mdc$Internal$Drawer$Implementation$view = F5(
	function (className, lift, model, options, nodes) {
		var summary = A2(aforemny$elm_mdc$Internal$Options$collect, aforemny$elm_mdc$Internal$Drawer$Implementation$defaultConfig, options);
		var config = summary.config;
		var stateChanged = (!model.closeOnAnimationEnd) && (!_Utils_eq(config.open, model.open));
		return A3(
			aforemny$elm_mdc$Internal$Options$styled,
			elm$html$Html$aside,
			_Utils_ap(
				_List_fromArray(
					[
						aforemny$elm_mdc$Internal$Options$cs('mdc-drawer'),
						aforemny$elm_mdc$Internal$Options$cs(className),
						A2(
						aforemny$elm_mdc$Internal$Options$when,
						stateChanged,
						aforemny$elm_mdc$Internal$GlobalEvents$onTick(
							elm$json$Json$Decode$succeed(
								lift(
									aforemny$elm_mdc$Internal$Drawer$Model$StartAnimation(config.open))))),
						A2(
						aforemny$elm_mdc$Internal$Options$when,
						config.open || model.open,
						aforemny$elm_mdc$Internal$Options$cs('mdc-drawer--open')),
						A2(
						aforemny$elm_mdc$Internal$Options$when,
						config.open && (stateChanged || model.animating),
						aforemny$elm_mdc$Internal$Options$cs('mdc-drawer--animate')),
						A2(
						aforemny$elm_mdc$Internal$Options$when,
						config.open && model.animating,
						aforemny$elm_mdc$Internal$Options$cs('mdc-drawer--opening')),
						A2(
						aforemny$elm_mdc$Internal$Options$when,
						(!config.open) && model.animating,
						aforemny$elm_mdc$Internal$Options$cs('mdc-drawer--closing')),
						A2(
						aforemny$elm_mdc$Internal$Options$when,
						model.animating,
						A2(
							aforemny$elm_mdc$Internal$Options$on,
							'transitionend',
							elm$json$Json$Decode$succeed(
								lift(aforemny$elm_mdc$Internal$Drawer$Model$EndAnimation)))),
						A2(
						aforemny$elm_mdc$Internal$Options$when,
						(!elm$core$String$isEmpty(className)) && (config.open || model.open),
						A2(aforemny$elm_mdc$Internal$Options$data, 'focustrap', '{}')),
						A2(
						aforemny$elm_mdc$Internal$Options$on,
						'keydown',
						A3(
							elm$json$Json$Decode$map2,
							F2(
								function (key, keyCode) {
									return (_Utils_eq(
										key,
										elm$core$Maybe$Just('Escape')) || (keyCode === 27)) ? A2(
										elm$core$Maybe$withDefault,
										lift(aforemny$elm_mdc$Internal$Drawer$Model$NoOp),
										config.onClose) : lift(aforemny$elm_mdc$Internal$Drawer$Model$NoOp);
								}),
							elm$json$Json$Decode$oneOf(
								_List_fromArray(
									[
										A2(
										elm$json$Json$Decode$map,
										elm$core$Maybe$Just,
										A2(
											elm$json$Json$Decode$at,
											_List_fromArray(
												['key']),
											elm$json$Json$Decode$string)),
										elm$json$Json$Decode$succeed(elm$core$Maybe$Nothing)
									])),
							A2(
								elm$json$Json$Decode$at,
								_List_fromArray(
									['keyCode']),
								elm$json$Json$Decode$int)))
					]),
				options),
			nodes);
	});
var aforemny$elm_mdc$Internal$Drawer$Implementation$render = function (className) {
	return A3(
		aforemny$elm_mdc$Internal$Component$render,
		aforemny$elm_mdc$Internal$Drawer$Implementation$getSet.get,
		aforemny$elm_mdc$Internal$Drawer$Implementation$view(className),
		aforemny$elm_mdc$Internal$Msg$DrawerMsg);
};
var aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$view = aforemny$elm_mdc$Internal$Drawer$Implementation$render(aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$className);
var aforemny$elm_mdc$Material$Drawer$Dismissible$view = aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$view;
var aforemny$elm_mdc$Internal$List$Implementation$defaultConfig = {activated: false, isRadioGroup: false, isSingleSelectionList: false, node: elm$core$Maybe$Nothing, onSelectListItem: elm$core$Maybe$Nothing, selected: false, selectedIndex: elm$core$Maybe$Nothing, useActivated: false};
var aforemny$elm_mdc$Internal$List$Implementation$find = F2(
	function (predicate, list) {
		find:
		while (true) {
			if (!list.b) {
				return elm$core$Maybe$Nothing;
			} else {
				var first = list.a;
				var rest = list.b;
				if (predicate(first)) {
					return elm$core$Maybe$Just(first);
				} else {
					var $temp$predicate = predicate,
						$temp$list = rest;
					predicate = $temp$predicate;
					list = $temp$list;
					continue find;
				}
			}
		}
	});
var elm$core$Elm$JsArray$appendN = _JsArray_appendN;
var elm$core$Elm$JsArray$slice = _JsArray_slice;
var elm$core$Array$appendHelpBuilder = F2(
	function (tail, builder) {
		var tailLen = elm$core$Elm$JsArray$length(tail);
		var notAppended = (elm$core$Array$branchFactor - elm$core$Elm$JsArray$length(builder.tail)) - tailLen;
		var appended = A3(elm$core$Elm$JsArray$appendN, elm$core$Array$branchFactor, builder.tail, tail);
		return (notAppended < 0) ? {
			nodeList: A2(
				elm$core$List$cons,
				elm$core$Array$Leaf(appended),
				builder.nodeList),
			nodeListSize: builder.nodeListSize + 1,
			tail: A3(elm$core$Elm$JsArray$slice, notAppended, tailLen, tail)
		} : ((!notAppended) ? {
			nodeList: A2(
				elm$core$List$cons,
				elm$core$Array$Leaf(appended),
				builder.nodeList),
			nodeListSize: builder.nodeListSize + 1,
			tail: elm$core$Elm$JsArray$empty
		} : {nodeList: builder.nodeList, nodeListSize: builder.nodeListSize, tail: appended});
	});
var elm$core$Bitwise$shiftLeftBy = _Bitwise_shiftLeftBy;
var elm$core$Bitwise$shiftRightZfBy = _Bitwise_shiftRightZfBy;
var elm$core$Array$tailIndex = function (len) {
	return (len >>> 5) << 5;
};
var elm$core$Basics$ge = _Utils_ge;
var elm$core$Array$sliceLeft = F2(
	function (from, array) {
		var len = array.a;
		var tree = array.c;
		var tail = array.d;
		if (!from) {
			return array;
		} else {
			if (_Utils_cmp(
				from,
				elm$core$Array$tailIndex(len)) > -1) {
				return A4(
					elm$core$Array$Array_elm_builtin,
					len - from,
					elm$core$Array$shiftStep,
					elm$core$Elm$JsArray$empty,
					A3(
						elm$core$Elm$JsArray$slice,
						from - elm$core$Array$tailIndex(len),
						elm$core$Elm$JsArray$length(tail),
						tail));
			} else {
				var skipNodes = (from / elm$core$Array$branchFactor) | 0;
				var helper = F2(
					function (node, acc) {
						if (node.$ === 'SubTree') {
							var subTree = node.a;
							return A3(elm$core$Elm$JsArray$foldr, helper, acc, subTree);
						} else {
							var leaf = node.a;
							return A2(elm$core$List$cons, leaf, acc);
						}
					});
				var leafNodes = A3(
					elm$core$Elm$JsArray$foldr,
					helper,
					_List_fromArray(
						[tail]),
					tree);
				var nodesToInsert = A2(elm$core$List$drop, skipNodes, leafNodes);
				if (!nodesToInsert.b) {
					return elm$core$Array$empty;
				} else {
					var head = nodesToInsert.a;
					var rest = nodesToInsert.b;
					var firstSlice = from - (skipNodes * elm$core$Array$branchFactor);
					var initialBuilder = {
						nodeList: _List_Nil,
						nodeListSize: 0,
						tail: A3(
							elm$core$Elm$JsArray$slice,
							firstSlice,
							elm$core$Elm$JsArray$length(head),
							head)
					};
					return A2(
						elm$core$Array$builderToArray,
						true,
						A3(elm$core$List$foldl, elm$core$Array$appendHelpBuilder, initialBuilder, rest));
				}
			}
		}
	});
var elm$core$Array$bitMask = 4294967295 >>> (32 - elm$core$Array$shiftStep);
var elm$core$Bitwise$and = _Bitwise_and;
var elm$core$Elm$JsArray$unsafeGet = _JsArray_unsafeGet;
var elm$core$Array$fetchNewTail = F4(
	function (shift, end, treeEnd, tree) {
		fetchNewTail:
		while (true) {
			var pos = elm$core$Array$bitMask & (treeEnd >>> shift);
			var _n0 = A2(elm$core$Elm$JsArray$unsafeGet, pos, tree);
			if (_n0.$ === 'SubTree') {
				var sub = _n0.a;
				var $temp$shift = shift - elm$core$Array$shiftStep,
					$temp$end = end,
					$temp$treeEnd = treeEnd,
					$temp$tree = sub;
				shift = $temp$shift;
				end = $temp$end;
				treeEnd = $temp$treeEnd;
				tree = $temp$tree;
				continue fetchNewTail;
			} else {
				var values = _n0.a;
				return A3(elm$core$Elm$JsArray$slice, 0, elm$core$Array$bitMask & end, values);
			}
		}
	});
var elm$core$Array$hoistTree = F3(
	function (oldShift, newShift, tree) {
		hoistTree:
		while (true) {
			if ((_Utils_cmp(oldShift, newShift) < 1) || (!elm$core$Elm$JsArray$length(tree))) {
				return tree;
			} else {
				var _n0 = A2(elm$core$Elm$JsArray$unsafeGet, 0, tree);
				if (_n0.$ === 'SubTree') {
					var sub = _n0.a;
					var $temp$oldShift = oldShift - elm$core$Array$shiftStep,
						$temp$newShift = newShift,
						$temp$tree = sub;
					oldShift = $temp$oldShift;
					newShift = $temp$newShift;
					tree = $temp$tree;
					continue hoistTree;
				} else {
					return tree;
				}
			}
		}
	});
var elm$core$Elm$JsArray$unsafeSet = _JsArray_unsafeSet;
var elm$core$Array$sliceTree = F3(
	function (shift, endIdx, tree) {
		var lastPos = elm$core$Array$bitMask & (endIdx >>> shift);
		var _n0 = A2(elm$core$Elm$JsArray$unsafeGet, lastPos, tree);
		if (_n0.$ === 'SubTree') {
			var sub = _n0.a;
			var newSub = A3(elm$core$Array$sliceTree, shift - elm$core$Array$shiftStep, endIdx, sub);
			return (!elm$core$Elm$JsArray$length(newSub)) ? A3(elm$core$Elm$JsArray$slice, 0, lastPos, tree) : A3(
				elm$core$Elm$JsArray$unsafeSet,
				lastPos,
				elm$core$Array$SubTree(newSub),
				A3(elm$core$Elm$JsArray$slice, 0, lastPos + 1, tree));
		} else {
			return A3(elm$core$Elm$JsArray$slice, 0, lastPos, tree);
		}
	});
var elm$core$Array$sliceRight = F2(
	function (end, array) {
		var len = array.a;
		var startShift = array.b;
		var tree = array.c;
		var tail = array.d;
		if (_Utils_eq(end, len)) {
			return array;
		} else {
			if (_Utils_cmp(
				end,
				elm$core$Array$tailIndex(len)) > -1) {
				return A4(
					elm$core$Array$Array_elm_builtin,
					end,
					startShift,
					tree,
					A3(elm$core$Elm$JsArray$slice, 0, elm$core$Array$bitMask & end, tail));
			} else {
				var endIdx = elm$core$Array$tailIndex(end);
				var depth = elm$core$Basics$floor(
					A2(
						elm$core$Basics$logBase,
						elm$core$Array$branchFactor,
						A2(elm$core$Basics$max, 1, endIdx - 1)));
				var newShift = A2(elm$core$Basics$max, 5, depth * elm$core$Array$shiftStep);
				return A4(
					elm$core$Array$Array_elm_builtin,
					end,
					newShift,
					A3(
						elm$core$Array$hoistTree,
						startShift,
						newShift,
						A3(elm$core$Array$sliceTree, startShift, endIdx, tree)),
					A4(elm$core$Array$fetchNewTail, startShift, end, endIdx, tree));
			}
		}
	});
var elm$core$Array$translateIndex = F2(
	function (index, _n0) {
		var len = _n0.a;
		var posIndex = (index < 0) ? (len + index) : index;
		return (posIndex < 0) ? 0 : ((_Utils_cmp(posIndex, len) > 0) ? len : posIndex);
	});
var elm$core$Array$slice = F3(
	function (from, to, array) {
		var correctTo = A2(elm$core$Array$translateIndex, to, array);
		var correctFrom = A2(elm$core$Array$translateIndex, from, array);
		return (_Utils_cmp(correctFrom, correctTo) > 0) ? elm$core$Array$empty : A2(
			elm$core$Array$sliceLeft,
			correctFrom,
			A2(elm$core$Array$sliceRight, correctTo, array));
	});
var elm$core$Tuple$second = function (_n0) {
	var y = _n0.b;
	return y;
};
var elm$core$Array$toIndexedList = function (array) {
	var len = array.a;
	var helper = F2(
		function (entry, _n0) {
			var index = _n0.a;
			var list = _n0.b;
			return _Utils_Tuple2(
				index - 1,
				A2(
					elm$core$List$cons,
					_Utils_Tuple2(index, entry),
					list));
		});
	return A3(
		elm$core$Array$foldr,
		helper,
		_Utils_Tuple2(len - 1, _List_Nil),
		array).b;
};
var aforemny$elm_mdc$Internal$List$Implementation$slicedIndexedList = F3(
	function (from, to, array) {
		return elm$core$Array$toIndexedList(
			A3(elm$core$Array$slice, from, to, array));
	});
var elm$core$Array$length = function (_n0) {
	var len = _n0.a;
	return len;
};
var aforemny$elm_mdc$Internal$List$Implementation$firstNonEmptyId = F2(
	function (from, array) {
		var list = A3(
			aforemny$elm_mdc$Internal$List$Implementation$slicedIndexedList,
			from,
			elm$core$Array$length(array),
			array);
		var non_empty_id = A2(
			aforemny$elm_mdc$Internal$List$Implementation$find,
			function (_n0) {
				var id = _n0.b;
				return id !== '';
			},
			list);
		return non_empty_id;
	});
var aforemny$elm_mdc$Internal$List$Implementation$lastNonEmptyId = F2(
	function (to, array) {
		var list = A3(aforemny$elm_mdc$Internal$List$Implementation$slicedIndexedList, 0, to, array);
		var non_empty_id = A2(
			aforemny$elm_mdc$Internal$List$Implementation$find,
			function (_n0) {
				var i = _n0.a;
				var id = _n0.b;
				return id !== '';
			},
			elm$core$List$reverse(list));
		return non_empty_id;
	});
var aforemny$elm_mdc$Internal$List$Implementation$listItemClass = aforemny$elm_mdc$Internal$Options$cs('mdc-list-item');
var aforemny$elm_mdc$Internal$List$Implementation$listItemDomId = F2(
	function (domId, index) {
		return domId + ('--' + elm$core$String$fromInt(index));
	});
var aforemny$elm_mdc$Internal$List$Model$FocusItem = F2(
	function (a, b) {
		return {$: 'FocusItem', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$List$Model$SelectItem = F2(
	function (a, b) {
		return {$: 'SelectItem', a: a, b: b};
	});
var aforemny$elm_mdc$Internal$Options$role = function (value) {
	return aforemny$elm_mdc$Internal$Options$Attribute(
		A2(elm$html$Html$Attributes$attribute, 'role', value));
};
var elm$html$Html$Attributes$tabindex = function (n) {
	return A2(
		_VirtualDom_attribute,
		'tabIndex',
		elm$core$String$fromInt(n));
};
var aforemny$elm_mdc$Internal$Options$tabindex = function (value) {
	return aforemny$elm_mdc$Internal$Options$Attribute(
		elm$html$Html$Attributes$tabindex(value));
};
var elm$core$Array$getHelp = F3(
	function (shift, index, tree) {
		getHelp:
		while (true) {
			var pos = elm$core$Array$bitMask & (index >>> shift);
			var _n0 = A2(elm$core$Elm$JsArray$unsafeGet, pos, tree);
			if (_n0.$ === 'SubTree') {
				var subTree = _n0.a;
				var $temp$shift = shift - elm$core$Array$shiftStep,
					$temp$index = index,
					$temp$tree = subTree;
				shift = $temp$shift;
				index = $temp$index;
				tree = $temp$tree;
				continue getHelp;
			} else {
				var values = _n0.a;
				return A2(elm$core$Elm$JsArray$unsafeGet, elm$core$Array$bitMask & index, values);
			}
		}
	});
var elm$core$Array$get = F2(
	function (index, _n0) {
		var len = _n0.a;
		var startShift = _n0.b;
		var tree = _n0.c;
		var tail = _n0.d;
		return ((index < 0) || (_Utils_cmp(index, len) > -1)) ? elm$core$Maybe$Nothing : ((_Utils_cmp(
			index,
			elm$core$Array$tailIndex(len)) > -1) ? elm$core$Maybe$Just(
			A2(elm$core$Elm$JsArray$unsafeGet, elm$core$Array$bitMask & index, tail)) : elm$core$Maybe$Just(
			A3(elm$core$Array$getHelp, startShift, index, tree)));
	});
var elm$html$Html$li = _VirtualDom_node('li');
var aforemny$elm_mdc$Internal$List$Implementation$liView = F9(
	function (domId, lift, model, config, listItemIds, focusedIndex, index, options, children) {
		var tab_index = _Utils_eq(focusedIndex, index) ? 0 : (-1);
		var list_item_dom_id = A2(aforemny$elm_mdc$Internal$List$Implementation$listItemDomId, domId, index);
		var ripple = A5(
			aforemny$elm_mdc$Internal$Ripple$Implementation$view,
			false,
			list_item_dom_id,
			A2(
				elm$core$Basics$composeL,
				lift,
				aforemny$elm_mdc$Internal$List$Model$RippleMsg(list_item_dom_id)),
			A2(
				elm$core$Maybe$withDefault,
				aforemny$elm_mdc$Internal$Ripple$Model$defaultModel,
				A2(elm$core$Dict$get, list_item_dom_id, model.ripples)),
			_List_Nil);
		var li_summary = A2(aforemny$elm_mdc$Internal$Options$collect, aforemny$elm_mdc$Internal$List$Implementation$defaultConfig, options);
		var li_config = li_summary.config;
		var is_selected = function () {
			var _n8 = config.selectedIndex;
			if (_n8.$ === 'Just') {
				var i = _n8.a;
				return _Utils_eq(i, index);
			} else {
				return li_config.selected;
			}
		}();
		return A5(
			aforemny$elm_mdc$Internal$Options$apply,
			li_summary,
			A2(elm$core$Maybe$withDefault, elm$html$Html$li, li_config.node),
			_List_fromArray(
				[
					aforemny$elm_mdc$Internal$List$Implementation$listItemClass,
					aforemny$elm_mdc$Internal$Options$tabindex(tab_index),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.isSingleSelectionList && (is_selected && (!config.useActivated)),
					aforemny$elm_mdc$Internal$Options$cs('mdc-list-item--selected')),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.isSingleSelectionList && (is_selected && config.useActivated),
					aforemny$elm_mdc$Internal$Options$cs('mdc-list-item--activated')),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.isRadioGroup,
					A2(
						aforemny$elm_mdc$Internal$Options$aria,
						'checked',
						is_selected ? 'True' : 'False')),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.isSingleSelectionList,
					aforemny$elm_mdc$Internal$Options$role('option')),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.isRadioGroup,
					aforemny$elm_mdc$Internal$Options$role('radio')),
					ripple.interactionHandler,
					ripple.properties,
					function () {
					var _n0 = config.onSelectListItem;
					if (_n0.$ === 'Just') {
						var onSelect = _n0.a;
						return aforemny$elm_mdc$Internal$Options$onClick(
							onSelect(index));
					} else {
						return aforemny$elm_mdc$Internal$Options$nop;
					}
				}(),
					A2(
					aforemny$elm_mdc$Internal$Options$onWithOptions,
					'keydown',
					A3(
						elm$json$Json$Decode$map2,
						F2(
							function (key, keyCode) {
								var selectItem = _Utils_eq(
									key,
									elm$core$Maybe$Just('Enter')) || ((keyCode === 13) || (_Utils_eq(
									key,
									elm$core$Maybe$Just('Space')) || (keyCode === 32)));
								var _n1 = function () {
									if (_Utils_eq(
										key,
										elm$core$Maybe$Just('ArrowDown')) || (keyCode === 40)) {
										var focusable_element = A2(aforemny$elm_mdc$Internal$List$Implementation$firstNonEmptyId, index + 1, listItemIds);
										if (focusable_element.$ === 'Just') {
											var _n3 = focusable_element.a;
											var next_index = _n3.a;
											var next_item = _n3.b;
											return _Utils_Tuple2(
												elm$core$Maybe$Just(next_index),
												elm$core$Maybe$Just(next_item));
										} else {
											return _Utils_Tuple2(
												elm$core$Maybe$Just(index + 1),
												elm$core$Maybe$Nothing);
										}
									} else {
										if (_Utils_eq(
											key,
											elm$core$Maybe$Just('ArrowUp')) || (keyCode === 38)) {
											var focusable_element = A2(aforemny$elm_mdc$Internal$List$Implementation$lastNonEmptyId, index, listItemIds);
											if (focusable_element.$ === 'Just') {
												var _n5 = focusable_element.a;
												var previous_index = _n5.a;
												var previous_item = _n5.b;
												return _Utils_Tuple2(
													elm$core$Maybe$Just(previous_index),
													elm$core$Maybe$Just(previous_item));
											} else {
												return _Utils_Tuple2(
													elm$core$Maybe$Just(index - 1),
													elm$core$Maybe$Nothing);
											}
										} else {
											if (_Utils_eq(
												key,
												elm$core$Maybe$Just('Home')) || (keyCode === 36)) {
												return _Utils_Tuple2(
													elm$core$Maybe$Just(0),
													A2(elm$core$Array$get, 0, listItemIds));
											} else {
												if (_Utils_eq(
													key,
													elm$core$Maybe$Just('End')) || (keyCode === 35)) {
													var last_index = elm$core$Array$length(listItemIds) - 1;
													return _Utils_Tuple2(
														elm$core$Maybe$Just(last_index),
														A2(elm$core$Array$get, last_index, listItemIds));
												} else {
													return _Utils_Tuple2(elm$core$Maybe$Nothing, elm$core$Maybe$Nothing);
												}
											}
										}
									}
								}();
								var index_to_focus = _n1.a;
								var id_to_focus = _n1.b;
								var msg = function () {
									if (selectItem) {
										var _n6 = config.onSelectListItem;
										if (_n6.$ === 'Just') {
											var onSelect = _n6.a;
											return A2(aforemny$elm_mdc$Internal$List$Model$SelectItem, index, onSelect);
										} else {
											return aforemny$elm_mdc$Internal$List$Model$NoOp;
										}
									} else {
										var _n7 = _Utils_Tuple2(index_to_focus, id_to_focus);
										if ((_n7.a.$ === 'Just') && (_n7.b.$ === 'Just')) {
											var idx = _n7.a.a;
											var id = _n7.b.a;
											return A2(aforemny$elm_mdc$Internal$List$Model$FocusItem, idx, id);
										} else {
											return aforemny$elm_mdc$Internal$List$Model$NoOp;
										}
									}
								}();
								return {
									message: lift(msg),
									preventDefault: (!_Utils_eq(index_to_focus, elm$core$Maybe$Nothing)) || selectItem,
									stopPropagation: false
								};
							}),
						elm$json$Json$Decode$oneOf(
							_List_fromArray(
								[
									A2(
									elm$json$Json$Decode$map,
									elm$core$Maybe$Just,
									A2(
										elm$json$Json$Decode$at,
										_List_fromArray(
											['key']),
										elm$json$Json$Decode$string)),
									elm$json$Json$Decode$succeed(elm$core$Maybe$Nothing)
								])),
						A2(
							elm$json$Json$Decode$at,
							_List_fromArray(
								['keyCode']),
							elm$json$Json$Decode$int)))
				]),
			_List_Nil,
			children);
	});
var aforemny$elm_mdc$Internal$List$Implementation$li = F2(
	function (options, children) {
		return {children: children, focusable: true, options: options, view: aforemny$elm_mdc$Internal$List$Implementation$liView};
	});
var aforemny$elm_mdc$Internal$List$Implementation$node = function (nodeFunc) {
	return aforemny$elm_mdc$Internal$Options$option(
		function (config) {
			return _Utils_update(
				config,
				{
					node: elm$core$Maybe$Just(nodeFunc)
				});
		});
};
var aforemny$elm_mdc$Material$List$a = F2(
	function (options, items) {
		return A2(
			aforemny$elm_mdc$Internal$List$Implementation$li,
			A2(
				elm$core$List$cons,
				aforemny$elm_mdc$Internal$List$Implementation$node(elm$html$Html$a),
				options),
			items);
	});
var aforemny$elm_mdc$Internal$List$Implementation$activated = aforemny$elm_mdc$Internal$Options$option(
	function (config) {
		return _Utils_update(
			config,
			{activated: true});
	});
var aforemny$elm_mdc$Material$List$activated = aforemny$elm_mdc$Internal$List$Implementation$activated;
var aforemny$elm_mdc$Internal$List$Implementation$asListItemView = F9(
	function (domId, lift, model, config, listItemsIds, focusedIndex, index, options, children) {
		var summary = A2(aforemny$elm_mdc$Internal$Options$collect, aforemny$elm_mdc$Internal$List$Implementation$defaultConfig, options);
		return A5(
			aforemny$elm_mdc$Internal$Options$apply,
			summary,
			A2(elm$core$Maybe$withDefault, elm$html$Html$div, summary.config.node),
			_List_Nil,
			_List_Nil,
			children);
	});
var aforemny$elm_mdc$Internal$List$Implementation$asListItem = F3(
	function (dom_node, options, children) {
		return {
			children: children,
			focusable: false,
			options: A2(
				elm$core$List$cons,
				aforemny$elm_mdc$Internal$List$Implementation$node(dom_node),
				options),
			view: aforemny$elm_mdc$Internal$List$Implementation$asListItemView
		};
	});
var aforemny$elm_mdc$Internal$List$Implementation$divider = function (options) {
	return A2(
		aforemny$elm_mdc$Internal$List$Implementation$asListItem,
		elm$html$Html$li,
		A2(
			elm$core$List$cons,
			aforemny$elm_mdc$Internal$Options$cs('mdc-list-divider'),
			A2(
				elm$core$List$cons,
				aforemny$elm_mdc$Internal$Options$role('separator'),
				options)));
};
var aforemny$elm_mdc$Material$List$divider = aforemny$elm_mdc$Internal$List$Implementation$divider;
var aforemny$elm_mdc$Internal$List$Implementation$graphicClass = aforemny$elm_mdc$Internal$Options$cs('mdc-list-item__graphic');
var aforemny$elm_mdc$Internal$List$Implementation$graphicIcon = function (options) {
	return aforemny$elm_mdc$Internal$Icon$Implementation$view(
		A2(elm$core$List$cons, aforemny$elm_mdc$Internal$List$Implementation$graphicClass, options));
};
var aforemny$elm_mdc$Material$List$graphicIcon = aforemny$elm_mdc$Internal$List$Implementation$graphicIcon;
var aforemny$elm_mdc$Internal$List$Implementation$doListItemDomId = F3(
	function (domId, index, listItem) {
		return listItem.focusable ? A2(aforemny$elm_mdc$Internal$List$Implementation$listItemDomId, domId, index) : '';
	});
var aforemny$elm_mdc$Internal$List$Implementation$findIndexHelp = F3(
	function (index, predicate, list) {
		findIndexHelp:
		while (true) {
			if (!list.b) {
				return elm$core$Maybe$Nothing;
			} else {
				var first = list.a;
				var rest = list.b;
				if (predicate(first)) {
					return elm$core$Maybe$Just(index);
				} else {
					var $temp$index = index + 1,
						$temp$predicate = predicate,
						$temp$list = rest;
					index = $temp$index;
					predicate = $temp$predicate;
					list = $temp$list;
					continue findIndexHelp;
				}
			}
		}
	});
var aforemny$elm_mdc$Internal$List$Implementation$findIndex = aforemny$elm_mdc$Internal$List$Implementation$findIndexHelp(0);
var aforemny$elm_mdc$Internal$List$Implementation$liIsSelectedOrActivated = function (li_) {
	var li_summary = A2(aforemny$elm_mdc$Internal$Options$collect, aforemny$elm_mdc$Internal$List$Implementation$defaultConfig, li_.options);
	var li_config = li_summary.config;
	return li_config.selected || li_config.activated;
};
var aforemny$elm_mdc$Internal$List$Implementation$listItemView = F8(
	function (domId, lift, model, config, listItemsIds, focusedIndex, index, li_) {
		return A9(li_.view, domId, lift, model, config, listItemsIds, focusedIndex, index, li_.options, li_.children);
	});
var elm$json$Json$Decode$maybe = function (decoder) {
	return elm$json$Json$Decode$oneOf(
		_List_fromArray(
			[
				A2(elm$json$Json$Decode$map, elm$core$Maybe$Just, decoder),
				elm$json$Json$Decode$succeed(elm$core$Maybe$Nothing)
			]));
};
var aforemny$elm_mdc$Internal$List$Implementation$invertDecoder = function (decoder) {
	return A2(
		elm$json$Json$Decode$andThen,
		function (maybe) {
			return _Utils_eq(maybe, elm$core$Maybe$Nothing) ? elm$json$Json$Decode$succeed(_Utils_Tuple0) : elm$json$Json$Decode$fail('');
		},
		elm$json$Json$Decode$maybe(decoder));
};
var aforemny$elm_mdc$Internal$List$Implementation$succeedIfContainerOrChildOfContainer = function (targetId) {
	return A2(
		elm$json$Json$Decode$andThen,
		function (id) {
			return _Utils_eq(id, targetId) ? elm$json$Json$Decode$succeed(_Utils_Tuple0) : A2(
				elm$json$Json$Decode$field,
				'parentNode',
				aforemny$elm_mdc$Internal$List$Implementation$succeedIfContainerOrChildOfContainer(targetId));
		},
		A2(elm$json$Json$Decode$field, 'id', elm$json$Json$Decode$string));
};
var aforemny$elm_mdc$Internal$List$Implementation$succeedIfLeavingList = function (targetId) {
	return aforemny$elm_mdc$Internal$List$Implementation$invertDecoder(
		A2(
			elm$json$Json$Decode$field,
			'relatedTarget',
			aforemny$elm_mdc$Internal$List$Implementation$succeedIfContainerOrChildOfContainer(targetId)));
};
var aforemny$elm_mdc$Internal$List$Model$ResetFocusedItem = {$: 'ResetFocusedItem'};
var elm$core$Array$fromListHelp = F3(
	function (list, nodeList, nodeListSize) {
		fromListHelp:
		while (true) {
			var _n0 = A2(elm$core$Elm$JsArray$initializeFromList, elm$core$Array$branchFactor, list);
			var jsArray = _n0.a;
			var remainingItems = _n0.b;
			if (_Utils_cmp(
				elm$core$Elm$JsArray$length(jsArray),
				elm$core$Array$branchFactor) < 0) {
				return A2(
					elm$core$Array$builderToArray,
					true,
					{nodeList: nodeList, nodeListSize: nodeListSize, tail: jsArray});
			} else {
				var $temp$list = remainingItems,
					$temp$nodeList = A2(
					elm$core$List$cons,
					elm$core$Array$Leaf(jsArray),
					nodeList),
					$temp$nodeListSize = nodeListSize + 1;
				list = $temp$list;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue fromListHelp;
			}
		}
	});
var elm$core$Array$fromList = function (list) {
	if (!list.b) {
		return elm$core$Array$empty;
	} else {
		return A3(elm$core$Array$fromListHelp, list, _List_Nil, 0);
	}
};
var elm$html$Html$ul = _VirtualDom_node('ul');
var aforemny$elm_mdc$Internal$List$Implementation$ul = F5(
	function (domId, lift, model, options, items) {
		var listItemIds = elm$core$Array$fromList(
			A2(
				elm$core$List$indexedMap,
				aforemny$elm_mdc$Internal$List$Implementation$doListItemDomId(domId),
				items));
		var summary = A2(aforemny$elm_mdc$Internal$Options$collect, aforemny$elm_mdc$Internal$List$Implementation$defaultConfig, options);
		var config = summary.config;
		var focusedIndex = function () {
			var _n0 = model.focused;
			if (_n0.$ === 'Just') {
				var focused = _n0.a;
				return focused;
			} else {
				var _n1 = config.selectedIndex;
				if (_n1.$ === 'Just') {
					var index = _n1.a;
					return index;
				} else {
					var _n2 = A2(aforemny$elm_mdc$Internal$List$Implementation$findIndex, aforemny$elm_mdc$Internal$List$Implementation$liIsSelectedOrActivated, items);
					if (_n2.$ === 'Just') {
						var i = _n2.a;
						return i;
					} else {
						return 0;
					}
				}
			}
		}();
		var list_nodes = A2(
			elm$core$List$indexedMap,
			A6(aforemny$elm_mdc$Internal$List$Implementation$listItemView, domId, lift, model, config, listItemIds, focusedIndex),
			items);
		return A5(
			aforemny$elm_mdc$Internal$Options$apply,
			summary,
			A2(elm$core$Maybe$withDefault, elm$html$Html$ul, config.node),
			_List_fromArray(
				[
					aforemny$elm_mdc$Internal$Options$cs('mdc-list'),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.isSingleSelectionList,
					aforemny$elm_mdc$Internal$Options$role('listbox')),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.isRadioGroup,
					aforemny$elm_mdc$Internal$Options$role('radiogroup')),
					aforemny$elm_mdc$Internal$Options$id(domId),
					A2(
					aforemny$elm_mdc$Internal$Options$on,
					'focusout',
					A2(
						elm$json$Json$Decode$map,
						elm$core$Basics$always(
							lift(aforemny$elm_mdc$Internal$List$Model$ResetFocusedItem)),
						aforemny$elm_mdc$Internal$List$Implementation$succeedIfLeavingList(domId)))
				]),
			_List_Nil,
			list_nodes);
	});
var aforemny$elm_mdc$Internal$List$Implementation$view = F2(
	function (lift, domId) {
		return A5(
			aforemny$elm_mdc$Internal$Component$render,
			aforemny$elm_mdc$Internal$List$Implementation$getSet.get,
			aforemny$elm_mdc$Internal$List$Implementation$ul(domId),
			aforemny$elm_mdc$Internal$Msg$ListMsg,
			lift,
			domId);
	});
var elm$html$Html$nav = _VirtualDom_node('nav');
var aforemny$elm_mdc$Material$List$nav = F5(
	function (lift, domId, model, options, items) {
		return A5(
			aforemny$elm_mdc$Internal$List$Implementation$view,
			lift,
			domId,
			model,
			A2(
				elm$core$List$cons,
				aforemny$elm_mdc$Internal$List$Implementation$node(elm$html$Html$nav),
				options),
			items);
	});
var aforemny$elm_mdc$Material$Options$attribute = aforemny$elm_mdc$Internal$Options$attribute;
var aforemny$elm_mdc$Material$Options$styled = aforemny$elm_mdc$Internal$Options$styled;
var aforemny$elm_mdc$Material$Options$when = aforemny$elm_mdc$Internal$Options$when;
var elm$html$Html$h3 = _VirtualDom_node('h3');
var elm$html$Html$h6 = _VirtualDom_node('h6');
var aforemny$elm_mdc$Main$viewDrawer = function (model) {
	return A5(
		aforemny$elm_mdc$Material$Drawer$Dismissible$view,
		aforemny$elm_mdc$Main$Mdc,
		'my-drawer2',
		model.mdc,
		_List_fromArray(
			[
				A2(aforemny$elm_mdc$Material$Options$when, model.drawerOpen, aforemny$elm_mdc$Material$Drawer$Dismissible$open),
				aforemny$elm_mdc$Material$Drawer$Dismissible$onClose(aforemny$elm_mdc$Main$ToggleDrawer)
			]),
		_List_fromArray(
			[
				A2(
				aforemny$elm_mdc$Material$Drawer$Dismissible$header,
				_List_Nil,
				_List_fromArray(
					[
						A3(
						aforemny$elm_mdc$Material$Options$styled,
						elm$html$Html$h3,
						_List_fromArray(
							[aforemny$elm_mdc$Material$Drawer$Dismissible$title]),
						_List_fromArray(
							[
								elm$html$Html$text('Mail')
							])),
						A3(
						aforemny$elm_mdc$Material$Options$styled,
						elm$html$Html$h6,
						_List_fromArray(
							[aforemny$elm_mdc$Material$Drawer$Dismissible$subTitle]),
						_List_fromArray(
							[
								elm$html$Html$text('email@material.io')
							]))
					])),
				A2(
				aforemny$elm_mdc$Material$Drawer$Dismissible$content,
				_List_Nil,
				_List_fromArray(
					[
						A5(
						aforemny$elm_mdc$Material$List$nav,
						aforemny$elm_mdc$Main$Mdc,
						'content',
						model.mdc,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								aforemny$elm_mdc$Material$List$a,
								_List_fromArray(
									[
										aforemny$elm_mdc$Material$Options$attribute(
										elm$html$Html$Attributes$href('#persistent-drawer')),
										aforemny$elm_mdc$Material$List$activated
									]),
								_List_fromArray(
									[
										A2(aforemny$elm_mdc$Material$List$graphicIcon, _List_Nil, 'inbox'),
										elm$html$Html$text('Inbox')
									])),
								A2(
								aforemny$elm_mdc$Material$List$a,
								_List_fromArray(
									[
										aforemny$elm_mdc$Material$Options$attribute(
										elm$html$Html$Attributes$href('#persistent-drawer'))
									]),
								_List_fromArray(
									[
										A2(aforemny$elm_mdc$Material$List$graphicIcon, _List_Nil, 'star'),
										elm$html$Html$text('Star')
									])),
								A2(aforemny$elm_mdc$Material$List$divider, _List_Nil, _List_Nil),
								A2(
								aforemny$elm_mdc$Material$List$a,
								_List_fromArray(
									[
										aforemny$elm_mdc$Material$Options$attribute(
										elm$html$Html$Attributes$href('#persistent-drawer'))
									]),
								_List_fromArray(
									[
										A2(aforemny$elm_mdc$Material$List$graphicIcon, _List_Nil, 'send'),
										elm$html$Html$text('Sent Mail')
									])),
								A2(
								aforemny$elm_mdc$Material$List$a,
								_List_fromArray(
									[
										aforemny$elm_mdc$Material$Options$attribute(
										elm$html$Html$Attributes$href('#persistent-drawer'))
									]),
								_List_fromArray(
									[
										A2(aforemny$elm_mdc$Material$List$graphicIcon, _List_Nil, 'drafts'),
										elm$html$Html$text('Drafts')
									]))
							]))
					]))
			]));
};
var aforemny$elm_mdc$Internal$Icon$Implementation$node = function (ctor) {
	return aforemny$elm_mdc$Internal$Options$option(
		function (config) {
			return _Utils_update(
				config,
				{node: ctor});
		});
};
var aforemny$elm_mdc$Internal$Icon$Implementation$button = aforemny$elm_mdc$Internal$Icon$Implementation$node('button');
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$actionItemView = F5(
	function (domId, lift, model, options, name) {
		var ripple = A5(
			aforemny$elm_mdc$Internal$Ripple$Implementation$view,
			true,
			domId,
			A2(
				elm$core$Basics$composeL,
				lift,
				aforemny$elm_mdc$Internal$TopAppBar$Model$RippleMsg(domId)),
			A2(
				elm$core$Maybe$withDefault,
				aforemny$elm_mdc$Internal$Ripple$Model$defaultModel,
				A2(elm$core$Dict$get, domId, model.ripples)),
			_List_Nil);
		return A2(
			aforemny$elm_mdc$Internal$Icon$Implementation$view,
			A2(
				elm$core$List$cons,
				aforemny$elm_mdc$Internal$Icon$Implementation$button,
				A2(
					elm$core$List$cons,
					aforemny$elm_mdc$Internal$Options$cs('mdc-icon-button'),
					A2(
						elm$core$List$cons,
						ripple.interactionHandler,
						A2(elm$core$List$cons, ripple.properties, options)))),
			name);
	});
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$actionItem = F2(
	function (lift, index) {
		return A5(
			aforemny$elm_mdc$Internal$Component$render,
			aforemny$elm_mdc$Internal$TopAppBar$Implementation$getSet.get,
			aforemny$elm_mdc$Internal$TopAppBar$Implementation$actionItemView(index),
			aforemny$elm_mdc$Internal$Msg$TopAppBarMsg,
			lift,
			index);
	});
var aforemny$elm_mdc$Material$Options$cs = aforemny$elm_mdc$Internal$Options$cs;
var aforemny$elm_mdc$Material$TopAppBar$actionItem = F5(
	function (lift, index, model, options, name) {
		return A5(
			aforemny$elm_mdc$Internal$TopAppBar$Implementation$actionItem,
			lift,
			index,
			model,
			A2(
				elm$core$List$cons,
				aforemny$elm_mdc$Material$Options$cs('mdc-top-app-bar__action-item'),
				options),
			name);
	});
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$alignEnd = aforemny$elm_mdc$Internal$Options$cs('mdc-top-app-bar__section--align-end');
var aforemny$elm_mdc$Material$TopAppBar$alignEnd = aforemny$elm_mdc$Internal$TopAppBar$Implementation$alignEnd;
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$alignStart = aforemny$elm_mdc$Internal$Options$cs('mdc-top-app-bar__section--align-start');
var aforemny$elm_mdc$Material$TopAppBar$alignStart = aforemny$elm_mdc$Internal$TopAppBar$Implementation$alignStart;
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$fixed = aforemny$elm_mdc$Internal$Options$option(
	function (config) {
		return _Utils_update(
			config,
			{fixed: true});
	});
var aforemny$elm_mdc$Material$TopAppBar$fixed = aforemny$elm_mdc$Internal$TopAppBar$Implementation$fixed;
var aforemny$elm_mdc$Material$TopAppBar$navigationIcon = F5(
	function (lift, index, model, options, name) {
		return A5(
			aforemny$elm_mdc$Internal$TopAppBar$Implementation$actionItem,
			lift,
			index,
			model,
			A2(
				elm$core$List$cons,
				aforemny$elm_mdc$Material$Options$cs('mdc-top-app-bar__navigation-icon'),
				options),
			name);
	});
var elm$html$Html$section = _VirtualDom_node('section');
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$section = function (options) {
	return A2(
		aforemny$elm_mdc$Internal$Options$styled,
		elm$html$Html$section,
		A2(
			elm$core$List$cons,
			aforemny$elm_mdc$Internal$Options$cs('mdc-top-app-bar__section'),
			options));
};
var aforemny$elm_mdc$Material$TopAppBar$section = aforemny$elm_mdc$Internal$TopAppBar$Implementation$section;
var elm$html$Html$span = _VirtualDom_node('span');
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$title = function (options) {
	return A2(
		aforemny$elm_mdc$Internal$Options$styled,
		elm$html$Html$span,
		A2(
			elm$core$List$cons,
			aforemny$elm_mdc$Internal$Options$cs('mdc-top-app-bar__title'),
			options));
};
var aforemny$elm_mdc$Material$TopAppBar$title = aforemny$elm_mdc$Internal$TopAppBar$Implementation$title;
var aforemny$elm_mdc$Internal$GlobalEvents$onResize = aforemny$elm_mdc$Internal$GlobalEvents$listener('globalresize');
var aforemny$elm_mdc$Internal$GlobalEvents$onScroll = aforemny$elm_mdc$Internal$GlobalEvents$listener('globalscroll');
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$cssClasses = {collapsed: 'mdc-top-app-bar--short-collapsed', dense: 'mdc-top-app-bar--dense', fixed: 'mdc-top-app-bar--fixed', prominent: 'mdc-top-app-bar--prominent', scrolled: 'mdc-top-app-bar--fixed-scrolled', _short: 'mdc-top-app-bar--short'};
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$getAppBarHeight = A2(
	elm$json$Json$Decode$at,
	_List_fromArray(
		['target', 'clientHeight']),
	elm$json$Json$Decode$float);
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$getViewportScrollY = debois$elm_dom$DOM$target(
	A2(
		elm$json$Json$Decode$at,
		_List_fromArray(
			['ownerDocument', 'defaultView', 'scrollY']),
		elm$json$Json$Decode$float));
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$row = function (options) {
	return A2(
		aforemny$elm_mdc$Internal$Options$styled,
		elm$html$Html$div,
		A2(
			elm$core$List$cons,
			aforemny$elm_mdc$Internal$Options$cs('mdc-top-app-bar__row'),
			options));
};
var aforemny$elm_mdc$Internal$TopAppBar$Model$Init = function (a) {
	return {$: 'Init', a: a};
};
var aforemny$elm_mdc$Internal$TopAppBar$Model$Resize = function (a) {
	return {$: 'Resize', a: a};
};
var aforemny$elm_mdc$Internal$TopAppBar$Model$Scroll = function (a) {
	return {$: 'Scroll', a: a};
};
var aforemny$elm_mdc$Internal$TopAppBar$Model$defaultConfig = {collapsed: false, dense: false, fixed: false, prominent: false, _short: false};
var elm$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			if (!list.b) {
				return false;
			} else {
				var x = list.a;
				var xs = list.b;
				if (isOkay(x)) {
					return true;
				} else {
					var $temp$isOkay = isOkay,
						$temp$list = xs;
					isOkay = $temp$isOkay;
					list = $temp$list;
					continue any;
				}
			}
		}
	});
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$topAppBar = F4(
	function (lift, model, options, sections) {
		var top = A2(elm$core$Maybe$withDefault, 0, model.styleTop);
		var lastScrollPosition = A2(elm$core$Maybe$withDefault, 0, model.lastScrollPosition);
		var summary = A2(aforemny$elm_mdc$Internal$Options$collect, aforemny$elm_mdc$Internal$TopAppBar$Model$defaultConfig, options);
		var config = summary.config;
		return A5(
			aforemny$elm_mdc$Internal$Options$apply,
			summary,
			elm$html$Html$header,
			_List_fromArray(
				[
					aforemny$elm_mdc$Internal$Options$cs('mdc-top-app-bar'),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.dense,
					aforemny$elm_mdc$Internal$Options$cs(aforemny$elm_mdc$Internal$TopAppBar$Implementation$cssClasses.dense)),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.fixed,
					aforemny$elm_mdc$Internal$Options$cs(aforemny$elm_mdc$Internal$TopAppBar$Implementation$cssClasses.fixed)),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.fixed && (lastScrollPosition > 0),
					aforemny$elm_mdc$Internal$Options$cs(aforemny$elm_mdc$Internal$TopAppBar$Implementation$cssClasses.scrolled)),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.prominent,
					aforemny$elm_mdc$Internal$Options$cs(aforemny$elm_mdc$Internal$TopAppBar$Implementation$cssClasses.prominent)),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config._short,
					aforemny$elm_mdc$Internal$Options$cs(aforemny$elm_mdc$Internal$TopAppBar$Implementation$cssClasses._short)),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					config.collapsed || (config._short && (lastScrollPosition > 0)),
					aforemny$elm_mdc$Internal$Options$cs(aforemny$elm_mdc$Internal$TopAppBar$Implementation$cssClasses.collapsed)),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					(!config.fixed) && (!config._short),
					A2(
						aforemny$elm_mdc$Internal$Options$css,
						'top',
						elm$core$String$fromFloat(top) + 'px')),
					aforemny$elm_mdc$Internal$GlobalEvents$onScroll(
					A2(
						elm$json$Json$Decode$map,
						lift,
						A2(
							elm$json$Json$Decode$map,
							function (scrollPosition) {
								return aforemny$elm_mdc$Internal$TopAppBar$Model$Scroll(
									{scrollPosition: scrollPosition});
							},
							aforemny$elm_mdc$Internal$TopAppBar$Implementation$getViewportScrollY))),
					aforemny$elm_mdc$Internal$GlobalEvents$onResize(
					A2(
						elm$json$Json$Decode$map,
						lift,
						A3(
							elm$json$Json$Decode$map2,
							F2(
								function (scrollPosition, topAppBarHeight) {
									return aforemny$elm_mdc$Internal$TopAppBar$Model$Resize(
										{scrollPosition: scrollPosition, topAppBarHeight: topAppBarHeight});
								}),
							aforemny$elm_mdc$Internal$TopAppBar$Implementation$getViewportScrollY,
							aforemny$elm_mdc$Internal$TopAppBar$Implementation$getAppBarHeight))),
					A2(
					aforemny$elm_mdc$Internal$Options$when,
					A2(
						elm$core$List$any,
						elm$core$Basics$identity,
						_List_fromArray(
							[
								_Utils_eq(model.lastScrollPosition, elm$core$Maybe$Nothing),
								_Utils_eq(model.topAppBarHeight, elm$core$Maybe$Nothing)
							])),
					aforemny$elm_mdc$Internal$GlobalEvents$onTick(
						A2(
							elm$json$Json$Decode$map,
							lift,
							A3(
								elm$json$Json$Decode$map2,
								F2(
									function (scrollPosition, topAppBarHeight) {
										return aforemny$elm_mdc$Internal$TopAppBar$Model$Init(
											{scrollPosition: scrollPosition, topAppBarHeight: topAppBarHeight});
									}),
								aforemny$elm_mdc$Internal$TopAppBar$Implementation$getViewportScrollY,
								aforemny$elm_mdc$Internal$TopAppBar$Implementation$getAppBarHeight))))
				]),
			_List_Nil,
			_List_fromArray(
				[
					A2(aforemny$elm_mdc$Internal$TopAppBar$Implementation$row, _List_Nil, sections)
				]));
	});
var aforemny$elm_mdc$Internal$TopAppBar$Implementation$view = A3(aforemny$elm_mdc$Internal$Component$render, aforemny$elm_mdc$Internal$TopAppBar$Implementation$getSet.get, aforemny$elm_mdc$Internal$TopAppBar$Implementation$topAppBar, aforemny$elm_mdc$Internal$Msg$TopAppBarMsg);
var aforemny$elm_mdc$Material$TopAppBar$view = aforemny$elm_mdc$Internal$TopAppBar$Implementation$view;
var aforemny$elm_mdc$Main$viewTopAppBar = function (model) {
	return A5(
		aforemny$elm_mdc$Material$TopAppBar$view,
		aforemny$elm_mdc$Main$Mdc,
		'my-top-app-bar',
		model.mdc,
		_List_fromArray(
			[aforemny$elm_mdc$Material$TopAppBar$fixed]),
		_List_fromArray(
			[
				A2(
				aforemny$elm_mdc$Material$TopAppBar$section,
				_List_fromArray(
					[aforemny$elm_mdc$Material$TopAppBar$alignStart]),
				_List_fromArray(
					[
						A5(
						aforemny$elm_mdc$Material$TopAppBar$navigationIcon,
						aforemny$elm_mdc$Main$Mdc,
						'my-menu',
						model.mdc,
						_List_fromArray(
							[
								aforemny$elm_mdc$Material$Options$onClick(aforemny$elm_mdc$Main$ToggleDrawer)
							]),
						'menu'),
						A2(
						aforemny$elm_mdc$Material$TopAppBar$title,
						_List_Nil,
						_List_fromArray(
							[
								elm$html$Html$text('cim comes')
							]))
					])),
				A2(
				aforemny$elm_mdc$Material$TopAppBar$section,
				_List_fromArray(
					[aforemny$elm_mdc$Material$TopAppBar$alignEnd]),
				_List_fromArray(
					[
						A5(aforemny$elm_mdc$Material$TopAppBar$actionItem, aforemny$elm_mdc$Main$Mdc, 'foo', model.mdc, _List_Nil, 'print'),
						A5(aforemny$elm_mdc$Material$TopAppBar$actionItem, aforemny$elm_mdc$Main$Mdc, 'bar', model.mdc, _List_Nil, 'more_vert')
					]))
			]));
};
var aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$appContent = aforemny$elm_mdc$Internal$Options$cs('mdc-drawer-app-content');
var aforemny$elm_mdc$Material$Drawer$Dismissible$appContent = aforemny$elm_mdc$Internal$Drawer$Dismissible$Implementation$appContent;
var aforemny$elm_mdc$Main$mainPage = function (model) {
	return A2(
		elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				aforemny$elm_mdc$Main$viewDrawer(model),
				A3(
				aforemny$elm_mdc$Material$Options$styled,
				elm$html$Html$div,
				_List_fromArray(
					[aforemny$elm_mdc$Material$Drawer$Dismissible$appContent]),
				_List_fromArray(
					[
						aforemny$elm_mdc$Main$viewTopAppBar(model),
						aforemny$elm_mdc$Main$viewContent(model)
					]))
			]));
};
var aforemny$elm_mdc$Main$view = function (model) {
	return model.authenticated ? aforemny$elm_mdc$Main$mainPage(model) : aforemny$elm_mdc$Main$loginPage(model);
};
var elm$browser$Browser$element = _Browser_element;
var elm$core$Platform$Sub$batch = _Platform_batch;
var elm$core$Platform$Sub$none = elm$core$Platform$Sub$batch(_List_Nil);
var aforemny$elm_mdc$Main$main = elm$browser$Browser$element(
	{
		init: function (_n0) {
			return _Utils_Tuple2(aforemny$elm_mdc$Main$defaultModel, elm$core$Platform$Cmd$none);
		},
		subscriptions: function (_n1) {
			return elm$core$Platform$Sub$none;
		},
		update: aforemny$elm_mdc$Main$update,
		view: aforemny$elm_mdc$Main$view
	});
_Platform_export({'Main':{'init':aforemny$elm_mdc$Main$main(
	elm$json$Json$Decode$succeed(_Utils_Tuple0))(0)}});}(this));