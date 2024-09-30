project('visualizer-push-swap', ['c', 'vala'], version : '0.1', default_options : ['optimization=3', 'buildtype=release'])

# BluePrint-Compiler compile all .blp files 
blueprints = custom_target('blueprints',
  input: files(
    'data/window.blp'
  ),
  output: '.',
  command: [find_program('blueprint-compiler'), 'batch-compile', '@OUTPUT@', '@CURRENT_SOURCE_DIR@', '@INPUT@'],
)

# GResources (add style.css and blueprint in the resources)
gnome = import('gnome')
asresources = gnome.compile_resources(
    'as-resources', 'data/gresource.xml',
    dependencies: blueprints,
)

# Create the executable
subdir('src')
