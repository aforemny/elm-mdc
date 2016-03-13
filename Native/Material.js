/*
 * Helper functions for accessing Google Material Design lite.
 */

// ELM Boilerplate
Elm.Native.Material = {};
Elm.Native.Material.make = function(elm) {
  elm.Native = elm.Native || {};
  elm.Native.Material = elm.Native.Material || {};
  if (elm.Native.Material.values) {
    return elm.Native.Material.values;
  }

  var Signal = Elm.Native.Signal.make(elm);
  var Json = Elm.Native.Json.make(elm);

  function property(key, value) {
    return { key: key, value: value };
  }

  function on(name, options, decoder, createMessage)
  {
    function eventHandler(event)
    {
      if (options.withGeometry)
      {
        event.boundingClientRect = event.currentTarget.getBoundingClientRect();
      }
      var value = A2(Json.runDecoderValue, decoder, event);
      if (value.ctor === 'Ok')
      {
        if (options.stopPropagation)
        {
          event.stopPropagation();
        }
        if (options.preventDefault)
        {
          event.preventDefault();
        }
        Signal.sendMessage(createMessage(value._0));
      }
    }

    return property('on' + name, eventHandler);
  }

  return elm.Native.Material.values = {
    on : F4(on)
  }
}
