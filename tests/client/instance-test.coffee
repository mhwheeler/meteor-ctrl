describe 'Instance', ->
  afterEach -> Test.tearDown()

  it 'has standard structure', (done) ->
    Test.insert 'foo', (instance) =>
      @try =>
        expect(Object.isString(instance.uid)).to.equal true
        expect(instance.type).to.equal 'foo'
        expect(instance.ctrl).to.be.an.instanceOf Ctrl.Control
      done()






describe 'Instance: dispose', ->
  afterEach -> Test.tearDown()

  it 'results in an "isDisposed" state', (done) ->

    Test.insert 'deep', (instance) =>
      children = instance.children.clone()
      @try =>
          instance.dispose()
          expect(instance.isDisposed).to.equal true
          expect(instance.ctrl.isDisposed).to.equal true

          expect(instance.children.length).to.equal 0
          for child in children
            expect(child.isDisposed).to.equal true

      done()


  it 'calls "destroyed" on instance', (done) ->
    Test.insert 'foo', (instance) =>
      @try =>
          instance.dispose()
          expect(instance.destroyedWasCalled).to.equal true
      done()



  it 'removes the ctrl from the DOM', (done) ->
    Test.insert 'foo', (instance) =>
      @try =>
          el = $("div.foo[data-ctrl-uid='#{ instance.uid }']")
          expect(el.length).to.equal 1
          instance.dispose()
          el = $("div.foo[data-ctrl-uid='#{ instance.uid }']")
          expect(el.length).to.equal 0
      done()


  it 'remove the global reference to the instance', (done) ->
    Test.insert 'foo', (instance) =>
      ctrl = instance.ctrl
      @try =>
          expect(Ctrl.instances[instance.uid]).to.equal ctrl
          instance.dispose()
          expect(Ctrl.instances[instance.uid]).to.be.undefined
      done()





describe 'Instance: [find] and [el] methods', ->
  afterEach -> Test.tearDown()

  it 'has both [find] and [el] methods', (done) ->
    Test.insert 'foo', (instance) =>
      @try =>
          expect(instance.find().attr("data-ctrl-uid")).to.equal instance.uid
          expect(instance.el().attr("data-ctrl-uid")).to.equal instance.uid
      done()

  it 'finds child elements with CSS selector', (done) ->
    Test.insert 'foo', (instance) =>
      @try =>
          el = instance.find('code')
          expect(el.html()).to.equal "Foo:#{ instance.uid }"

          el = instance.el('code')
          expect(el.html()).to.equal "Foo:#{ instance.uid }"

      done()



describe 'Instance: parent / children', ->
  afterEach -> Test.tearDown()

  it 'has children', (done) ->
    Test.insert 'deep', (instance) =>
      @try =>
          children = instance.children
          expect(instance.parent).to.be.undefined

          # Children array.
          expect(children.length).to.equal 3
          expect(children[0].type).to.equal 'foo'
          expect(children[1].type).to.equal 'deepChild'
          expect(children[2].type).to.equal 'foo'

          # Children by "id".
          expect(children.myChild).to.equal children[1]
          expect(children.myFoo).to.equal instance.children[2]

      done()


  it 'has parent', (done) ->
    Test.insert 'deep', (instance) =>
      @try =>
          child = instance.children.myChild
          grandChild = child.children[0]
          expect(grandChild.parent).to.equal child
          expect(child.parent).to.equal instance
      done()


  it 'does not have parent', (done) ->
    Test.insert 'foo', (instance) =>
      @try =>
          expect(instance.parent).to.be.undefined
      done()



describe 'Instance: autorun', ->
  afterEach -> Test.tearDown()

  it 're-runs the autorun function', (done) ->
    KEY = 'reactive-value'
    Test.insert 'autorun', (instance) =>
      Util.delay 10, =>
        Session.set(KEY, 'a')
        Util.delay 10, =>
          Session.set(KEY, 'b')
          @try =>
            expect(instance.runCount).to.equal 2

          done()




describe 'Instance: ScopedSession', ->
  afterEach -> Test.tearDown()

  it 'has a session with a namespace of the UID', (done) ->
    Test.insert 'foo', (instance) =>
      @try => expect(instance.session().namespace).to.equal "__ctrl:#{ instance.uid }"
      done()

  it 'has returns the same instance of the session', (done) ->
    Test.insert 'foo', (instance) =>
      @try =>
        session1 = instance.session()
        session2 = instance.session()
        expect(session1).to.equal session2
      done()

  it 'disposes of the session', (done) ->
    Test.insert 'foo', (instance) =>
      @try =>
        session = instance.session()
        instance.dispose()
        expect(session.isDisposed).to.equal true
      done()



describe 'Instance: ReactiveHash', ->
  afterEach -> Test.tearDown()

  it 'has a ReactiveHash', (done) ->
    Test.insert 'foo', (instance) =>
      @try =>
          expect(instance.hash()).to.be.an.instanceof ReactiveHash
          expect(instance.hash()).to.equal instance.hash() # Same instance.
      done()

  it 'disposes of the ReactiveHash', (done) ->
    Test.insert 'foo', (instance) =>
      @try =>
          hash = instance.hash()
          instance.dispose()
          expect(hash.isDisposed).to.equal true
      done()



describe 'Instance: Prop', ->
  afterEach -> Test.tearDown()

  it 'reads a value from the hash', (done) ->
    Test.insert 'foo', (instance) =>
      instance.hash().set('myProp', 123)
      @try =>
        expect(instance.prop('myProp')).to.equal 123
      done()

  it 'writes a value to the hash', (done) ->
    Test.insert 'foo', (instance) =>
      instance.prop('myProp', 123)
      @try =>
        expect(instance.hash().get('myProp')).to.equal 123
      done()


