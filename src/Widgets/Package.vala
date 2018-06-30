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

public class Package : Gtk.ListBoxRow {
    public string package_name;
    public Package (string name, Gtk.SizeGroup group) {
        package_name = name;

        var button = new Gtk.Button ();

        string[] installed = Docs.settings.get_strv ("packages");

        if (name in installed) {
            button.image = new Gtk.Image.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
        } else {
            button.image = new Gtk.Image.from_icon_name ("folder-download-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        }

        button.clicked.connect (() => {
            Downloader.toggled (button, name);
        });

        var label = new Gtk.Label (name);
        label.xalign = 0;

        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL,10);
        box.border_width = 10;
        box.pack_start (label);
        box.pack_start (button);

        group.add_widget (label);
        this.add (box);
        show_all ();
    }
}
