
Ctrl.define
  'foo':
    init: ->
    # created: -> console.log 'created', @
    helpers:
      title: -> "Foo:#{ @uid }"


#  --------------------------------------------------------------------------


myAsyncFunction = (callback) ->
  Meteor.setTimeout (-> callback('Test complete!')), 1000




Test.suite
  'fooBar':

    tearDown: ->
      # for key, value of Ctrl.instances
      #   console.log 'REMVOE', value

    tests:
      async: (test, done) ->

        # timeout (callback) ->


      insertCtrl: (test, done) ->

        instance = Ctrl.defs.foo.insert('body')

        console.trace()

        console.log 'done', done


        myAsyncFunction done (value)->

          console.log 'after timeout'
          console.log 'instance', instance
          console.log 'instance.find()', instance.find()[0]
          console.log ''

          # expect(true).to.equal false


        # myAsyncFunction done((value)->
        #   test.isNotNull(value)
        # )

        # c = instance.__component__
        # console.log 'c', c
        # console.log 'c.destroy', c.destroy

