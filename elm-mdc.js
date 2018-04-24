let createFocusTrap = require('focus-trap');
let CustomEvent = require('custom-event');

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
          let focusTrap = createFocusTrap(node, {
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
      let event = new CustomEvent(eventName)
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
            let event = new CustomEvent("globalload")
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
              let event = new CustomEvent("globaltick")
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
            let event = new CustomEvent("globaltick")
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
