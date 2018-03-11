/**
* This file is part of NRV-GTK.
*
* NRV-GTK is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* NRV-GTK is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with NRV-GTK.  If not, see <http://www.gnu.org/licenses/>.
*/

const string CSS = """

.example {
    border-left: 3px solid @SILVER_300;
    padding: 10px;
}

""";

public class Nrv.MainWindow : Gtk.ApplicationWindow {

    public Gtk.Stack stack { get; construct; }

    public Gtk.Label error_label { get; construct; }

    public Granite.Widgets.Toast toast { get; construct; }

	construct {
        title = "La Nova Reta Vortaro";
        icon_name = "xyz.gelez.nrv";
        window_position = Gtk.WindowPosition.CENTER;
        height_request = 600;
        width_request = 800;

        var green = Gdk.RGBA ();
        green.parse ("#9bdb4d");
        Granite.Widgets.Utils.set_color_primary (this, green);

        var provider = new Gtk.CssProvider ();
        provider.load_from_data (CSS, CSS.length);
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        set_titlebar (new HeaderBar (this));

        var overlay = new Gtk.Overlay ();
        stack = new Gtk.Stack ();
        overlay.add_overlay (stack);
        toast = new Granite.Widgets.Toast ("");
        overlay.add_overlay (toast);
        add (overlay);
        show_all ();

        error_label = new Gtk.Label ("");
        error_label.get_style_context ().add_class ("h3");

        var home_button = new Gtk.Button.with_label ("Iru hejme.");

        var error_page = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        error_page.pack_start (error_label, false, false);
        error_page.pack_start (home_button, false, false);

        var loading = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        loading.pack_start (new Gtk.Spinner () { active = true }, false, false);
        stack.add_named (loading, "load");
        stack.add_named (error_page, "error");
        stack.add_named (new Home (this), "home");
    }

    public void navigate (string name, Gtk.Widget? view = null) {
        if (stack.get_child_by_name (name) == null) {
            stack.add_named (view, name);
        }

        stack.visible_child_name = name;
    }

    public bool navigate_to_link (string url) {
        if (url.has_prefix ("/vorto/")) {
            load_word (url.replace ("/vorto/", ""));
            return true;
        }

        return false;
    }

    public void load_word (string query) {
        navigate ("load");
        Api.word.begin (query, (_, word_obj) => {
            try {
                var word = Api.word.end (word_obj);
                navigate ("word:" + query, new WordPage (word, this));
            } catch (ApiError err) {
                error (err.message);
            }
        });
    }

    public void error (string msg) {
        if (stack.visible_child_name == "load") {
            error_label.label = msg;
            stack.visible_child_name = "error";
        } else {
            toast.title = msg;
            toast.send_notification ();
        }
    }
}