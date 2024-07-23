open Graphics
open Operations
open DataCheck
open Api
open FileWrite

(** [y] is a mutable helper vairable for [print_investment_portfolio] that
    states the y location of where to draw the next stock invested *)
let y = ref 140

let balance_box () =
  create_box ((size_x () / 2) - 90) ((size_y () / 2) - 155) 200 40

let print_balance b =
  moveto (size_x () / 2) ((size_y () / 2) - 152);
  draw_string (String.sub b 1 (String.length b - 2))

let rec net_gain lst =
  try
    match lst with
    | (_, new_price, num_shares, old_price) :: t ->
        ((new_price |> Stdlib.float_of_string)
        -. (old_price |> Stdlib.float_of_string))
        *. (num_shares |> Stdlib.float_of_string)
        +. net_gain t
    | [] -> 0.
  with _ -> 0.

let print_net_gain lst =
  moveto ((size_x () / 2) + 40) ((size_y () / 2) - 107);
  lst |> net_gain |> string_of_float |> draw_string

(** [stock_string n p a o] is the string concatentation that tells the user the
    invested stock [n], the number of shares [a], the current price [p], and the
    price they invested at [o] *)
let stock_string n p a o =
  "Stock: " ^ n ^ "  Shares: " ^ a ^ "  Current Price: " ^ p
  ^ "  Price Invested: " ^ o

let rec print_investment_portfolio lst =
  try
    match lst with
    | (n, p, a, o) :: t ->
        moveto ((size_x () / 2) - 190) ((size_y () / 2) + !y);
        stock_string n p a o |> draw_string;
        y := !y - 12;
        print_investment_portfolio t
    | [] -> ()
  with _ ->
    moveto ((size_x () / 2) - 190) ((size_y () / 2) + !y);
    draw_string "Invalid API Key"

let get_investment_portfolio u p =
  try
    let investment_lst = get_stocks u p (from_json json_file) in
    let balance = get_balance u p (from_json json_file) in
    print_balance balance;
    let stocks_lst = get_current_prices investment_lst in
    print_investment_portfolio stocks_lst;
    print_net_gain stocks_lst
  with _ ->
    moveto ((size_x () / 2) - 190) ((size_y () / 2) + !y);
    draw_string "Invalid API Key"

let add_market_index () =
  try
    moveto (size_x () - 390) (size_y () - 20);
    draw_string ("S&P 500: " ^ money_of_str (stock "SPX"));
    moveto (size_x () - 270) (size_y () - 20);
    draw_string ("Dow Jones: " ^ money_of_str (stock "DJI"));
    moveto (size_x () - 130) (size_y () - 20);
    draw_string ("Nasdaq: " ^ money_of_str (stock "IXIC"))
  with _ ->
    moveto (size_x () - 390) (size_y () - 20);
    draw_string "Invalid API Key"

let rec keep_window_open exit_box =
  match wait_next_event [ Key_pressed; Button_down ] with
  | { mouse_x; mouse_y; _ } ->
      if clicked mouse_x mouse_y exit_box then (
        return_to_choose := true;
        ())
      else keep_window_open exit_box

let change_graph_to_dashboard u p =
  clear_graph ();
  y := 140;
  print_title "Dashboard";
  let exit_box = create_box 0 (size_y () - 25) 50 70 in
  print_exit_box exit_box "Exit";
  let info_box = create_box (size_x () - 500) (size_y () - 25) 500 70 in
  draw_in_box info_box "Market Indeces: ";
  draw_box info_box;
  add_market_index ();
  let inv_port_box =
    create_box ((size_x () / 2) - 200) ((size_y () / 2) - 45) 475 200
  in
  draw_box inv_port_box;
  draw_in_box inv_port_box "investment portfolio";
  let net_gains_box =
    create_box ((size_x () / 2) - 100) ((size_y () / 2) - 110) 200 40
  in
  let balance_box = balance_box () in
  draw_box balance_box;
  draw_box net_gains_box;
  draw_in_box balance_box "Your Balance: ";
  draw_in_box net_gains_box "Your Net Gains So Far:  ";
  get_investment_portfolio u p;
  keep_window_open exit_box
