(function() {
  "use strict";

  var o = new MutationObserver(function(mutations) {
    for (var i = 0; i < mutations.length; i++) {
      if (mutations[i].type !== "attributes") {
        continue;
      }
      var mutation = mutations[i];
      var node = mutation.target;
      if (!node.dataset) {
        continue;
      }
      if (typeof node.dataset.autofocus !== "undefined") {
        node.focus();
      }
    }
  });

  o.observe(document.body, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: [ "data-autofocus" ]
  });
})();
