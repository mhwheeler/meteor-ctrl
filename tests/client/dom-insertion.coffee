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



describe 'parent / children', ->
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



