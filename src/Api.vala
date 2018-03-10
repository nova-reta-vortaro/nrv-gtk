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

namespace Nrv.Api {
    const string API_URL = "http://nrv.gelez.xyz/api";

    private static Soup.Session session;

    private static void init () {
        session = new Soup.Session ();
    }

    private static async Soup.Message request (string method, string url) {
        var full_url = API_URL + url;
        print ("%s: %s\n", method, full_url);
        var msg = new Soup.Message (method, full_url);

        Soup.Message res = new Soup.Message (method, url);
        session.queue_message (msg, (sess, mess) => {
            res = mess;
            GLib.Idle.add (request.callback);
        });
        yield;
        return res;
    }

    private static Json.Object to_json (Soup.Message msg) {
        var parser = new Json.Parser ();
        try {
            parser.load_from_data ((string) msg.response_body.data);
            var node = parser.get_root ();
            return node.get_object ();
        } catch (Error e) {
            error ("Unable to parse the string: %s\n", e.message);
        }
    }

    public static async Gee.ArrayList<string> search (string query) {
        var json = to_json (yield request ("GET", "/sercxu?demando=%s".printf (query)));
        var res = new Gee.ArrayList<string> ();
        json.get_array_member ("results").foreach_element ((arr, i, elt) => {
            res.add (elt.dup_string ());
        });
        return res;
    }
}