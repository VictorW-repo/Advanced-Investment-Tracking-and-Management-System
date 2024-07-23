open Yojson.Basic
open Api
open FileWrite

let json_file = Yojson.Basic.from_file file

(* [stocks j] is the stock that json [j] represents. *)
let stocks j =
  {
    name = j |> Util.member "name" |> to_string;
    price = j |> Util.member "price" |> to_string;
    shares = j |> Util.member "shares" |> to_string;
    dateInvested = j |> Util.member "dateInvested" |> to_string;
  }

(* [account j] is the account that json [j] represents. *)
let account j =
  {
    username = j |> Util.member "Username" |> to_string;
    password = j |> Util.member "Password" |> to_string;
    balance = j |> Util.member "Balance" |> to_string;
    investedStocks =
      j |> Util.member "investedStocks" |> Util.to_list |> List.map stocks;
  }

(* [json_extract json] is all accounts that json [j] represnts. *)
let json_extract json =
  json |> Util.member "accounts" |> Util.to_list |> List.map account

let from_json json =
  try json_extract json
  with Util.Type_error (s, _) -> failwith ("Parsing error: " ^ s)

let rec account_name accounts =
  match accounts with
  | h :: tl -> (h.username, h.password) :: account_name tl
  | [] -> []

let make_new_account u p t =
  let new_account =
    {
      username = add_quotes u;
      password = add_quotes p;
      balance = add_quotes "10000";
      investedStocks = [];
    }
  in
  new_account :: t

let add_account u p t =
  let all_accounts = make_new_account u p t in
  let new_json = accounts_to_string all_accounts in
  let x = file |> open_out in
  Printf.fprintf x "%s\n" new_json;
  close_out x

let add_stock u p t stock price shares =
  try
    let new_json =
      accounts_to_string (edit_accounts u p t stock price shares)
    in
    let out_channel = file |> open_out in
    Printf.fprintf out_channel "%s\n" new_json;
    close_out out_channel
  with e -> raise e

let data_sell_stock u p t stock price =
  try
    let price = "-" ^ price in
    let new_stock_lst = sell_share u p t stock in
    let account = get_account u p t in
    let other_accounts = delete_account u p t in
    let new_account =
      {
        username = account.username;
        password = account.password;
        balance = update_balance account.balance price;
        investedStocks = new_stock_lst;
      }
    in
    let edit_accounts = new_account :: other_accounts in
    let new_json = accounts_to_string edit_accounts in
    let x = file |> open_out in
    Printf.fprintf x "%s\n" new_json;
    close_out x
  with e -> raise e

(** [get_stocks_helper lst] takes in a list of invested stocks of type s list
    and returns a list of tuples that contins the stocks name, price, and number
    of shares bought *)
let rec get_stocks_helper lst =
  match lst with
  | h :: t -> (h.name, h.shares, h.price) :: get_stocks_helper t
  | [] -> []

let get_stocks u p t = (get_account u p t).investedStocks |> get_stocks_helper
let get_balance u p t = (get_account u p t).balance

let rec get_current_prices lst =
  match lst with
  | (name, num_shares, old_price) :: t ->
      let new_price = trim_quotes name |> stock in
      ( trim_quotes name,
        new_price,
        trim_quotes num_shares,
        trim_quotes old_price )
      :: get_current_prices t
  | [] -> []
