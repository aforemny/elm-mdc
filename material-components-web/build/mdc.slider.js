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
		exports["slider"] = factory();
	else
		root["mdc"] = root["mdc"] || {}, root["mdc"]["slider"] = factory();
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
/******/ 	return __webpack_require__(__webpack_require__.s = 79);
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

/***/ 18:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return cssClasses; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "c", function() { return strings; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "b", function() { return numbers; });
/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

var cssClasses = {
  ACTIVE: 'mdc-slider--active',
  DISABLED: 'mdc-slider--disabled',
  DISCRETE: 'mdc-slider--discrete',
  FOCUS: 'mdc-slider--focus',
  IN_TRANSIT: 'mdc-slider--in-transit',
  OFF: 'mdc-slider--off',
  IS_DISCRETE: 'mdc-slider--discrete',
  HAS_TRACK_MARKER: 'mdc-slider--display-markers'
};

var strings = {
  TRACK_SELECTOR: '.mdc-slider__track',
  TRACK_MARKER_CONTAINER_SELECTOR: '.mdc-slider__track-marker-container',
  LAST_TRACK_MARKER_SELECTOR: '.mdc-slider__track-marker:last-child',
  THUMB_CONTAINER_SELECTOR: '.mdc-slider__thumb-container',
  PIN_VALUE_MARKER_SELECTOR: '.mdc-slider__pin-value-marker',
  ARIA_VALUEMIN: 'aria-valuemin',
  ARIA_VALUEMAX: 'aria-valuemax',
  ARIA_VALUENOW: 'aria-valuenow',
  ARIA_DISABLED: 'aria-disabled',
  STEP_DATA_ATTR: 'data-step',
  CHANGE_EVENT: 'MDCSlider:change',
  INPUT_EVENT: 'MDCSlider:input'
};

var numbers = {
  PAGE_FACTOR: 4
};

/***/ }),

/***/ 79:
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(80);


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

/***/ 80:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "MDCSlider", function() { return MDCSlider; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__material_base_component__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__constants__ = __webpack_require__(18);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__foundation__ = __webpack_require__(81);
/* harmony reexport (binding) */ __webpack_require__.d(__webpack_exports__, "MDCSliderFoundation", function() { return __WEBPACK_IMPORTED_MODULE_2__foundation__["a"]; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */








var MDCSlider = function (_MDCComponent) {
  _inherits(MDCSlider, _MDCComponent);

  function MDCSlider() {
    _classCallCheck(this, MDCSlider);

    return _possibleConstructorReturn(this, (MDCSlider.__proto__ || Object.getPrototypeOf(MDCSlider)).apply(this, arguments));
  }

  _createClass(MDCSlider, [{
    key: 'initialize',
    value: function initialize() {
      this.thumbContainer_ = this.root_.querySelector(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].THUMB_CONTAINER_SELECTOR);
      this.track_ = this.root_.querySelector(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].TRACK_SELECTOR);
      this.pinValueMarker_ = this.root_.querySelector(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].PIN_VALUE_MARKER_SELECTOR);
      this.trackMarkerContainer_ = this.root_.querySelector(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].TRACK_MARKER_CONTAINER_SELECTOR);
    }
  }, {
    key: 'getDefaultFoundation',
    value: function getDefaultFoundation() {
      var _this2 = this;

      return new __WEBPACK_IMPORTED_MODULE_2__foundation__["a" /* default */]({
        hasClass: function hasClass(className) {
          return _this2.root_.classList.contains(className);
        },
        addClass: function addClass(className) {
          return _this2.root_.classList.add(className);
        },
        removeClass: function removeClass(className) {
          return _this2.root_.classList.remove(className);
        },
        getAttribute: function getAttribute(name) {
          return _this2.root_.getAttribute(name);
        },
        setAttribute: function setAttribute(name, value) {
          return _this2.root_.setAttribute(name, value);
        },
        removeAttribute: function removeAttribute(name) {
          return _this2.root_.removeAttribute(name);
        },
        computeBoundingRect: function computeBoundingRect() {
          return _this2.root_.getBoundingClientRect();
        },
        getTabIndex: function getTabIndex() {
          return _this2.root_.tabIndex;
        },
        registerInteractionHandler: function registerInteractionHandler(type, handler) {
          _this2.root_.addEventListener(type, handler);
        },
        deregisterInteractionHandler: function deregisterInteractionHandler(type, handler) {
          _this2.root_.removeEventListener(type, handler);
        },
        registerThumbContainerInteractionHandler: function registerThumbContainerInteractionHandler(type, handler) {
          _this2.thumbContainer_.addEventListener(type, handler);
        },
        deregisterThumbContainerInteractionHandler: function deregisterThumbContainerInteractionHandler(type, handler) {
          _this2.thumbContainer_.removeEventListener(type, handler);
        },
        registerBodyInteractionHandler: function registerBodyInteractionHandler(type, handler) {
          document.body.addEventListener(type, handler);
        },
        deregisterBodyInteractionHandler: function deregisterBodyInteractionHandler(type, handler) {
          document.body.removeEventListener(type, handler);
        },
        registerResizeHandler: function registerResizeHandler(handler) {
          window.addEventListener('resize', handler);
        },
        deregisterResizeHandler: function deregisterResizeHandler(handler) {
          window.removeEventListener('resize', handler);
        },
        notifyInput: function notifyInput() {
          _this2.emit(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].INPUT_EVENT, _this2);
        },
        notifyChange: function notifyChange() {
          _this2.emit(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].CHANGE_EVENT, _this2);
        },
        setThumbContainerStyleProperty: function setThumbContainerStyleProperty(propertyName, value) {
          _this2.thumbContainer_.style.setProperty(propertyName, value);
        },
        setTrackStyleProperty: function setTrackStyleProperty(propertyName, value) {
          _this2.track_.style.setProperty(propertyName, value);
        },
        setMarkerValue: function setMarkerValue(value) {
          _this2.pinValueMarker_.innerText = value;
        },
        appendTrackMarkers: function appendTrackMarkers(numMarkers) {
          var frag = document.createDocumentFragment();
          for (var i = 0; i < numMarkers; i++) {
            var marker = document.createElement('div');
            marker.classList.add('mdc-slider__track-marker');
            frag.appendChild(marker);
          }
          _this2.trackMarkerContainer_.appendChild(frag);
        },
        removeTrackMarkers: function removeTrackMarkers() {
          while (_this2.trackMarkerContainer_.firstChild) {
            _this2.trackMarkerContainer_.removeChild(_this2.trackMarkerContainer_.firstChild);
          }
        },
        setLastTrackMarkersStyleProperty: function setLastTrackMarkersStyleProperty(propertyName, value) {
          // We remove and append new nodes, thus, the last track marker must be dynamically found.
          var lastTrackMarker = _this2.root_.querySelector(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].LAST_TRACK_MARKER_SELECTOR);
          lastTrackMarker.style.setProperty(propertyName, value);
        },
        isRTL: function isRTL() {
          return getComputedStyle(_this2.root_).direction === 'rtl';
        }
      });
    }
  }, {
    key: 'initialSyncWithDOM',
    value: function initialSyncWithDOM() {
      var origValueNow = parseFloat(this.root_.getAttribute(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].ARIA_VALUENOW));
      this.min = parseFloat(this.root_.getAttribute(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].ARIA_VALUEMIN)) || this.min;
      this.max = parseFloat(this.root_.getAttribute(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].ARIA_VALUEMAX)) || this.max;
      this.step = parseFloat(this.root_.getAttribute(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].STEP_DATA_ATTR)) || this.step;
      this.value = origValueNow || this.value;
      this.disabled = this.root_.hasAttribute(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].ARIA_DISABLED) && this.root_.getAttribute(__WEBPACK_IMPORTED_MODULE_1__constants__["c" /* strings */].ARIA_DISABLED) !== 'false';
      this.foundation_.setupTrackMarker();
    }
  }, {
    key: 'layout',
    value: function layout() {
      this.foundation_.layout();
    }
  }, {
    key: 'stepUp',
    value: function stepUp() {
      var amount = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : this.step || 1;

      this.value += amount;
    }
  }, {
    key: 'stepDown',
    value: function stepDown() {
      var amount = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : this.step || 1;

      this.value -= amount;
    }
  }, {
    key: 'value',
    get: function get() {
      return this.foundation_.getValue();
    },
    set: function set(value) {
      this.foundation_.setValue(value);
    }
  }, {
    key: 'min',
    get: function get() {
      return this.foundation_.getMin();
    },
    set: function set(min) {
      this.foundation_.setMin(min);
    }
  }, {
    key: 'max',
    get: function get() {
      return this.foundation_.getMax();
    },
    set: function set(max) {
      this.foundation_.setMax(max);
    }
  }, {
    key: 'step',
    get: function get() {
      return this.foundation_.getStep();
    },
    set: function set(step) {
      this.foundation_.setStep(step);
    }
  }, {
    key: 'disabled',
    get: function get() {
      return this.foundation_.isDisabled();
    },
    set: function set(disabled) {
      this.foundation_.setDisabled(disabled);
    }
  }], [{
    key: 'attachTo',
    value: function attachTo(root) {
      return new MDCSlider(root);
    }
  }]);

  return MDCSlider;
}(__WEBPACK_IMPORTED_MODULE_0__material_base_component__["a" /* default */]);

/***/ }),

/***/ 81:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__constants__ = __webpack_require__(18);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__material_animation__ = __webpack_require__(8);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__material_base_foundation__ = __webpack_require__(0);
var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 *you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */






var KEY_IDS = {
  ARROW_LEFT: 'ArrowLeft',
  ARROW_RIGHT: 'ArrowRight',
  ARROW_UP: 'ArrowUp',
  ARROW_DOWN: 'ArrowDown',
  HOME: 'Home',
  END: 'End',
  PAGE_UP: 'PageUp',
  PAGE_DOWN: 'PageDown'
};

var MDCSliderFoundation = function (_MDCFoundation) {
  _inherits(MDCSliderFoundation, _MDCFoundation);

  _createClass(MDCSliderFoundation, null, [{
    key: 'cssClasses',
    get: function get() {
      return __WEBPACK_IMPORTED_MODULE_0__constants__["a" /* cssClasses */];
    }
  }, {
    key: 'strings',
    get: function get() {
      return __WEBPACK_IMPORTED_MODULE_0__constants__["c" /* strings */];
    }
  }, {
    key: 'numbers',
    get: function get() {
      return __WEBPACK_IMPORTED_MODULE_0__constants__["b" /* numbers */];
    }
  }, {
    key: 'defaultAdapter',
    get: function get() {
      return {
        hasClass: function hasClass() {
          return (/* className: string */ /* boolean */false
          );
        },
        addClass: function addClass() /* className: string */{},
        removeClass: function removeClass() /* className: string */{},
        getAttribute: function getAttribute() {
          return (/* name: string */ /* string|null */null
          );
        },
        setAttribute: function setAttribute() /* name: string, value: string */{},
        removeAttribute: function removeAttribute() /* name: string */{},
        computeBoundingRect: function computeBoundingRect() {
          return (/* ClientRect */{
              top: 0, right: 0, bottom: 0, left: 0, width: 0, height: 0
            }
          );
        },
        getTabIndex: function getTabIndex() {
          return (/* number */0
          );
        },
        registerInteractionHandler: function registerInteractionHandler() /* type: string, handler: EventListener */{},
        deregisterInteractionHandler: function deregisterInteractionHandler() /* type: string, handler: EventListener */{},
        registerThumbContainerInteractionHandler: function registerThumbContainerInteractionHandler() /* type: string, handler: EventListener */{},
        deregisterThumbContainerInteractionHandler: function deregisterThumbContainerInteractionHandler() /* type: string, handler: EventListener */{},
        registerBodyInteractionHandler: function registerBodyInteractionHandler() /* type: string, handler: EventListener */{},
        deregisterBodyInteractionHandler: function deregisterBodyInteractionHandler() /* type: string, handler: EventListener */{},
        registerResizeHandler: function registerResizeHandler() /* handler: EventListener */{},
        deregisterResizeHandler: function deregisterResizeHandler() /* handler: EventListener */{},
        notifyInput: function notifyInput() {},
        notifyChange: function notifyChange() {},
        setThumbContainerStyleProperty: function setThumbContainerStyleProperty() /* propertyName: string, value: string */{},
        setTrackStyleProperty: function setTrackStyleProperty() /* propertyName: string, value: string */{},
        setMarkerValue: function setMarkerValue() /* value: number */{},
        appendTrackMarkers: function appendTrackMarkers() /* numMarkers: number */{},
        removeTrackMarkers: function removeTrackMarkers() {},
        setLastTrackMarkersStyleProperty: function setLastTrackMarkersStyleProperty() /* propertyName: string, value: string */{},
        isRTL: function isRTL() {
          return (/* boolean */false
          );
        }
      };
    }
  }]);

  function MDCSliderFoundation() {
    var adapter = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

    _classCallCheck(this, MDCSliderFoundation);

    var _this = _possibleConstructorReturn(this, (MDCSliderFoundation.__proto__ || Object.getPrototypeOf(MDCSliderFoundation)).call(this, _extends(MDCSliderFoundation.defaultAdapter, adapter)));

    _this.rect_ = null;
    // We set this to NaN since we want it to be a number, but we can't use '0' or '-1'
    // because those could be valid tabindices set by the client code.
    _this.savedTabIndex_ = NaN;
    _this.off_ = false;
    _this.active_ = false;
    _this.inTransit_ = false;
    _this.isDiscrete_ = false;
    _this.hasTrackMarker_ = false;
    _this.handlingThumbTargetEvt_ = false;
    _this.min_ = 0;
    _this.max_ = 100;
    _this.step_ = 0;
    _this.value_ = 0;
    _this.disabled_ = false;
    _this.preventFocusState_ = false;
    _this.updateUIFrame_ = 0;
    _this.thumbContainerPointerHandler_ = function () {
      _this.handlingThumbTargetEvt_ = true;
    };
    _this.mousedownHandler_ = _this.createDownHandler_('mousemove', 'mouseup');
    _this.pointerdownHandler_ = _this.createDownHandler_('pointermove', 'pointerup');
    _this.touchstartHandler_ = _this.createDownHandler_('touchmove', 'touchend', function (_ref) {
      var targetTouches = _ref.targetTouches;
      return targetTouches[0].pageX;
    });
    _this.keydownHandler_ = function (evt) {
      return _this.handleKeydown_(evt);
    };
    _this.focusHandler_ = function () {
      return _this.handleFocus_();
    };
    _this.blurHandler_ = function () {
      return _this.handleBlur_();
    };
    _this.resizeHandler_ = function () {
      return _this.layout();
    };
    return _this;
  }

  _createClass(MDCSliderFoundation, [{
    key: 'init',
    value: function init() {
      var _this2 = this;

      this.isDiscrete_ = this.adapter_.hasClass(__WEBPACK_IMPORTED_MODULE_0__constants__["a" /* cssClasses */].IS_DISCRETE);
      this.hasTrackMarker_ = this.adapter_.hasClass(__WEBPACK_IMPORTED_MODULE_0__constants__["a" /* cssClasses */].HAS_TRACK_MARKER);
      this.adapter_.registerInteractionHandler('mousedown', this.mousedownHandler_);
      this.adapter_.registerInteractionHandler('pointerdown', this.pointerdownHandler_);
      this.adapter_.registerInteractionHandler('touchstart', this.touchstartHandler_);
      this.adapter_.registerInteractionHandler('keydown', this.keydownHandler_);
      this.adapter_.registerInteractionHandler('focus', this.focusHandler_);
      this.adapter_.registerInteractionHandler('blur', this.blurHandler_);
      ['mousedown', 'pointerdown', 'touchstart'].forEach(function (evtName) {
        _this2.adapter_.registerThumbContainerInteractionHandler(evtName, _this2.thumbContainerPointerHandler_);
      });
      this.adapter_.registerResizeHandler(this.resizeHandler_);
      this.layout();
      // At last step, provide a reasonable default value to discrete slider
      if (this.isDiscrete_ && this.getStep() == 0) {
        this.setStep(1);
      }
    }
  }, {
    key: 'destroy',
    value: function destroy() {
      var _this3 = this;

      this.adapter_.deregisterInteractionHandler('mousedown', this.mousedownHandler_);
      this.adapter_.deregisterInteractionHandler('pointerdown', this.mousedownHandler_);
      this.adapter_.deregisterInteractionHandler('touchstart', this.mousedownHandler_);
      this.adapter_.deregisterInteractionHandler('keydown', this.keydownHandler_);
      this.adapter_.deregisterInteractionHandler('focus', this.focusHandler_);
      this.adapter_.deregisterInteractionHandler('blur', this.blurHandler_);
      ['mousedown', 'pointerdown', 'touchstart'].forEach(function (evtName) {
        _this3.adapter_.deregisterThumbContainerInteractionHandler(evtName, _this3.thumbContainerPointerHandler_);
      });
      this.adapter_.deregisterResizeHandler(this.resizeHandler_);
    }
  }, {
    key: 'setupTrackMarker',
    value: function setupTrackMarker() {
      if (this.isDiscrete_ && this.hasTrackMarker_ && this.getStep() != 0) {
        var min = this.getMin();
        var max = this.getMax();
        var step = this.getStep();
        var numMarkers = (max - min) / step;

        // In case distance between max & min is indivisible to step,
        // we place the secondary to last marker proportionally at where thumb
        // could reach and place the last marker at max value
        var indivisible = Math.ceil(numMarkers) !== numMarkers;
        if (indivisible) {
          numMarkers = Math.ceil(numMarkers);
        }

        this.adapter_.removeTrackMarkers();
        this.adapter_.appendTrackMarkers(numMarkers);

        if (indivisible) {
          var lastStepRatio = (max - numMarkers * step) / step + 1;
          var flex = Object(__WEBPACK_IMPORTED_MODULE_1__material_animation__["getCorrectPropertyName"])(window, 'flex');
          this.adapter_.setLastTrackMarkersStyleProperty(flex, lastStepRatio);
        }
      }
    }
  }, {
    key: 'layout',
    value: function layout() {
      this.rect_ = this.adapter_.computeBoundingRect();
      this.updateUIForCurrentValue_();
    }
  }, {
    key: 'getValue',
    value: function getValue() {
      return this.value_;
    }
  }, {
    key: 'setValue',
    value: function setValue(value) {
      this.setValue_(value, false);
    }
  }, {
    key: 'getMax',
    value: function getMax() {
      return this.max_;
    }
  }, {
    key: 'setMax',
    value: function setMax(max) {
      if (max < this.min_) {
        throw new Error('Cannot set max to be less than the slider\'s minimum value');
      }
      this.max_ = max;
      this.setValue_(this.value_, false, true);
      this.adapter_.setAttribute(__WEBPACK_IMPORTED_MODULE_0__constants__["c" /* strings */].ARIA_VALUEMAX, String(this.max_));
      this.setupTrackMarker();
    }
  }, {
    key: 'getMin',
    value: function getMin() {
      return this.min_;
    }
  }, {
    key: 'setMin',
    value: function setMin(min) {
      if (min > this.max_) {
        throw new Error('Cannot set min to be greater than the slider\'s maximum value');
      }
      this.min_ = min;
      this.setValue_(this.value_, false, true);
      this.adapter_.setAttribute(__WEBPACK_IMPORTED_MODULE_0__constants__["c" /* strings */].ARIA_VALUEMIN, String(this.min_));
      this.setupTrackMarker();
    }
  }, {
    key: 'getStep',
    value: function getStep() {
      return this.step_;
    }
  }, {
    key: 'setStep',
    value: function setStep(step) {
      if (step < 0) {
        throw new Error('Step cannot be set to a negative number');
      }
      if (this.isDiscrete_ && (typeof step !== 'number' || step < 1)) {
        step = 1;
      }
      this.step_ = step;
      this.setValue_(this.value_, false, true);
      this.setupTrackMarker();
    }
  }, {
    key: 'isDisabled',
    value: function isDisabled() {
      return this.disabled_;
    }
  }, {
    key: 'setDisabled',
    value: function setDisabled(disabled) {
      this.disabled_ = disabled;
      this.toggleClass_(__WEBPACK_IMPORTED_MODULE_0__constants__["a" /* cssClasses */].DISABLED, this.disabled_);
      if (this.disabled_) {
        this.savedTabIndex_ = this.adapter_.getTabIndex();
        this.adapter_.setAttribute(__WEBPACK_IMPORTED_MODULE_0__constants__["c" /* strings */].ARIA_DISABLED, 'true');
        this.adapter_.removeAttribute('tabindex');
      } else {
        this.adapter_.removeAttribute(__WEBPACK_IMPORTED_MODULE_0__constants__["c" /* strings */].ARIA_DISABLED);
        if (!isNaN(this.savedTabIndex_)) {
          this.adapter_.setAttribute('tabindex', String(this.savedTabIndex_));
        }
      }
    }
  }, {
    key: 'createDownHandler_',
    value: function createDownHandler_(moveEvt, upEvt) {
      var _this4 = this;

      var getPageX = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : function (_ref2) {
        var pageX = _ref2.pageX;
        return pageX;
      };

      var moveHandler = function moveHandler(evt) {
        evt.preventDefault();
        _this4.setValueFromEvt_(evt, getPageX);
      };

      var upHandler = function upHandler() {
        _this4.setActive_(false);
        _this4.adapter_.deregisterBodyInteractionHandler(moveEvt, moveHandler);
        _this4.adapter_.deregisterBodyInteractionHandler(upEvt, upHandler);
        _this4.adapter_.notifyChange();
      };

      var downHandler = function downHandler(evt) {
        if (_this4.disabled_) {
          return;
        }

        _this4.preventFocusState_ = true;
        _this4.setInTransit_(!_this4.handlingThumbTargetEvt_);
        _this4.handlingThumbTargetEvt_ = false;

        _this4.setActive_(true);

        _this4.adapter_.registerBodyInteractionHandler(moveEvt, moveHandler);
        _this4.adapter_.registerBodyInteractionHandler(upEvt, upHandler);
        _this4.setValueFromEvt_(evt, getPageX);
      };

      return downHandler;
    }
  }, {
    key: 'setValueFromEvt_',
    value: function setValueFromEvt_(evt, getPageX) {
      var pageX = getPageX(evt);
      var value = this.computeValueFromPageX_(pageX);
      this.setValue_(value, true);
    }
  }, {
    key: 'computeValueFromPageX_',
    value: function computeValueFromPageX_(pageX) {
      var max = this.max_,
          min = this.min_;

      var xPos = pageX - this.rect_.left;
      var pctComplete = xPos / this.rect_.width;
      if (this.adapter_.isRTL()) {
        pctComplete = 1 - pctComplete;
      }
      // Fit the percentage complete between the range [min,max]
      // by remapping from [0, 1] to [min, min+(max-min)].
      return min + pctComplete * (max - min);
    }
  }, {
    key: 'handleKeydown_',
    value: function handleKeydown_(evt) {
      var keyId = this.getKeyId_(evt);
      var value = this.getValueForKeyId_(keyId);
      if (isNaN(value)) {
        return;
      }

      // Prevent page from scrolling due to key presses that would normally scroll the page
      evt.preventDefault();
      this.adapter_.addClass(__WEBPACK_IMPORTED_MODULE_0__constants__["a" /* cssClasses */].FOCUS);
      this.setValue_(value, true);
      this.adapter_.notifyChange();
    }
  }, {
    key: 'getKeyId_',
    value: function getKeyId_(kbdEvt) {
      switch (kbdEvt.key || kbdEvt.keyCode) {
        case KEY_IDS.ARROW_LEFT:
        case 37:
          return KEY_IDS.ARROW_LEFT;
        case KEY_IDS.ARROW_RIGHT:
        case 39:
          return KEY_IDS.ARROW_RIGHT;
        case KEY_IDS.ARROW_UP:
        case 38:
          return KEY_IDS.ARROW_UP;
        case KEY_IDS.ARROW_DOWN:
        case 40:
          return KEY_IDS.ARROW_DOWN;
        case KEY_IDS.HOME:
        case 36:
          return KEY_IDS.HOME;
        case KEY_IDS.END:
        case 35:
          return KEY_IDS.END;
        case KEY_IDS.PAGE_UP:
        case 33:
          return KEY_IDS.PAGE_UP;
        case KEY_IDS.PAGE_DOWN:
        case 34:
          return KEY_IDS.PAGE_DOWN;
        default:
          // Doesn't matter
          return '';
      }
    }
  }, {
    key: 'getValueForKeyId_',
    value: function getValueForKeyId_(keyId) {
      var max = this.max_,
          min = this.min_,
          step = this.step_;

      var delta = step || (max - min) / 100;
      var valueNeedsToBeFlipped = this.adapter_.isRTL() && (keyId === KEY_IDS.ARROW_LEFT || keyId === KEY_IDS.ARROW_RIGHT);
      if (valueNeedsToBeFlipped) {
        delta = -delta;
      }

      switch (keyId) {
        case KEY_IDS.ARROW_LEFT:
        case KEY_IDS.ARROW_DOWN:
          return this.value_ - delta;
        case KEY_IDS.ARROW_RIGHT:
        case KEY_IDS.ARROW_UP:
          return this.value_ + delta;
        case KEY_IDS.HOME:
          return this.min_;
        case KEY_IDS.END:
          return this.max_;
        case KEY_IDS.PAGE_UP:
          return this.value_ + delta * __WEBPACK_IMPORTED_MODULE_0__constants__["b" /* numbers */].PAGE_FACTOR;
        case KEY_IDS.PAGE_DOWN:
          return this.value_ - delta * __WEBPACK_IMPORTED_MODULE_0__constants__["b" /* numbers */].PAGE_FACTOR;
        default:
          return NaN;
      }
    }
  }, {
    key: 'handleFocus_',
    value: function handleFocus_() {
      if (this.preventFocusState_) {
        return;
      }
      this.adapter_.addClass(__WEBPACK_IMPORTED_MODULE_0__constants__["a" /* cssClasses */].FOCUS);
    }
  }, {
    key: 'handleBlur_',
    value: function handleBlur_() {
      this.preventFocusState_ = false;
      this.adapter_.removeClass(__WEBPACK_IMPORTED_MODULE_0__constants__["a" /* cssClasses */].FOCUS);
    }
  }, {
    key: 'setValue_',
    value: function setValue_(value, shouldFireInput) {
      var force = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : false;

      if (value === this.value_ && !force) {
        return;
      }

      var min = this.min_,
          max = this.max_;

      var valueSetToBoundary = value === min || value === max;
      if (this.step_ && !valueSetToBoundary) {
        value = this.quantize_(value);
      }
      if (value < min) {
        value = min;
      } else if (value > max) {
        value = max;
      }
      this.value_ = value;
      this.adapter_.setAttribute(__WEBPACK_IMPORTED_MODULE_0__constants__["c" /* strings */].ARIA_VALUENOW, String(this.value_));
      this.updateUIForCurrentValue_();

      if (shouldFireInput) {
        this.adapter_.notifyInput();
        if (this.isDiscrete_) {
          this.adapter_.setMarkerValue(value);
        }
      }
    }
  }, {
    key: 'quantize_',
    value: function quantize_(value) {
      var numSteps = Math.round(value / this.step_);
      var quantizedVal = numSteps * this.step_;
      return quantizedVal;
    }
  }, {
    key: 'updateUIForCurrentValue_',
    value: function updateUIForCurrentValue_() {
      var _this5 = this;

      var max = this.max_,
          min = this.min_,
          value = this.value_;

      var pctComplete = (value - min) / (max - min);
      var translatePx = pctComplete * this.rect_.width;
      if (this.adapter_.isRTL()) {
        translatePx = this.rect_.width - translatePx;
      }

      var transformProp = Object(__WEBPACK_IMPORTED_MODULE_1__material_animation__["getCorrectPropertyName"])(window, 'transform');
      var transitionendEvtName = Object(__WEBPACK_IMPORTED_MODULE_1__material_animation__["getCorrectEventName"])(window, 'transitionend');

      if (this.inTransit_) {
        var onTransitionEnd = function onTransitionEnd() {
          _this5.setInTransit_(false);
          _this5.adapter_.deregisterThumbContainerInteractionHandler(transitionendEvtName, onTransitionEnd);
        };
        this.adapter_.registerThumbContainerInteractionHandler(transitionendEvtName, onTransitionEnd);
      }

      this.updateUIFrame_ = requestAnimationFrame(function () {
        _this5.setOff_(pctComplete === 0);
        // NOTE(traviskaufman): It would be nice to use calc() here,
        // but IE cannot handle calcs in transforms correctly.
        // See: https://goo.gl/NC2itk
        // Also note that the -50% offset is used to center the slider thumb.
        _this5.adapter_.setThumbContainerStyleProperty(transformProp, 'translateX(' + translatePx + 'px) translateX(-50%)');
        _this5.adapter_.setTrackStyleProperty(transformProp, 'scaleX(' + pctComplete + ')');
      });
    }
  }, {
    key: 'setOff_',
    value: function setOff_(off) {
      this.off_ = off;
      this.toggleClass_(__WEBPACK_IMPORTED_MODULE_0__constants__["a" /* cssClasses */].OFF, this.off_);
    }
  }, {
    key: 'setActive_',
    value: function setActive_(active) {
      this.active_ = active;
      this.toggleClass_(__WEBPACK_IMPORTED_MODULE_0__constants__["a" /* cssClasses */].ACTIVE, this.active_);
    }
  }, {
    key: 'setInTransit_',
    value: function setInTransit_(inTransit) {
      this.inTransit_ = inTransit;
      this.toggleClass_(__WEBPACK_IMPORTED_MODULE_0__constants__["a" /* cssClasses */].IN_TRANSIT, this.inTransit_);
    }
  }, {
    key: 'toggleClass_',
    value: function toggleClass_(className, shouldBePresent) {
      if (shouldBePresent) {
        this.adapter_.addClass(className);
      } else {
        this.adapter_.removeClass(className);
      }
    }
  }]);

  return MDCSliderFoundation;
}(__WEBPACK_IMPORTED_MODULE_2__material_base_foundation__["a" /* default */]);

/* harmony default export */ __webpack_exports__["a"] = (MDCSliderFoundation);

/***/ })

/******/ });
});