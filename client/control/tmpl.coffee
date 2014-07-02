###
The container template for a [Ctrl].

  This dynamically renders the declared 'tmpl' passing it a
  [CtrlInstance] as the context.

###
Template.ctrl.helpers

  ###
  The template name: {{> UI.dynamic template=name data=context }}
  ###
  name: ->
    throw new Error("A 'tmpl' name has not been declared on the {{> ctrl}}.") unless @tmpl
    @tmpl



  ###
  The templates data context: {{> UI.dynamic template=name data=context }}
  ###
  context: ->
    options = @

    # Retrieve the template name, and clear it off the options object.
    tmpl = options.tmpl
    delete options.tmpl

    # Retrieve the control definition.
    ctrl = Ctrl.defs[tmpl]
    if not ctrl
      throw new Error("The control named '#{ tmpl }' has not been defined.")

    # Return the instance helpers as the data context for the rendered template.
    return new Ctrl.Instance(ctrl.def, options).helpers


