import Lake
open Lake DSL

package "homework" where
  version := v!"0.1.0"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "master"

lean_lib «Homework» where
  -- add library configuration options here

@[default_target]
lean_exe "homework4" where
  root := `homework4
lean_exe "wff" where
  root := `wff
