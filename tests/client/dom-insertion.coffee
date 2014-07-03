@expect = chai.expect


describe 'Insert into the DOM', ->
  afterEach -> Test.tearDown()

  it 'inserts into the DOM with the "data-ctrl-uid" attribute', (done) ->
    Ctrl.defs.foo.insert('body').ready (instance) =>
        @try ->
            # Ensure the element exist within the DOM.
            el = $("div.foo[data-ctrl-uid='#{ instance.uid }']")
            expect(el[0]).to.exist
        done()



describe 'remove from the DOM', ->
  it 'removes the ctrl from the DOM', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>
          el = $("div.foo[data-ctrl-uid='#{ ctrl.uid }']")
          expect(el.length).to.equal 1
          ctrl.remove()
          el = $("div.foo[data-ctrl-uid='#{ ctrl.uid }']")
          expect(el.length).to.equal 0
      done()


  it 'disposes of the ctrl when removed', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>
          expect(ctrl.isDisposed).to.be.undefined
          ctrl.remove()
          expect(ctrl.isDisposed).to.be.true
      done()


  it 'does not fail when removing twice', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>
          ctrl.remove()
          ctrl.remove()
      done()


  it 'removes from the DOM when "dispose" is called', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>
          ctrl.dispose()
          el = $("div.foo[data-ctrl-uid='#{ ctrl.uid }']")
          expect(el.length).to.equal 0
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
          expect(children[1].type).to.equal 'deep-child'
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



