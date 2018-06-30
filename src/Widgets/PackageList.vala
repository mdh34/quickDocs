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

public class PackageList : Gtk.Popover {
    private string search_text;
    private Gtk.ListBox package_list;
    public PackageList () {
        var entry = new Gtk.SearchEntry ();
        entry.search_changed.connect (on_search);

        package_list = new Gtk.ListBox ();
        package_list.set_selection_mode(Gtk.SelectionMode.NONE);
        package_list.set_filter_func (filter_func);
        var group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        foreach (string item in PACKAGES) {
            package_list.add(new Package (item, group));
        }

        var scroller = new Gtk.ScrolledWindow (null, null);
        scroller.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroller.min_content_height = 512;
        scroller.add (package_list);

        var container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        container.pack_start (entry);
        container.pack_start (scroller);
        container.show_all ();
        add (container);
    }

    private bool filter_func (Gtk.ListBoxRow row) {
        if (search_text == null) {
            return true;
        }

        if (row is Package) {
            return ((Package) row).package_name.down ().contains (search_text);
        }

        return true;
    }

    private void on_search (Gtk.Entry searchentry) {
        search_text = searchentry.get_text ().down ();
        package_list.invalidate_filter ();
    }
}