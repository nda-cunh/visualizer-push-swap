
# Create a configuration file (config.vala)
config_vala = configure_file(input : 'config.vala.in',
              output : 'config.vala',
              configuration : conf_data)
all_srcs = [
  files('DrawStack.vala'),
  files('functions.vala'),
  files('main.vala'),
  files('window_program.vala'),
  files('Window.vala'),
  files('utils.vala'),
  files('Options.vala'),
  config_vala,
]

# Create visualizer executable 
executable('visualizer',
  all_srcs,
  asresources,
  vala_args: ['--enable-experimental', '--enable-deprecated'],
  c_args: '-w',
  dependencies : [
    dependency('gtk4'),
    meson.get_compiler('c').find_library('m')
  ],
  install : true)
