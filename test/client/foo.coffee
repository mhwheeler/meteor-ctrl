
Ctrl.define
  'foo':
    init: ->
    # created: -> console.log 'created', @
    helpers:
      title: -> "Foo:#{ @uid }"
    # helpers:
    #   title: -> 'Foo Title', @uid


# Tinytest.add 'My Coffee', (test) ->
#   instance = Ctrl.defs.foo.insert('body')
#   console.log 'instance', instance
#   console.log ''


#  --------------------------------------------------------------------------



# myAsyncFunction = (callback) -> callback('Test complete!')


# TestSuiteExample =
#   name: "TestSuiteExample"

#   suiteSetup: -> # console.log 'suiteSetup'
#   setup: -> # console.log 'setup'


#   tests: [
#     {
#       name: "sync test"
#       func: (test) ->
#     },
#     {
#       name: "sync test ctrl"
#       func: (test)->
#         instance = Ctrl.defs.foo.insert('body')
#         # console.log '+++++ instance', instance
#         # console.log ''
#         test.isTrue(true)

#     },
#     {
#       name: "async test"
#       # skip: true
#       func: (test, done)->
#         myAsyncFunction done((value)->
#           test.isNotNull(value)
#         )

#     },
#     {
#       name: "test with timeout"
#       type: "client"
#       timeout: 5000
#       func: (test)->
#         test.isTrue Meteor.isClient
#     }
#   ]

#   tearDown: -> # console.log 'tearDown'
#   suiteTearDown: -> # console.log 'suiteTearDown'

# Munit.run(TestSuiteExample)



Test.suite
  'fooBar':

    tearDown: ->
      for key, value of Ctrl.instances
        console.log 'REMVOE', value

    tests:
      insertCtrl: (test) ->

        instance = Ctrl.defs.foo.insert('body')

        console.log 'instance', instance


        c = instance.__component__
        console.log 'c', c
        console.log 'c.destroy', c.destroy

