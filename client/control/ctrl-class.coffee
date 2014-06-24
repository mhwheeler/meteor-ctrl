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

    invoke = (instance, funcName, args) =>
            return if instance.isDisposed
            args = [args] unless _.isArray(args)
            @def[funcName]?.apply?(instance, args)


    # Init.
    tmpl.created = ->
        # Retrieve the instance from the data (helpers) object,
        # then clean up the data object.
        instance = @__instance__ = @data.__instance__
        delete @data.__instance__

        # Cross reference component/instance.
        @__component__.__instance__ = instance
        instance.__component__ = @__component__

        # Retrieve a reference to the parent control.
        findParent = (component) ->
                return unless component
                if inst = component.__instance__
                  return inst
                else
                  findParent(component.parent) # <== RECURSION.
        instance.parent = parent = findParent(@__component__.parent)

        # Register child within the parent's [children] array.
        if parent
          parent.children.push(instance)
          if id = instance.options.id
            parent.children[id] = @

        # Invoke the "init" method.
        invoke(instance, 'init')



    # Created (DOM Ready).
    tmpl.rendered = -> @__instance__.__created()

    # Destroyed
    tmpl.destroyed = ->
        console.log 'destroyed', @


    # Prepare events.
    wrapEvent = (func) -> (e, context) -> func.call(context.__instance__, e)
    def.events[key] = wrapEvent(func) for key, func of def.events
    tmpl.events(def.events)
