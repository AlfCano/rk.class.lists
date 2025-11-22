# Golden Rules of RKWard Plugin Development (Revised & Extended)
# Plugin: rk.class.lists (Data Structure, Vectors, and List Manipulation)
# STATUS: FIXED (Removed single quotes in JS comment that caused R parse error)

local({
  # =========================================================================================
  # 1. Prerequisites & Package Metadata
  # =========================================================================================
  require(rkwarddev)
  rkwarddev.required("0.10-3")

  package_about <- rk.XML.about(
    name = "rk.class.lists",
    author = person(
      given = "Alfonso",
      family = "Cano",
      email = "alfonso.cano@correo.buap.mx",
      role = c("aut", "cre")
    ),
    about = list(
      desc = "A plugin package to coerce data structure, vectors and manipulating lists in the Rkward GUI.",
      version = "0.0.1",
      url = "https://github.com/AlfCano/rk.class.lists",
      license = "GPL (>= 3)"
    )
  )

  # =========================================================================================
  # 2. Reusable UI Elements
  # =========================================================================================

  var_select <- rk.XML.varselector(id.name = "vars")

  # =========================================================================================
  # Component 1: Coerce Data Structure
  # =========================================================================================

  cs_target <- rk.XML.varslot("Select Object", source = var_select, required = TRUE, id.name = "cs_obj")

  cs_type <- rk.XML.radio("Target Structure", options = list(
    "Vector (as.vector)" = list(val = "vector"),
    "Matrix (as.matrix)" = list(val = "matrix"),
    "Data Frame (as.data.frame)" = list(val = "data.frame", chk = TRUE),
    "List (as.list)" = list(val = "list")
  ), id.name = "cs_type")

  # RULE 3: Hard-coded result name matches this initial value
  cs_save <- rk.XML.saveobj("Save result as", chk = TRUE, initial = "struct_obj", id.name = "cs_save")

  cs_dialog <- rk.XML.dialog(
    label = "Coerce Data Structure",
    child = rk.XML.row(
      var_select,
      rk.XML.col(
        cs_target,
        rk.XML.frame(cs_type, label = "Conversion Method"),
        cs_save
      )
    )
  )

  js_calc_cs <- '
    var obj = getValue("cs_obj");
    var type = getValue("cs_type");

    var code = "input_obj <- " + obj + "\\n";

    if(type == "vector") {
        code += "struct_obj <- as.vector(input_obj)\\n";
    } else if (type == "matrix") {
        code += "struct_obj <- as.matrix(input_obj)\\n";
    } else if (type == "data.frame") {
        code += "struct_obj <- as.data.frame(input_obj)\\n";
    } else {
        code += "struct_obj <- as.list(input_obj)\\n";
    }
    echo(code);
  '

  js_print_cs <- 'echo("rk.header(\\"Structure Coercion completed.\\")\\n");'

  help_cs <- rk.rkh.doc(
    title = rk.rkh.title("Coerce Data Structure"),
    summary = rk.rkh.summary("Converts R objects between basic data structures: vector, matrix, data.frame, and list."),
    usage = rk.rkh.usage("Select an object and choose the desired target structure."),
    settings = rk.rkh.settings(
      rk.rkh.setting(id = "cs_type", text = "The target R class/structure.")
    )
  )

  comp_cs <- rk.plugin.component("Coerce Data Structure", xml = list(dialog = cs_dialog), js = list(calculate = js_calc_cs, printout = js_print_cs), rkh = list(help = help_cs), hierarchy = list("data", "Class and Structure"))

  # =========================================================================================
  # Component 2: Coerce Vector Type
  # =========================================================================================

  cv_target <- rk.XML.varslot("Select Vector/Variable", source = var_select, required = TRUE, id.name = "cv_obj")

  cv_type <- rk.XML.dropdown("Target Data Type", options = list(
    "Integer (as.integer)" = list(val = "integer"),
    "Numeric (as.numeric)" = list(val = "numeric"),
    "Character (as.character)" = list(val = "character"),
    "Factor (as.factor)" = list(val = "factor", chk = TRUE),
    "Logical (as.logical)" = list(val = "logical"),
    "NULL (as.null - creates empty)" = list(val = "null")
  ), id.name = "cv_type")

  # RULE 3: Hard-coded result name matches this initial value
  cv_save <- rk.XML.saveobj("Save result as", chk = TRUE, initial = "vec_obj", id.name = "cv_save")

  cv_dialog <- rk.XML.dialog(
    label = "Coerce Vector Type",
    child = rk.XML.row(
      var_select,
      rk.XML.col(
        cv_target,
        rk.XML.frame(cv_type, label = "Conversion Method"),
        cv_save
      )
    )
  )

  js_calc_cv <- '
    var obj = getValue("cv_obj");
    var type = getValue("cv_type");

    var code = "input_vec <- " + obj + "\\n";

    if(type == "integer") {
        code += "vec_obj <- as.integer(input_vec)\\n";
    } else if (type == "numeric") {
        code += "vec_obj <- as.numeric(input_vec)\\n";
    } else if (type == "character") {
        code += "vec_obj <- as.character(input_vec)\\n";
    } else if (type == "factor") {
        code += "vec_obj <- as.factor(input_vec)\\n";
    } else if (type == "logical") {
        code += "vec_obj <- as.logical(input_vec)\\n";
    } else {
        code += "vec_obj <- as.null(input_vec)\\n";
    }
    echo(code);
  '

  js_print_cv <- 'echo("rk.header(\\"Vector Type Coercion completed.\\")\\n");'

  help_cv <- rk.rkh.doc(
    title = rk.rkh.title("Coerce Vector Type"),
    summary = rk.rkh.summary("Converts an object or vector to a specific atomic type (integer, numeric, factor, etc.)."),
    usage = rk.rkh.usage("Select a variable and the target type."),
    settings = rk.rkh.settings(
      rk.rkh.setting(id = "cv_type", text = "The target atomic mode.")
    )
  )

  comp_cv <- rk.plugin.component("Coerce Vector Type", xml = list(dialog = cv_dialog), js = list(calculate = js_calc_cv, printout = js_print_cv), rkh = list(help = help_cv), hierarchy = list("data", "Class and Structure"))

  # =========================================================================================
  # Component 3: Batch Coercion (Range/Catalog)
  # =========================================================================================

  bc_target_df <- rk.XML.varslot("Target Data Frame", source = var_select, required = TRUE, classes = "data.frame", id.name = "bc_df")
  bc_cols <- rk.XML.varslot("Vector containing Column Names", source = var_select, required = TRUE, id.name = "bc_names")

  bc_type <- rk.XML.dropdown("Convert Columns To", options = list(
    "Factor" = list(val = "factor", chk = TRUE),
    "Character" = list(val = "character"),
    "Numeric" = list(val = "numeric"),
    "Integer" = list(val = "integer"),
    "Logical" = list(val = "logical")
  ), id.name = "bc_type")

  # RULE 3: Hard-coded result name matches this initial value
  bc_save <- rk.XML.saveobj("Save Data Frame as", chk = TRUE, initial = "batch_df", id.name = "bc_save")

  bc_dialog <- rk.XML.dialog(
    label = "Batch Column Coercion",
    child = rk.XML.row(
      var_select,
      rk.XML.col(
        rk.XML.frame(bc_target_df, label="Data to Modify"),
        rk.XML.frame(bc_cols, label="List/Vector of Column Names"),
        rk.XML.frame(bc_type, label="Target Type"),
        bc_save
      )
    )
  )

  js_calc_bc <- '
    var df = getValue("bc_df");
    var names_vec = getValue("bc_names");
    var type = getValue("bc_type");

    var code = "target_df <- " + df + "\\n";
    code += "col_names <- " + names_vec + "\\n";

    code += "for (i in col_names) {\\n";
    code += "  if (i %in% names(target_df)) {\\n";
    if(type == "factor") {
        code += "    target_df[[i]] <- as.factor(target_df[[i]])\\n";
    } else if (type == "character") {
        code += "    target_df[[i]] <- as.character(target_df[[i]])\\n";
    } else if (type == "numeric") {
        code += "    target_df[[i]] <- as.numeric(target_df[[i]])\\n";
    } else if (type == "integer") {
        code += "    target_df[[i]] <- as.integer(target_df[[i]])\\n";
    } else {
        code += "    target_df[[i]] <- as.logical(target_df[[i]])\\n";
    }
    code += "  }\\n";
    code += "}\\n";

    code += "batch_df <- target_df\\n";
    echo(code);
  '

  js_print_bc <- 'echo("rk.header(\\"Batch Column Coercion completed.\\")\\n");'

  help_bc <- rk.rkh.doc(
    title = rk.rkh.title("Batch Column Coercion"),
    summary = rk.rkh.summary("Converts a specific set of columns within a data frame to a single type, based on a vector of names."),
    usage = rk.rkh.usage("Select the target dataframe and a vector containing the names of the columns to modify."),
    settings = rk.rkh.settings(
      rk.rkh.setting(id = "bc_df", text = "The dataframe containing the data."),
      rk.rkh.setting(id = "bc_names", text = "A character vector with the names of the columns to convert."),
      rk.rkh.setting(id = "bc_type", text = "The target type for the selected columns.")
    )
  )

  comp_bc <- rk.plugin.component("Batch Column Coercion", xml = list(dialog = bc_dialog), js = list(calculate = js_calc_bc, printout = js_print_bc), rkh = list(help = help_bc), hierarchy = list("data", "Class and Structure"))

  # =========================================================================================
  # Component 4: Create / Append List
  # =========================================================================================

  cl_create_mode <- rk.XML.radio("Mode", options = list(
      "Create New List" = list(val = "new", chk = TRUE),
      "Append to Existing List" = list(val = "append")
  ), id.name = "cl_create_mode")

  cl_exist_list <- rk.XML.varslot("Existing List (for Append)", source = var_select, required = FALSE, classes = "list", id.name = "cl_exist_list")

  cl_add_objs <- rk.XML.varslot("Objects to Add/Combine", source = var_select, multi = TRUE, required = TRUE, id.name = "cl_add_objs")

  cl_rm_orig <- rk.XML.cbox("Remove original objects from Workspace after assignment", value = "1", id.name = "cl_rm_orig")

  cl_save_list <- rk.XML.saveobj("Save List as", chk = TRUE, initial = "my_list", id.name = "cl_save_list")

  cl_dialog <- rk.XML.dialog(
    label = "Create or Append List",
    child = rk.XML.row(
      var_select,
      rk.XML.col(
         cl_create_mode,
         cl_exist_list,
         cl_add_objs,
         cl_rm_orig,
         cl_save_list
      )
    )
  )

  js_calc_cl <- '
    var mode = getValue("cl_create_mode");
    var rm_orig = getValue("cl_rm_orig");
    var obj_array = getValue("cl_add_objs").split("\\n");
    var code = "";

    // 1. Initialize list
    if(mode == "append") {
        var ex = getValue("cl_exist_list");
        if(ex == "") ex = "list()";
        code += "my_list <- " + ex + "\\n";
    } else {
        code += "my_list <- list()\\n";
    }

    // 2. Iterate and assign named elements
    var valid_objs = new Array();
    for (var i = 0; i < obj_array.length; i++) {
        var obj = obj_array[i];
        if(obj != "") {
            code += "my_list[[\\"" + obj + "\\"]] <- " + obj + "\\n";
            if(obj.indexOf("$") === -1 && obj.indexOf("[") === -1) {
                valid_objs.push(obj);
            }
        }
    }

    // 3. Remove originals from .GlobalEnv if requested
    if(rm_orig == "1" && valid_objs.length > 0) {
       var rm_list = valid_objs.map(function(o){ return "\\"" + o + "\\""; }).join(", ");
       code += "rm(list = c(" + rm_list + "), envir = .GlobalEnv)\\n";
    }

    echo(code);
  '

  js_print_cl <- 'echo("rk.header(\\"List Creation/Append completed.\\")\\n");'

  help_cl <- rk.rkh.doc(
    title = rk.rkh.title("Create or Append List"),
    summary = rk.rkh.summary("Creates a new list from selected objects or appends objects to an existing list, using the object names as keys."),
    usage = rk.rkh.usage("Select the objects to combine. If appending, select the base list."),
    settings = rk.rkh.settings(
      rk.rkh.setting(id = "cl_create_mode", text = "Choose whether to start a fresh list or add to an existing one."),
      rk.rkh.setting(id = "cl_add_objs", text = "The R objects to include. They will be assigned to the list using their names as the index."),
      rk.rkh.setting(id = "cl_rm_orig", text = "If checked, top-level objects will be removed from the Global Environment after assignment.")
    )
  )

  comp_cl <- rk.plugin.component("Create or Append List", xml = list(dialog = cl_dialog), js = list(calculate = js_calc_cl, printout = js_print_cl), rkh = list(help = help_cl), hierarchy = list("data", "Class and Structure", "Manipulate Lists"))

  # =========================================================================================
  # Component 5: Extract List Elements (FIXED Logic)
  # =========================================================================================

  el_vars <- rk.XML.varslot("Select Elements to Extract", source = var_select, multi = TRUE, required = TRUE, id.name = "el_vars")

  el_save_elem <- rk.XML.saveobj("Save Extracted Object(s) as", chk = TRUE, initial = "extracted_obj", id.name = "el_save_elem")

  el_dialog <- rk.XML.dialog(
    label = "Extract List Elements",
    child = rk.XML.row(
      var_select,
      rk.XML.col(
         el_vars,
         el_save_elem
      )
    )
  )

  # Logic Update: Direct assignment for single elements to preserve Class
  # Fixed: Removed comment with single quotes that caused R parse error
  js_calc_el <- '
    var vars = getValue("el_vars").split("\\n").filter(function(e){return e});
    var code = "";

    if(vars.length == 1) {
        // Single element: Direct assignment to preserve object class
        code = "extracted_obj <- " + vars[0] + "\\n";
    } else {
        // Multiple elements: Create named list
        var list_items = new Array();
        for(var i=0; i<vars.length; i++) {
            var v = vars[i];
            var name = v;
            // Attempt to extract simple name from string
            var match = v.match(/\\[\\[\\"(.+?)\\"\\]\\]/);
            if(match) {
                name = match[1];
            } else {
                match = v.match(/\\$([a-zA-Z0-9_.]+)/);
                if(match) name = match[1];
            }
            list_items.push("\\"" + name + "\\" = " + v);
        }
        code = "extracted_obj <- list(" + list_items.join(", ") + ")\\n";
    }
    echo(code);
  '

  js_print_el <- 'echo("rk.header(\\"List Extraction completed.\\")\\n");'

  help_el <- rk.rkh.doc(
    title = rk.rkh.title("Extract List Elements"),
    summary = rk.rkh.summary("Extracts specific elements (vectors, sub-lists, etc.) from an existing list or dataframe."),
    usage = rk.rkh.usage("Select specific elements. If one is selected, the object class is preserved. If multiple are selected, they are returned as a named list."),
    settings = rk.rkh.settings(
      rk.rkh.setting(id = "el_vars", text = "The objects/elements to extract.")
    )
  )

  comp_el <- rk.plugin.component("Extract List Elements", xml = list(dialog = el_dialog), js = list(calculate = js_calc_el, printout = js_print_el), rkh = list(help = help_el), hierarchy = list("data", "Class and Structure", "Manipulate Lists"))

  # =========================================================================================
  # Main Skeleton Call
  # =========================================================================================

  rk.plugin.skeleton(
    about = package_about,
    path = ".",
    xml = list(dialog = cs_dialog), # Component 1 as default
    js = list(calculate = js_calc_cs, printout = js_print_cs),
    rkh = list(help = help_cs),
    components = list(comp_cv, comp_bc, comp_cl, comp_el),
    pluginmap = list(name = "Coerce Data Structure", hierarchy = list("data", "Class and Structure")),
    create = c("pmap", "xml", "js", "desc", "rkh"),
    load = TRUE,
    overwrite = TRUE,
    show = FALSE
  )

  cat("Plugin files generated successfully in '", normalizePath("."), "'. Run rk.updatePluginMessages('.') and devtools::install('.')", sep="")
})
