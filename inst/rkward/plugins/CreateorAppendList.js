// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here

}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var mode = getValue("cl_create_mode");
    var rm_orig = getValue("cl_rm_orig");
    var obj_array = getValue("cl_add_objs").split("\n");
    var code = "";

    // 1. Initialize list
    if(mode == "append") {
        var ex = getValue("cl_exist_list");
        if(ex == "") ex = "list()";
        code += "my_list <- " + ex + "\n";
    } else {
        code += "my_list <- list()\n";
    }

    // 2. Iterate and assign named elements
    var valid_objs = new Array();
    for (var i = 0; i < obj_array.length; i++) {
        var obj = obj_array[i];
        if(obj != "") {
            code += "my_list[[\"" + obj + "\"]] <- " + obj + "\n";
            if(obj.indexOf("$") === -1 && obj.indexOf("[") === -1) {
                valid_objs.push(obj);
            }
        }
    }

    // 3. Remove originals from .GlobalEnv if requested
    if(rm_orig == "1" && valid_objs.length > 0) {
       var rm_list = valid_objs.map(function(o){ return "\"" + o + "\""; }).join(", ");
       code += "rm(list = c(" + rm_list + "), envir = .GlobalEnv)\n";
    }

    echo(code);
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Create or Append List results")).print();
echo("rk.header(\"List Creation/Append completed.\")\n");
	//// save result object
	// read in saveobject variables
	var clSaveList = getValue("cl_save_list");
	var clSaveListActive = getValue("cl_save_list.active");
	var clSaveListParent = getValue("cl_save_list.parent");
	// assign object to chosen environment
	if(clSaveListActive) {
		echo(".GlobalEnv$" + clSaveList + " <- my_list\n");
	}

}

