###
Represents an "context" instance of a control used internally
by the control's code-behind.
###
class Ctrl.Instance
  constructor: (def, options = {}) ->
    # Setup initial conditions.
    self           = @
    @options       = options
    @id            = options.id if options.id
    @uid           = _.uniqueId('u')
    @type          = def.type
    @helpers       = { __instance__:@ } # NB: Temporarily store the instance for retrieval within [created/init] callback.
    @children      = []
    @__internal__ = { def:def }

    # Store temporary global reference if an "insert" ID was specified.
    # This is retrieved (and cleaned up) via the "insert" method.
    if insertId = options.__insert
      Ctrl.__inserted = @
      delete options.__insert

    # Wrap helper methods.
    wrap = (func) -> -> func.call(self)
    @helpers[key] = wrap(func) for key, func of def.helpers
    @helpers.instance ?= ->
      "#{ self.type }##{ self.uid }" # Standard output for {{instance}} within a template.


  ###
  Disposes of the control instance, releasing resources and Deps handles.
  ###
  dispose: ->
    # Setup initial conditions.
    return if @isDisposed

    # Remove from the DOM if required.
    # NB: This is only necessary when "dispose" is being called directly
    #     without either Blaze destroying the element, or the "remove" method
    #     having caused the ctrl to be destroyed.
    @remove() unless @__internal__.blazeView.isDestroyed

    # Dispose of children first.
    for child in _.clone(@children)
      child.dispose()

    # Remove from parent.
    if children = @parent?.children
      index = _.indexOf(children, @)
      children.splice(index, 1) if index > -1
      delete children[@id]

    # Stop [autorun] callbacks.
    if depsHandles = @__internal__.depsHandles
      depsHandles.each (handle) -> handle?.stop?()
      delete @__internal__.depsHandles

    # Invoke [destroyed] method on the instance.
    @__internal__.def.destroyed?.call?(@)

    # Remove global reference.
    delete Ctrl.instances[@uid]

    # Dispose of function handlers.
    @__internal__.onCreated?.dispose()

    # Finish up.
    @isDisposed = true



  ###
  Safely provides [Deps.autorun] funtionality stopping the
  handle when the control is disposed.
  @param func: The function to monitor.
  ###
  autorun: (func) ->
    handle = Deps.autorun(func)
    depsHandles = @__internal__.depsHandles ?= []
    depsHandles.push(handle)
    handle



  ###
  Retrieves the a jQuery element for the control.
  @param selector:  Optional. A CSS selector to search within the element's DOM for.
                    If ommited the root element is returned.
  ###
  find: (selector) ->
    if el = @__internal__.blazeView?.domrange?.members[0]
      if not selector? or selector is ''
        $(el)
      else
        $(el).find(selector)


  # Alias to "find".
  el: (selector) -> @find(selector)



  ###
  Registers a handler to be run when the instance is "created" (and ready).
  @param func: The function to invoke.
  ###
  onCreated: (func) ->
    handlers = @__internal__.onCreated ?= new Util.Handlers(@)
    handlers.push(func)



  ###
  Removes the ctrl from the DOM and destroyed it.
  ###
  remove: ->
    return if @isDisposed
    UI.remove(@__internal__.blazeView.domrange)





