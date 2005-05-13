(*********************************************************************************)
(*                OCamlODBC                                                         *)
(*                                                                               *)
(*    Copyright (C) 2004 Institut National de Recherche en Informatique et       *)
(*    en Automatique. All rights reserved.                                       *)
(*                                                                               *)
(*    This program is free software; you can redistribute it and/or modify       *)
(*    it under the terms of the GNU Lesser General Public License as published   *)
(*    by the Free Software Foundation; either version 2.1 of the License, or     *)
(*    any later version.                                                         *)
(*                                                                               *)
(*    This program is distributed in the hope that it will be useful,            *)
(*    but WITHOUT ANY WARRANTY; without even the implied warranty of             *)
(*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *)
(*    GNU Lesser General Public License for more details.                        *)
(*                                                                               *)
(*    You should have received a copy of the GNU Lesser General Public License   *)
(*    along with this program; if not, write to the Free Software                *)
(*    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA                   *)
(*    02111-1307  USA                                                            *)
(*                                                                               *)
(*    Contact: Maxence.Guesdon@inria.fr                                          *)
(*********************************************************************************)

(* Definitions des types abstraits                       *)

type sQLHENV
type sQLHDBC
type env

module type Sql_column_type =
  sig
    type t
    val string : t -> string
  end

module Interface (Sql_col : Sql_column_type) =
  struct
    (*  Constructeurs des types abstraits (valeur vide) *)
    external value_SQLHENV : unit -> sQLHENV = "value_HENV_c" 
    external value_SQLHDBC : unit -> sQLHDBC = "value_HDBC_c"

    (*  Fonctions C utilis�es *)
    external initDB : string -> string -> string -> (int*sQLHENV*sQLHDBC) = "initDB_c"
    external initDB_driver : string -> bool -> (int*sQLHENV*sQLHDBC) = "initDB_driver_c"
    external execDB : sQLHENV -> sQLHDBC -> string -> int * env = "execDB_c"
    external itereDB : env -> int -> (int*string list list) = "itere_execDB_c"
    external free_execDB : env -> unit = "free_execDB_c"
    external get_infoDB : env -> sQLHENV -> sQLHDBC -> (string * Sql_col.t) list = "get_infoDB_c"
    external exitDB : sQLHENV -> sQLHDBC -> int = "exitDB_c"
  end



