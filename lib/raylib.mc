// raylib — main module. Imports the shims, the composed raylib
// library, and the GL bindings. See README.md for the build flow.

@gui    // no console window alongside the app

import cstdlib_shim;
import cfile_shim;
import cvararg_shim;
import gl_core33;
import raylib_lib;
import raylib_constants;
import glad_compat;
import glfw3;
