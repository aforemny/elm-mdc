import createFocusTrap from 'focus-trap';
import CustomEvent from 'custom-event';


// attribute "data-focustrap":
(() => {
  if (window["ElmFocusTrap"]) return

  window["ElmFocusTrap"] = { activeTrap: null }

  let setUp = (node) => {
    if (window["ElmFocusTrap"].activeTrap !== null) {
      return
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

  let tearDown = (node) => {
    if (window["ElmFocusTrap"].activeTrap === null) {
      return
    }
    if (window["ElmFocusTrap"].activeTrap.node !== node) {
      return
    }
    window["ElmFocusTrap"].activeTrap.focusTrap.deactivate()
    window["ElmFocusTrap"].activeTrap = null
    document.body.classList.remove("mdc-dialog-scroll-lock")
  }

  new MutationObserver((mutations) => {
    for (let i = 0; i < mutations.length; i++) {
      let mutation = mutations[i]

      if (mutation.type === "childList") {
        for (let i = 0; i < mutation.removedNodes.length; i++) {
          let node = mutation.removedNodes[i]
          if (!node.dataset) {
            continue
          }
          if (typeof node.dataset.focustrap !== "undefined") {
            tearDown(node)
          } else {
            let childNode = node.querySelector("[data-focustrap]")
            if (typeof childNode === "undefined") {
              continue;
            }
            tearDown(childNode)
          }
        }
      }

      if (mutation.type === "attributes") {
        let node = mutation.target
        if (!node.dataset) {
          continue
        }
        if (typeof node.dataset.focustrap === "undefined") {
          tearDown(node)
        } else {
          setUp(node)
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
              if (JSON.parse(node.dataset.globaltick || "{}").targetRect || false) {
                event.targetRect = target.getBoundingClientRect()
              }
              if (JSON.parse(node.dataset.globaltick || "{}").parentRect || false) {
                event.parentRect = target.parentElement.getBoundingClientRect()
              }
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
            if (JSON.parse(node.dataset.globaltick || "{}").targetRect || false) {
              event.targetRect = node.getBoundingClientRect()
            }
            if (JSON.parse(node.dataset.globaltick || "{}").parentRect || false) {
              event.parentRect = node.parentElement.getBoundingClientRect()
            }
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
