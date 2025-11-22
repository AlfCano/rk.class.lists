// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here

}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    // Logic checks active tab via saveobj activation
    
    // Part 1: Composition
    if(getValue("ml_save_list.active")) {
        var mode = getValue("ml_create_mode");
        var objs = getValue("ml_add_objs").split("\n").join(", ");
        
        var code = "";
        if(mode == "append") {
            code += "my_list <- " + getValue("ml_exist_list") + "\n";
            code += "new_items <- list(" + objs + ")\n";
            code += "my_list <- c(my_list, new_items)\n";
        } else {
            code += "my_list <- list(" + objs + ")\n";
        }
        echo(code);
    }

    // Part 2: Extraction
    if(getValue("ml_save_elem.active")) {
        var src = getValue("ml_src_list");
        var idx = getValue("ml_index");
        
        // Check if idx is numeric or string
        var idx_str = idx;
        // If it doesnt look like a number, wrap in quotes
        if(isNaN(idx)) {
            idx_str = "\"" + idx + "\"";
        }
        
        echo("extracted_elem <- " + src + "[[" + idx_str + "]]\n");
    }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Manipulate Lists results")).print();
echo("rk.header(\"List Manipulation completed.\")\n");
	//// save result object
	// read in saveobject variables
	var mlSaveList = getValue("ml_save_list");
	var mlSaveListActive = getValue("ml_save_list.active");
	var mlSaveListParent = getValue("ml_save_list.parent");	var mlSaveElem = getValue("ml_save_elem");
	var mlSaveElemActive = getValue("ml_save_elem.active");
	var mlSaveElemParent = getValue("ml_save_elem.parent");
	// assign object to chosen environment
	if(mlSaveListActive) {
		echo(".GlobalEnv$" + mlSaveList + " <- my_list\n");
	}
	if(mlSaveElemActive) {
		echo(".GlobalEnv$" + mlSaveElem + " <- extracted_elem\n");
	}

}

