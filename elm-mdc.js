/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
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
/******/ 	// identity function for calling harmony imports with the correct context
/******/ 	__webpack_require__.i = function(value) { return value; };
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
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 3);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(global) {
var NativeCustomEvent = global.CustomEvent;

function useNative () {
  try {
    var p = new NativeCustomEvent('cat', { detail: { foo: 'bar' } });
    return  'cat' === p.type && 'bar' === p.detail.foo;
  } catch (e) {
  }
  return false;
}

/**
 * Cross-browser `CustomEvent` constructor.
 *
 * https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent.CustomEvent
 *
 * @public
 */

module.exports = useNative() ? NativeCustomEvent :

// IE >= 9
'undefined' !== typeof document && 'function' === typeof document.createEvent ? function CustomEvent (type, params) {
  var e = document.createEvent('CustomEvent');
  if (params) {
    e.initCustomEvent(type, params.bubbles, params.cancelable, params.detail);
  } else {
    e.initCustomEvent(type, false, false, void 0);
  }
  return e;
} :

// IE <= 8
function CustomEvent (type, params) {
  var e = document.createEventObject();
  e.type = type;
  if (params) {
    e.bubbles = Boolean(params.bubbles);
    e.cancelable = Boolean(params.cancelable);
    e.detail = params.detail;
  } else {
    e.bubbles = false;
    e.cancelable = false;
    e.detail = void 0;
  }
  return e;
}

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(4)))

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

var tabbable = __webpack_require__(2);

var listeningFocusTrap = null;

function focusTrap(element, userOptions) {
  var tabbableNodes = [];
  var firstTabbableNode = null;
  var lastTabbableNode = null;
  var nodeFocusedBeforeActivation = null;
  var active = false;
  var paused = false;
  var tabEvent = null;

  var container = (typeof element === 'string')
    ? document.querySelector(element)
    : element;

  var config = userOptions || {};
  config.returnFocusOnDeactivate = (userOptions && userOptions.returnFocusOnDeactivate !== undefined)
    ? userOptions.returnFocusOnDeactivate
    : true;
  config.escapeDeactivates = (userOptions && userOptions.escapeDeactivates !== undefined)
    ? userOptions.escapeDeactivates
    : true;

  var trap = {
    activate: activate,
    deactivate: deactivate,
    pause: pause,
    unpause: unpause,
  };

  return trap;

  function activate(activateOptions) {
    if (active) return;

    var defaultedActivateOptions = {
      onActivate: (activateOptions && activateOptions.onActivate !== undefined)
        ? activateOptions.onActivate
        : config.onActivate,
    };

    active = true;
    paused = false;
    nodeFocusedBeforeActivation = document.activeElement;

    if (defaultedActivateOptions.onActivate) {
      defaultedActivateOptions.onActivate();
    }

    addListeners();
    return trap;
  }

  function deactivate(deactivateOptions) {
    if (!active) return;

    var defaultedDeactivateOptions = {
      returnFocus: (deactivateOptions && deactivateOptions.returnFocus !== undefined)
        ? deactivateOptions.returnFocus
        : config.returnFocusOnDeactivate,
      onDeactivate: (deactivateOptions && deactivateOptions.onDeactivate !== undefined)
        ? deactivateOptions.onDeactivate
        : config.onDeactivate,
    };

    removeListeners();

    if (defaultedDeactivateOptions.onDeactivate) {
      defaultedDeactivateOptions.onDeactivate();
    }

    if (defaultedDeactivateOptions.returnFocus) {
      setTimeout(function () {
        tryFocus(nodeFocusedBeforeActivation);
      }, 0);
    }

    active = false;
    paused = false;
    return this;
  }

  function pause() {
    if (paused || !active) return;
    paused = true;
    removeListeners();
  }

  function unpause() {
    if (!paused || !active) return;
    paused = false;
    addListeners();
  }

  function addListeners() {
    if (!active) return;

    // There can be only one listening focus trap at a time
    if (listeningFocusTrap) {
      listeningFocusTrap.pause();
    }
    listeningFocusTrap = trap;

    updateTabbableNodes();
    tryFocus(firstFocusNode());
    document.addEventListener('focus', checkFocus, true);
    document.addEventListener('click', checkClick, true);
    document.addEventListener('mousedown', checkPointerDown, true);
    document.addEventListener('touchstart', checkPointerDown, true);
    document.addEventListener('keydown', checkKey, true);

    return trap;
  }

  function removeListeners() {
    if (!active || listeningFocusTrap !== trap) return;

    document.removeEventListener('focus', checkFocus, true);
    document.removeEventListener('click', checkClick, true);
    document.removeEventListener('mousedown', checkPointerDown, true);
    document.removeEventListener('touchstart', checkPointerDown, true);
    document.removeEventListener('keydown', checkKey, true);

    listeningFocusTrap = null;

    return trap;
  }

  function getNodeForOption(optionName) {
    var optionValue = config[optionName];
    var node = optionValue;
    if (!optionValue) {
      return null;
    }
    if (typeof optionValue === 'string') {
      node = document.querySelector(optionValue);
      if (!node) {
        throw new Error('`' + optionName + '` refers to no known node');
      }
    }
    if (typeof optionValue === 'function') {
      node = optionValue();
      if (!node) {
        throw new Error('`' + optionName + '` did not return a node');
      }
    }
    return node;
  }

  function firstFocusNode() {
    var node;
    if (getNodeForOption('initialFocus') !== null) {
      node = getNodeForOption('initialFocus');
    } else if (container.contains(document.activeElement)) {
      node = document.activeElement;
    } else {
      node = tabbableNodes[0] || getNodeForOption('fallbackFocus');
    }

    if (!node) {
      throw new Error('You can\'t have a focus-trap without at least one focusable element');
    }

    return node;
  }

  // This needs to be done on mousedown and touchstart instead of click
  // so that it precedes the focus event
  function checkPointerDown(e) {
    if (config.clickOutsideDeactivates && !container.contains(e.target)) {
      deactivate({ returnFocus: false });
    }
  }

  function checkClick(e) {
    if (config.clickOutsideDeactivates) return;
    if (container.contains(e.target)) return;
    e.preventDefault();
    e.stopImmediatePropagation();
  }

  function checkFocus(e) {
    if (container.contains(e.target)) return;
    e.preventDefault();
    e.stopImmediatePropagation();
    // Checking for a blur method here resolves a Firefox issue (#15)
    if (typeof e.target.blur === 'function') e.target.blur();

    if (tabEvent) {
      readjustFocus(tabEvent);
    }
  }

  function checkKey(e) {
    if (e.key === 'Tab' || e.keyCode === 9) {
      handleTab(e);
    }

    if (config.escapeDeactivates !== false && isEscapeEvent(e)) {
      deactivate();
    }
  }

  function handleTab(e) {
    updateTabbableNodes();

    if (e.target.hasAttribute('tabindex') && Number(e.target.getAttribute('tabindex')) < 0) {
      return tabEvent = e;
    }

    e.preventDefault();
    var currentFocusIndex = tabbableNodes.indexOf(e.target);

    if (e.shiftKey) {
      if (e.target === firstTabbableNode || tabbableNodes.indexOf(e.target) === -1) {
        return tryFocus(lastTabbableNode);
      }
      return tryFocus(tabbableNodes[currentFocusIndex - 1]);
    }

    if (e.target === lastTabbableNode) return tryFocus(firstTabbableNode);

    tryFocus(tabbableNodes[currentFocusIndex + 1]);
  }

  function updateTabbableNodes() {
    tabbableNodes = tabbable(container);
    firstTabbableNode = tabbableNodes[0];
    lastTabbableNode = tabbableNodes[tabbableNodes.length - 1];
  }

  function readjustFocus(e) {
    if (e.shiftKey) return tryFocus(lastTabbableNode);

    tryFocus(firstTabbableNode);
  }
}

function isEscapeEvent(e) {
  return e.key === 'Escape' || e.key === 'Esc' || e.keyCode === 27;
}

function tryFocus(node) {
  if (!node || !node.focus) return;
  if (node === document.activeElement)  return;

  node.focus();
  if (node.tagName.toLowerCase() === 'input') {
    node.select();
  }
}

module.exports = focusTrap;


/***/ }),
/* 2 */
/***/ (function(module, exports) {

module.exports = function(el, options) {
  options = options || {};

  var elementDocument = el.ownerDocument || el;
  var basicTabbables = [];
  var orderedTabbables = [];

  // A node is "available" if
  // - it's computed style
  var isUnavailable = createIsUnavailable(elementDocument);

  var candidateSelectors = [
    'input',
    'select',
    'a[href]',
    'textarea',
    'button',
    '[tabindex]',
  ];

  var candidates = el.querySelectorAll(candidateSelectors.join(','));

  if (options.includeContainer) {
    var matches = Element.prototype.matches || Element.prototype.msMatchesSelector || Element.prototype.webkitMatchesSelector;

    if (
      candidateSelectors.some(function(candidateSelector) {
        return matches.call(el, candidateSelector);
      })
    ) {
      candidates = Array.prototype.slice.apply(candidates);
      candidates.unshift(el);
    }
  }

  var candidate, candidateIndex;
  for (var i = 0, l = candidates.length; i < l; i++) {
    candidate = candidates[i];
    candidateIndex = parseInt(candidate.getAttribute('tabindex'), 10) || candidate.tabIndex;

    if (
      candidateIndex < 0
      || (candidate.tagName === 'INPUT' && candidate.type === 'hidden')
      || candidate.disabled
      || isUnavailable(candidate, elementDocument)
    ) {
      continue;
    }

    if (candidateIndex === 0) {
      basicTabbables.push(candidate);
    } else {
      orderedTabbables.push({
        index: i,
        tabIndex: candidateIndex,
        node: candidate,
      });
    }
  }

  var tabbableNodes = orderedTabbables
    .sort(function(a, b) {
      return a.tabIndex === b.tabIndex ? a.index - b.index : a.tabIndex - b.tabIndex;
    })
    .map(function(a) {
      return a.node
    });

  Array.prototype.push.apply(tabbableNodes, basicTabbables);

  return tabbableNodes;
}

function createIsUnavailable(elementDocument) {
  // Node cache must be refreshed on every check, in case
  // the content of the element has changed
  var isOffCache = [];

  // "off" means `display: none;`, as opposed to "hidden",
  // which means `visibility: hidden;`. getComputedStyle
  // accurately reflects visiblity in context but not
  // "off" state, so we need to recursively check parents.

  function isOff(node, nodeComputedStyle) {
    if (node === elementDocument.documentElement) return false;

    // Find the cached node (Array.prototype.find not available in IE9)
    for (var i = 0, length = isOffCache.length; i < length; i++) {
      if (isOffCache[i][0] === node) return isOffCache[i][1];
    }

    nodeComputedStyle = nodeComputedStyle || elementDocument.defaultView.getComputedStyle(node);

    var result = false;

    if (nodeComputedStyle.display === 'none') {
      result = true;
    } else if (node.parentNode) {
      result = isOff(node.parentNode);
    }

    isOffCache.push([node, result]);

    return result;
  }

  return function isUnavailable(node) {
    if (node === elementDocument.documentElement) return false;

    var computedStyle = elementDocument.defaultView.getComputedStyle(node);

    if (isOff(node, computedStyle)) return true;

    return computedStyle.visibility === 'hidden';
  }
}


/***/ }),
/* 3 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_focus_trap__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_focus_trap___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0_focus_trap__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1_custom_event__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1_custom_event___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1_custom_event__);



// attribute "data-autofocus":
(() => {
  new MutationObserver((mutations) => {
    for (let i = 0; i < mutations.length; i++) {
      if (mutations[i].type !== "attributes") {
        continue
      }
      let mutation = mutations[i]
      let node = mutation.target
      if (!node.dataset) {
        continue
      }
      if (typeof node.dataset.autofocus !== "undefined") {
        node.focus()
      }
    }
  }).observe(document.body, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: [ "data-autofocus" ]
  })
})();


// attribute "data-autofocus":
(() => {
  if (window["ElmFocusTrap"]) return

  window["ElmFocusTrap"] = { activeTrap: null }

  new MutationObserver((mutations) => {
    for (let i = 0; i < mutations.length; i++) {
      let mutation = mutations[i]
      if (mutation.type !== "attributes") {
        continue
      }
      let node = mutation.target
      if (!node.dataset) {
        continue
      }
      if (typeof node.dataset.focustrap === "undefined") {
        if (window["ElmFocusTrap"].activeTrap === null) {
          continue
        }
        if (window["ElmFocusTrap"].activeTrap.node !== node) {
          continue
        }
        window["ElmFocusTrap"].activeTrap.focusTrap.deactivate()
        window["ElmFocusTrap"].activeTrap = null
        document.body.classList.remove("mdc-dialog-scroll-lock")
      } else {
        if (window["ElmFocusTrap"].activeTrap !== null) {
          continue
        }
        let initialFocusElement = null
        if (node.querySelector && (node.dataset.focustrap !== "")) {
          try {
            initialFocusElement = node.querySelector("." + node.dataset.focustrap)
          } catch (e) {}
        }
        try {
          let focusTrap = __WEBPACK_IMPORTED_MODULE_0_focus_trap___default()(node, {
            initialFocus: initialFocusElement,
            // Note: It is necessary for Menu to set clickOutsideDeactivates to
            // true.
            clickOutsideDeactivates: true,
            escapeDeactivates: false
          }).activate()
          window["ElmFocusTrap"].activeTrap = {
            node: node,
            focusTrap: focusTrap
          }
          document.body.classList.add("mdc-dialog-scroll-lock")
        } catch (e) {
          // TODO: find out why createFocusTrap is called twice on menu
          //console.log(e)
        }
      }
    }
  }).observe(document.body, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: [ "data-focustrap" ]
  })
})();


// custom events:
(() => {
  let select = (document, eventName) => {
    return document.querySelectorAll("[data-" + eventName + "]")
  }

  let dispatch = (document, eventName, extend) => {
    let targets = select(document, eventName)
    for (let i = 0; i < targets.length; i++) {
      let event = new __WEBPACK_IMPORTED_MODULE_1_custom_event___default.a(eventName)
      event = extend(targets[i], event)
      targets[i].dispatchEvent(event)
    }
  }

  // custom event "globalload":
  window.addEventListener("load", (originalEvent) => {
    dispatch(document, "globalload", (target, event) => {
      return event
    })
  });

  (() => {
    new MutationObserver((mutations) => {
      for (let i = 0; i < mutations.length; i++) {
        if (mutations[i].type !== "childList") {
          continue
        }
        let mutation = mutations[i]
        let nodes = mutation.addedNodes
        for (let j = 0; j < nodes.length; j++) {
          let node = nodes[j]
          if (!node.dataset) {
            continue
          }
          if (typeof node.dataset.globalload !== "undefined") {
            let event = new __WEBPACK_IMPORTED_MODULE_1_custom_event___default.a("globalload")
            node.dispatchEvent(event)
          }
          if (!(node.querySelector)) {
            continue
          }
          dispatch(node, "globalload", (target, event) => {
            return event
          })
        }
      }
    }).observe(document.body, {
      childList: true,
      subtree: true
    })
  })()
  

  // custom event "globalload1"
  window.addEventListener("load", (originalEvent) => {
    window.requestAnimationFrame(() => {
      dispatch(document, "globalload1", (target, event) => {
        return event
      })
    })
  });

  // custom event "globaltick"
  (() => {
    new MutationObserver((mutations) => {
      for (let i = 0; i < mutations.length; i++) {
        if (mutations[i].type === "childList") {
          let mutation = mutations[i]
          let  nodes = mutation.addedNodes
          for (let j = 0; j < nodes.length; j++) {
            let node = nodes[j]
            if (!node.dataset) {
              continue
            }
            if (typeof node.dataset.globaltick !== "undefined") {
              let event = new __WEBPACK_IMPORTED_MODULE_1_custom_event___default.a("globaltick")
              node.dispatchEvent(event)
            }
            if (!(node.querySelector)) {
              continue
            }
            dispatch(node, "globaltick", (target, event) => {
              return event
            })
          }
        }
        if (mutations[i].type === "attributes") {
          let mutation = mutations[i]
          let node = mutation.target
          if (!node.dataset) {
            continue
          }
          if (typeof node.dataset.globaltick !== "undefined") {
            let event = new __WEBPACK_IMPORTED_MODULE_1_custom_event___default.a("globaltick")
            node.dispatchEvent(event)
          }
        }
      }
    }).observe(document.body, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: [ "data-globaltick" ]
    })
  })()


  // custom event "globalscroll"
  document.addEventListener("scroll", (originalEvent) => {
    dispatch(document, "globalscroll", (target, event) => {
      return event
    })
  })


  // custom event "globalresize"
  window.addEventListener("resize", (originalEvent) => {
    dispatch(document, "globalresize", (target, event) => {
      return event
    })
  });

  window.addEventListener("resize", (originalEvent) => {
    window.requestAnimationFrame(() => {
      dispatch(document, "globalresize1", (target, event) => {
        return event
      })
    })
  });


  // custom event "globalpolledresize"
  window.addEventListener("resize", (originalEvent) => {
    let running = false
    window.requestAnimationFrame(() => {
      if (running) {
        return
      }
      running = true
      window.requestAnimationFrame(() => {
        dispatch(document, "globalpolledresize", (target, event) => {
          return event
        })
        running = false
      })
    })
  });


  // custom event "globalpolledresize1"
  window.addEventListener("resize", (originalEvent) => {
    let running = false
    window.requestAnimationFrame(() => {
      if (running) {
        return
      }
      running = true
      window.requestAnimationFrame(() => {
      window.requestAnimationFrame(() => {
        dispatch(document, "globalpolledresize1", (target, event) => {
          return event
        })
        running = false
      })
      })
    })
  });


  // custom event "globalmouseup"
  document.addEventListener("mouseup", (originalEvent) => {
      dispatch(document, "globalmouseup", (target, event) => {
          event.pageX = originalEvent.pageX
          event.pageY = originalEvent.pageY
          return event
      })
  })


  // custom event "globalpointerup"
  document.addEventListener("pointerup", (originalEvent) => {
      dispatch(document, "globalpointerup", (target, event) => {
          event.pageX = originalEvent.pageX
          event.pageY = originalEvent.pageY
          return event
      })
  })


  // custom event "globaltouchend"
  document.addEventListener("touchend", (originalEvent) => {
      dispatch(document, "globaltouchend", (target, event) => {
          event.changedTouches = originalEvent.changedTouches
          return event
      })
  })


  // custom event "globalmousemove"
  document.addEventListener("mousemove", (originalEvent) => {
      dispatch(document, "globalmousemove", (target, event) => {
          event.pageX = originalEvent.pageX
          event.pageY = originalEvent.pageY
          return event
      })
  })


  // custom event "globalpointermove"
  document.addEventListener("pointermove", (originalEvent) => {
      dispatch(document, "globalpointermove", (target, event) => {
          event.pageX = originalEvent.pageX
          event.pageY = originalEvent.pageY
          return event
      })
  })


  // custom event "globaltouchmove"
  document.addEventListener("touchmove", (originalEvent) => {
      dispatch(document, "globaltouchmove", (target, event) => {
          event.targetTouches = originalEvent.targetTouches
          return event
      })
  })
})();


/***/ }),
/* 4 */
/***/ (function(module, exports) {

var g;

// This works in non-strict mode
g = (function() {
	return this;
})();

try {
	// This works if eval is allowed (see CSP)
	g = g || Function("return this")() || (1,eval)("this");
} catch(e) {
	// This works if the window reference is available
	if(typeof window === "object")
		g = window;
}

// g can still be undefined, but nothing to do about it...
// We return undefined, instead of nothing here, so it's
// easier to handle this case. if(!global) { ...}

module.exports = g;


/***/ })
/******/ ]);