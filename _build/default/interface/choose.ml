open Graphics
open Operations
open StockPage
open Dashboard
open Api

let print_key () =
  let move_x = (size_x () / 2) - 95 in
  let move_y = (size_y () / 2) + 100 in
  moveto move_x move_y;
  draw_string !input_key

let insert_key () =
  remember_mode false;
  let move_x = (size_x () / 2) - 95 in
  let move_y = (size_y () / 2) + 100 in
  if !input_key = "" then (
    type_here move_x move_y;
    input_key := printer_with_fun !input_key move_x move_y print_key;
    synchronize ();
    print_key ();
    remember_mode true;
    ())
  else (
    input_key := printer_with_fun !input_key move_x move_y print_key;
    synchronize ();
    print_key ();
    remember_mode true;
    ())

let check_stock_box mouse_x mouse_y stock_box u p =
  if clicked mouse_x mouse_y stock_box then change_graph_to_stockpage u p
  else ()

let check_dashboard_box mouse_x mouse_y dashboard_box u p =
  if clicked mouse_x mouse_y dashboard_box then change_graph_to_dashboard u p
  else ()

let check_exit_box mouse_x mouse_y exit_box =
  if clicked mouse_x mouse_y exit_box then close_graph () else ()

let check_api_key_box mouse_x mouse_y api_key_box =
  if clicked mouse_x mouse_y api_key_box then insert_key () else ()

let rec change_to_choose u p =
  return_to_choose := false;
  clear_graph ();
  let dashboard_box =
    create_box ((size_x () / 2) - 100) ((size_y () / 2) - 110) 200 50
  in
  draw_box dashboard_box;
  draw_in_box dashboard_box "Click for Dashboard";
  let api_key_box =
    create_box ((size_x () / 2) - 100) ((size_y () / 2) + 75) 200 50
  in
  draw_box api_key_box;
  draw_in_box api_key_box "Insert Api Key";
  let stock_box =
    create_box ((size_x () / 2) - 100) ((size_y () / 2) - 25) 200 50
  in
  draw_box stock_box;
  draw_in_box stock_box "Click for Stock Page";
  let exit_box = create_box 0 (size_y () - 35) 50 70 in
  print_exit_box exit_box "Close";
  let rec keep_dash_open_loop stock_box dashboard_box exit_box api_key_box u p
      () =
    match wait_next_event [ Button_down ] with
    | { mouse_x; mouse_y; _ } ->
        check_stock_box mouse_x mouse_y stock_box u p;
        check_dashboard_box mouse_x mouse_y dashboard_box u p;
        check_exit_box mouse_x mouse_y exit_box;
        check_api_key_box mouse_x mouse_y api_key_box;
        if !return_to_choose then change_to_choose u p;
        keep_dash_open_loop stock_box dashboard_box exit_box api_key_box u p ()
  in
  keep_dash_open_loop stock_box dashboard_box exit_box api_key_box u p ()
