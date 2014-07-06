#= base
### @export Ctrl ###

Ctrl = {} unless Ctrl?
Ctrl.defs = {}
Ctrl.instances = {} # Referenced by the instance UID.


# --------------------------------------------------------------------------



###
Registers one or more control definitions.
@param defs: An object containing named control definitionsl
              defs:
                - <name>: {}
###
Ctrl.define = (defs = {}) ->
  for type, def of defs
    def.type ?= type
    if Ctrl.defs[type]?
      throw new Error("The control named '#{ type }' has already been defined.")
    Ctrl.defs[type] = new Ctrl.Definition(type, def)




###
Looks up a Ctrl instance for the given DOM elemnet.
@param el: The element to look up, can be:
              - a jQuery element.
              - a DOM element
              - a CSS selector (string).

@returns the corresponding Ctrl, or null if not found.
###
Ctrl.find = (el) ->
  # Setup initial conditions.
  return unless el?
  el = $(el) if not el.jquery?
  return if el.length is 0

  # Look up the control instance.
  if uid = el.data('ctrl-uid')
    Ctrl.instances[uid]
