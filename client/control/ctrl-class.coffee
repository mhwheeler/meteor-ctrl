###
The definition of a control.
###
class @CtrlClass
  constructor: (@type, @def = {}) ->
    # Setup initial conditions.
    self = @
    def = @def
    @def.type ?= @type
    @tmpl = tmpl = Template[@type]
    throw new Error("Template '#{ @type }' does not exist.") unless @tmpl

    # Ensure objects exist.
    def.api     ?= {}
    def.helpers ?= {}
    def.events  ?= {}

    invoke = (context, funcName, args) =>
            instance = context.__instance__
            unless instance.isDisposed
              args = [args] unless _.isArray(args)
              @def[funcName]?.apply?(instance, args)


    # Init (invoked at construction, prior to the DOM being available).
    tmpl.created = ->
        # Retrieve the ctrl instance from the data (helpers) object,
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
        invoke(@, 'init')


    # Created (DOM Ready).
    tmpl.rendered = -> invoke(@, 'created')


    # Destroyed.
    tmpl.destroyed = -> @__instance__.dispose()


    # Prepare events.
    wrapEvent = (func) -> (e, context) -> func.call(context.__instance__, e)
    def.events[key] = wrapEvent(func) for key, func of def.events
    tmpl.events(def.events)



