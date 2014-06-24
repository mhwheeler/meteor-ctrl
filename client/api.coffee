#= base
### @export Ctrl ###

Ctrl = {} unless Ctrl?
@ctrlDefs = {}



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
    if ctrlDefs[type]?
      throw new Error("The control named '#{ type }' has already been defined.")
    ctrlDefs[type] = new CtrlClass(type, def)

