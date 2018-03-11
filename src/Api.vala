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

public errordomain ApiError {
    API_ERROR
}

namespace Nrv.Api {
    const string API_URL = "http://nrv.gelez.xyz/api";

    private static Soup.Session session;

    private static void init () {
        session = new Soup.Session ();
    }

    private static async Soup.Message request (string method, string url) {
        print ("%s: %s\n", method, url);
        var full_url = API_URL + url;
        var msg = new Soup.Message (method, full_url);

        Soup.Message res = new Soup.Message (method, url);
        session.queue_message (msg, (sess, mess) => {
            res = mess;
            GLib.Idle.add (request.callback);
        });
        yield;
        return res;
    }

    private static Json.Object to_json (Soup.Message msg) throws ApiError {
        var parser = new Json.Parser ();
        try {
            var payload = (string) msg.response_body.data;
            payload = payload.replace ("\"\":", "\"za\":"); // I don't know why but we have empty keys for chinese translations
            print (payload + "\n");
            parser.load_from_data (payload);
            var node = parser.get_root ();
            var obj = node.get_object ();
            if (obj.has_member ("error")) {
                throw new ApiError.API_ERROR (obj.get_string_member ("error"));
            }
            return obj;
        } catch (Error e) {
            throw new ApiError.API_ERROR (e.message);
        }
    }

    public static async Json.Object word (string word) throws ApiError {
        return to_json (yield request ("GET", "/vorto/" + word));
    }

    public static async Gee.ArrayList<string> search (string query) throws ApiError {
        var json = to_json (yield request ("GET", "/sercxu?demando=%s".printf (query)));
        var res = new Gee.ArrayList<string> ();
        json.get_array_member ("results").foreach_element ((arr, i, elt) => {
            res.add (elt.dup_string ());
        });
        return res;
    }
}