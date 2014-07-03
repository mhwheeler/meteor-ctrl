@expect = chai.expect


describe 'Inserting a control into the DOM', ->
  it 'inserts into the DOM with the "data-ctrl-uid" attribute', (done) ->
    Ctrl.defs.foo.insert('body').ready (instance) =>
        @try ->
            # Ensure the element exist within the DOM.
            el = $("div.foo[data-ctrl-uid='#{ instance.uid }']")
            expect(el[0]).to.exist
        done()

