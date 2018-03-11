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

public class Nrv.HeaderBar : Gtk.HeaderBar {
    public MainWindow window { get; construct; }

    public HeaderBar (MainWindow window) {
        Object (window: window);
    }

    construct {
        title = window.title;
        show_close_button = true;

        var home_button = new Gtk.Button ();
        home_button.has_tooltip = true;
        home_button.image = new Gtk.Image.from_icon_name ("go-home", Gtk.IconSize.SMALL_TOOLBAR);
        home_button.tooltip_text = ("Iru hejme");
        home_button.clicked.connect (() => {
            window.navigate ("home");
        });
        pack_start (home_button);
    }
}