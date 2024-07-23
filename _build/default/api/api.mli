(** This module represents the operations involving gather stock price
    information from the api [https://twelvedata.com] using an api key. *)

exception InvalidAPI
(** [InvalidAPI] exception is raised when the api key is not valid. *)

val input_key : string ref
(** [input_key] is the api key used in gather information from the api. If it is
    "" then the given api key in the file api.ml is used. *)

val stock : string -> string
(** [stock s] uses the helper function above to return the price of stock [s].
    Throws InvalidAPI if exception is raised. *)
