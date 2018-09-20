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
        var constants = new Constants ();
        var installed = Docs.settings.get_strv ("packages");
        var installed_list = new Gee.ArrayList<string> ();
        installed_list.add_all_array (installed);
        installed_list.sort ();

        var install_all = new Gtk.Button.with_label (_("Install all"));
        install_all.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        install_all.no_show_all = compare_lists (constants.package_list, installed_list);
        install_all.clicked.connect (() => {
            foreach (string package in constants.package_list) {
                if (!installed_list.contains (package)) {
                    Downloader.download (package);
                    Downloader.decompress (package);
                    Downloader.remove (package, true);
                    installed += package;
                }
            }

            Docs.settings.set_strv ("packages", installed);
            install_all.sensitive = false;
        });

        var entry = new Gtk.SearchEntry ();
        entry.search_changed.connect (on_search);

        package_list = new Gtk.ListBox ();
        package_list.set_selection_mode (Gtk.SelectionMode.NONE);
        package_list.set_filter_func (filter_func);
        var group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        foreach (string item in constants.package_list) {
            package_list.add (new Package (item, group));
        }

        var scroller = new Gtk.ScrolledWindow (null, null);
        scroller.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroller.min_content_height = 512;
        scroller.add (package_list);

        var container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        container.pack_start (entry);
        container.pack_start (install_all);
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

// Vala compares array pointers rather than content so we have to iterate through
private bool compare_lists (Gee.ArrayList<string> a, Gee.ArrayList<string> b ) {
    a.sort ();
    b.sort ();
    var array_one = a.to_array ();
    var array_two = b.to_array ();
    if (array_one.length != array_two.length) return false;
    for (int i=0; i< array_one.length; i++) {
        if (array_one[i] != array_two[i]) {
            return false;
        }
    }
    return true;
}
