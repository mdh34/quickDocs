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
 * Authored by: Matt Harris <mdh34@users.noreply.github.com>
 */
using Gtk;
using WebKit;
int main(string[] args) {
        Gtk.init (ref args);
        var x = 1000;
        var y = 700;
        var window = new Gtk.Window ();
        var header = new HeaderBar();
        header.set_show_close_button(true);
        window.set_titlebar(header);
        window.set_border_width (12);
        window.set_position (WindowPosition.CENTER);
        window.set_default_size (x, y);
        window.destroy.connect (Gtk.main_quit);
        var stack = new Stack();
        stack.set_transition_type(StackTransitionType.SLIDE_LEFT_RIGHT);

        var stackSwitcher = new StackSwitcher();
        stackSwitcher.set_stack(stack);
        header.set_custom_title(stackSwitcher);

        var vala = new WebView();
        vala.load_uri("https://valadoc.org/");;
        stack.add_titled(vala, "vala", "Valadoc");


        var dev = new WebView();
        dev.load_uri("http://devdocs.io/");
        stack.add_titled(dev, "dev", "DevDocs");

        var git = new WebView();
        git.load_uri("https://github.com/");
        stack.add_titled(git, "git", "GitHub");

        window.add(stack);
        window.show_all ();
        Gtk.main();
        return 0;
}
