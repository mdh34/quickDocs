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

public class MainWindow : Gtk.Window {
    Gtk.Stack stack;
    public MainWindow (Gtk.Application application) {
         Object (application: application,
         icon_name: "com.github.mdh34.quickdocs",
         title: "quickDocs");
    }

    construct {
        set_position (Gtk.WindowPosition.CENTER);

        var header = new Gtk.HeaderBar ();
        header.set_show_close_button (true);

        var header_context = header.get_style_context ();
        header_context.add_class ("default-decoration");

        set_titlebar (header);

        stack = new Gtk.Stack ();
        stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);

        var window_width = Docs.settings.get_int ("width");
        var window_height = Docs.settings.get_int ("height");
        set_default_size (window_width, window_height);
        var x = Docs.settings.get_int ("window-x");
        var y = Docs.settings.get_int ("window-y");

        if (x != -1 || y != -1) {
            move (x, y);
        }

        this.destroy.connect (() => {
            Docs.settings.set_string ("tab", stack.get_visible_child_name ());
        });

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.set_stack (stack);
        header.set_custom_title (stack_switcher);

        var vala = new View ();

        var online = check_online ();
        if (online) {
            vala.load_uri (Docs.settings.get_string ("last-vala"));
            stack.add_titled (vala, "vala", "Valadoc");
        } else {
            var manager = new Dh.BookManager ();
            manager.populate ();

            var sidebar = new Dh.Sidebar (manager);
            sidebar.link_selected.connect ((source, link) => {
                vala.load_uri (link.get_uri ());
            });

            var pane = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
            pane.pack1 (sidebar, false, false);
            pane.add2 (vala);
            pane.set_position (300);

            stack.add_titled (pane, "vala", "Valadoc");
        }

        var dev = new View ();
        dev.set_cookies ();
        dev.appcache_init (online);
        dev.load_uri (Docs.settings.get_string ("last-dev"));

        stack.add_titled (dev, "dev", "DevDocs");

        var back = new Gtk.Button.from_icon_name ("go-previous-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        back.clicked.connect (() => {
            if (stack.get_visible_child_name () == "vala") {
                vala.go_back ();
            } else if (stack.get_visible_child_name () == "dev") {
                dev.go_back ();
            }
        });

        var forward = new Gtk.Button.from_icon_name ("go-next-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
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
        var gtk_settings = Gtk.Settings.get_default ();
        var theme_switch = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic", "weather-clear-night-symbolic");
        theme_switch.active = Docs.settings.get_boolean ("dark");
        theme_switch.row_homogeneous = true;
        theme_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");

        theme_switch.notify["active"].connect (()=> {
            toggle_theme (dev, online, gtk_settings);
        });
        var offline_popover = new PackageList ();

        var offline_button = new Gtk.MenuButton ();
        offline_button.image = new Gtk.Image.from_icon_name ("folder-download-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        offline_button.popover = offline_popover;
        offline_button.sensitive = online;
        offline_button.valign = Gtk.Align.CENTER;
        offline_button.set_tooltip_text (_("Download offline documentation"));

        header.add (back);
        header.add (forward);
        header.pack_end (theme_switch);
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
            stack_change (provider, theme_switch, offline_button);
        });

        show_all ();

        theme_switch.set_visible (false);
        set_tab ();

        this.delete_event.connect (() => {
            int current_x, current_y, width, height;
            get_position (out current_x, out current_y);
            get_size (out width, out height);

            Docs.settings.set_int ("window-x", current_x);
            Docs.settings.set_int ("window-y", current_y);
            Docs.settings.set_int ("width", width);
            Docs.settings.set_int ("height", height);

            if (dev.uri.contains ("devdocs.io")) {
                Docs.settings.set_string ("last-dev", dev.uri);
            }

            if (online && vala.uri.contains ("valadoc.org")) {
                Docs.settings.set_string ("last-vala", vala.uri);
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

    private void stack_change (Gtk.CssProvider provider, Granite.ModeSwitch theme_switch, Gtk.Button offline_button) {
        if (stack.get_visible_child_name () == "vala") {
            Gtk.Settings.get_default ().set ("gtk-application-prefer-dark-theme", true);
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            theme_switch.set_visible (false);
            offline_button.set_visible (true);
        } else {
            Gtk.StyleContext.remove_provider_for_screen (Gdk.Screen.get_default (), provider);
            init_theme ();

            theme_switch.set_visible (true);
            offline_button.set_visible (false);
        }
    }

    private void init_theme () {
        var window_settings = Gtk.Settings.get_default ();
        var dark = Docs.settings.get_boolean ("dark");

        if (dark) {
            window_settings.set ("gtk-application-prefer-dark-theme", true);
        } else {
            window_settings.set ("gtk-application-prefer-dark-theme", false);
        }
    }

    private void set_tab () {
        var tab = Docs.settings.get_string ("tab");
        stack.set_visible_child_name (tab);
    }

    private void toggle_theme (View view, bool online, Gtk.Settings gtk_settings) {
        if (!gtk_settings.gtk_application_prefer_dark_theme) {
            view.run_javascript.begin ("document.cookie = 'dark=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';", null);
            Docs.settings.set_boolean ("dark", false);
            view.get_settings ().enable_offline_web_application_cache = true;
            view.reload_bypass_cache ();
        } else {
            view.run_javascript.begin ("document.cookie = 'dark=1; expires=01 Jan 2100 00:00:00 UTC';", null);
            Docs.settings.set_boolean ("dark", true);
            if (online) {
                view.get_settings ().enable_offline_web_application_cache = false;
            }
            view.reload_bypass_cache ();
        }
    }
}
