(** Representation of operations for our "choose page".

    Our "choose page" consists of operations, where the user can insert their
    key, click on the stock box to search up a stock, or click on the dashboard
    box to check their portfolio.

    Note that in order to check your dashboard or search a stock, you must have
    already inserted a valid API key. *)

val print_key : unit -> unit
(** [print_key ()] prints the API key onto the GUI based on keyboard inputs from
    user. *)

val insert_key : unit -> unit
(** [insert_key] allows the user to input their api key that they want to use.
    Accordingly changes [Api.input_key]. *)

val check_stock_box : int -> int -> Operations.box -> string -> string -> unit
(** [check_stock_box mouse_x mouse_y stock_box] checks if the stock box is
    clicked and calls the function to change the graph to the stockpage. *)

val check_dashboard_box :
  int -> int -> Operations.box -> string -> string -> unit
(** [check_dashboard_box mouse_x mouse_y dashboard_box] checks if the dashboard
    box is clicked and calls the function to change the graph to the dashboard
    page. *)

val check_exit_box : int -> int -> Operations.box -> unit
(** [check_exit_box mouse_x mouse_y exit_box] checks if the exit box is clicked
    and closes the GUI if it was. *)

val check_api_key_box : int -> int -> Operations.box -> unit
(** [check_api_key_box mouse_x mouse_y api_key_box] checks if the api key box is
    clicked and calls the function to change insert the key if it is. *)

val change_to_choose : string -> string -> unit
(** [change_to_choose] changes to GUI to the "choose page" accordingly to input
    later information for account associated with username [u] and password [p]. *)
