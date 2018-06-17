executable(
    meson.project_name(),
    'Application.vala',
    'MainWindow.vala',
    'Services/Downloader.vala',
    'Widgets/Package.vala',
    'Widgets/PackageList.vala',
    'Widgets/View.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('libarchive'),
        dependency('libdevhelp-3.0'),
        dependency('webkit2gtk-4.0'),

    ],
    install: true
)