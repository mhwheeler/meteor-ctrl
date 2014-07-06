describe 'DOM: insert', ->
  afterEach -> Test.tearDown()

  it 'inserts into the DOM with the "data-ctrl-uid" attribute', (done) ->
    Ctrl.defs.foo.insert('body').ready (instance) =>
        @try ->
            # Ensure the element exist within the DOM.
            el = $("div.foo[data-ctrl-uid='#{ instance.uid }']")
            expect(el[0]).to.exist
        done()


describe 'DOM: retrieval', ->
  it 'fromDom: jQuery elemnet', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>

        Ctrl.fromDom()

      done()
