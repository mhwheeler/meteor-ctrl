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





