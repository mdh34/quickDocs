/*
 * Copyright (c) 2017 Matt Harris
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

void init_theme (){
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

void set_appcache (WebView view){
    var host = "elementary.io";
    var settings = view.get_settings ();
    try {
      var resolve = Resolver.get_default ();
      resolve.lookup_by_name (host, null);
      settings.enable_offline_web_application_cache = false;
    } catch (Error e) {
      print ("Using application cache");
    }
}

void set_cookies (CookieManager cookies){
    var path = (Environment.get_home_dir () + "/.config/com.github.mdh34.quickdocs/cookies");
    var folder = (Environment.get_home_dir () + "/.config/com.github.mdh34.quickdocs/");
    var file = File.new_for_path (folder);
    if (!file.query_exists ()){
        try{
            file.make_directory ();
        } catch (Error e){
            print ("Unable to create config directory");
            return;
        }
    }
    cookies.set_accept_policy (CookieAcceptPolicy.ALWAYS);
    cookies.set_persistent_storage (path, CookiePersistentStorage.SQLITE);
}

void set_tab (Stack stack){
    var user_settings = new GLib.Settings ("com.github.mdh34.quickdocs");
    var tab = user_settings.get_string ("tab");
    stack.set_visible_child_name (tab);
}

void toggle_theme (WebView view){
    var window_settings = Gtk.Settings.get_default ();
    var user_settings = new GLib.Settings ("com.github.mdh34.quickdocs");
    var dark = user_settings.get_int ("dark");
    if (dark == 1) {
        window_settings.set ("gtk-application-prefer-dark-theme", false);
        user_settings.set_int ("dark", 0);
        view.run_javascript ("document.cookie = 'dark=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';", null);
        view.reload_bypass_cache ();
    }
    else {
        window_settings.set ("gtk-application-prefer-dark-theme", true);
        user_settings.set_int ("dark", 1);
        view.run_javascript ("document.cookie = 'dark=1';", null);
        view.reload_bypass_cache ();
    }
}

int main(string[] args) {
    Gtk.init (ref args);
    var x = 1000;
    var y = 700;
    var window = new Gtk.Window ();
    var header = new HeaderBar ();
    header.set_show_close_button (true);
    window.set_titlebar (header);
    window.set_border_width (12);
    window.set_position (WindowPosition.CENTER);
    window.set_default_size (x, y);
    var stack = new Stack ();

    window.destroy.connect (() => {
      var user_settings = new GLib.Settings ("com.github.mdh34.quickdocs");
      user_settings.set_string ("tab", stack.get_visible_child_name());
      Gtk.main_quit ();
    });

    stack.set_transition_type (StackTransitionType.SLIDE_LEFT_RIGHT);

    var stack_switcher = new StackSwitcher ();
    stack_switcher.set_stack (stack);
    header.set_custom_title (stack_switcher);

    var context = new WebContext ();
    var cookies = context.get_cookie_manager ();
    set_cookies (cookies);

    var vala = new WebView ();
    vala.load_uri ("https://valadoc.org/");;
    stack.add_titled (vala, "vala", "Valadoc");

    var dev = new WebView.with_context (context);
    set_appcache(dev);
    dev.load_uri ("http://devdocs.io/");
    stack.add_titled (dev, "dev", "DevDocs");

    var back = new Button.from_icon_name ("go-previous-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
    back.clicked.connect (() => {
        if (stack.get_visible_child_name () == "vala"){
            vala.go_back ();
        } else if (stack.get_visible_child_name () == "dev") {
            dev.go_back ();
        }
    });
    header.add (back);

    var forward = new Button.from_icon_name ("go-next-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
    forward.clicked.connect (() => {
        if (stack.get_visible_child_name () == "vala"){
            vala.go_forward ();
        } else if (stack.get_visible_child_name () == "dev") {
            dev.go_forward ();
        }
    });
    header.add (forward);

    var theme_button = new Button.from_icon_name ("weather-few-clouds-symbolic");
    theme_button.clicked.connect(() => {
        toggle_theme (dev);
    });
    header.pack_end(theme_button);

    window.add (stack);
    init_theme();
    window.show_all ();
    set_tab (stack);
    Gtk.main ();
    return 0;
}
