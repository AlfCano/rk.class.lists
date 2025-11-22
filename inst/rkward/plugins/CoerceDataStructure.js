// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here

}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var obj = getValue("cs_obj");
    var type = getValue("cs_type");

    var code = "input_obj <- " + obj + "\n";

    if(type == "vector") {
        code += "struct_obj <- as.vector(input_obj)\n";
    } else if (type == "matrix") {
        code += "struct_obj <- as.matrix(input_obj)\n";
    } else if (type == "data.frame") {
        code += "struct_obj <- as.data.frame(input_obj)\n";
    } else {
        code += "struct_obj <- as.list(input_obj)\n";
    }
    echo(code);
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Coerce Data Structure results")).print();
echo("rk.header(\"Structure Coercion completed.\")\n");
	//// save result object
	// read in saveobject variables
	var csSave = getValue("cs_save");
	var csSaveActive = getValue("cs_save.active");
	var csSaveParent = getValue("cs_save.parent");
	// assign object to chosen environment
	if(csSaveActive) {
		echo(".GlobalEnv$" + csSave + " <- struct_obj\n");
	}

}

