###
Represents an "context" instance of a control used internally
by the control's code-behind.
###
class @CtrlContext
  constructor: (@__def__, @options) ->
    # Setup initial conditions.
    self = @
    def = @__def__
    @uid = _.uniqueId('u')
    @type = def.type
    @helpers = { __instance__:@ } # NB: Temporarily store the instance for retrieval within [created/init] callback.

    # Wrap helper methods.
    wrap = (func) -> -> func.call(self)
    @helpers[key] = wrap(func) for key, func of def.helpers
    @helpers.instance ?= ->
      "#{ self.type }##{ self.uid }"


  ###
  Invoked when the component for the control is first created.
  ###
  __init: (component) ->
    component.__instance__ = @
    @__component__ = component
    @__def__.init?.apply(@)

    # Retrieve a reference to the parent control.
    findParent = (component) ->
        return unless component
        return instance if instance = component.__instance__
        findParent(component.parent) # <== RECURSION.
    @parent = findParent(@__component__.parent)


  ###
  Invokd when the control is in the DOM and ready to use.
  ###
  __created: -> @__def__.created?.apply(@)



  ###
  Invoked when the component has been destroyed.
  ###
  __destroyed: ->
