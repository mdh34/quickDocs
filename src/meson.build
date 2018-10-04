if dependency('libarchive').version().version_compare('>=3.3.2')
    add_project_arguments('--define=ARCHIVE_332', language: 'vala')
endif
executable(
    meson.project_name(),
    'Application.vala',
    'Constants.vala',
    'MainWindow.vala',
    'Services/Downloader.vala',
    'Widgets/Package.vala',
    'Widgets/PackageList.vala',
    'Widgets/View.vala',
    dependencies: [
        dependency('gee-0.8'),
        dependency('gtk+-3.0'),
        dependency('granite', version : '>=5.1.0'),
        dependency('libarchive'),
        dependency('libdevhelp-3.0'),
        dependency('webkit2gtk-4.0'),
    ],
    install: true
)
