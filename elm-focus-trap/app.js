import createFocusTrap from 'focus-trap';

(function() {
  "use strict";

  if (window["ElmFocusTrap"]) {
    console.log("elm-focus-trap already present. Skipping initialization.");
    return;
  }

  var o = new MutationObserver(function(mutations) {
    for (var i = 0; i < mutations.length; i++) {
      var mutation = mutations[i];
      if (mutation.type !== "attributes") {
        continue;
      }
      var node = mutation.target;
      if (!node.dataset) {
        continue;
      }
      if (typeof node.dataset.focustrap === "undefined") {
        if (window["ElmFocusTrap"].activeTrap === null) {
          continue;
        }
        if (window["ElmFocusTrap"].activeTrap.node !== node) {
          continue;
        }
        window["ElmFocusTrap"].activeTrap.focusTrap.deactivate();
        window["ElmFocusTrap"].activeTrap = null;
      } else {
        if (window["ElmFocusTrap"].activeTrap !== null) {
          continue;
        }
        var initialFocusElement = null;
        if (node.querySelector && (node.dataset.focustrap !== "")) {
          try {
            initialFocusElement = node.querySelector("." + node.dataset.focustrap);
          } catch (e) {}
        }
        var focusTrap = createFocusTrap(node, {
          initialFocus: initialFocusElement,
          clickOutsideDeactivates: true
        }).activate();
        window["ElmFocusTrap"].activeTrap = {
          node: node,
          focusTrap: focusTrap
        };
      }
    }
  });

  o.observe(document.body, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: [ "data-focustrap" ]
  });

  window["ElmFocusTrap"] = {
    activeTrap: null
  };
})();
