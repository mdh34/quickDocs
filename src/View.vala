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

public class View : WebKit.WebView {
    public View () {
        this.create.connect (() => {
            return this;
        });
    }

    public void appcache_init (bool online) {
        var dark = new GLib.Settings ("com.github.mdh34.quickdocs").get_int ("dark");
        if (dark == 1 && online) {
            get_settings ().enable_offline_web_application_cache = false;
        }
    }

    public void set_cookies () {
        string path = Path.build_filename (Environment.get_user_config_dir (), "com.github.mdh34.quickdocs", "cookies");
        string folder = Path.build_filename (Environment.get_user_config_dir (), "com.github.mdh34.quickdocs");
        var cookies = get_context ().get_cookie_manager ();
        if (!GLib.FileUtils.test (folder, GLib.FileTest.IS_DIR)) {
            var file = File.new_for_path (folder);
            try {
                file.make_directory ();
            } catch (Error e) {
                warning ("Unable to create config directory: %s", e.message);
            }
        }
        cookies.set_accept_policy (WebKit.CookieAcceptPolicy.ALWAYS);
        cookies.set_persistent_storage (path, WebKit.CookiePersistentStorage.SQLITE);
    }
}