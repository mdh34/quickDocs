namespace Downloader {
	public void download (string item) {
		string folder_path = Path.build_filename (Environment.get_home_dir (), ".local", "share", "com.github.mdh34.quickdocs");
		var folder = File.new_for_path (folder_path);
		
		if (!folder.query_exists ()) {
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
		public Package (string name) {
			var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL,20);
			box.border_width = 10;
			var download_button = new Gtk.Button.with_label ("Download");
			download_button.clicked.connect(() => {
				Downloader.download (name);
			});
			var remove_button = new Gtk.Button.with_label ("Delete");
			remove_button.clicked.connect(() => {
				Downloader.remove (name);
			});
			var label = new Gtk.Label (name);
			box.pack_start (label);
			box.pack_start (download_button);
			box.pack_start (remove_button);
			this.add (box);
			show_all ();
		}
	}
}
