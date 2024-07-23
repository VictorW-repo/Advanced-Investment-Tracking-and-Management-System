open Unix

let file = "data/actualData.json"

type s = {
  name : string;
  price : string;
  shares : string;
  dateInvested : string;
}

type a = {
  username : string;
  password : string;
  balance : string;
  investedStocks : s list;
}

type t = a list

exception NegativeBalance of string

let add_quotes s = "\"" ^ s ^ "\""
let trim_quotes s = String.sub s 1 (String.length s - 2)
let get_time () = Unix.time () |> Unix.localtime

let time_to_string tm =
  let day = tm.tm_mday in
  let month = tm.tm_mon + 1 in
  let year = tm.tm_year + 1900 in
  string_of_int month ^ "/" ^ string_of_int day ^ "/" ^ string_of_int year
  |> add_quotes

let rec get_account u p t =
  match t with
  | h :: tl ->
      if u = (h.username |> trim_quotes) && p = (h.password |> trim_quotes) then
        h
      else get_account u p tl
  | [] -> raise Not_found

let rec delete_account u p t =
  match t with
  | h :: tl ->
      if h.username = add_quotes u && h.password = add_quotes p then
        delete_account u p tl
      else h :: delete_account u p tl
  | [] -> []

(** [print_user_pass u p] returns the string that would be seen in the json file
    with username [u] and password [p]. *)
let print_user_pass u p = "\"Username\": " ^ u ^ ",\n\"Password\": " ^ p ^ ",\n"

(** [print_balance b] returns the string representation of the balance in the
    JSON file. *)
let print_balance b = "\"Balance\": " ^ b ^ ",\n"

let money_of_str str =
  try
    let str = str ^ "00" in
    let dec_position = String.index str '.' in
    String.sub str 0 (dec_position + 3)
  with _ -> "Exceeded API Key"

let update_balance b p =
  let balance_float = (trim_quotes b |> float_of_string) -. float_of_string p in
  let balance_string =
    money_of_str (string_of_float balance_float) |> add_quotes
  in
  if balance_float >= 0. then balance_string
  else raise (NegativeBalance ("exceeds balance: " ^ balance_string))

(** [print_stock s] returns the string that would be seen in the json file with
    stock [s] *)
let print_stock s =
  "{\n\"name\": " ^ s.name ^ ",\n\"price\": " ^ s.price ^ ",\n\"shares\": "
  ^ s.shares ^ ",\n\"dateInvested\": " ^ s.dateInvested ^ "\n}"

(** [stock_to_string s] returns the string that would be seen in the json file
    with stock list [s] *)
let stocks_to_string stock_lst =
  let rec print_stock_helper stock_lst =
    match stock_lst with
    | [] -> ""
    | [ h ] -> print_stock h
    | h :: t -> print_stock h ^ "," ^ print_stock_helper t
  in
  "\"investedStocks\": [" ^ print_stock_helper stock_lst ^ "]\n"

(** [account_to_string a] returns the string that would be seen in the json file
    with account [a] *)
let account_to_string a =
  "{\n"
  ^ print_user_pass a.username a.password
  ^ print_balance a.balance
  ^ stocks_to_string a.investedStocks
  ^ "}"

let accounts_to_string a =
  let rec print_all_helper lst =
    match lst with
    | [] -> ""
    | [ h ] -> account_to_string h
    | h :: t -> account_to_string h ^ ",\n" ^ print_all_helper t
  in
  "{\n\"accounts\": [\n" ^ print_all_helper a ^ "\n]\n}"

let check_stock u p t stock =
  let account = get_account u p t in
  let rec find_stock stock lst =
    match lst with
    | [] -> None
    | h :: t -> if h.name = add_quotes stock then Some h else find_stock stock t
  in
  find_stock stock account.investedStocks

let add_share s =
  {
    name = s.name;
    price = s.price;
    shares = string_of_int (int_of_string (trim_quotes s.shares) + 1);
    dateInvested = s.dateInvested;
  }

let edit_accounts u p t stock price shares =
  let account = get_account u p t in
  let other_accounts = delete_account u p t in
  let new_stock =
    {
      name = add_quotes stock;
      price = add_quotes price;
      shares = add_quotes shares;
      dateInvested = get_time () |> time_to_string;
    }
  in
  let all_stocks = account.investedStocks @ [ new_stock ] in
  let new_account =
    {
      username = account.username;
      password = account.password;
      balance = update_balance account.balance price;
      investedStocks = all_stocks;
    }
  in
  new_account :: other_accounts

(** [subtract_share_helper s] gets number of shares in stock [s] converts the
    string to an int, subtracts by 1, converts back to string, and adds quotes. *)
let subtract_share_helper s =
  let num_shares =
    let n = trim_quotes s.shares |> int_of_string in
    n - 1 |> string_of_int |> add_quotes
  in
  { s with shares = num_shares }

(** [find_subtract_stock lst stock] looks for stock [stock] within [lst], and
    once it finds it, subtracts one from the shares, and returns the revied
    stock list. *)
let rec find_subtract_stock lst stock =
  match lst with
  | [] -> []
  | h :: t ->
      if h.name = add_quotes stock then
        subtract_share_helper h :: find_subtract_stock t stock
      else h :: find_subtract_stock t stock

(** [subtract_share u p t stock] subtracts one share of stock [stock] from user
    [u]. *)
let subtract_share u p t stock =
  let s = (get_account u p t).investedStocks in
  find_subtract_stock s stock

(** [delete_stock u p t stock] deletes stock [stock] from the account associated
    with user [u] and password [p] within accounts [t]. *)
let delete_stock u p t stock =
  let invested = (get_account u p t).investedStocks in
  let rec delete_stock_helper stock lst =
    match lst with
    | [] -> []
    | h :: t ->
        if h.name = add_quotes stock then delete_stock_helper stock t
        else h :: delete_stock_helper stock t
  in
  delete_stock_helper stock invested

let sell_share u p t stock =
  match check_stock u p t stock with
  | None -> (get_account u p t).investedStocks
  | Some s ->
      if int_of_string (trim_quotes s.shares) = 1 then delete_stock u p t stock
      else subtract_share u p t stock

(* note: still need to check if stock is already invested then add one to stock
   shares *)
(* bugs, when subtracting a share (so selling with more than one shares theres
   an issue where it crashes) *)
