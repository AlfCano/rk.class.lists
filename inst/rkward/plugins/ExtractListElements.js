// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here

}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var vars = getValue("el_vars").split("\n").filter(function(e){return e});
    var code = "";

    if(vars.length == 1) {
        // Single element: Direct assignment to preserve object class
        code = "extracted_obj <- " + vars[0] + "\n";
    } else {
        // Multiple elements: Create named list
        var list_items = new Array();
        for(var i=0; i<vars.length; i++) {
            var v = vars[i];
            var name = v;
            // Attempt to extract simple name from string
            var match = v.match(/\[\[\"(.+?)\"\]\]/);
            if(match) {
                name = match[1];
            } else {
                match = v.match(/\$([a-zA-Z0-9_.]+)/);
                if(match) name = match[1];
            }
            list_items.push("\"" + name + "\" = " + v);
        }
        code = "extracted_obj <- list(" + list_items.join(", ") + ")\n";
    }
    echo(code);
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Extract List Elements results")).print();
echo("rk.header(\"List Extraction completed.\")\n");
	//// save result object
	// read in saveobject variables
	var elSaveElem = getValue("el_save_elem");
	var elSaveElemActive = getValue("el_save_elem.active");
	var elSaveElemParent = getValue("el_save_elem.parent");
	// assign object to chosen environment
	if(elSaveElemActive) {
		echo(".GlobalEnv$" + elSaveElem + " <- extracted_obj\n");
	}

}

