
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

@expect = chai.expect


myAsyncFunction = (callback) -> callback('Test complete!')


TestSuiteExample =

  name: "TestSuiteExample"

  suiteSetup: ->
    console.log 'suiteSetup'

  setup: -> console.log 'setup'

  testAsync: (test, done) ->
    myAsyncFunction done((value) ->
      test.isNotNull value
    )




  tests: [
    {
      name: "sync test"
      func: (test) ->
    },
    {
      name: "sync test ctrl"
      func: (test)->
        instance = Ctrl.defs.foo.insert('body')
        console.log '+++++ instance', instance
        console.log ''
        test.isTrue(true)

    },
    {
      name: "async test"
      # skip: true
      func: (test, done)->
        myAsyncFunction done((value)->
          test.isNotNull(value)
        )

    },
    {
      name: "test with timeout"
      type: "client"
      timeout: 5000
      func: (test)->
        test.isTrue Meteor.isClient
    }
  ]

  tearDown: -> console.log 'tearDown'

  suiteTearDown: -> console.log 'suiteTearDown'

Munit.run(TestSuiteExample)