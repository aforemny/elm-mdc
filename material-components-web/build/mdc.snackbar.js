/*!
 Material Components for the web
 Copyright (c) 2017 Google Inc.
 License: Apache-2.0
*/
(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define([], factory);
	else if(typeof exports === 'object')
		exports["snackbar"] = factory();
	else
		root["mdc"] = root["mdc"] || {}, root["mdc"]["snackbar"] = factory();
})(this, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/assets/";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 82);
/******/ })
/************************************************************************/
/******/ ({

/***/ 0:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * Copyright 2016 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @template A
 */
var MDCFoundation = function () {
  _createClass(MDCFoundation, null, [{
    key: "cssClasses",

    /** @return enum{cssClasses} */
    get: function get() {
      // Classes extending MDCFoundation should implement this method to return an object which exports every
      // CSS class the foundation class needs as a property. e.g. {ACTIVE: 'mdc-component--active'}
      return {};
    }

    /** @return enum{strings} */

  }, {
    key: "strings",
    get: function get() {
      // Classes extending MDCFoundation should implement this method to return an object which exports all
      // semantic strings as constants. e.g. {ARIA_ROLE: 'tablist'}
      return {};
    }

    /** @return enum{numbers} */

  }, {
    key: "numbers",
    get: function get() {
      // Classes extending MDCFoundation should implement this method to return an object which exports all
      // of its semantic numbers as constants. e.g. {ANIMATION_DELAY_MS: 350}
      return {};
    }

    /** @return {!Object} */

  }, {
    key: "defaultAdapter",
    get: function get() {
      // Classes extending MDCFoundation may choose to implement this getter in order to provide a convenient
      // way of viewing the necessary methods of an adapter. In the future, this could also be used for adapter
      // validation.
      return {};
    }

    /**
     * @param {A=} adapter
     */

  }]);

  function MDCFoundation() {
    var adapter = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

    _classCallCheck(this, MDCFoundation);

    /** @protected {!A} */
    this.adapter_ = adapter;
  }

  _createClass(MDCFoundation, [{
    key: "init",
    value: function init() {
      // Subclasses should override this method to perform initialization routines (registering events, etc.)
    }
  }, {
    key: "destroy",
    value: function destroy() {
      // Subclasses should override this method to perform de-initialization routines (de-registering events, etc.)
    }
  }]);

  return MDCFoundation;
}();

/* harmony default export */ __webpack_exports__["a"] = (MDCFoundation);

/***/ }),

/***/ 1:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__foundation__ = __webpack_require__(0);
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * Copyright 2016 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



/**
 * @template F
 */

var MDCComponent = function () {
  _createClass(MDCComponent, null, [{
    key: 'attachTo',

    /**
     * @param {!Element} root
     * @return {!MDCComponent}
     */
    value: function attachTo(root) {
      // Subclasses which extend MDCBase should provide an attachTo() method that takes a root element and
      // returns an instantiated component with its root set to that element. Also note that in the cases of
      // subclasses, an explicit foundation class will not have to be passed in; it will simply be initialized
      // from getDefaultFoundation().
      return new MDCComponent(root, new __WEBPACK_IMPORTED_MODULE_0__foundation__["a" /* default */]());
    }

    /**
     * @param {!Element} root
     * @param {F=} foundation
     * @param {...?} args
     */

  }]);

  function MDCComponent(root) {
    var foundation = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : undefined;

    _classCallCheck(this, MDCComponent);

    /** @protected {!Element} */
    this.root_ = root;

    for (var _len = arguments.length, args = Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
      args[_key - 2] = arguments[_key];
    }

    this.initialize.apply(this, args);
    // Note that we initialize foundation here and not within the constructor's default param so that
    // this.root_ is defined and can be used within the foundation class.
    /** @protected {!F} */
    this.foundation_ = foundation === undefined ? this.getDefaultFoundation() : foundation;
    this.foundation_.init();
    this.initialSyncWithDOM();
  }

  _createClass(MDCComponent, [{
    key: 'initialize',
    value: function initialize() /* ...args */{}
    // Subclasses can override this to do any additional setup work that would be considered part of a
    // "constructor". Essentially, it is a hook into the parent constructor before the foundation is
    // initialized. Any additional arguments besides root and foundation will be passed in here.


    /**
     * @return {!F} foundation
     */

  }, {
    key: 'getDefaultFoundation',
    value: function getDefaultFoundation() {
      // Subclasses must override this method to return a properly configured foundation class for the
      // component.
      throw new Error('Subclasses must override getDefaultFoundation to return a properly configured ' + 'foundation class');
    }
  }, {
    key: 'initialSyncWithDOM',
    value: function initialSyncWithDOM() {
      // Subclasses should override this method if they need to perform work to synchronize with a host DOM
      // object. An example of this would be a form control wrapper that needs to synchronize its internal state
      // to some property or attribute of the host DOM. Please note: this is *not* the place to perform DOM
      // reads/writes that would cause layout / paint, as this is called synchronously from within the constructor.
    }
  }, {
    key: 'destroy',
    value: function destroy() {
      // Subclasses may implement this method to release any resources / deregister any listeners they have
      // attached. An example of this might be deregistering a resize event from the window object.
      this.foundation_.destroy();
    }

    /**
     * Wrapper method to add an event listener to the component's root element. This is most useful when
     * listening for custom events.
     * @param {string} evtType
     * @param {!Function} handler
     */

  }, {
    key: 'listen',
    value: function listen(evtType, handler) {
      this.root_.addEventListener(evtType, handler);
    }

    /**
     * Wrapper method to remove an event listener to the component's root element. This is most useful when
     * unlistening for custom events.
     * @param {string} evtType
     * @param {!Function} handler
     */

  }, {
    key: 'unlisten',
    value: function unlisten(evtType, handler) {
      this.root_.removeEventListener(evtType, handler);
    }

    /**
     * Fires a cross-browser-compatible custom event from the component root of the given type,
     * with the given data.
     * @param {string} evtType
     * @param {!Object} evtData
     * @param {boolean=} shouldBubble
     */

  }, {
    key: 'emit',
    value: function emit(evtType, evtData) {
      var shouldBubble = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : false;

      var evt = void 0;
      if (typeof CustomEvent === 'function') {
        evt = new CustomEvent(evtType, {
          detail: evtData,
          bubbles: shouldBubble
        });
      } else {
        evt = document.createEvent('CustomEvent');
        evt.initCustomEvent(evtType, shouldBubble, false, evtData);
      }

      this.root_.dispatchEvent(evt);
    }
  }]);

  return MDCComponent;
}();

/* harmony default export */ __webpack_exports__["a"] = (MDCComponent);

/***/ }),

/***/ 4:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__foundation__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__component__ = __webpack_require__(1);
/* harmony reexport (binding) */ __webpack_require__.d(__webpack_exports__, "MDCFoundation", function() { return __WEBPACK_IMPORTED_MODULE_0__foundation__["a"]; });
/* harmony reexport (binding) */ __webpack_require__.d(__webpack_exports__, "MDCComponent", function() { return __WEBPACK_IMPORTED_MODULE_1__component__["a"]; });
/**
 * Copyright 2016 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */






/***/ }),

/***/ 8:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "transformStyleProperties", function() { return transformStyleProperties; });
/* harmony export (immutable) */ __webpack_exports__["getCorrectEventName"] = getCorrectEventName;
/* harmony export (immutable) */ __webpack_exports__["getCorrectPropertyName"] = getCorrectPropertyName;
/**
 * Copyright 2016 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @typedef {{
 *   noPrefix: string,
 *   webkitPrefix: string
 * }}
 */
var VendorPropertyMapType = void 0;

/** @const {Object<string, !VendorPropertyMapType>} */
var eventTypeMap = {
  'animationstart': {
    noPrefix: 'animationstart',
    webkitPrefix: 'webkitAnimationStart',
    styleProperty: 'animation'
  },
  'animationend': {
    noPrefix: 'animationend',
    webkitPrefix: 'webkitAnimationEnd',
    styleProperty: 'animation'
  },
  'animationiteration': {
    noPrefix: 'animationiteration',
    webkitPrefix: 'webkitAnimationIteration',
    styleProperty: 'animation'
  },
  'transitionend': {
    noPrefix: 'transitionend',
    webkitPrefix: 'webkitTransitionEnd',
    styleProperty: 'transition'
  }
};

/** @const {Object<string, !VendorPropertyMapType>} */
var cssPropertyMap = {
  'animation': {
    noPrefix: 'animation',
    webkitPrefix: '-webkit-animation'
  },
  'transform': {
    noPrefix: 'transform',
    webkitPrefix: '-webkit-transform'
  },
  'transition': {
    noPrefix: 'transition',
    webkitPrefix: '-webkit-transition'
  }
};

/**
 * @param {!Object} windowObj
 * @return {boolean}
 */
function hasProperShape(windowObj) {
  return windowObj['document'] !== undefined && typeof windowObj['document']['createElement'] === 'function';
}

/**
 * @param {string} eventType
 * @return {boolean}
 */
function eventFoundInMaps(eventType) {
  return eventType in eventTypeMap || eventType in cssPropertyMap;
}

/**
 * @param {string} eventType
 * @param {!Object<string, !VendorPropertyMapType>} map
 * @param {!Element} el
 * @return {string}
 */
function getJavaScriptEventName(eventType, map, el) {
  return map[eventType].styleProperty in el.style ? map[eventType].noPrefix : map[eventType].webkitPrefix;
}

/**
 * Helper function to determine browser prefix for CSS3 animation events
 * and property names.
 * @param {!Object} windowObj
 * @param {string} eventType
 * @return {string}
 */
function getAnimationName(windowObj, eventType) {
  if (!hasProperShape(windowObj) || !eventFoundInMaps(eventType)) {
    return eventType;
  }

  var map = /** @type {!Object<string, !VendorPropertyMapType>} */eventType in eventTypeMap ? eventTypeMap : cssPropertyMap;
  var el = windowObj['document']['createElement']('div');
  var eventName = '';

  if (map === eventTypeMap) {
    eventName = getJavaScriptEventName(eventType, map, el);
  } else {
    eventName = map[eventType].noPrefix in el.style ? map[eventType].noPrefix : map[eventType].webkitPrefix;
  }

  return eventName;
}

// Public functions to access getAnimationName() for JavaScript events or CSS
// property names.

var transformStyleProperties = ['transform', 'WebkitTransform', 'MozTransform', 'OTransform', 'MSTransform'];

/**
 * @param {!Object} windowObj
 * @param {string} eventType
 * @return {string}
 */
function getCorrectEventName(windowObj, eventType) {
  return getAnimationName(windowObj, eventType);
}

/**
 * @param {!Object} windowObj
 * @param {string} eventType
 * @return {string}
 */
function getCorrectPropertyName(windowObj, eventType) {
  return getAnimationName(windowObj, eventType);
}

/***/ }),

/***/ 82:
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(83);


/***/ }),

/***/ 83:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "MDCSnackbar", function() { return MDCSnackbar; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__material_base__ = __webpack_require__(4);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__foundation__ = __webpack_require__(84);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__material_animation__ = __webpack_require__(8);
/* harmony reexport (binding) */ __webpack_require__.d(__webpack_exports__, "MDCSnackbarFoundation", function() { return __WEBPACK_IMPORTED_MODULE_1__foundation__["a"]; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

/**
 * Copyright 2016 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */







var MDCSnackbar = function (_MDCComponent) {
  _inherits(MDCSnackbar, _MDCComponent);

  function MDCSnackbar() {
    _classCallCheck(this, MDCSnackbar);

    return _possibleConstructorReturn(this, (MDCSnackbar.__proto__ || Object.getPrototypeOf(MDCSnackbar)).apply(this, arguments));
  }

  _createClass(MDCSnackbar, [{
    key: 'show',
    value: function show(data) {
      this.foundation_.show(data);
    }
  }, {
    key: 'getDefaultFoundation',
    value: function getDefaultFoundation() {
      var _this2 = this;

      var _MDCSnackbarFoundatio = __WEBPACK_IMPORTED_MODULE_1__foundation__["a" /* default */].strings,
          TEXT_SELECTOR = _MDCSnackbarFoundatio.TEXT_SELECTOR,
          ACTION_BUTTON_SELECTOR = _MDCSnackbarFoundatio.ACTION_BUTTON_SELECTOR;

      var getText = function getText() {
        return _this2.root_.querySelector(TEXT_SELECTOR);
      };
      var getActionButton = function getActionButton() {
        return _this2.root_.querySelector(ACTION_BUTTON_SELECTOR);
      };

      /* eslint brace-style: "off" */
      return new __WEBPACK_IMPORTED_MODULE_1__foundation__["a" /* default */]({
        addClass: function addClass(className) {
          return _this2.root_.classList.add(className);
        },
        removeClass: function removeClass(className) {
          return _this2.root_.classList.remove(className);
        },
        setAriaHidden: function setAriaHidden() {
          return _this2.root_.setAttribute('aria-hidden', 'true');
        },
        unsetAriaHidden: function unsetAriaHidden() {
          return _this2.root_.removeAttribute('aria-hidden');
        },
        setActionAriaHidden: function setActionAriaHidden() {
          return getActionButton().setAttribute('aria-hidden', 'true');
        },
        unsetActionAriaHidden: function unsetActionAriaHidden() {
          return getActionButton().removeAttribute('aria-hidden');
        },
        setActionText: function setActionText(text) {
          getActionButton().textContent = text;
        },
        setMessageText: function setMessageText(text) {
          getText().textContent = text;
        },
        setFocus: function setFocus() {
          return getActionButton().focus();
        },
        visibilityIsHidden: function visibilityIsHidden() {
          return document.hidden;
        },
        registerCapturedBlurHandler: function registerCapturedBlurHandler(handler) {
          return getActionButton().addEventListener('blur', handler, true);
        },
        deregisterCapturedBlurHandler: function deregisterCapturedBlurHandler(handler) {
          return getActionButton().removeEventListener('blur', handler, true);
        },
        registerVisibilityChangeHandler: function registerVisibilityChangeHandler(handler) {
          return document.addEventListener('visibilitychange', handler);
        },
        deregisterVisibilityChangeHandler: function deregisterVisibilityChangeHandler(handler) {
          return document.removeEventListener('visibilitychange', handler);
        },
        registerCapturedInteractionHandler: function registerCapturedInteractionHandler(evt, handler) {
          return document.body.addEventListener(evt, handler, true);
        },
        deregisterCapturedInteractionHandler: function deregisterCapturedInteractionHandler(evt, handler) {
          return document.body.removeEventListener(evt, handler, true);
        },
        registerActionClickHandler: function registerActionClickHandler(handler) {
          return getActionButton().addEventListener('click', handler);
        },
        deregisterActionClickHandler: function deregisterActionClickHandler(handler) {
          return getActionButton().removeEventListener('click', handler);
        },
        registerTransitionEndHandler: function registerTransitionEndHandler(handler) {
          return _this2.root_.addEventListener(Object(__WEBPACK_IMPORTED_MODULE_2__material_animation__["getCorrectEventName"])(window, 'transitionend'), handler);
        },
        deregisterTransitionEndHandler: function deregisterTransitionEndHandler(handler) {
          return _this2.root_.removeEventListener(Object(__WEBPACK_IMPORTED_MODULE_2__material_animation__["getCorrectEventName"])(window, 'transitionend'), handler);
        }
      });
    }
  }, {
    key: 'dismissesOnAction',
    get: function get() {
      return this.foundation_.dismissesOnAction();
    },
    set: function set(dismissesOnAction) {
      this.foundation_.setDismissOnAction(dismissesOnAction);
    }
  }], [{
    key: 'attachTo',
    value: function attachTo(root) {
      return new MDCSnackbar(root);
    }
  }]);

  return MDCSnackbar;
}(__WEBPACK_IMPORTED_MODULE_0__material_base__["MDCComponent"]);

/***/ }),

/***/ 84:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__material_base__ = __webpack_require__(4);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__constants__ = __webpack_require__(85);
var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

/**
 * Copyright 2016 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */




var MDCSnackbarFoundation = function (_MDCFoundation) {
  _inherits(MDCSnackbarFoundation, _MDCFoundation);

  _createClass(MDCSnackbarFoundation, [{
    key: 'active',
    get: function get() {
      return this.active_;
    }
  }], [{
    key: 'cssClasses',
    get: function get() {
      return __WEBPACK_IMPORTED_MODULE_1__constants__["a" /* cssClasses */];
    }
  }, {
    key: 'strings',
    get: function get() {
      return __WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */];
    }
  }, {
    key: 'defaultAdapter',
    get: function get() {
      return {
        addClass: function addClass() /* className: string */{},
        removeClass: function removeClass() /* className: string */{},
        setAriaHidden: function setAriaHidden() {},
        unsetAriaHidden: function unsetAriaHidden() {},
        setActionAriaHidden: function setActionAriaHidden() {},
        unsetActionAriaHidden: function unsetActionAriaHidden() {},
        setActionText: function setActionText() /* actionText: string */{},
        setMessageText: function setMessageText() /* message: string */{},
        setFocus: function setFocus() {},
        visibilityIsHidden: function visibilityIsHidden() {
          return (/* boolean */false
          );
        },
        registerCapturedBlurHandler: function registerCapturedBlurHandler() /* handler: EventListener */{},
        deregisterCapturedBlurHandler: function deregisterCapturedBlurHandler() /* handler: EventListener */{},
        registerVisibilityChangeHandler: function registerVisibilityChangeHandler() /* handler: EventListener */{},
        deregisterVisibilityChangeHandler: function deregisterVisibilityChangeHandler() /* handler: EventListener */{},
        registerCapturedInteractionHandler: function registerCapturedInteractionHandler() /* evtType: string, handler: EventListener */{},
        deregisterCapturedInteractionHandler: function deregisterCapturedInteractionHandler() /* evtType: string, handler: EventListener */{},
        registerActionClickHandler: function registerActionClickHandler() /* handler: EventListener */{},
        deregisterActionClickHandler: function deregisterActionClickHandler() /* handler: EventListener */{},
        registerTransitionEndHandler: function registerTransitionEndHandler() /* handler: EventListener */{},
        deregisterTransitionEndHandler: function deregisterTransitionEndHandler() /* handler: EventListener */{}
      };
    }
  }]);

  function MDCSnackbarFoundation(adapter) {
    _classCallCheck(this, MDCSnackbarFoundation);

    var _this = _possibleConstructorReturn(this, (MDCSnackbarFoundation.__proto__ || Object.getPrototypeOf(MDCSnackbarFoundation)).call(this, _extends(MDCSnackbarFoundation.defaultAdapter, adapter)));

    _this.active_ = false;
    _this.actionWasClicked_ = false;
    _this.dismissOnAction_ = true;
    _this.firstFocus_ = true;
    _this.pointerDownRecognized_ = false;
    _this.snackbarHasFocus_ = false;
    _this.snackbarData_ = null;
    _this.queue_ = [];
    _this.actionClickHandler_ = function () {
      _this.actionWasClicked_ = true;
      _this.invokeAction_();
    };
    _this.visibilitychangeHandler_ = function () {
      clearTimeout(_this.timeoutId_);
      _this.snackbarHasFocus_ = true;

      if (!_this.adapter_.visibilityIsHidden()) {
        setTimeout(_this.cleanup_.bind(_this), _this.snackbarData_.timeout || __WEBPACK_IMPORTED_MODULE_1__constants__["b" /* numbers */].MESSAGE_TIMEOUT);
      }
    };
    _this.interactionHandler_ = function (evt) {
      if (evt.type == 'touchstart' || evt.type == 'mousedown') {
        _this.pointerDownRecognized_ = true;
      }
      _this.handlePossibleTabKeyboardFocus_(evt);

      if (evt.type == 'focus') {
        _this.pointerDownRecognized_ = false;
      }
    };
    _this.blurHandler_ = function () {
      clearTimeout(_this.timeoutId_);
      _this.snackbarHasFocus_ = false;
      _this.timeoutId_ = setTimeout(_this.cleanup_.bind(_this), _this.snackbarData_.timeout || __WEBPACK_IMPORTED_MODULE_1__constants__["b" /* numbers */].MESSAGE_TIMEOUT);
    };
    return _this;
  }

  _createClass(MDCSnackbarFoundation, [{
    key: 'init',
    value: function init() {
      this.adapter_.registerActionClickHandler(this.actionClickHandler_);
      this.adapter_.setAriaHidden();
      this.adapter_.setActionAriaHidden();
    }
  }, {
    key: 'destroy',
    value: function destroy() {
      var _this2 = this;

      this.adapter_.deregisterActionClickHandler(this.actionClickHandler_);
      this.adapter_.deregisterCapturedBlurHandler(this.blurHandler_);
      this.adapter_.deregisterVisibilityChangeHandler(this.visibilitychangeHandler_);
      ['touchstart', 'mousedown', 'focus'].forEach(function (evtType) {
        _this2.adapter_.deregisterCapturedInteractionHandler(evtType, _this2.interactionHandler_);
      });
    }
  }, {
    key: 'dismissesOnAction',
    value: function dismissesOnAction() {
      return this.dismissOnAction_;
    }
  }, {
    key: 'setDismissOnAction',
    value: function setDismissOnAction(dismissOnAction) {
      this.dismissOnAction_ = !!dismissOnAction;
    }
  }, {
    key: 'show',
    value: function show(data) {
      var _this3 = this;

      if (!data) {
        throw new Error('Please provide a data object with at least a message to display.');
      }
      if (!data.message) {
        throw new Error('Please provide a message to be displayed.');
      }
      if (data.actionHandler && !data.actionText) {
        throw new Error('Please provide action text with the handler.');
      }
      if (this.active) {
        this.queue_.push(data);
        return;
      }
      clearTimeout(this.timeoutId_);
      this.snackbarData_ = data;
      this.firstFocus_ = true;
      this.adapter_.registerVisibilityChangeHandler(this.visibilitychangeHandler_);
      this.adapter_.registerCapturedBlurHandler(this.blurHandler_);
      ['touchstart', 'mousedown', 'focus'].forEach(function (evtType) {
        _this3.adapter_.registerCapturedInteractionHandler(evtType, _this3.interactionHandler_);
      });

      var ACTIVE = __WEBPACK_IMPORTED_MODULE_1__constants__["a" /* cssClasses */].ACTIVE,
          MULTILINE = __WEBPACK_IMPORTED_MODULE_1__constants__["a" /* cssClasses */].MULTILINE,
          ACTION_ON_BOTTOM = __WEBPACK_IMPORTED_MODULE_1__constants__["a" /* cssClasses */].ACTION_ON_BOTTOM;


      this.adapter_.setMessageText(this.snackbarData_.message);

      if (this.snackbarData_.multiline) {
        this.adapter_.addClass(MULTILINE);
        if (this.snackbarData_.actionOnBottom) {
          this.adapter_.addClass(ACTION_ON_BOTTOM);
        }
      }

      if (this.snackbarData_.actionHandler) {
        this.adapter_.setActionText(this.snackbarData_.actionText);
        this.actionHandler_ = this.snackbarData_.actionHandler;
        this.setActionHidden_(false);
      } else {
        this.setActionHidden_(true);
        this.actionHandler_ = null;
        this.adapter_.setActionText(null);
      }

      this.active_ = true;
      this.adapter_.addClass(ACTIVE);
      this.adapter_.unsetAriaHidden();

      this.timeoutId_ = setTimeout(this.cleanup_.bind(this), this.snackbarData_.timeout || __WEBPACK_IMPORTED_MODULE_1__constants__["b" /* numbers */].MESSAGE_TIMEOUT);
    }
  }, {
    key: 'handlePossibleTabKeyboardFocus_',
    value: function handlePossibleTabKeyboardFocus_() {
      var hijackFocus = this.firstFocus_ && !this.pointerDownRecognized_;

      if (hijackFocus) {
        this.setFocusOnAction_();
      }

      this.firstFocus_ = false;
    }
  }, {
    key: 'setFocusOnAction_',
    value: function setFocusOnAction_() {
      this.adapter_.setFocus();
      this.snackbarHasFocus_ = true;
      this.firstFocus_ = false;
    }
  }, {
    key: 'invokeAction_',
    value: function invokeAction_() {
      try {
        if (!this.actionHandler_) {
          return;
        }

        this.actionHandler_();
      } finally {
        if (this.dismissOnAction_) {
          this.cleanup_();
        }
      }
    }
  }, {
    key: 'cleanup_',
    value: function cleanup_() {
      var _this4 = this;

      var allowDismissal = !this.snackbarHasFocus_ || this.actionWasClicked_;

      if (allowDismissal) {
        var ACTIVE = __WEBPACK_IMPORTED_MODULE_1__constants__["a" /* cssClasses */].ACTIVE,
            MULTILINE = __WEBPACK_IMPORTED_MODULE_1__constants__["a" /* cssClasses */].MULTILINE,
            ACTION_ON_BOTTOM = __WEBPACK_IMPORTED_MODULE_1__constants__["a" /* cssClasses */].ACTION_ON_BOTTOM;


        this.adapter_.removeClass(ACTIVE);

        var handler = function handler() {
          clearTimeout(_this4.timeoutId_);
          _this4.adapter_.deregisterTransitionEndHandler(handler);
          _this4.adapter_.removeClass(MULTILINE);
          _this4.adapter_.removeClass(ACTION_ON_BOTTOM);
          _this4.setActionHidden_(true);
          _this4.adapter_.setAriaHidden();
          _this4.active_ = false;
          _this4.snackbarHasFocus_ = false;
          _this4.showNext_();
        };

        this.adapter_.registerTransitionEndHandler(handler);
      }
    }
  }, {
    key: 'showNext_',
    value: function showNext_() {
      if (!this.queue_.length) {
        return;
      }
      this.show(this.queue_.shift());
    }
  }, {
    key: 'setActionHidden_',
    value: function setActionHidden_(isHidden) {
      if (isHidden) {
        this.adapter_.setActionAriaHidden();
      } else {
        this.adapter_.unsetActionAriaHidden();
      }
    }
  }]);

  return MDCSnackbarFoundation;
}(__WEBPACK_IMPORTED_MODULE_0__material_base__["MDCFoundation"]);

/* harmony default export */ __webpack_exports__["a"] = (MDCSnackbarFoundation);

/***/ }),

/***/ 85:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return cssClasses; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "c", function() { return strings; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "b", function() { return numbers; });
/**
 * Copyright 2016 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
var cssClasses = {
  ROOT: 'mdc-snackbar',
  TEXT: 'mdc-snackbar__text',
  ACTION_WRAPPER: 'mdc-snackbar__action-wrapper',
  ACTION_BUTTON: 'mdc-snackbar__action-button',
  ACTIVE: 'mdc-snackbar--active',
  MULTILINE: 'mdc-snackbar--multiline',
  ACTION_ON_BOTTOM: 'mdc-snackbar--action-on-bottom'
};

var strings = {
  TEXT_SELECTOR: '.mdc-snackbar__text',
  ACTION_WRAPPER_SELECTOR: '.mdc-snackbar__action-wrapper',
  ACTION_BUTTON_SELECTOR: '.mdc-snackbar__action-button'
};

var numbers = {
  MESSAGE_TIMEOUT: 2750
};

/***/ })

/******/ });
});