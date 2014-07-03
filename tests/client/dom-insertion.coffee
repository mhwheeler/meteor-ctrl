@expect = chai.expect


describe 'Inserting a control into the DOM', ->
  it 'inserts into the DOM with the "data-ctrl-uid" attribute', (done) ->
    Ctrl.defs.foo.insert('body').ready (instance) =>
        @try ->
            # Ensure the element exist within the DOM.
            el = $("div.foo[data-ctrl-uid='#{ instance.uid }']")
            expect(el[0]).to.exist
        done()



describe '[find] and [el] methods', ->
  it 'has both [find] and [el] methods', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>
          expect(ctrl.find().attr("data-ctrl-uid")).to.equal ctrl.uid
          expect(ctrl.el().attr("data-ctrl-uid")).to.equal ctrl.uid
      done()


  it 'finds sub elements', (done) ->
    Test.insert 'foo', (ctrl) =>
      @try =>
          el = ctrl.find('code')
          expect(el.html()).to.equal "Foo:#{ ctrl.uid }"
      done()


