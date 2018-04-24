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

namespace Downloader {
    public void decompress (string item) {
        var reader = new Archive.Read ();
        reader.support_filter_bzip2 ();
        reader.support_format_all ();

        var disk = new Archive.WriteDisk ();
        disk.set_standard_lookup ();

        string path = Path.build_filename (GLib.Environment.get_user_data_dir (), "devhelp", "books", item + ".tar.bz2");
        string destination = Path.build_filename (GLib.Environment.get_user_data_dir (), "devhelp", "books/");

        reader.open_filename (path, 4096);
        unowned Archive.Entry entry;

        while (reader.next_header (out entry) == Archive.Result.OK) {
            entry.set_pathname (destination + entry.pathname ());

            if(disk.write_header (entry) != Archive.Result.OK) {
                continue;
            };

            void* buffer = null;
            size_t buffer_length;
            Posix.off_t offset;

            if (entry.size () > 0) {
                while (reader.read_data_block(out buffer, out buffer_length, out offset) != Archive.Result.EOF) {
                    disk.write_data_block(buffer, buffer_length, offset);
                }
            }
        }
    }

    public void download (string item) {
        var loop = new MainLoop ();
        string parent_path = Path.build_filename (GLib.Environment.get_user_data_dir (), "devhelp");
        string folder_path = Path.build_filename (GLib.Environment.get_user_data_dir (), "devhelp", "books");

        if (!GLib.FileUtils.test (parent_path, GLib.FileTest.IS_DIR)) {
            var folder = File.new_for_path (parent_path);
            try {
                folder.make_directory ();
            } catch (Error e) {
                warning ("Unable to create download directory");
                warning (e.message);
            }
        }

        if (!GLib.FileUtils.test (folder_path, GLib.FileTest.IS_DIR)) {
            var folder = File.new_for_path (folder_path);
            try {
                folder.make_directory ();
            } catch (Error e) {
                warning ("Unable to create download directory");
                warning (e.message);
            }
        }

        File target = File.new_for_uri ("https://valadoc.org/" + item + "/" + item + ".tar.bz2");
        string dest_path = Path.build_filename (GLib.Environment.get_user_data_dir (), "devhelp", "books", item + ".tar.bz2");

        File destination = File.new_for_path (dest_path);
        target.copy_async.begin (destination, 0, Priority.DEFAULT, null, () => {}, (obj, res) => {
            try {
                target.copy_async.end (res);
            } catch (Error e) {
                warning (e.message);
            }
            loop.quit ();
        });
        loop.run ();
    }

    public void remove (string item, bool cleanup) {
        var loop = new MainLoop ();

        if (!cleanup) {
            string folder_path = Path.build_filename (GLib.Environment.get_user_data_dir (), "devhelp", "books", item);
            File folder = File.new_for_path (folder_path);

            folder.trash_async.begin (0, null, (obj, res) => {
                try {
                    folder.trash_async.end (res);
                } catch (Error e) {
                    warning (e.message);
                }
                loop.quit ();
            });
            loop.run ();
        } else {
            string file_path = Path.build_filename (GLib.Environment.get_user_data_dir (), "devhelp", "books", item + ".tar.bz2");
            File file = File.new_for_path (file_path);

            file.delete_async.begin (0, null, (obj, res) => {
                try {
                    file.delete_async.end (res);
                } catch (Error e) {
                    warning (e.message);
                }
                loop.quit ();
            });
            loop.run ();
        }
    }

    public void toggled (Gtk.Button button, string name, GLib.Settings user_settings) {
        string [] installed = user_settings.get_strv ("packages");

        if (name in installed) {
            remove (name, false);
            button.image = new Gtk.Image.from_icon_name ("folder-download-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            button.get_style_context ().remove_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);

            for (int i =0; i < installed.length; i++) {
                if (installed[i] == name) {
                    installed[i] = null;
                }
            }
            user_settings.set_strv ("packages", installed);
        } else {
            download (name);
            decompress (name);
            remove (name, true);

            button.image = new Gtk.Image.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);

            installed += name;
            user_settings.set_strv ("packages", installed);
        }
    }

    public class Package : Gtk.ListBoxRow {
        public Package (string name, Gtk.SizeGroup group) {
            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL,10);
            box.border_width = 10;
            var button = new Gtk.Button ();

            var user_settings = new GLib.Settings ("com.github.mdh34.quickdocs");
            string[] installed = user_settings.get_strv("packages");

            if (name in installed) {
                button.image = new Gtk.Image.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
                button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
            } else {
                button.image = new Gtk.Image.from_icon_name ("folder-download-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            }

            button.clicked.connect (() => {
                toggled (button, name, user_settings);
            });

            var label = new Gtk.Label (name);
            label.xalign = 0;
            box.pack_start (label);
            box.pack_start (button);
            group.add_widget (label);
            this.add (box);
            show_all ();
        }
    }
}
