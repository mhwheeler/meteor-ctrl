


Tinytest.add('Foo Tests', function (test) {
  test.equal(1, 1);
  console.log( 'Ctrl', Ctrl );
  el = $('body')
  console.log( 'el[0]', el[0] );

  console.log( 'Ctrl', Ctrl );


  el.append('<div>Foo</div>')

});
