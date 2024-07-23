(** Representation of operations to manipulate JSON files

    This module represents operations used to write into JSON files. Our JSON
    file represents our database, and in this file we revise their balances and
    add stocks to their portfolios, among other operations.

    Note that certain functions that return a string return that string with two
    double quotes, such as ""x"" to correctly manipulate a JSON file. The
    specifications specify which functions return a string with two double
    quotes and one double quote. *)

val file : string
(** The JSON file that holds all information for accounts that are being edited. *)

type s = {
  name : string;
  price : string;
  shares : string;
  dateInvested : string;
}
(** The type representing a stock. *)

type a = {
  username : string;
  password : string;
  balance : string;
  investedStocks : s list;
}
(** The type representing an account in the database. *)

type t = a list
(** The type of values representing all accounts. *)

exception NegativeBalance of string
(** Raised when a user's balance is exceeded. This would occur when a user tries
    to invest more money in a stock than they do in their balance. *)

val add_quotes : string -> string
(** [add_quotes s] adds quotes to both sides of [s]. *)

val trim_quotes : string -> string
(** [trim_quotes s] takes in a string [s] and then trims the first and last
    character and returns the new string. *)

val get_time : unit -> Unix.tm
(** [get_time ()] is the current time as type [Unix.tm]. *)

val time_to_string : Unix.tm -> string
(** [time_to_string tm] is the string format mm/dd/yyyy of [tm]. *)

val get_account : string -> string -> t -> a
(** [get_account u p t] returns the account of type a which has username [u] and
    password [p] from all accounts [t]. Raises [Not_found] if there's no account
    in [t] with username [u] and password [p]. *)

val delete_account : string -> string -> t -> t
(** [delete_account u p t] deletes account with associated username [u] and
    password [p] from all accounts [t]. If no account found with that username
    and password, all accounts will be returned. *)

val money_of_str : string -> string
(** [money_of_str str] converts str, which contains a float in string form, to
    form [xxxx.xx] to avoid float rounding operations. The outputted string is
    with one double quote. If it throws an exception, then output is "Exceeded
    API Key", if the person overuses their 8 api requests/minute with their api
    key. *)

val update_balance : string -> string -> string
(** [update_balance b p] subtracts the float within price [p] from the float
    within balance [b] and returns the string version of the new balance. Note
    that this function doesn't return two double quotes for the output string.
    Raises [NegativeBalance s] if the updated balance is negative. *)

val accounts_to_string : t -> string
(** [accounts_to_string a] returns full json file to be reprinted. *)

val check_stock : string -> string -> t -> string -> s option
(** [check_stock u p t stock] checks if stock ticker string [stock] is in user's
    [u] portfolio and returns [Some stock], where [stock] will contain price
    bought, shares, and date invested, if it is and [None] if it is not. *)

val add_share : s -> s
(** [add_share s] adds a share to stock [s] and returns the new stock. *)

val edit_accounts :
  string -> string -> a list -> string -> string -> string -> t
(** [edit_accouts u p t stock price shares] adds stock [stock] to the user
    [user] at price [price] and returns a list of accounts. *)

val sell_share : string -> string -> t -> string -> s list
(** [sell_share u p t stock] sells one share of stock [stock] that is invested
    under the account associated with user [u] and password [p] within accounts
    [t]. If there is only one share remaining it deletes then stock from the
    list if not then it subtracts one. *)
