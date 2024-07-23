(** This module represents the operations involving changing the GUI to the
    stock page where the user can search for, sell, and invest in stocks. *)

val stock_invest : string ref
(** [stock_invest] represents the stock name that the user recently search for.
    If the user has not yet searched it is the empty string. *)

val stock_price : string ref
(** [stock_invest] represents the price of the stock name that the user recently
    search for. If the user has not yet searched it is the empty string. *)

val get_price : string -> string
(** [get_price stock_name] retrieves the price of stock [stock_name] and returns
    a message along with the stock price. If exception is found prints "Invalid
    API Key". *)

val print_stock_search : unit -> unit
(** [print_stock_search ()] prints the stock [stock_invest] and price
    [stock_price] in the respective boxes for the user to see. *)

val search_stock : unit -> unit
(** [search_stock ()] allows the user to continually search for stocks and
    recurses until the program is closed. Edits [stock_invest] and [stock_price]
    with each search. *)

val buy_stock : string -> string -> unit
(** [buy_stock u p] invests one share in [!stock_invest] at price [!stock_price]
    for the user with username [u] and password [p]. *)

val sell_stock : string -> string -> unit
(** [sell_stock u p] sells one share in [!stock_invest] at price [!stock_price]
    for the user with username [u] and password [p]. *)

val where_search :
  Operations.box ->
  Operations.box ->
  Operations.box ->
  Operations.box ->
  string ->
  string ->
  unit
(** [where_search b1 b2 b3 u p] allows the user with username [u] and password
    [p] to click on either boxes [b1], [b2], or [b3] and be allowed to type in
    that box. Continually recurses to check where the user clicks. *)

val change_graph_to_stockpage : string -> string -> unit
(** [change_graph_to_stockpage u p] clears the graph and uses helper functions
    to draw the UI for the stock page where the user with username [u] and
    password [p] can search for stocks and invest. *)
