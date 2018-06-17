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

public class PackageList : Gtk.ScrolledWindow {
    public PackageList () {
        hscrollbar_policy = Gtk.PolicyType.NEVER;
        min_content_height = 512;

        var package_list = new Gtk.ListBox ();
        package_list.set_selection_mode(Gtk.SelectionMode.NONE);
        var group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        foreach (string item in PACKAGES) {
            package_list.add(new Package (item, group));
        }
        add (package_list);

        show_all ();
    }
}