open Graphics
open Api
open Operations
open DataCheck

let stock_invest = ref ""
let stock_price = ref ""

(** [draw_r_stock x y] draws a centered rectangle with width [x] and height [y]*)
let draw_r_stock x y =
  let search_box =
    create_box ((size_x () / 2) - 100) ((size_y () / 2) - 25) x y
  in
  draw_box search_box;
  search_box

(** [invest_box ()] create and draws the box where the user invests in a stock *)
let invest_box () =
  let i_box = create_box ((size_x () / 2) + 20) ((size_y () / 2) - 80) 75 50 in
  draw_box i_box;
  draw_in_box i_box "Buy Share";
  i_box

(** [sell_box ()] create and draws the box where the user sells a stock *)
let sell_box () =
  let sell_box =
    create_box ((size_x () / 2) - 95) ((size_y () / 2) - 80) 75 50
  in
  draw_box sell_box;
  draw_in_box sell_box "Sell Share";
  sell_box

let get_price stock_name =
  try
    match stock stock_name with
    | "message" -> "This is not a valid stock."
    | s -> "The price of " ^ stock_name ^ " is " ^ s
  with _ -> "Invalid API Key"

let print_stock_search () =
  synchronize ();
  moveto ((size_x () / 2) - 95) ((size_y () / 2) - 5);
  draw_string !stock_invest;
  moveto ((size_x () / 2) - 95) ((size_y () / 2) - 20);
  draw_string !stock_price

let search_stock () =
  synchronize ();
  let move_x = (size_x () / 2) - 95 in
  let move_y = (size_y () / 2) - 5 in
  type_here move_x move_y;
  let stock_name = printer "" move_x move_y in
  stock_invest := stock_name;
  synchronize ();
  stock_price := get_price !stock_invest;
  print_stock_search ()

let buy_stock u p =
  synchronize ();
  print_stock_search ();
  try
    add_stock u p (from_json json_file) !stock_invest (stock !stock_invest) "1";
    moveto ((size_x () / 2) + 20) ((size_y () / 2) - 100);
    draw_string ("Invested one share in " ^ !stock_invest)
  with _ ->
    moveto ((size_x () / 2) + 20) ((size_y () / 2) - 100);
    draw_string "Balance Negative"

let sell_stock u p =
  try
    data_sell_stock u p (from_json json_file) !stock_invest
      (stock !stock_invest);
    moveto ((size_x () / 2) - 150) ((size_y () / 2) - 100);
    draw_string ("Sold One Share in " ^ !stock_invest)
  with _ ->
    moveto ((size_x () / 2) - 150) ((size_y () / 2) - 100);
    draw_string "Balance Negative"

let rec where_search i_box search_box exit_box sell_box u p =
  match wait_next_event [ Button_down ] with
  | { mouse_x; mouse_y; _ } ->
      if clicked mouse_x mouse_y search_box then search_stock ()
      else if clicked mouse_x mouse_y i_box && !stock_invest <> "" then
        buy_stock u p
      else if clicked mouse_x mouse_y sell_box && !stock_invest <> "" then
        sell_stock u p
      else if clicked mouse_x mouse_y exit_box then (
        synchronize ();
        return_to_choose := true;
        ())
      else (
        print_stock_search ();
        where_search i_box search_box exit_box sell_box u p)

let change_graph_to_stockpage u p =
  clear_graph ();
  let search_box = draw_r_stock 200 50 in
  let i_box = invest_box () in
  let sell_box = sell_box () in
  let exit_box = create_box 0 (size_y () - 35) 50 70 in
  print_exit_box exit_box "Exit";
  print_title "Stock Page";
  moveto ((size_x () / 2) - 65) ((size_y () / 2) + 30);
  draw_string "Click to Search Stock";
  remember_mode false;
  where_search i_box search_box exit_box sell_box u p
