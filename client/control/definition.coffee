###
The definition of a control.
###
class Ctrl.Definition
  ###
  Constructor.
  @param type: The type/template name.
  @param def:  An object containing the callbacks used within the control instance.
  ###
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


    # INIT (invoked at construction, prior to the DOM being available).
    tmpl.created = ->
        # Retrieve the ctrl instance from the data (helpers) object,
        # then clean up the data object.
        instance = @__instance__ = @data.__instance__
        delete @data.__instance__

        # Cross reference component/instance.
        component = @__component__
        component.__instance__ = instance
        instance.__component__ = component

        # Store global reference to the instance.
        Ctrl.instances[instance.uid] = instance

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

    # CREATED (DOM Ready).
    tmpl.rendered = -> invoke(@, 'created')

    # DESTROYED.
    tmpl.destroyed = -> @__instance__.dispose()

    # Prepare events.
    wrapEvent = (func) -> (e, context) -> func.call(context.__instance__, e)
    def.events[key] = wrapEvent(func) for key, func of def.events
    tmpl.events(def.events)



  ###
  Inserts a new instance of the control into the DOM.
  @param el:    The element to insert into. Can be:
                - DOM element
                - jQuery element
                - String (CSS selector)
  @param args:  The named data arguments to supply to the control.
  ###
  insert: (el, args = {}) ->
    # Setup initial conditions.
    args.tmpl = @type
    args.__insert = _.uniqueId() # Temporarily store an ID to retrieve the instance with.

    # Process the element to insert into.
    el = $(el) if _.isString(el)
    el = el[0] if el.jquery

    # Render the control.
    component = UI.renderWithData(Template.ctrl, args)
    UI.insert(component, el)

    # Return the new instance.
    instance = Ctrl.__inserted
    delete Ctrl.__inserted
    instance





