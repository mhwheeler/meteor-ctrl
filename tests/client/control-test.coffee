describe 'Control', ->
  it 'has a subset of properties from the context (instance)', (done) ->
    Test.insert 'foo', (instance) =>
      ctrl = instance.ctrl
      @try =>

          expect(ctrl.context).to.equal instance
          expect(ctrl.type).to.equal 'foo'
          expect(ctrl.uid).to.equal instance.uid

      done()


  it 'parent/children', (done) ->
    Test.insert 'deep', (instance) =>
      ctrl = instance.ctrl
      @try =>
          expect(ctrl.children.length).to.equal 3
          expect(ctrl.children[0].parent).to.equal ctrl
          expect(ctrl.children.myFoo).to.equal instance.children.myFoo.ctrl
      done()



describe 'Control: dispose', ->
  it 'is disposed when instance is disposed', (done) ->
    Test.insert 'foo', (instance) =>
      @try =>
          instance.dispose()
          expect(instance.isDisposed).to.equal true
          expect(instance.ctrl.isDisposed).to.equal true
      done()


  it 'disposes of instance', (done) ->
    Test.insert 'foo', (instance) =>
      ctrl = instance.ctrl
      @try =>
          ctrl.dispose()
          expect(instance.isDisposed).to.equal true
          expect(ctrl.isDisposed).to.equal true
          expect(Ctrl.instances[ctrl.uid]).to.equal undefined
      done()


  it 'removes children on dispose', (done) ->
    Test.insert 'deep', (instance) =>
      ctrl = instance.ctrl
      @try =>
          count = ctrl.children.length
          ctrl.children.myFoo.dispose()
          expect(ctrl.children.myFoo).to.equal undefined
          expect(ctrl.children.length).to.equal count - 1
      done()
