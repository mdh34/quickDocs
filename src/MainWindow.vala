/*
 * Copyright (c) 2018 Matt Harris
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 *
 * Authored by: Matt Harris <matth281@outlook.com>
 */

using Gtk;
using WebKit;

const string[] PACKAGES = {
    "gee-0.8",
    "gio-2.0",
    "gio-unix-2.0",
    "glib-2.0",
    "gmodule-2.0",
    "gobject-2.0",
    "libpeas-gtk-1.0",
    "champlain-gtk-0.12",
    "clutter-1.0",
    "clutter-gtk-1.0",
    "gtk+-3.0",
    "gtksourceview-3.0",
    "libdazzle-1.0",
    "libgda-ui-5.0",
    "libgnome-menu-3.0",
    "vte-2.90",
    "vte-2.91",
    "webkit-1.0",
    "webkit2gtk-4.0",
    "webkit2gtk-web-extension-4.0",
    "clutter-gst-2.0",
    "clutter-gst-3.0",
    "grilo-0.2",
    "grilo-net-0.2",
    "gssdp-1.0",
    "gstreamer-1.0",
    "gstreamer-allocators-1.0",
    "gstreamer-app-1.0",
    "gstreamer-audio-1.0",
    "gstreamer-base-1.0",
    "gstreamer-check-1.0",
    "gstreamer-controller-1.0",
    "gstreamer-fft-1.0",
    "gstreamer-net-1.0",
    "gstreamer-pbutils-1.0",
    "gstreamer-player-1.0",
    "gstreamer-riff-1.0",
    "gstreamer-rtp-1.0",
    "gstreamer-rtsp-1.0",
    "gstreamer-rtsp-server-1.0",
    "gstreamer-sdp-1.0",
    "gstreamer-tag-1.0",
    "gstreamer-video-1.0",
    "gupnp-1.0",
    "gupnp-av-1.0",
    "gupnp-dlna-1.0",
    "gupnp-dlna-2.0",
    "gupnp-dlna-gst-2.0",
    "libcanberra",
    "libcanberra-gtk",
    "atk",
    "atspi-2",
    "cairo",
    "ccss-1",
    "cogl-1.0",
    "cogl-pango-1.0",
    "gdk-3.0",
    "gdk-pixbuf-2.0",
    "gdk-x11-3.0",
    "ibus-1.0",
    "librsvg-2.0",
    "pango",
    "pangocairo",
    "camel-1.2",
    "dconf",
    "folks",
    "folks-eds",
    "folks-libsocialweb",
    "folks-telepathy",
    "gnome-keyring-1",
    "libaccounts-glib",
    "libebook-1.2",
    "libebook-contacts-1.2",
    "libecalendar-1.2",
    "libedataserver-1.2",
    "libgda-5.0",
    "libgeoclue-2.0",
    "libmediaart-1.0",
    "libsecret-1",
    "sqlite3",
    "tracker-control-1.0",
    "tracker-indexer-module-1.0",
    "tracker-miner-0.16",
    "tracker-sparql-0.16",
    "tracker-sparql-1.0",
    "gnutls",
    "goa-1.0",
    "gsignond",
    "gweather-3.0",
    "libgdata",
    "libgsignon-glib",
    "libsoup-2.4",
    "libuhttpmock-0.0",
    "mock-service-0",
    "rest-0.6",
    "rest-0.7",
    "rest-extras-0.6",
    "telepathy-glib",
    "twitter-glib-1.0",
    "valum-0.3",
    "vsgi-0.3",
    "gxml-0.14",
    "json-glib-1.0",
    "libxml-2.0",
    "gtk-vnc-2.0",
    "gvnc-1.0",
    "gvncpulse-1.0",
    "libvirt-gconfig-1.0",
    "libvirt-glib-1.0",
    "libvirt-gobject-1.0",
    "spice-client-glib-2.0",
    "spice-client-gtk-3.0",
    "spice-protocol",
    "accountsservice",
    "appstream",
    "avahi-client",
    "avahi-gobject",
    "champlain-0.12",
    "colord",
    "colord-gtk",
    "dbus-glib-1",
    "enchant",
    "gck-1",
    "gcr-3",
    "gcr-ui-3",
    "gdl-1.0",
    "gdl-3.0",
    "gdu",
    "gdu-gtk",
    "gedit",
    "geocode-glib-1.0",
    "ggit-1.0",
    "gobject-introspection-1.0",
    "gudev-1.0",
    "javascriptcoregtk-3.0",
    "jsonrpc-glib-1.0",
    "libarchive",
    "libdmapsharing-3.0",
    "libepc-1.0",
    "libgitg-ext-1.0",
    "libgsf-1",
    "libide-1.0",
    "libnm-glib",
    "libnm-util",
    "libnotify",
    "liboobs-1",
    "libosinfo-1.0",
    "libpeas-1.0",
    "libwnck-3.0",
    "packagekit-glib2",
    "pkcs11",
    "poppler-glib",
    "udisks2",
    "unique-1.0",
    "dbusmenu-glib-0.4",
    "dbusmenu-gtk3-0.4",
    "dee-1.0",
    "snapd-glib",
    "unity",
    "unity-trace",
    "zeitgeist-1.0",
    "zeitgeist-datamodel-2.0",
    "granite",
    "switchboard-2.0",
    "sdl",
    "sdl-gfx",
    "sdl-image",
    "sdl-mixer",
    "sdl-net",
    "sdl-ttf",
    "libpq",
    "mysql",
    "raptor",
    "rasqal",
    "tokyocabinet",
    "alsa",
    "atasmart",
    "curses",
    "fuse",
    "gusb",
    "hal",
    "libftdi",
    "libmm-glib",
    "libnl-1",
    "libnl-2.0",
    "libnl-3.0",
    "libpulse",
    "libpulse-mainloop-glib",
    "libpulse-simple",
    "libusb",
    "libusb-1.0",
    "libxklavier",
    "linux",
    "posix",
    "readline",
    "v4l2",
    "x11",
    "xtst",
    "libgvc",
    "libmagic",
    "pixman-1",
    "taglib_c",
    "tiff",
    "bzlib",
    "gsl",
    "gtkmozembed",
    "hildon-1",
    "hildon-fm-2",
    "libdaemon",
    "libesmtp",
    "libosso",
    "libproxy-1.0",
    "loudmouth-1.0",
    "lua",
    "mx-1.0",
    "mx-2.0",
    "orc-0.4",
    "purple",
    "zlib",
    "aubio",
    "augeas",
    "cairo-xcb",
    "cairosdl",
    "cpufreq",
    "ctpl",
    "cups",
    "fcgi",
    "gcrypt",
    "gles2",
    "glfw3",
    "gpg-error",
    "gpgme",
    "kiss_fft",
    "leveldb",
    "libcolumbus",
    "libcouchbase",
    "libcurl",
    "libevent",
    "libgsasl",
    "libmarkdown",
    "libmatheval",
    "libmemcached",
    "libmemcachedutil",
    "libqpid-proton",
    "librabbitmq",
    "libserialport",
    "libstemmer",
    "libsystemd-id128",
    "libsystemd-journal",
    "libzmq",
    "magic",
    "oniguruma",
    "OpenCL",
    "opencv",
    "pa_ringbuffer",
    "portaudio",
    "portmidi",
    "pwquality",
    "qrencode",
    "samplerate",
    "sane-backends",
    "sdl2",
    "sdl2-android",
    "sdl2-gfx",
    "sdl2-image",
    "sdl2-ios",
    "sdl2-mixer",
    "sdl2-net",
    "sdl2-ttf",
    "sdl2-windows",
    "sensors",
    "snappy",
    "sndfile",
    "tcc",
    "uchardet",
    "uuid",
    "xcb",
    "xcb-composite",
    "xcb-damage",
    "xcb-dri2",
    "xcb-dri3",
    "xcb-icccm",
    "xcb-present",
    "xcb-randr",
    "xcb-render",
    "xcb-res",
    "xcb-shape",
    "xcb-shm",
    "xcb-sync",
    "xcb-xfixes",
    "xcb-xinerama",
    "xcb-xtest",
    "xcb-xv"
};

public class MainWindow : Gtk.Window {
    static GLib.Settings settings;
    Stack stack;
    public MainWindow (Gtk.Application application) {
         Object (application: application,
         icon_name: "com.github.mdh34.quickdocs",
         title: "quickDocs");
    }

    static construct {
        settings = new GLib.Settings ("com.github.mdh34.quickdocs");
    }

    construct {
        set_position (WindowPosition.CENTER);
        var header = new HeaderBar ();
        header.set_show_close_button (true);
        var header_context = header.get_style_context ();
        header_context.add_class ("default-decoration");
        set_titlebar (header);

        stack = new Stack ();
        stack.set_transition_type (StackTransitionType.SLIDE_LEFT_RIGHT);

        var window_width = settings.get_int ("width");
        var window_height = settings.get_int ("height");
        set_default_size (window_width, window_height);
        var x = settings.get_int ("window-x");
        var y = settings.get_int ("window-y");

        if (x != -1 || y != -1) {
            move (x, y);
        }

        this.destroy.connect (() => {
            settings.set_string ("tab", stack.get_visible_child_name ());
        });

        var stack_switcher = new StackSwitcher ();
        stack_switcher.set_stack (stack);
        header.set_custom_title (stack_switcher);

        var context = new WebContext ();
        var cookies = context.get_cookie_manager ();
        set_cookies (cookies);

        var online = check_online ();
        var vala = new WebView();

        if (online) {
            vala.load_uri (settings.get_string ("last-vala"));
            stack.add_titled (vala, "vala", "Valadoc");
        } else {
            var manager = new Dh.BookManager ();
            manager.populate ();
            var sidebar = new Dh.Sidebar (manager);
            sidebar.link_selected.connect ((source, link) => {
                vala.load_uri (link.get_uri ());
            });
            var pane = new Paned(Gtk.Orientation.HORIZONTAL);
            pane.add1 (sidebar);
            pane.add2 (vala);
            pane.set_position (300);
            stack.add_titled (pane, "vala", "Valadoc");
        }

        var dev = new WebView.with_context (context);
        set_appcache (dev, online);
        dev.load_uri (settings.get_string ("last-dev"));
        stack.add_titled (dev, "dev", "DevDocs");

        var back = new Button.from_icon_name ("go-previous-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        back.clicked.connect (() => {
            if (stack.get_visible_child_name () == "vala") {
                vala.go_back ();
            } else if (stack.get_visible_child_name () == "dev") {
                dev.go_back ();
            }
        });

        var forward = new Button.from_icon_name ("go-next-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        forward.clicked.connect (() => {
            if (stack.get_visible_child_name () == "vala") {
                vala.go_forward ();
            } else if (stack.get_visible_child_name () == "dev") {
                dev.go_forward ();
            }
        });

        var current_icons = Gtk.IconTheme.get_default ();
        string icon_name = "object-inverse-symbolic";
        if (current_icons.lookup_icon (icon_name, 16, Gtk.IconLookupFlags.FORCE_SIZE) == null) {
            icon_name = "weather-few-clouds-symbolic";
        }

        var theme_button = new Button.from_icon_name (icon_name);
        theme_button.clicked.connect(() => {
            toggle_theme (dev, online);
        });

        var package_list = new ListBox ();
        package_list.set_selection_mode(Gtk.SelectionMode.NONE);
        var group = new SizeGroup (Gtk.SizeGroupMode.BOTH);
        foreach (string item in PACKAGES) {
            package_list.add(new Downloader.Package (item, group));
        }

        var package_view = new ScrolledWindow (null,null);
        package_view.hscrollbar_policy = Gtk.PolicyType.NEVER;
        package_view.min_content_height = 512;
        package_view.add (package_list);
        package_view.show_all ();

        var offline_popover = new Popover (null);
        offline_popover.add (package_view);

        var offline_button = new MenuButton ();
        offline_button.image = new Gtk.Image.from_icon_name ("folder-download-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        offline_button.popover = offline_popover;
        offline_button.sensitive = online;
        offline_button.valign = Gtk.Align.CENTER;
        header.add (back);
        header.add (forward);
        header.pack_end (theme_button);
        header.pack_end (offline_button);

        add (stack);
        init_theme ();

        string style = "@define-color colorPrimary #403757;";
        var provider = new Gtk.CssProvider ();

        try {
            provider.load_from_data (style, -1);
        } catch {
            warning ("Couldn't load CSS");
        }

        stack.notify["visible-child"].connect (() => {
            stack_change(provider, theme_button, offline_button);
        });

        show_all ();

        theme_button.set_visible (false);
        set_tab ();

        this.delete_event.connect (() => {
            int current_x, current_y, width, height;
            get_position (out current_x, out current_y);
            get_size (out width, out height);
            settings.set_int ("window-x", current_x);
            settings.set_int ("window-y", current_y);
            settings.set_int ("width", width);
            settings.set_int ("height", height);
            settings.set_string ("last-dev", dev.uri);

            if (online) {
                settings.set_string ("last-vala", vala.uri);
            }

            return false;
        });

    }

    public void change_tab () {
        var current = stack.get_visible_child_name ();
        if (current == "vala") {
            stack.set_visible_child_name ("dev");
        } else {
            stack.set_visible_child_name ("vala");
        }
    }

    private bool check_online () {
        var host = "valadoc.org";
        try {
            var resolve = Resolver.get_default ();
            resolve.lookup_by_name (host, null);
            return true;
        } catch {
            return false;
        }
    }

    private void stack_change (CssProvider provider, Button theme_button, Button offline_button) {
        if (stack.get_visible_child_name () == "vala") {
            Gtk.Settings.get_default ().set ("gtk-application-prefer-dark-theme", true);
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            theme_button.set_visible (false);
            offline_button.set_visible (true);
        } else {
            Gtk.StyleContext.remove_provider_for_screen (Gdk.Screen.get_default (), provider);
            init_theme ();
            theme_button.set_visible (true);
            offline_button.set_visible (false);
        }
    }

    private void init_theme () {
        var window_settings = Gtk.Settings.get_default ();
        var dark = settings.get_int ("dark");

        if (dark == 1) {
            window_settings.set ("gtk-application-prefer-dark-theme", true);
        } else {
            window_settings.set ("gtk-application-prefer-dark-theme", false);
        }
    }

    private void set_appcache (WebView view, bool online) {
        var dark = settings.get_int ("dark");
        if (dark == 1 && online) {
            view.get_settings ().enable_offline_web_application_cache = false;
        }
    }

    private void set_cookies (CookieManager cookies) {
        string path = Path.build_filename (Environment.get_home_dir (), ".config", "com.github.mdh34.quickdocs", "cookies");
        string folder = Path.build_filename (Environment.get_home_dir (), ".config", "com.github.mdh34.quickdocs");

        if (!GLib.FileUtils.test (folder, GLib.FileTest.IS_DIR)) {
            var file = File.new_for_path (folder);
            try {
                file.make_directory ();
            } catch (Error e) {
                warning ("Unable to create config directory: %s", e.message);
            }
        }
        cookies.set_accept_policy (CookieAcceptPolicy.ALWAYS);
        cookies.set_persistent_storage (path, CookiePersistentStorage.SQLITE);
    }

    private void set_tab () {
        var tab = settings.get_string ("tab");
        stack.set_visible_child_name (tab);
    }

    private void toggle_theme (WebView view, bool online) {
        var window_settings = Gtk.Settings.get_default ();
        var dark = settings.get_int ("dark");
        if (dark == 1) {
            window_settings.set ("gtk-application-prefer-dark-theme", false);
            view.run_javascript.begin ("document.cookie = 'dark=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';", null);
            settings.set_int ("dark", 0);
            view.get_settings ().enable_offline_web_application_cache = true;
            view.reload_bypass_cache ();
        } else {
            window_settings.set ("gtk-application-prefer-dark-theme", true);
            view.run_javascript.begin ("document.cookie = 'dark=1; expires=01 Jan 2100 00:00:00 UTC';", null);
            settings.set_int ("dark", 1);
            if (online) {
                view.get_settings ().enable_offline_web_application_cache = false;
            }
            view.reload_bypass_cache ();
        }
    }
}
