Template.ctrl.helpers
  name: ->
    throw new Error("A 'tmpl' name has not been declared on the {{> ctrl}}.") unless @tmpl
    @tmpl



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


