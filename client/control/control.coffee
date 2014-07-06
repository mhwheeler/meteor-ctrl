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
    @id       = instance.id
    @uid      = instance.uid
    @children = []


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


