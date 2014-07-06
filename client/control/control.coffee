###
Represents the public API of a control.
###
class Ctrl.Control
  ###
  Constructor.
  @param context: The Ctrl instance.
  ###
  constructor: (@context) ->
    instance  = @context
    @type     = instance.type
    @uid      = instance.uid
    @id       = instance.id if instance.id # NB: ID only exists if specified within the tmplate {{ id=123 }}
    @children = []

    # Copy API.
    for key, func of instance.api
      do (key, func) =>
        @[key] = (args...) -> instance.api[key].apply(instance, args)





  ###
  Disposes of the control.
  ###
  dispose: ->
    return if @isDisposed
    @isDisposed = true
    @context.dispose()

    # Remove from parent.
    if children = @parent?.children
      index = _.indexOf(children, @)
      children.splice(index, 1) if index > -1
      delete children[@id]



  ###
  Retrieves the a jQuery element for the control.
  @param selector:  Optional. A CSS selector to search within the element's DOM for.
                    If ommited the root element is returned.
  ###
  el: (selector) -> @context.find(selector)
