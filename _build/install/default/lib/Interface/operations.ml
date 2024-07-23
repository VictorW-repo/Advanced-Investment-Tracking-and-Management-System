open Graphics

let return_to_choose = ref false

type box = {
  x : int;
  y : int;
  w : int;
  h : int;
}

let draw_box box = draw_rect box.x box.y box.w box.h

let draw_in_box box descr =
  moveto (box.x + (25 / 12)) (box.y + (25 / 8));
  draw_string descr

let get_x box = box.x
let get_y box = box.y
let get_max_x box = get_x box + box.w
let get_max_y box = box.y + box.h
let create_box x y w h = { x; y; w; h }

let print_title x =
  moveto ((size_x () / 2) - 75) (size_y () - 50);
  draw_string ("Welcome to the " ^ x)

let print_exit_box ebox str =
  draw_box ebox;
  moveto 15 (size_y () - 20);
  draw_string str

let clicked x y box =
  x <= get_max_x box && x >= box.x && y <= get_max_y box && y >= box.y

let type_here move_x move_y =
  moveto move_x move_y;
  rgb 211 211 211 |> set_color;
  draw_string "Type Here";
  set_color black

let rec printer x move_x move_y =
  let s = wait_next_event [ Key_pressed ] in
  match s with
  | { key = '\r'; _ } -> x
  | { key = '\b'; _ } ->
      synchronize ();
      if String.length x > 0 then (
        moveto move_x move_y;
        draw_string (String.sub x 0 (String.length x - 1));
        printer (String.sub x 0 (String.length x - 1)) move_x move_y)
      else (
        draw_string "";
        printer x move_x move_y)
  | { key = s; _ } ->
      synchronize ();
      moveto move_x move_y;
      let new_string = x ^ String.make 1 s in
      draw_string new_string;
      printer new_string move_x move_y

let rec printer_with_fun x move_x move_y f =
  let s = wait_next_event [ Key_pressed ] in
  match s with
  | { key = '\r'; _ } -> x
  | { key = '\b'; _ } ->
      synchronize ();
      f ();
      if String.length x > 0 then (
        moveto move_x move_y;
        draw_string (String.sub x 0 (String.length x - 1));
        printer_with_fun (String.sub x 0 (String.length x - 1)) move_x move_y f)
      else (
        draw_string "";
        printer_with_fun x move_x move_y f)
  | { key = s; _ } ->
      synchronize ();
      f ();
      moveto move_x move_y;
      let new_string = x ^ String.make 1 s in
      draw_string new_string;
      printer_with_fun new_string move_x move_y f
