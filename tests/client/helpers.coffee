@Test = {}


Test.insert = (ctrlDef, callback) ->
  ctrlDef = Ctrl.defs[ctrlDef] if Object.isString(ctrlDef)
  ctrlDef.insert('body').ready (instance) -> callback?(instance)
