namespace Downloader {
	public void download (string item) {
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
		target.copy_async.begin (destination, 0, Priority.DEFAULT, null, null);
    }

	public void remove (string item) {
		string path = Path.build_filename (Environment.get_home_dir (), ".local", "share", "com.github.mdh34.quickdocs", item + ".tar.bz2");
		File folder = File.new_for_path (path);
		folder.delete_async.begin (0, null);
	}

	public class Package : Gtk.ListBoxRow {
		public Package (string name, Gtk.SizeGroup group) {
			var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL,10);
			box.border_width = 10;
			var download_button = new Gtk.Button.from_icon_name ("browser-download-symbolic");
			download_button.clicked.connect(() => {
				Downloader.download (name);
			});
			var remove_button = new Gtk.Button.from_icon_name ("edit-delete-symbolic");
			remove_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
			remove_button.clicked.connect(() => {
				Downloader.remove (name);
			});
			var label = new Gtk.Label (name);
			label.xalign = 0;
			box.pack_start (label);
			box.pack_start (download_button);
			box.pack_start (remove_button);
			group.add_widget (label);
			this.add (box);
			show_all ();
		}
	}
}
