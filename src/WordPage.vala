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

public class Nrv.WordPage : Gtk.Grid {
    public Json.Object word { get; construct; }

    public WordPage (Json.Object word) {
        Object (word: word);
    }

    construct {
        attach (new Gtk.Label (word.get_string_member ("word")), 0, 0, 1, 1);

        show_all ();
    }
}