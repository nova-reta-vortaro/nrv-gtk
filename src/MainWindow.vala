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

public class Nrv.MainWindow : Gtk.ApplicationWindow {

    public Gtk.SearchEntry search { get; construct; }

    public Gtk.Box results { get; construct; }

    public Gtk.Spinner spinner { get; construct; }

	construct {
        title = "La Nova Reta Vortaro";
        window_position = Gtk.WindowPosition.CENTER;
        height_request = 600;
        width_request = 800;

        var title_label = new Gtk.Label (title);
        title_label.get_style_context ().add_class ("h1");

        search = new Gtk.SearchEntry ();
        search.search_changed.connect (trigger_search);

        spinner = new Gtk.Spinner ();
        spinner.active = true;
        spinner.height_request = 24;
        spinner.width_request = 24;

        results = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        results.get_style_context ().add_class ("card");

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 24);
        box.margin = 112;
        box.pack_start (title_label, false);
        box.pack_start (search, false);
        box.pack_start (spinner, false);
        box.pack_start (results);

        var scroll = new Gtk.ScrolledWindow (null, null);
        scroll.add (box);
        add (scroll);

        show_all ();
        spinner.hide ();
        results.hide ();
    }

    private void trigger_search () {
        if (search.text == "") {
            results.foreach((ch) => {
                results.remove (ch);
            });
            results.hide ();
            spinner.hide ();
        } else {
            spinner.show ();
            Api.search.begin (search.text, (res, obj) => {
                var api_results = Api.search.end (obj);
                spinner.hide ();

                bool first = true;
                foreach (var result in api_results) {
                    if (!first) {
                        results.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, false);
                    } else {
                        first = false;
                    }

                    results.pack_start (new Gtk.Label (result), false, false, 6);
                    results.show_all ();
                }
            });
        }
    }
}