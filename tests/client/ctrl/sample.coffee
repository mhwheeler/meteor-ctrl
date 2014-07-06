Ctrl.define
  'callbacksTest':
    init: -> @initWasCalled = true
    created: -> @createdWasCalled = true
    destroyed: -> @destroyedWasCalled = true

  'foo':
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
