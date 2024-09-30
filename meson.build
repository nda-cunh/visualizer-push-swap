project('visualizer-push-swap',
    version : '1.1',
    default_options : ['optimization=3', 'buildtype=release']
)

add_languages('c')
need_bootstrap = not (add_languages('vala', required: false))

if get_option ('bootstrap').enabled()
  need_bootstrap = true  
endif

conf_data = configuration_data()
conf_data.set('version', meson.project_version())

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
