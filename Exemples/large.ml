
open Ocamlodbc

let affiche iRC result =
  if iRC = 0
  then
    (
     print_newline();
     begin
       let p_row row = (List.iter (function s -> print_string (s^" ")) row) in
       let p_rows rows = (List.iter (function row -> p_row row; print_newline()) rows) in
       begin
      	 print_string "Resultats :\n";
      	 p_rows result;
      	 print_newline()
       end;
     end
    )
  else
    print_int iRC
;;

let usage = Sys.argv.(0) ^ " database user [password]"

let main () =
  let tab = Sys.argv in
  let (pszDB, pszUser) = 
    try tab.(1), tab.(2)
    with _ -> prerr_endline usage ; exit 1
  in

  let pszPassword = if (Array.length tab) < 4 then  "" else tab.(3) in

  (* Affichage parametre base *)
  print_string ("nom base : "^pszDB^"\n");
  print_string ("nom util : "^pszUser^"\n");
  print_string ("passwd   : "^pszPassword^"\n");

  (* Connection *)
  let connection = connect pszDB pszUser pszPassword in

  let req_create = "create table large_test (chaine TEXT, bin BLOB)" in
  let _ = execute connection req_create in
  let s = String.make 50000 'a' in
  let v = Marshal.to_string [ 1 ; 2 ; 1000 ; 5000 ; 20000 ; 3 ] [] in
  prerr_endline ("v="^v);
  let req_insert = "insert into large_test (chaine, bin) values ('"^s^"', '"^v^"')" in
  let (n,_) = execute connection req_insert in
  if n <> 0 then prerr_endline "erreur insert";
  let req_select = "select * from large_test" in
  let (a,c) = execute connection req_select in
  affiche a c ;

  let req_destroy = "drop table large_test" in
  let _ = execute connection req_destroy in
  disconnect connection
;;


try
  main();
  Unix.sleep(5)
with
  SQL_Error(s) -> print_string s; print_newline()
| _ -> print_string "Erreur inconnue.\n"
;;

