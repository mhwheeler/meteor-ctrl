

Template.ctrl.helpers
  name: ->
    throw new Error("A 'tmpl' name has not been declared on the {{> ctrl}}.") unless @tmpl
    @tmpl

  context: ->
    options = @

    # Retrieve the template name, and clear it off the options object.
    tmpl = options.tmpl
    delete options.tmpl

    # Retrieve the control definition.
    ctrl = ctrlDefs[tmpl]
    if not ctrl
      throw new Error("The control named '#{ tmpl }' has not been defined.")

    # Return the instance helpers as the data context for the rendered template.
    return new CtrlContext(ctrl.def, options).helpers



# --------------------------------------------------------------------------



###
Represents the definition of a control.
###
class @CtrlClass
  constructor: (@type, @def = {}) ->
    # Setup initial conditions.
    self = @
    @def.type ?= @type
    @tmpl = tmpl = Template[@type]
    throw new Error("Template '#{ @type }' does not exist.") unless @tmpl

    # Ensure objects exist.
    def.api     ?= {}
    def.helpers ?= {}
    def.events  ?= {}

    # Init.
    tmpl.created = ->
        # Retrieve the instance from the data (helpers) object,
        # then clean up the data object.
        instance = @__instance__ = @data.__instance__
        delete @data.__instance__

        # Invoke the "init" method.
        instance.__init(@__component__)


    # Created (DOM Ready).
    tmpl.rendered = -> @__instance__.__created()

    # Prepare events.
    wrapEvent = (func) -> (e, context) -> func.call(context.__instance__, e)
    def.events[key] = wrapEvent(func) for key, func of def.events
    tmpl.events(def.events)




# --------------------------------------------------------------------------


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


  ###
  Invokd when the control is in the DOM and ready to use.
  ###
  __created: ->
    # Retrieve a reference to the parent control.
    findParent = (component) ->
        return unless component
        return instance if instance = component.__instance__
        findParent(component.parent) # <== RECURSION.
    @parent = findParent(@__component__.parent)

    # Invoke the [created] method.
    @__def__.created?.apply(@)


  ###
  Invoked when the component has been destroyed.
  ###
  __destroyed: ->



