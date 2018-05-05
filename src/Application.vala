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

public class Docs : Gtk.Application {
    public Docs () {
        Object (application_id: "com.github.mdh34.quickdocs",
        flags: ApplicationFlags.FLAGS_NONE);
    }

    public override void activate () {
        var window = new MainWindow (this);

        var quit_action = new SimpleAction ("quit", null);
        add_action (quit_action);
        set_accels_for_action ("app.quit", {"<Control>q"});

        quit_action.activate.connect (() => {
            window.destroy ();
        });

        var tab_switch = new SimpleAction ("switch", null);
        add_action (tab_switch);
        set_accels_for_action ("app.switch", {"<Control>Tab"});

        tab_switch.activate.connect (() => {
            window.change_tab ();
        });
    }

    public static int main (string[] args) {
        var app = new Docs ();
        return app.run (args);
    }
}