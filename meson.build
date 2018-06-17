project('com.github.mdh34.quickdocs', 'vala', 'c')

i18n = import('i18n')

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

subdir ('src')
subdir('data')
subdir('po')
meson.add_install_script('meson/post_install.py')
