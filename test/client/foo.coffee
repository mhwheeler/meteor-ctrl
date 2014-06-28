
Ctrl.define
  'foo':
    init: ->
    # created: -> console.log 'created', @
    helpers:
      title: -> "Foo:#{ @uid }"
    # helpers:
    #   title: -> 'Foo Title', @uid


Tinytest.add 'My Coffee', (test) ->
  # console.log 'test', test
  # console.log 'Ctrl.defs', Ctrl.defs

  instance = Ctrl.defs.foo.insert('body')

  console.log 'instance', instance
