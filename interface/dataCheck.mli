(** Representation of operations to mainly to read JSON files

    This module represents operations that are mainly used to read JSON files.
    Our JSON file represents our database, and in this file we extract accounts
    from the JSON file and add accounts to the file, among other operations.

    Note that certain functions that return a string return that string with two
    double quotes, such as ""x"" to correctly manipulate a JSON file. The
    specifications specify which functions return a string with two double
    quotes and one double quote. *)

val json_file : Yojson.Basic.t
(** [json_file] is the file where the data is coming from. *)

val from_json : Yojson.Basic.t -> FileWrite.t
(** [from_json json] is all the accounts that [json] represents. Raises
    [Failure s] if [from_json] applied to wrong type of JSON element. *)

val account_name : FileWrite.t -> (string * string) list
(** [account_name accounts] is a list of all usernames and password as tuples in
    accounts [accounts]. The outputted strings in the tuple is with two double
    quote. *)

val make_new_account : string -> string -> FileWrite.t -> FileWrite.t
(** [make_new_account u p t] adds account with username [u] and password [p] to
    the account list in [t]. Helper function for add_account. *)

val add_account : string -> string -> FileWrite.t -> unit
(** [add_account u p t] adds a new account to the json file with username [u]
    and password [p] *)

val add_stock :
  string -> string -> FileWrite.t -> string -> string -> string -> unit
(** [add_stock u p t stock price] adds stock [stock] with investment price
    [price] to the account with username [u] and password [p] in the list of
    accounts [t]. *)

val data_sell_stock :
  string -> string -> FileWrite.t -> string -> string -> unit
(** [sell_stock u p t stock] sells one share of stock [stock] that is invested
    under user [u]. *)

val get_stocks :
  string -> string -> FileWrite.t -> (string * string * string) list
(** [get_stocks u p t] is all the stocks that account with username [u] and
    password [p] bought among the accounts [t]. Returns a list of tuples that
    contains the stocks' names, prices, and numbers of shares bought. The
    strings in the tuple in the output are with two double quotes. Raises
    [Not_found] if account not found. *)

val get_balance : string -> string -> FileWrite.t -> string
(** [get_balance u p t] gets the balance from account associated username [u]
    and password [p] in accounts [t] and returns the balance. The output is with
    two double quotes. Raises [Not_found] if account not found. *)

val get_current_prices :
  (string * string * string) list -> (string * string * string * string) list
(** [get_current_prices lst] takes in a list [lst] of tuples that contains the
    stocks name, price, and number of shares bought and returns a list of the
    tuples contains the name, current price of the stock, and the number of
    shares bought. The strings in the tuple in the output are with one double
    quote. *)
