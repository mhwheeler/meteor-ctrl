###
Represents an "context" instance of a control used internally
by the control's code-behind.
###
class @CtrlContext
  constructor: (def, options) ->
    # Setup initial conditions.
    self           = @
    @__def__       = def
    @options       = options
    @id            = options.id if options.id
    @uid           = _.uniqueId('u')
    @type          = def.type
    @helpers       = { __instance__:@ } # NB: Temporarily store the instance for retrieval within [created/init] callback.
    @children      = []
    @__internal__  = {}

    # Wrap helper methods.
    wrap = (func) -> -> func.call(self)
    @helpers[key] = wrap(func) for key, func of def.helpers
    @helpers.instance ?= ->
      "#{ self.type }##{ self.uid }"


  ###
  Disposes of the control instance, releasing resources and Deps handles.
  ###
  dispose: ->
    # Setup initial conditions.
    return if @isDisposed

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
    @__def__.destroyed?.call?(@)

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






