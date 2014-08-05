findElement = (uid) -> $("div.foo[data-ctrl-uid='#{ uid }']")


describe 'DOM: insert', ->
  afterEach -> Test.tearDown()

  it 'inserts into the DOM with the "data-ctrl-uid" attribute', (done) ->
    Ctrl.defs.foo.insert('body').ready (instance) =>
        @try ->
            # Ensure the element exist within the DOM.
            el = findElement(instance.uid)
            expect(el[0]).to.exist
        done()


describe 'Ctrl.fromElement', ->
  it 'via jQuery element', (done) ->
    Test.insert 'foo', (instance) =>
        el = findElement(instance.uid)
        @try => expect(Ctrl.fromElement(el)).to.equal instance.ctrl
        done()


  it 'via DOM element', (done) ->
    Test.insert 'foo', (instance) =>
        el = findElement(instance.uid)
        @try => expect(Ctrl.fromElement(el[0])).to.equal instance.ctrl
        done()


  it 'via CSS selector', (done) ->
    Test.insert 'foo', (instance) =>
        @try => expect(Ctrl.fromElement("div.foo[data-ctrl-uid='#{ instance.uid }']")).to.equal instance.ctrl
        done()


  it 'returns nothing when not found', (done) ->
    Test.insert 'foo', (instance) =>
      @try =>
          expect(Ctrl.fromElement($(".not-exist"))).to.equal undefined
          expect(Ctrl.fromElement(".not-exist")).to.equal undefined
          expect(Ctrl.fromElement("")).to.equal undefined
          expect(Ctrl.fromElement(null)).to.equal undefined
          expect(Ctrl.fromElement()).to.equal undefined
      done()
