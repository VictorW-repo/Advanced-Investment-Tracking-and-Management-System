(** Representation of operations performed on the dashboard page.

    Our dashboard page consists of the balance of the user, along with their net
    gain of all stocks they invested in, and their portfolio. It also contains
    the 3 market indices that will appear on the top of the GUI. *)

val balance_box : unit -> Operations.box
(** [balance_box ()] creates a box that contains the balance of the user and
    returns the box. *)

val print_balance : string -> unit
(** [print_balance b] prints the users balance b in the balance box *)

val net_gain : (string * string * string * string) list -> float
(** [net_gain lst] returns the net gain or loss of all the stocks in list [lst].
    [lst] is a list of tuples that contains the stock name, new price, number of
    shares, and old price *)

val print_net_gain : (string * string * string * string) list -> unit
(** [print_net_gain lst] prints the net gain of the user using the list [lst] of
    stocks they invested in on the GUI. *)

val print_investment_portfolio :
  (string * string * string * string) list -> unit
(** [print_investment_portfolio lst] prints the information for each stock in
    list, a list of stocks with the stock ticker, shares, current price, and
    price invested, for the user to see. If exception is found prints "Invalid
    API Key" *)

val get_investment_portfolio : string -> string -> unit
(** [get_investment_portfolio u p] prints the investment portfolio on the GUI
    and net gain or loss of the account associated with username [u] and
    password [p] If exception is found prints "Invalid API Key". *)

val add_market_index : unit -> unit
(** [add_market_index ()] adds the market indices S&P 500, Dow Jones, and the
    Nasdaq prices to the dashboard page on the GUI. If exception is found prints
    "Invalid API Key". *)

val keep_window_open : Operations.box -> unit
(** [keep_window_open exit_box] keeps the current dashboard page open unless a
    click has occurred in [exit_box]. *)

val change_graph_to_dashboard : string -> string -> unit
(** [change_graph_to_dashboard u p] changes the graph to the dashboard makeup
    and uses the username [u] and password [p] to get the necessary information
    for the user. *)
