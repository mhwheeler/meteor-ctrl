Package.describe({
  summary: 'core-control: UI Control wrapper around blaze'
});



Package.on_use(function (api) {
  api.use('http', ['client', 'server']);
  api.use(['templating', 'ui', 'spacebars'], 'client');
  api.use('coffeescript');
  api.export('Ctrl');

  // Generated with: github.com/philcockfield/meteor-package-loader
  api.add_files('client/control/control.html', 'client');
  api.add_files('client/export.coffee', 'client');
  api.add_files('client/control/control.coffee', 'client');

});
