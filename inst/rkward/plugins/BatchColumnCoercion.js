// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here

}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var df = getValue("bc_df");
    var names_vec = getValue("bc_names");
    var type = getValue("bc_type");

    var code = "target_df <- " + df + "\n";
    code += "col_names <- " + names_vec + "\n";

    code += "for (i in col_names) {\n";
    code += "  if (i %in% names(target_df)) {\n";
    if(type == "factor") {
        code += "    target_df[[i]] <- as.factor(target_df[[i]])\n";
    } else if (type == "character") {
        code += "    target_df[[i]] <- as.character(target_df[[i]])\n";
    } else if (type == "numeric") {
        code += "    target_df[[i]] <- as.numeric(target_df[[i]])\n";
    } else if (type == "integer") {
        code += "    target_df[[i]] <- as.integer(target_df[[i]])\n";
    } else {
        code += "    target_df[[i]] <- as.logical(target_df[[i]])\n";
    }
    code += "  }\n";
    code += "}\n";

    code += "batch_df <- target_df\n";
    echo(code);
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Batch Column Coercion results")).print();
echo("rk.header(\"Batch Column Coercion completed.\")\n");
	//// save result object
	// read in saveobject variables
	var bcSave = getValue("bc_save");
	var bcSaveActive = getValue("bc_save.active");
	var bcSaveParent = getValue("bc_save.parent");
	// assign object to chosen environment
	if(bcSaveActive) {
		echo(".GlobalEnv$" + bcSave + " <- batch_df\n");
	}

}

