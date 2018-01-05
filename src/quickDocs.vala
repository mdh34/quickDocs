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


        var context = new WebContext();
        var cookies = context.get_cookie_manager();
        cookies.set_accept_policy(CookieAcceptPolicy.ALWAYS);


        var path = (Environment.get_home_dir() + "/.config/com.github.mdh34.quickDocs/cookies");
        var folder = (Environment.get_home_dir() + "/.config/com.github.mdh34.quickDocs/");
        var file = File.new_for_path(folder);
        if(!file.query_exists()){
          try{
            file.make_directory();
          } catch(Error e){
            print("Unable to create config directory");
          }
        }

        cookies.set_persistent_storage(path, CookiePersistentStorage.SQLITE);

        var dev = new WebView.with_context(context);
        dev.load_uri("http://devdocs.io/");
        stack.add_titled(dev, "dev", "DevDocs");

        var back = new Button.from_icon_name("go-previous-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        back.clicked.connect (() => {
          if (stack.get_visible_child_name() == "vala"){
            vala.go_back();
          } else {
            dev.go_back();
          }
          });
        header.add(back);

        var forward = new Button.from_icon_name("go-next-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        forward.clicked.connect (() => {
          if (stack.get_visible_child_name() == "vala"){
            vala.go_forward();
          } else if (stack.get_visible_child_name() == "dev") {
            dev.go_forward();
          }
          });
        header.add(forward);

        window.add(stack);
        window.show_all ();
        Gtk.main();
        return 0;
}
