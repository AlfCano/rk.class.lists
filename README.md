# rk.class.lists: Data Structure & List Manipulation for RKWard

![Version](https://img.shields.io/badge/Version-0.0.1-blue.svg)
![License](https://img.shields.io/badge/License-GPL--3-green.svg)
![R Version](https://img.shields.io/badge/R-%3E%3D%203.0.0-lightgrey.svg)

This package provides a suite of RKWard plugins designed to simplify the manipulation of R object classes and data structures. It offers a graphical interface for coercing objects (e.g., converting a matrix to a data frame), changing vector types (e.g., numeric to factor), and performing complex list operations (creating, appending, and extracting elements).

It is designed to bridge the gap between R's powerful but syntax-heavy coercion functions and the RKWard GUI.

## Features / Included Plugins

This package installs a new submenu in RKWard: **Data > Class and Structure**.

### Structure & Type Conversion
*   **Coerce Data Structure:** Transform entire objects between standard R structures.
    *   Supports conversion to `Vector`, `Matrix`, `Data Frame`, and `List`.
    *   Wraps base R functions like `as.data.frame()`, `as.matrix()`, etc.

*   **Coerce Vector Type:** Convert variables or vectors to specific atomic modes.
    *   Supports `Integer`, `Numeric`, `Character`, `Factor`, `Logical`, and `NULL`.

*   **Batch Column Coercion:** Efficiently convert multiple columns within a data frame to a specific type.
    *   Target specific columns using a character vector of names.
    *   Ideal for bulk processing imported data (e.g., converting a list of "ID" columns to factors).

### Submenu: Manipulate Lists
*   **Create or Append List:** A flexible tool for assembling lists.
    *   **Create New:** Initialize a fresh list with selected objects.
    *   **Append:** Add objects to an existing list.
    *   **Named Assignment:** Objects are automatically assigned to the list using their variable names as keys.
    *   **Cleanup:** Includes an optional safety feature to **remove the original objects** from the Global Environment after they have been successfully assigned to the list.

*   **Extract List Elements:** A robust subsetting tool.
    *   Select specific elements (vectors, sub-lists) from a list or data frame directly via the object browser.
    *   **Smart Extraction:**
        *   If **one** element is selected, it is extracted directly, preserving its original class (e.g., extracting a single data frame returns a `data.frame`, not a `list`).
        *   If **multiple** elements are selected, they are returned as a new named `list`.

## Requirements

1.  A working installation of **RKWard**.
2.  The R package **`devtools`** is required for installation from source.
    ```R
    install.packages("devtools")
    ```

## Installation

To install the `rk.class.lists` plugin package directly from GitHub:

1.  Open R in RKWard.
2.  Run the following commands in the R console:

```R
local({
## Prepare
require(devtools)
## Install
  install_github(
    repo="AlfCano/rk.class.lists"
  )
## Print result
rk.header ("Installation from GitHub completed")
})

```

3.  Restart RKWard to update the menu structure.

## Usage

Once installed, all plugins can be found under the **Data > Class and Structure** menu in RKWard.

### Example: Organizing Workspace into a List

1.  Assume you have three separate data frames in your workspace: `survey_2020`, `survey_2021`, and `survey_2022`.
2.  Navigate to **Data > Class and Structure > Manipulate Lists > Create or Append List**.
3.  **Mode:** Select "Create New List".
4.  **Objects to Add:** Select `survey_2020`, `survey_2021`, and `survey_2022`.
5.  **Options:** Check "Remove original objects from Workspace after assignment" to clean up your environment.
6.  **Save List as:** Enter `all_surveys`.
7.  Click **Submit**.

Result: You now have a single list `all_surveys` containing the three data frames, and the individual objects have been removed from the Global Environment.

## Author

Alfonso Cano (alfonso.cano@correo.buap.mx)

Assisted by Gemini, a large language model from Google.
