Package.describe({
  summary: 'Logical UI control abstraction around blaze'
});



Package.on_use(function (api) {
  api.use('http', ['client', 'server']);
  api.use(['templating', 'ui', 'spacebars'], 'client');
  api.use('coffeescript');
  api.export('Ctrl');

  // Generated with: github.com/philcockfield/meteor-package-loader
  api.add_files('client/control/tmpl.html', 'client');
  api.add_files('client/api.coffee', 'client');
  api.add_files('client/control/ctrl-class.coffee', 'client');
  api.add_files('client/control/ctrl-context.coffee', 'client');
  api.add_files('client/control/tmpl.coffee', 'client');

});

