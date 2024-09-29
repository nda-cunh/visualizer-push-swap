
# Create visualizer executable 

executable('visualizer',
  'DrawStack.vala',
  'functions.vala',
  'main.vala',
  'Utils.vala',
  'window_program.vala',
  'window.vala',
  asresources,
  vala_args: ['--enable-experimental', '--enable-deprecated'],
  c_args: '-w',
  dependencies : [
    dependency('gtk4'),
  ],
  install : true)
