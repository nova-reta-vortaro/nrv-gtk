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

public class Nrv.App : Gtk.Application {

    public App () {
        Object(
            application_id: "xyz.gelez.nrv",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var win = new MainWindow ();
        win.destroy.connect (Gtk.main_quit);
    }

    public static void main (string[] args) {
        Gtk.init (ref args);
        Api.init ();
        App app = new App ();
        app.run (args);
        Gtk.main ();
    }
}