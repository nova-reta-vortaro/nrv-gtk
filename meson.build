project('gelez.xyz.nrv-gtk', 'vala', 'c', version: '0.1.0')

glib = dependency('glib-2.0')
gobject = dependency('gobject-2.0')
gtk = dependency('gtk+-3.0')
libsoup = dependency('libsoup-2.4')
json = dependency('json-glib-1.0')
gee = dependency('gee-0.8')
granite = dependency('granite')

executable(
    'nrv-gtk',
    'src/Api.vala',
    'src/App.vala',
    'src/HeaderBar.vala',
    'src/Home.vala',
    'src/MainWindow.vala',
    'src/WordPage.vala',
    dependencies: [
        glib,
        gobject,
        gtk,
        libsoup,
        json,
        gee,
        granite
    ],
    install: true
)