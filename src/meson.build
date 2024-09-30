
if need_bootstrap 
  # Bootstrap the project use C sources instead of Vala sources
  warning('[Bootstrap] Vala is not available, using C sources')

  boot_strap = custom_target('tar_gz',
    input: files( 'bootstrap.tar.gz'),
    output: [
      'DrawStack.c',
      'functions.c',
      'main.c',
      'window_program.c',
      'Window.c',
      'utils.c',
      'Options.c',],
    command: [find_program('tar'), '-xf', '@INPUT@', '-C', meson.current_build_dir()],
  )

  all_srcs = boot_strap
else
  # Uses Vala sources if available else use C sources

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
endif

# Create visualizer executable 
executable('visualizer',
  all_srcs,
  asresources,
  vala_args: ['--enable-experimental', '--enable-deprecated'],
  c_args: '-w',
  dependencies : [
    dependency('gtk4'),
  ],
  install : true)
