(function() {

  if (window["ElmGlobalEvents"]) {
    console.log("ElmGlobalEvents already present. Skipping.");
    return;
  }

  // BEGIN: IE >=9 CustomEvent polyfill
  // from:
  // https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent/CustomEvent
  (function () {

    if ( typeof window.CustomEvent === "function" ) return false;

    function CustomEvent ( event, params ) {
      params = params || { bubbles: false, cancelable: false, detail: undefined };
      var evt = document.createEvent("CustomEvent");
      evt.initCustomEvent( event, params.bubbles, params.cancelable, params.detail );
      return evt;
     }

    CustomEvent.prototype = window.Event.prototype;

    window.CustomEvent = CustomEvent;
  })();
  // END: IE >=9 CustomEvent polyfill

  var select = function(document, eventName) {
    return document.querySelectorAll("[data-" + eventName + "]");
  };

  var dispatch = function(document, eventName, extend) {
    var targets = select(document, eventName);
    for (var i = 0; i < targets.length; i++) {
      var event = new CustomEvent(eventName);
      event = extend(targets[i], event);
      targets[i].dispatchEvent(event);
    }
  };


  // EVENT globalload


  window.addEventListener("load", function(originalEvent) {
    dispatch(document, "globalload", function(target, event) {
      return event;
    });
  });

  window.addEventListener("load", function(originalEvent) {
    window.requestAnimationFrame(function() {
      dispatch(document, "globalload1", function(target, event) {
        return event;
      });
    });
  });

  (function() {
    var o = new MutationObserver(function(mutations) {
      for (var i = 0; i < mutations.length; i++) {
        if (mutations[i].type !== "childList") {
          continue;
        }
        var mutation = mutations[i];
        var nodes = mutation.addedNodes;
        for (var j = 0; j < nodes.length; j++) {
          var node = nodes[j];
          if (!node.dataset) {
            continue;
          }
          if (typeof node.dataset.globalload !== "undefined") {
            var event = new CustomEvent("globalload");
            node.dispatchEvent(event);
          }
          if (!(node.querySelector)) {
            continue;
          }
          dispatch(node, "globalload", function(target, event) {
            return event;
          });
        }
      }
    });
    o.observe(document.body, {
      childList: true,
      subtree: true
    });
  })();
  

  // EVENT globaltick


  (function() {
    var o = new MutationObserver(function(mutations) {
      for (var i = 0; i < mutations.length; i++) {
        if (mutations[i].type === "childList") {
          var mutation = mutations[i];
          var  nodes = mutation.addedNodes;
          for (var j = 0; j < nodes.length; j++) {
            var node = nodes[j];
            if (!node.dataset) {
              continue;
            }
            if (typeof node.dataset.globaltick !== "undefined") {
              var event = new CustomEvent("globaltick");
              node.dispatchEvent(event);
            }
            if (!(node.querySelector)) {
              continue;
            }
            dispatch(node, "globaltick", function(target, event) {
              return event;
            });
          }
        }
        if (mutations[i].type === "attributes") {
          var mutation = mutations[i];
          var node = mutation.target;
          if (!node.dataset) {
            continue;
          }
          if (typeof node.dataset.globaltick !== "undefined") {
            var event = new CustomEvent("globaltick");
            node.dispatchEvent(event);
          }
        }
      }
    });
    o.observe(document.body, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: [ "data-globaltick" ]
    });
  })();


  // EVENT globalscroll


  document.addEventListener("scroll", function(originalEvent) {
    dispatch(document, "globalscroll", function(target, event) {
      return event;
    });
  });


  // EVENT globalresize


  window.addEventListener("resize", function(originalEvent) {
    dispatch(document, "globalresize", function(target, event) {
      return event;
    });
  });

  window.addEventListener("resize", function(originalEvent) {
    window.requestAnimationFrame(function() {
      dispatch(document, "globalresize1", function(target, event) {
        return event;
      });
    });
  });


  // EVENT globalpolledresize


  window.addEventListener("resize", function(originalEvent) {
    var running = false;
    window.requestAnimationFrame(function() {
      if (running) {
        return;
      }
      running = true;
      window.requestAnimationFrame(function() {
        dispatch(document, "globalpolledresize", function(target, event) {
          return event;
        });
        running = false;
      });
    });
  });

  window.addEventListener("resize", function(originalEvent) {
    var running = false;
    window.requestAnimationFrame(function() {
      if (running) {
        return;
      }
      running = true;
      window.requestAnimationFrame(function() {
      window.requestAnimationFrame(function() {
        dispatch(document, "globalpolledresize1", function(target, event) {
          return event;
        });
        running = false;
      });
      });
    });
  });

  // EVENT globalmouseup

  document.addEventListener("mouseup", function(originalEvent) {
      dispatch(document, "globalmouseup", function(target, event) {
          event.pageX = originalEvent.pageX;
          event.pageY = originalEvent.pageY;
          event.detail = originalEvent.detail;
          event.currentTarget = originalEvent.currentTarget;
          event.relatedTarget = originalEvent.relatedTarget;
          event.screenX = originalEvent.screenX;
          event.screenY = originalEvent.screenY;
          event.clientX = originalEvent.clientX;
          event.clientY = originalEvent.clientY;
          event.button = originalEvent.button;
          event.buttons = originalEvent.buttons;
          event.mozPressure = originalEvent.mozPressure;
          event.ctrlKey = originalEvent.ctrlKey;
          event.shiftKey = originalEvent.shiftKey;
          event.altKey = originalEvent.altKey;
          event.metaKey = originalEvent.metaKey;
          return event;
      });
  });

  // EVENT globalpointerup

  document.addEventListener("pointerup", function(originalEvent) {
      dispatch(document, "globalpointerup", function(target, event) {
          event.detail = originalEvent.detail;
          event.pointerId = originalEvent.pointerId;
          event.width = originalEvent.width;
          event.height = originalEvent.height;
          event.pressure = originalEvent.pressure;
          event.tiltX = originalEvent.tiltX;
          event.tiltY = originalEvent.tiltY;
          event.pointerType = originalEvent.pointerType;
          event.isPrimary = originalEvent.isPrimary;
          return event;
      });
  });

  // EVENT globaltouchend

  document.addEventListener("touchend", function(originalEvent) {
      dispatch(document, "globaltouchend", function(target, event) {
          event.detail = originalEvent.detail;
          event.touches = originalEvent.touches;
          event.targetTouches = originalEvent.targetTouches;
          event.changedTouches = originalEvent.changedTouches;
          event.ctrlKey = originalEvent.ctrlKey;
          event.shiftKey = originalEvent.shiftKey;
          event.altKey = originalEvent.altKey;
          event.metaKey = originalEvent.metaKey;
          return event;
      });
  });

  // EVENT globalmousemove

  document.addEventListener("mousemove", function(originalEvent) {
      dispatch(document, "globalmousemove", function(target, event) {
          event.pageX = originalEvent.pageX;
          event.pageY = originalEvent.pageY;
          event.detail = originalEvent.detail;
          event.currentTarget = originalEvent.currentTarget;
          event.relatedTarget = originalEvent.relatedTarget;
          event.screenX = originalEvent.screenX;
          event.screenY = originalEvent.screenY;
          event.clientX = originalEvent.clientX;
          event.clientY = originalEvent.clientY;
          event.button = originalEvent.button;
          event.buttons = originalEvent.buttons;
          event.mozPressure = originalEvent.mozPressure;
          event.ctrlKey = originalEvent.ctrlKey;
          event.shiftKey = originalEvent.shiftKey;
          event.altKey = originalEvent.altKey;
          event.metaKey = originalEvent.metaKey;
          return event;
      });
  });

  // EVENT globalpointermove

  document.addEventListener("pointermove", function(originalEvent) {
      dispatch(document, "globalpointermove", function(target, event) {
          event.detail = originalEvent.detail;
          event.pointerId = originalEvent.pointerId;
          event.width = originalEvent.width;
          event.height = originalEvent.height;
          event.pressure = originalEvent.pressure;
          event.tiltX = originalEvent.tiltX;
          event.tiltY = originalEvent.tiltY;
          event.pointerType = originalEvent.pointerType;
          event.isPrimary = originalEvent.isPrimary;
          return event;
      });
  });

  // EVENT globaltouchmove

  document.addEventListener("touchmove", function(originalEvent) {
      dispatch(document, "globaltouchmove", function(target, event) {
          event.detail = originalEvent.detail;
          event.touches = originalEvent.touches;
          event.targetTouches = originalEvent.targetTouches;
          event.changedTouches = originalEvent.changedTouches;
          event.ctrlKey = originalEvent.ctrlKey;
          event.shiftKey = originalEvent.shiftKey;
          event.altKey = originalEvent.altKey;
          event.metaKey = originalEvent.metaKey;
          return event;
      });
  });

  window["ElmGlobalEvents"] = {};
})();
