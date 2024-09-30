
# Create a configuration file (config.vala)
config_vala = configure_file(input : 'config.vala.in',
               output : 'config.vala',
               configuration : conf_data)

# Create visualizer executable 
executable('visualizer',
  'DrawStack.vala',
  'functions.vala',
  'main.vala',
  'window_program.vala',
  'Window.vala',
  'utils.vala',
  'Options.vala',
  config_vala,
  asresources,
  vala_args: ['--enable-experimental', '--enable-deprecated'],
  c_args: '-w',
  dependencies : [
    dependency('gtk4'),
  ],
  install : true)
