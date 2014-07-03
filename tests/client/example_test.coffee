@expect = chai.expect

describe 'Inserting a control into the DOM', ->
  it 'insert ctrl', (done) ->
    instance = Ctrl.defs.foo.insert('body')


    func = ->
      console.log 'instance', instance
      console.log 'instance.find()', instance.find()[0]

      done()


    Meteor.setTimeout func, 800







