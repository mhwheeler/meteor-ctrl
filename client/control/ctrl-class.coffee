###
The definition of a control.
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
