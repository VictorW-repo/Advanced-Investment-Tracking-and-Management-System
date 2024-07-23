(** This module represents the operations involving a rectangle on a GUI screen
    and interactively printing text on the GUI, such as drawing a box on the
    screen, and checking to see if it's clicked. *)

val return_to_choose : bool ref
(** If true then the GUI should be switched back to the screen in choose.ml,
    where the user can either insert api key, search up stocks, or buy/sell
    stocks, if false then the screen should stay as is. *)

type box
(** The abstract type of values represnting a drawn rectangle box on the screen. *)

val draw_box : box -> unit
(** [draw_box box] draws [box] as a rectangle. *)

val draw_in_box : box -> string -> unit
(** [draw_in_box box str] draws [str] inside the lower-left corner of [box] in
    the GUI. *)

val get_x : box -> int
(** [get_x box] is the lower left x-value of [box]. *)

val get_y : box -> int
(** [get_y box] is the lower left y-value of [box]. *)

val get_max_x : box -> int
(** [get_max_x box] is the right corner x-value of [box]. *)

val get_max_y : box -> int
(** [get_max_y box] is the upper corner y-value of [box]. *)

val create_box : int -> int -> int -> int -> box
(** [create_box x y w h] is the rectangle box that [x y w h] represents. *)

val print_title : string -> unit
(** [print_title s] print the title of each page onto the GUI, such as for the
    landing page, dashboard, and stockpage. *)

val clicked : int -> int -> box -> bool
(** [clicked x y box] checks if [x] is between the x-values of [box] and [y] is
    between the y-values of [box]. *)

val print_exit_box : box -> string -> unit
(** [print_exit_box b s] prints box [b] in the upper left corner with the string
    [s] printed in the box. This allows the user to click on this box to go back
    to the landing page. *)

val type_here : int -> int -> unit
(** [type_here x y] prints the words "Type Here at x y in a gray font then sets
    the font back to black" *)

val printer : string -> int -> int -> string
(** [printer s x y] is [s] when the enter key is pressed. It checks to see which
    key is pressed and then prints the string concatenation of [x] and the new
    key at locations x = [x] y = [y]. Deletes one character from [s] and prints
    it if the key hit is backspace. *)

val printer_with_fun : string -> int -> int -> (unit -> unit) -> string
(** [printer_with_fun s x y f] is [s] when the enter key is pressed. It checks
    to see which key is pressed and then prints the string concatenation of [x]
    and the new key at locations x = [x] y = [y]. Applies function [f] after
    each call to synchronise. Deletes one character from [s] and prints it if
    the key is backspace. *)
