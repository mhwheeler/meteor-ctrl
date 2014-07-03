Ctrl.define
  'foo':
    init: ->
    destroyed: -> @destroyedWasCalled = true
    helpers:
      title: -> "Foo:#{ @uid }"


  'deep': {}
  'deepChild': {}


  'autorun':
    created: ->
      @runCount = 0
      @autorun =>
        value = Session.get('reactive-value')
        @runCount += 1
