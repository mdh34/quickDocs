# project name and programming language
project('com.github.mdh34.quickdocs', 'vala', 'c')

# Include the translations module
i18n = import('i18n')

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')
# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    meson.project_name(),
    'src/quickDocs.vala',
    'src/Downloader.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('libarchive'),
        dependency('libdevhelp-3.0'),
        dependency('webkit2gtk-4.0'),
        
    ],
    install: true
)

meson.add_install_script('meson/post_install.py')
subdir('data')
