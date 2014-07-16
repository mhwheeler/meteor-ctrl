Ctrl.define
  'callbacksTest':
    init: ->
      @initWasCalled = true
      @modelCount = 0
    created: -> @createdWasCalled = true
    destroyed: -> @destroyedWasCalled = true
    model: ->
      @modelCount += 1
      { name:'my-model' }


  'apiTest':
    api:
      myProp: (value) -> @prop 'myProp', value, default:123
      myMethod: -> { self: @ }
      children: -> 'my-children'


  'foo':
    helpers:
      title: -> "Foo:#{ @uid }"


  'deep':
    helpers:
      childData: -> { foo:123 }
  'deepChild': {}


  'autorun':
    created: ->
      @runCount = 0
      @autorun =>
        value = Session.get('reactive-value')
        @runCount += 1
