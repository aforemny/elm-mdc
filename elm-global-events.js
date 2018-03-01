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

  window["ElmGlobalEvents"] = {};
})();
