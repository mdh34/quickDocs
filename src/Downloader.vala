namespace Downloader {

	public void decompress (string item) {
		
		
	}
	
public void download (string item) {
		var loop = new MainLoop ();
		string folder_path = Path.build_filename (Environment.get_home_dir (), ".local", "share", "com.github.mdh34.quickdocs");
		
		
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
		string dest_path = Path.build_filename (Environment.get_home_dir (), ".local", "share", "com.github.mdh34.quickdocs", item + ".tar.bz2");

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

	
	public void remove (string item) {
		var loop = new MainLoop ();

		string folder_path = Path.build_filename (Environment.get_home_dir (), ".local", "share", "com.github.mdh34.quickdocs", item);
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

		string file_path = Path.build_filename (Environment.get_home_dir (), ".local", "share", "com.github.mdh34.quickdocs", item + ".tar.bz2");
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
	
	public void toggled (Gtk.Button button, string name, GLib.Settings user_settings) {
		string [] installed = user_settings.get_strv ("packages");
		if (name in installed) {
			remove (name);
			button.image = new Gtk.Image.from_icon_name ("browser-download-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
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
				button.image = new Gtk.Image.from_icon_name ("browser-download-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
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
