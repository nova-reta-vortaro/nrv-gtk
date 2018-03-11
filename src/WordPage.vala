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

public class Nrv.WordPage : Gtk.ScrolledWindow {

    public MainWindow window { get; construct; }

    public Json.Object word { get; construct; }

    public WordPage (Json.Object word, MainWindow window) {
        Object (word: word, window: window);
    }

    construct {
        var grid = new Gtk.Grid ();
        grid.margin = 24;

        var title = new Gtk.Label (word.get_string_member ("word"));
        title.get_style_context ().add_class ("h1");
        title.halign = Gtk.Align.START;
        grid.attach (title, 0, 0, 1, 1);

        int line = 1;
        word.get_array_member ("meanings").foreach_element ((arr, i, meaning_node) => {
            var meaning = meaning_node.get_object ();

            var usage = markup_label ("<b>%s</b>".printf (meaning.get_string_member ("usage")));
            usage.halign = Gtk.Align.START;
            usage.margin_top = 24;
            grid.attach (usage, 0, line++, 1, 1);

            var def = markup_label (meaning.get_string_member ("definition"));
            def.justify = Gtk.Justification.FILL;
            def.activate_link.connect (window.navigate_to_link);
            def.margin_bottom = 6;
            grid.attach (def, 0, line++, 1, 1);

            meaning.get_array_member ("examples").foreach_element ((a, j, example) => {
                var ex_label = markup_label (example.get_string ());
                ex_label.justify = Gtk.Justification.FILL;
                ex_label.halign = Gtk.Align.START;
                ex_label.get_style_context ().add_class ("example");
                ex_label.margin_bottom = 6;
                grid.attach (ex_label, 0, line++, 1, 1);
            });
        });

        var translations = new Gtk.Label ("Tradukoj");
        translations.get_style_context ().add_class ("h2");
        translations.halign = Gtk.Align.START;
        translations.margin_top = 12;
        grid.attach (translations, 0, line++, 1, 1);

        word.get_object_member ("translations").foreach_member ((obj, key, val) => {
            string[] trans_list = {};
            val.get_array ().foreach_element ((a, i, elt) => {
                trans_list += elt.dup_string ();
            });
            var trans = markup_label ("<b>%s</b>: %s".printf (get_lang (key), string.joinv (", ", trans_list)));
            trans.halign = Gtk.Align.START;
            grid.attach (trans, 0, line++, 1, 1);
        });

        var related = new Gtk.Label ("Parencaj vortoj");
        related.get_style_context ().add_class ("h2");
        related.halign = Gtk.Align.START;
        related.margin_top = 12;
        grid.attach (related, 0, line++, 1, 1);

        var related_box = new Gtk.FlowBox ();
        word.get_array_member ("related").foreach_element ((arr, i, elt) => {
            var button = new Gtk.Button.with_label (elt.get_string ());
            button.get_style_context ().add_class ("flat");
            button.clicked.connect (() => {
                window.load_word (elt.get_string ());
            });
            related_box.add (button);
        });
        grid.attach (related_box, 0, line++, 1, 1);

        var sources = new Gtk.Label ("Fontoj");
        sources.get_style_context ().add_class ("h2");
        sources.halign = Gtk.Align.START;
        sources.margin_top = 12;
        grid.attach (sources, 0, line++, 1, 1);
        string[] source_list = {};
        word.get_array_member ("bibliography").foreach_element ((a, i, elt) => {
            source_list += elt.dup_string ();
        });
        var source_label = new Gtk.Label (string.joinv (", ", source_list));
        source_label.halign = Gtk.Align.START;
        grid.attach (source_label, 0, line++, 1, 1);

        add (grid);
        show_all ();
    }

    private Gtk.Label markup_label (string content) {
        var label = new Gtk.Label ("");
        label.use_markup = true;
        label.set_markup (content.replace ("<p>", "").replace ("</p>\n", "").replace ("</p>", ""));
        label.wrap = true;
        return label;
    }

    private string get_lang (string lang) {
        switch (lang) {
            case "be":
                return "Belorusaj";
            case "ca":
                return "Katalunaj";
            case "cs":
                return "Ĉeĥaj";
            case "de":
                return "Germanaj";
            case "en":
                return "Anglaj";
            case "es":
                return "Hispanaj";
            case "fr":
                return "Francaj";
            case "hu":
                return "Hungaraj";
            case "nl":
                return "Nederlandaj";
            case "pl":
                return "Polaj";
            case "pt":
                return "Portugalaj";
            case "ru":
                return "Rusaj";
            case "sk":
                return "Slovakaj";
            case "tp":
                return "Tokiponaj";
            default:
                return lang;
        }
    }
}