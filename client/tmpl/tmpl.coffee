###
The container template for a [Ctrl].

  This dynamically renders the declared 'type' passing it a
  [CtrlInstance] as the context.

  The type corresponds with the <template> name.

###
Template.ctrl.helpers

  ###
  The template name: {{> UI.dynamic template=name data=context }}
  ###
  name: ->
    throw new Error("A 'type' name has not been declared on the {{> ctrl}}.") unless @type
    @type



  ###
  The templates data context: {{> UI.dynamic template=name data=context }}
  ###
  context: ->
    options = @

    # Retrieve the template name, and clear it off the options object.
    tmpl = options.type
    delete options.type

    # Retrieve the control definition.
    ctrl = Ctrl.defs[tmpl]
    if not ctrl
      throw new Error("The control of type '#{ tmpl }' has not been defined.")

    # Return the instance helpers as the data context for the rendered template.
    return new Ctrl.Instance(ctrl.def, options).helpers


