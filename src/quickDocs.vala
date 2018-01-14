using Gtk;
using WebKit;

public class App : Gtk.Application {

    public App () {
        Object (
            application_id: "com.github.mdh34.quickdocs",
            flags: ApplicationFlags.FLAGS_NONE
            );
    }


    protected override void activate () {
        var window = new ApplicationWindow (this);
        window.set_default_size (1000, 700);
        window.set_border_width (12);
        window.set_position (WindowPosition.CENTER);
        var header = new HeaderBar ();
        header.set_show_close_button (true);
        window.set_titlebar (header);

        var stack = new Stack ();
        stack.set_transition_type (StackTransitionType.SLIDE_LEFT_RIGHT);

        window.destroy.connect (() => {
            var user_settings = new GLib.Settings ("com.github.mdh34.quickdocs");
            user_settings.set_string ("tab", stack.get_visible_child_name());
            Gtk.main_quit ();
        });

        var stack_switcher = new StackSwitcher ();
        stack_switcher.set_stack (stack);
        header.set_custom_title (stack_switcher);

        var context = new WebContext ();
        var cookies = context.get_cookie_manager ();
        //set_cookies (cookies);

        var vala = new WebView(); //todo put this in a class
        vala.load_uri ("https://valadoc.org");

        var dev = new WebView.with_context (context);
        //set_appcache(dev);
        dev.load_uri ("https://devdocs.io");

        stack.add_titled (dev, "dev", "DevDocs");
        stack.add_titled (vala, "vala", "Valadoc");

        var back = new Button.from_icon_name ("go-previous-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        back.clicked.connect (() => {
            if (stack.get_visible_child_name () == "vala"){
                vala.go_back ();
            } else if (stack.get_visible_child_name () == "dev") {
                dev.go_back ();
            }
        });

        var forward = new Button.from_icon_name ("go-next-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        forward.clicked.connect (() => {
            if (stack.get_visible_child_name () == "vala"){
                vala.go_forward ();
            } else if (stack.get_visible_child_name () == "dev") {
                dev.go_forward ();
            }
        });

        var theme_button = new Button.from_icon_name ("weather-few-clouds-symbolic");
        theme_button.clicked.connect(() => {
            //toggle_theme (dev);
        });

        header.add (back);
        header.add (forward);
        header.pack_end(theme_button);

        window.add (stack);
        //init_theme ();
        //set_tab (stack);
        window.show_all();
    }

    public static int main (string[] args) {
        var app = new App();
        return app.run (args);
    }
}
