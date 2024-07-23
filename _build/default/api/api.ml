open Lwt.Infix
open Cohttp_lwt_unix

exception InvalidAPI

let input_key = ref ""

(** [website] is the variable that holds the api wesbite *)
let website = "https://api.twelvedata.com/price?symbol="

(** [apikey] is the variable that holds the current api key *)
let apikey = "2aeae63d7425428da0b8c1a20e9fa4a3"

(** [reduce s] shortens string [s] to only the numbers for the price of the
    stock and returns the new string *)
let reduce s =
  try
    List.nth
      (List.nth (String.split_on_char ':' s) 1 |> String.split_on_char '"')
      1
  with _ -> raise InvalidAPI

(** [get_stock s] make a request to the api to get the price of stock [s].
    Returns the string the request returns *)
let get_stock s =
  try
    if !input_key = "" then
      let uri = Uri.of_string (website ^ s ^ "&apikey=" ^ apikey) in
      Client.call `GET uri >>= fun (_, body_stream) ->
      Cohttp_lwt.Body.to_string body_stream
    else
      let uri = Uri.of_string (website ^ s ^ "&apikey=" ^ !input_key) in
      Client.call `GET uri >>= fun (_, body_stream) ->
      Cohttp_lwt.Body.to_string body_stream
  with _ -> raise InvalidAPI

let stock s =
  try Lwt_main.run (get_stock s) |> reduce with _ -> raise InvalidAPI
