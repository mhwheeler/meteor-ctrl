Ctrl.define
  'callbacksTest':
    init: -> @initWasCalled = true
    created: -> @createdWasCalled = true
    destroyed: -> @destroyedWasCalled = true


  'apiTest':
    api:
      myProp: (value) -> @prop 'myProp', value, default:123
      myMethod: -> { self: @ }
      children: -> 'my-children'


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
