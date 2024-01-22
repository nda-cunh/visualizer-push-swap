project('visualizer-push-swap', ['c', 'vala'], version : '0.1')
gnome = import('gnome')
# , default_options : ['b_sanitize=address']
add_project_arguments('--enable-experimental', language: 'vala')
add_project_arguments('--enable-deprecated', language: 'vala')
add_project_arguments('-g', language: 'vala')

blueprints = custom_target('blueprints',
  input: files(
    'window.blp'
  ),
  output: '.',
  command: [find_program('blueprint-compiler'), 'batch-compile', '@OUTPUT@', '@CURRENT_SOURCE_DIR@', '@INPUT@'],
)

asresources = gnome.compile_resources(
    'as-resources', 'gresource.xml',
    dependencies: blueprints,
)

executable('visualizer',
  asresources,
           'src/DrawStack.vala',
           'src/functions.vala',
           'src/main.vala',
           'src/Utils.vala',
           'src/window_program.vala',
           'src/window.vala',
           dependencies : [
              dependency('gtk4')],
           install : true)
