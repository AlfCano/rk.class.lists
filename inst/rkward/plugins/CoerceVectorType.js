// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here

}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var obj = getValue("cv_obj");
    var type = getValue("cv_type");

    var code = "input_vec <- " + obj + "\n";

    if(type == "integer") {
        code += "vec_obj <- as.integer(input_vec)\n";
    } else if (type == "numeric") {
        code += "vec_obj <- as.numeric(input_vec)\n";
    } else if (type == "character") {
        code += "vec_obj <- as.character(input_vec)\n";
    } else if (type == "factor") {
        code += "vec_obj <- as.factor(input_vec)\n";
    } else if (type == "logical") {
        code += "vec_obj <- as.logical(input_vec)\n";
    } else {
        code += "vec_obj <- as.null(input_vec)\n";
    }
    echo(code);
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Coerce Vector Type results")).print();
echo("rk.header(\"Vector Type Coercion completed.\")\n");
	//// save result object
	// read in saveobject variables
	var cvSave = getValue("cv_save");
	var cvSaveActive = getValue("cv_save.active");
	var cvSaveParent = getValue("cv_save.parent");
	// assign object to chosen environment
	if(cvSaveActive) {
		echo(".GlobalEnv$" + cvSave + " <- vec_obj\n");
	}

}

