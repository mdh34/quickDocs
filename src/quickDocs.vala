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

public class App : Gtk.Application {

    public App () {
        Object (
            application_id: "com.github.mdh34.quickdocs",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }


    protected override void activate () {
        var window = new ApplicationWindow (this);
        window.set_position (WindowPosition.CENTER);
        var header = new HeaderBar ();
        header.set_show_close_button (true);
        var header_context = header.get_style_context ();
        header_context.add_class ("default-decoration");
        window.set_titlebar (header);

        var stack = new Stack ();
        stack.set_transition_type (StackTransitionType.SLIDE_LEFT_RIGHT);

        var user_settings = new GLib.Settings ("com.github.mdh34.quickdocs");
        window.destroy.connect (() => {
            user_settings.set_string ("tab", stack.get_visible_child_name ());
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
            vala.load_uri (user_settings.get_string ("last-vala"));
        } else {
            vala.load_uri ("file://" + Environment.get_home_dir () + "/.local/share/com.github.mdh34.quickdocs/");
        }

        var dev = new WebView.with_context (context);
        first_run (dev);
        set_appcache (dev, online);
        dev.load_uri (user_settings.get_string ("last-dev"));

        stack.add_titled (vala, "vala", "Valadoc");
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

        var theme_button = new Button.from_icon_name ("object-inverse");
        theme_button.clicked.connect(() => {
            toggle_theme (dev);   
        });
        
        var offline_button = new Button.from_icon_name ("folder-download-symbolic");
        offline_button.clicked.connect(() => {
            download_docs ();
        });

        header.add (back);
        header.add (forward);
        header.pack_end (theme_button);
        header.pack_end (offline_button);
        
        window.add (stack);
        init_theme ();

        string style = "@define-color colorPrimary #403757;";
        var provider = new Gtk.CssProvider ();

        try {
            provider.load_from_data (style, -1);
        } catch {
            print ("Couldn't load CSS");
        }

        stack.notify["visible-child"].connect (() => {
            stack_change(stack, provider, theme_button, offline_button);
        });
        
        var window_x = user_settings.get_int ("window-x");
        var window_y = user_settings.get_int ("window-y");
        if (window_x != -1 ||  window_y != -1) {
            window.move (window_x, window_y);
        }

        var window_width = user_settings.get_int ("width");
        var window_height = user_settings.get_int ("height");
        window.set_default_size (window_width, window_height);

        window.show_all ();
        
        theme_button.set_visible (false);
        set_tab (stack);


        window.delete_event.connect (() => {
            int current_x, current_y, width, height;
            window.get_position (out current_x, out current_y);
            window.get_size (out width, out height);
            user_settings.set_int ("window-x", current_x);
            user_settings.set_int ("window-y", current_y);
            user_settings.set_int ("width", width);
            user_settings.set_int ("height", height);
            user_settings.set_string ("last-dev", dev.uri);
            
            if (online) {
                user_settings.set_string ("last-vala", vala.uri);
            }
            
            return false;
        });

        var tab_switch = new SimpleAction ("switch", null);
        add_action (tab_switch);
        set_accels_for_action ("app.switch", {"<Control>Tab"});

        tab_switch.activate.connect (() => {
            change_tab (stack);
        });
    }


    private void change_tab (Stack stack) {
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

    private void stack_change (Stack stack, CssProvider provider, Button theme_button, Button offline_button) {
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
    private void download_docs () {
        try {
            Process.spawn_command_line_async ("x-terminal-emulator -e /usr/share/com.github.mdh34.quickdocs/offline.sh");
        } catch (SpawnError e) {
            print (e.message);
        }
    }

    private void first_run (WebView view) {
        var user_settings = new GLib.Settings ("com.github.mdh34.quickdocs");
        if (user_settings.get_int ("first") == 0) {
            view.load_uri ("https://devdocs.io");
            user_settings.set_int ("first", 1);
        }
    }


    private void init_theme () {
        var window_settings = Gtk.Settings.get_default ();
        var user_settings = new GLib.Settings ("com.github.mdh34.quickdocs");
        var dark = user_settings.get_int ("dark");

        if (dark == 1) {
            window_settings.set ("gtk-application-prefer-dark-theme", true);
        } else {
            window_settings.set ("gtk-application-prefer-dark-theme", false);
        }
    }

    private void set_appcache (WebView view, bool online) {
        var settings = view.get_settings ();
        if (online) {
            settings.enable_offline_web_application_cache = false;
        }
    }

    private void set_cookies (CookieManager cookies) {
        var path = (Environment.get_home_dir () + "/.config/com.github.mdh34.quickdocs/cookies");
        var folder = (Environment.get_home_dir () + "/.config/com.github.mdh34.quickdocs/");
        var file = File.new_for_path (folder);
        if (!file.query_exists ()) {
            try {
                file.make_directory ();
            } catch (Error e) {
                print ("Unable to create config directory");
                print (e.message);
            }
        }
        cookies.set_accept_policy (CookieAcceptPolicy.ALWAYS);
        cookies.set_persistent_storage (path, CookiePersistentStorage.SQLITE);
    }

    private void set_tab (Stack stack) {
        var user_settings = new GLib.Settings ("com.github.mdh34.quickdocs");
        var tab = user_settings.get_string ("tab");
        stack.set_visible_child_name (tab);
    }

    private void toggle_theme (WebView view) {
        var window_settings = Gtk.Settings.get_default ();
        var user_settings = new GLib.Settings ("com.github.mdh34.quickdocs");
        var dark = user_settings.get_int ("dark");
        if (dark == 1) {
            window_settings.set ("gtk-application-prefer-dark-theme", false);
            user_settings.set_int ("dark", 0);
            view.run_javascript ("document.cookie = 'dark=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';", null);
            view.reload_bypass_cache ();
        } else {
            window_settings.set ("gtk-application-prefer-dark-theme", true);
            user_settings.set_int ("dark", 1);
            view.run_javascript ("document.cookie = 'dark=1; expires=01 Jan 2020 00:00:00 UTC';", null);
            view.reload_bypass_cache ();
        }
    }

    public static int main (string[] args) {
        var app = new App ();
        return app.run (args);
    }
}
