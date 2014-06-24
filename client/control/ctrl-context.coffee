###
Represents an "context" instance of a control used internally
by the control's code-behind.
###
class @CtrlContext
  constructor: (def, options) ->
    # Setup initial conditions.
    self      = @
    @__def__  = def
    @options  = options
    @uid      = _.uniqueId('u')
    @type     = def.type
    @helpers  = { __instance__:@ } # NB: Temporarily store the instance for retrieval within [created/init] callback.
    @children = []

    # Wrap helper methods.
    wrap = (func) -> -> func.call(self)
    @helpers[key] = wrap(func) for key, func of def.helpers
    @helpers.instance ?= ->
      "#{ self.type }##{ self.uid }"




  ###
  Invokd when the control is in the DOM and ready to use.
  ###
  __created: -> @__def__.created?.apply(@)



  ###
  Invoked when the component has been destroyed.
  ###
  __destroyed: ->
