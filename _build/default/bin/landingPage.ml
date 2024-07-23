open Interface
open Graphics
open Operations
open Choose
open DataCheck
open FileWrite

let username = ref ""
let password = ref ""
let info_from_file () = json_file |> from_json

let rec account_check lst =
  match lst with
  | (u, p) :: t ->
      let u = trim_quotes u in
      let p = trim_quotes p in
      if u = !username && p = !password then true else account_check t
  | [] -> false

(** [draw_sign_in ub pb] draws the username and password box on the current open
    window and writes "Username" and "Password" in the respective boxes. *)
let draw_sign_in ub pb =
  draw_box ub;
  draw_in_box ub "Username";
  draw_box pb;
  draw_in_box pb "Password"

let print_info () =
  moveto ((size_x () / 2) - 70) ((size_y () / 2) + 20);
  draw_string !username;
  moveto ((size_x () / 2) - 70) ((size_y () / 2) - 40);
  draw_string !password;
  ()

let change_graph_to_login move_x move_y b =
  remember_mode false;
  if b = true then
    if !username = "" then (
      type_here move_x move_y;
      username := printer_with_fun !username move_x move_y print_info;
      synchronize ();
      print_info ())
    else (
      username := printer_with_fun !username move_x move_y print_info;
      synchronize ();
      print_info ())
  else if !password = "" then (
    type_here move_x move_y;
    password := printer_with_fun !password move_x move_y print_info;
    synchronize ();
    print_info ())
  else (
    password := printer_with_fun !password move_x move_y print_info;
    synchronize ();
    print_info ())

let check_username_box mouse_x mouse_y username_box =
  if clicked mouse_x mouse_y username_box then (
    change_graph_to_login ((size_x () / 2) - 70) ((size_y () / 2) + 20) true;
    remember_mode true)
  else ()

let check_password_box mouse_x mouse_y password_box =
  if clicked mouse_x mouse_y password_box then (
    change_graph_to_login ((size_x () / 2) - 70) ((size_y () / 2) - 40) false;
    remember_mode true)
  else ()

let rec check_user user a_lst =
  match a_lst with
  | [] -> false
  | h :: t -> if h.username = add_quotes user then true else check_user user t

let check_account_box mouse_x mouse_y account_box info =
  if clicked mouse_x mouse_y account_box then
    if check_user !username info then (
      moveto ((size_x () / 2) - 100) ((size_y () / 2) - 140);
      draw_string "Username already taken")
    else (
      add_account !username !password info;
      change_to_choose !username !password)
  else ()

let check_login_box mouse_x mouse_y login_box info =
  if clicked mouse_x mouse_y login_box then
    if info |> account_name |> account_check then
      change_to_choose !username !password
    else (
      moveto (size_x () / 2) ((size_y () / 2) - 140);
      draw_string "Not valid username or password";
      ())
  else ()

let rec keep_window_open_loop username_box password_box account_box login_box
    info =
  match wait_next_event [ Key_pressed; Button_down ] with
  | { mouse_x; mouse_y; _ } ->
      check_username_box mouse_x mouse_y username_box;
      check_password_box mouse_x mouse_y password_box;
      check_account_box mouse_x mouse_y account_box info;
      check_login_box mouse_x mouse_y login_box info;
      keep_window_open_loop username_box password_box account_box login_box info

let open_graphic_window =
  open_graph "";
  print_title "Home Page";
  let input_box_x = (size_x () / 2) - 100 in
  let input_box_w = 200 in
  let input_box_h = 50 in
  let username_box =
    create_box input_box_x (size_y () / 2) input_box_w input_box_h
  in
  let password_box =
    create_box input_box_x ((size_y () / 2) - 60) input_box_w input_box_h
  in
  draw_sign_in username_box password_box;
  let create_account_box =
    create_box ((size_x () / 2) - 100) ((size_y () / 2) - 120) 90 50
  in
  draw_box create_account_box;
  moveto ((size_x () / 2) - 95) ((size_y () / 2) - 100);
  draw_string "Create Account";
  let login_box =
    create_box ((size_x () / 2) + 10) ((size_y () / 2) - 120) 90 50
  in
  draw_box login_box;
  moveto ((size_x () / 2) + 40) ((size_y () / 2) - 100);
  draw_string "Login";
  let info = info_from_file () in
  keep_window_open_loop username_box password_box create_account_box login_box
    info

let main () = open_graphic_window
let () = main ()
