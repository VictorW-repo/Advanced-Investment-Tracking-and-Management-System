(** This module represents the operations involving opening the GUI to the
    landing page, where the user can sign in or create a new account. *)

val username : string ref
(** [username] stores the username of the user *)

val password : string ref
(** [password] stores the password of the user *)

val info_from_file : unit -> Interface.FileWrite.t
(** [info_from_file] returns the type t which represents the data from the json
    file *)

val account_check : (string * string) list -> bool
(** [account_check lst] iterates through all tuples of username and passwords in
    [lst]. Returns: true if username and password are valid, meaning they are in
    the list, and false if not. *)

val print_info : unit -> unit
(** [print_info] draws the strings representing what the user typed in for
    [username] and [password] in the respective boxes. *)

val change_graph_to_login : int -> int -> bool -> unit
(** [change_graph_to_login] changes the graphic window gui to the login page
    where the user can input their username and password. *)

val check_username_box : int -> int -> Interface.Operations.box -> unit
(** [check_username_box mouse_x mouse_y username_box] checks if the username box
    is clicked based on [mouse_x] and [mouse_y] and calls the function to type
    in the username box. The function does nothing if the box was not cliked.
    Requires: [mouse_x] and [mouse_y] are valid coordinates. *)

val check_password_box : int -> int -> Interface.Operations.box -> unit
(** [check_password_box mouse_x mouse_y password_box] checks if the password box
    is clicked based on [mouse_x] and [mouse_y] and calls the function to type
    in the password box. Requires: [mouse_x] and [mouse_y] are valid
    coordinates. *)

val check_user : string -> Interface.FileWrite.a list -> bool
(** [check_user user a_lst] check if username [user] is already registered in an
    account in [a_lst]. Returns true if it is and false if not. *)

val check_account_box :
  int -> int -> Interface.Operations.box -> Interface.FileWrite.t -> unit
(** [check_account_box mouse_x mouse_y account_box] checks if the create account
    box is clicked and calls the function to change the graph to the login page
    if the box is clicked. The function does nothing if the box is not clicked.
    Requires: [mouse_x] and [mouse_y] are valid coordinates. *)

val check_login_box :
  int -> int -> Interface.Operations.box -> Interface.FileWrite.t -> unit
(** [check_login_box mouse_x mouse_y login_box] checks if the login box is
    clicked based on [mouse_x] and [mouse_y] and calls the function to change
    the graph to the login page. Also ensure that the login for the user is
    valid. The function does nothing if the box is not clicked and login not
    right. Requires: [mouse_x] and [mouse_y] are valid coordinates. *)

val keep_window_open_loop :
  Interface.Operations.box ->
  Interface.Operations.box ->
  Interface.Operations.box ->
  Interface.Operations.box ->
  Interface.FileWrite.t ->
  unit
(** [keep_window_open_loop box1 box2 box3 box4 t] is a recursive loop that keeps
    window open to ensure the GUI does not close. Whenever the mouse is cliked,
    it calls on functions to determine if [box1], [box2], [box3], or [box4] were
    clicked. *)

val open_graphic_window : unit
(** [open_graphic_window] opens and sets up the background for the gui which the
    user can interact with. *)
