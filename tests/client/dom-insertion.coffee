@expect = chai.expect


describe 'DOM insertion', ->
  afterEach -> Test.tearDown()

  it 'inserts into the DOM with the "data-ctrl-uid" attribute', (done) ->
    Ctrl.defs.foo.insert('body').ready (instance) =>
        @try ->
            # Ensure the element exist within the DOM.
            el = $("div.foo[data-ctrl-uid='#{ instance.uid }']")
            expect(el[0]).to.exist
        done()



describe 'dispose', ->
  it 'results in an "isDisposed" state', (done) ->

    Test.insert 'deep', (ctrl) =>
      children = ctrl.children.clone()
      @try =>
          ctrl.dispose()
          expect(ctrl.isDisposed).to.be.true

          expect(ctrl.children.length).to.equal 0
          for child in children
            expect(child.isDisposed).to.equal true

      done()


  it 'calls "destroyed" on instance', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>
          ctrl.dispose()
          expect(ctrl.destroyedWasCalled).to.equal true
      done()



  it 'removes the ctrl from the DOM', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>
          el = $("div.foo[data-ctrl-uid='#{ ctrl.uid }']")
          expect(el.length).to.equal 1
          ctrl.dispose()
          el = $("div.foo[data-ctrl-uid='#{ ctrl.uid }']")
          expect(el.length).to.equal 0
      done()


  it 'remove the global reference to the instance', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>
          expect(Ctrl.instances[ctrl.uid]).to.equal ctrl
          ctrl.dispose()
          expect(Ctrl.instances[ctrl.uid]).to.be.undefined
      done()





describe '[find] and [el] methods', ->
  afterEach -> Test.tearDown()

  it 'has both [find] and [el] methods', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>
          expect(ctrl.find().attr("data-ctrl-uid")).to.equal ctrl.uid
          expect(ctrl.el().attr("data-ctrl-uid")).to.equal ctrl.uid
      done()

  it 'finds child elements with CSS selector', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>
          el = ctrl.find('code')
          expect(el.html()).to.equal "Foo:#{ ctrl.uid }"

          el = ctrl.el('code')
          expect(el.html()).to.equal "Foo:#{ ctrl.uid }"

      done()



describe 'parent / children', ->
  afterEach -> Test.tearDown()

  it 'has children', (done) ->
    Test.insert 'deep', (ctrl) =>
      @try =>
          children = ctrl.children
          expect(ctrl.parent).to.be.undefined

          # Children array.
          expect(children.length).to.equal 3
          expect(children[0].type).to.equal 'foo'
          expect(children[1].type).to.equal 'deepChild'
          expect(children[2].type).to.equal 'foo'

          # Children by "id".
          expect(children.myChild).to.equal children[1]
          expect(children.myFoo).to.equal ctrl.children[2]

      done()


  it 'has parent', (done) ->
    Test.insert 'deep', (ctrl) =>
      @try =>
          child = ctrl.children.myChild
          grandChild = child.children[0]
          expect(grandChild.parent).to.equal child
          expect(child.parent).to.equal ctrl
      done()


  it 'does not have parent', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>
          expect(ctrl.parent).to.be.undefined
      done()



