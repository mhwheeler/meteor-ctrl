

myAsyncFunction = (callback) ->
  Meteor.setTimeout (-> callback('Test complete!')), 1000



TestSuiteExample =
  name: "TestSuiteExample"

  suiteSetup: -> # console.log 'suiteSetup'
  setup: -> # console.log 'setup'


  tests: [
    {
      name: "sync test"
      func: (test) ->
    },
    {
      name: "sync test ctrl"
      func: (test)->
        instance = Ctrl.defs.foo.insert('body')
        test.isTrue(true)
    },
    {
      name: "async test"
      # skip: true
      func: (test, done)->

        # myAsyncFunction ->

        #   console.log 'done', done

        #   expect(true).to.equal false
        #   done(false)


        myAsyncFunction done((value)->
          test.isNotNull(value)
          # expect(true).to.equal false
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

  tearDown: -> # console.log 'tearDown'
  suiteTearDown: -> # console.log 'suiteTearDown'

Munit.run(TestSuiteExample)