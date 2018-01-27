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
        window.set_default_size (1000, 700);
        window.set_position (WindowPosition.CENTER);
        var header = new HeaderBar ();
        header.set_show_close_button (true);
        window.set_titlebar (header);

        var stack = new Stack ();
        stack.set_transition_type (StackTransitionType.SLIDE_LEFT_RIGHT);

        window.destroy.connect (() => {
            var user_settings = new GLib.Settings ("com.github.mdh34.quickdocs");
            user_settings.set_string ("tab", stack.get_visible_child_name());
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
            vala.load_uri ("https://valadoc.org");
        } else {
            //todo sidebar or searching thing
            var path = ("file://" + Environment.get_home_dir () + "/.local/share/com.github.mdh34.quickdocs/offline");
            vala.load_uri (path);
        }


        var dev = new WebView.with_context (context);
        set_appcache (dev, online);
        dev.load_uri ("https://devdocs.io");

        stack.add_titled (vala, "vala", "Valadoc");
        stack.add_titled (dev, "dev", "DevDocs");

        var back = new Button.from_icon_name ("go-previous-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        back.clicked.connect (() => {
            if (stack.get_visible_child_name () == "vala"){
                vala.go_back ();
            } else if (stack.get_visible_child_name () == "dev") {
                dev.go_back ();
            }
        });

        var forward = new Button.from_icon_name ("go-next-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        forward.clicked.connect (() => {
            if (stack.get_visible_child_name () == "vala"){
                vala.go_forward ();
            } else if (stack.get_visible_child_name () == "dev") {
                dev.go_forward ();
            }
        });

        var theme_button = new Button.from_icon_name ("object-inverse");
        theme_button.clicked.connect(() => {
            toggle_theme (dev);
        });

        var download_button = new Button.from_icon_name ("go-down-symbolic");
        download_button.tooltip_text = (_("Download Valadoc for offline use"));
        download_button.clicked.connect (() => {
            try {
                GLib.Process.spawn_command_line_async("sh /usr/share/com.github.mdh34.quickdocs/offline.sh");
            } catch (SpawnError e) {
                print ("error downloading");
                print (e.message);
            }
        });
        download_button.sensitive = online;


        header.add (back);
        header.add (forward);
        header.pack_end (theme_button);
        header.pack_end (download_button);

        window.add (stack);
        init_theme ();
        window.show_all ();
        set_tab (stack);

        var tab_switch = new SimpleAction ("switch", null);
        add_action (tab_switch);
        add_accelerator ("<Control>Tab", "app.switch", null);

        tab_switch.activate.connect (() => {
            change_tab (stack);
        });
    }


    private void init_theme () {
        var window_settings = Gtk.Settings.get_default ();
        var user_settings = new GLib.Settings ("com.github.mdh34.quickdocs");
        var dark = user_settings.get_int ("dark");

        if (dark == 1) {
            window_settings.set ("gtk-application-prefer-dark-theme", true);
        }
        else {
            window_settings.set ("gtk-application-prefer-dark-theme", false);
        }
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
        var host = "elementary.io";
        try {
            var resolve = Resolver.get_default ();
            resolve.lookup_by_name (host, null);
            return true;
        } catch {
            return false;
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
                return;
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
