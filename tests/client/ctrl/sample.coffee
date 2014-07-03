Ctrl.define
  'foo':
    init: ->
    destroyed: -> @destroyedWasCalled = true
    helpers:
      title: -> "Foo:#{ @uid }"


  'deep': {}
  'deepChild': {}
  'autoRun': {}
