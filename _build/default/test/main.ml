(* Test Plan: For our testing, we mainly conducted manual testing by
   play-testing with our GUI. We will go through each of the modules to describe
   how we have conducted our testing.

   In Operations, we wrote OUnit test for clicked and functions that obtained
   the characteristics of the box, consequently testing our function that would
   create a box. For manual-testing, much of the testing here was visual, such
   as seeing that the title or box or text is printed in the specified position.
   For the exit box, we play-tested it by clicking the box to ensure that it
   exits properly. Note that many of these functions have also been play-tested
   in other modules, such as when we use clicked to check if the username or
   password box gets clicked. We have also play-tested functions [printer] and
   [printer_with_fun] by typing into boxes and seeing that our keyboard inputs
   have been correctly detected and outputted.

   In LandingPage, we manually tested that the appropriate action occurs when
   the username, password, create account, or login button gets clicked, such as
   allowing the user to now type in the box or changing the page. We also
   manually tested that the username and password inputted by the user exists
   (if they pressed the login button) by seeing if the GUI gets changed to our
   “choose page”, and have visually tested print_info by seeing what the user
   has inputted is actually being drawn in the correct position in the
   respective box. We have tested [keep_window_open_loop], a function that keeps
   our window open by clicking on random whitespace or any of the boxes in the
   GUI to ensure that it doesn’t close, and that the window only changes/closes
   if it clicked on that appropriate box.

   In DataCheck and FileWrite, we tested our function [from_json] as being part
   of the input of many of our OUnit tests. We wrote OUnit Tests where we looked
   at corner cases. For our balance functions, we looked at an account having a
   balance with decimals with update_balance, exceptions were being raised if an
   account balance was negative, getting balances for different accounts. For
   our tests regarding stocks, we ensured that [check_stock] would not return
   the stock if it was in someone else’s account but not for the account
   associated with the test, and ensured that the appropriate options were being
   returned. We also similarly wrote OUnit Tests for [get_account], (checking if
   the correct exception is being thrown as well), account_name, time_str
   (converting time from the Unix module). For [sell_share], we tested the
   number of stocks that someone has in their portfolio when a share gets
   subtracted, ensuring that a stock gets removed entirely if it previously had
   one share and that share was sold, and that nothing would happen if a stock
   that wasn’t in the portfolio was inputted. For add_share, we similarly tested
   the number of stocks in a user’s portfolio. For delete_account and
   add_account, we similarly tested the number of accounts in our json
   “database”. Since [Not_found] gets thrown from [get_account], and it gets
   used by many of the other functions, we only tested that the exception gets
   thrown from get_account. For manipulating JSON files, we manually tested them
   by ensuring that the JSON files were changed in the appropriate way and
   without any unnecessary additions or deletions. For example, if an account
   gets added, that it shows up in the JSON file with all of the other accounts,
   if an account gets deleted, all of the other accounts remain without that
   account, if share gets sold, the stock only gets deleted if there’s one
   share, and that it deletes it from the specified stock in the portfolio, etc.

   In Choose, we manually tested that the API key inputted by user gets printed
   as the user is typing in the API box, and similarly pressing the boxes on the
   page and that the GUI gets updated, such as clicking the dashboard box will
   take us to the dashboard page and not crash or remain on the same page. We
   have also manually tested [change_to_choose], ensuring that when the user
   clicks on log in from the landing page, that the “choose page” opens up
   appropriately.

   In Dashboard, we manually tested that the market indices show up with the
   correct prices and in the correct positions on the page, that
   [get_investment_portfolio] gets the correct investment portfolio shows up for
   the specified user, along with the correct information for each stock, along
   with portfolio being printed in the correct position on the page. We also
   ensured that the correct balance appears for the user in the balance box, and
   that [net_gain] correctly computes the net profit for a user’s portfolio,
   taking into account the number of shares. We have also tested
   [change_graph_to_dashboard] by ensuring that the page appears when the
   dashboard box gets clicked from the “choose” page.

   In API, we tested the functionality by manually searching for stocks in the
   stockPage. Using this we were able to determine if the functions in api were
   implemented correctly because we could check the price returns versus the
   current price on google to make sure it was correct. To test when a invalid
   api key was used we changed the api key variable to be an invalid one and
   tried to search for a stock on go into the dashboard page where the current
   indices were presented. We ensured that whenever this occurred the error
   Invalid API Key was printed onto the screen and could be seen by the user. We
   only needed to test this way because when searching for a stock price,
   [stock] function is called which in turn calls all the functions in API as
   they are helper functions. We were not able to write individual OUnit test
   cases because it would require a valid API to be successful, and if the test
   was run with an invalid API key then many of the tests would fail.

   In stockPage, we tested the functionality by manually testing each function
   via the GUI. We could not make OUnit tests because all functions either
   edited a JSON file or implemented features in the GUI. To test
   [change_graph_to_stockpage] we clicked on the button to choose which called
   on this function. We made sure the stockPage was set up correctly using this.
   We tested the [search_stock] function by searching for both valid and non
   valid stocks in the search bar and made sure if a stock was valid the price
   would be printed and if it was not then a corresponding error message would
   be displayed to the user. We tested the [buy_stock] and [sell_stock]
   functions by searching for a stock and then clicking the buy or sell buttons
   that correspond to buying or selling those stocks. We would then look for the
   correct representative changes in the JSON file that correspond to
   buying/selling stocks. We also made sure to test with non valid stocks to
   make sure that a user can’t buy stocks that don’t exist and sell stocks they
   don't have.

   Regarding how test cases were developed, for our OUnit tests, we used a glass
   box strategy, where we first implemented the functions and later tested them
   to ensure they gave us the right output. For our manual/visual/play-testing,
   we also used a glass box strategy, where we wrote all the functions and would
   afterwards intentionally try to run into errors with the GUI. At first, we
   would test the expected functionality with a simple amount of data (such as
   the first account from a database), and would later proceed to testing with
   other accounts in the database, and would then take into account corner cases
   with the kind of data we might expect from a JSON file (such as number of
   shares, or decimals/number of digits in the balance).

   Our testing approach demonstrates the correctness of our stock market
   simulator system because in our OUnit Tests, we have tested for corner cases,
   especially in terms of the data that might appear from our JSON database. For
   example, we ran our tests dealing with multiple accounts, variety of a user
   portfolio (different balances, different stocks at different prices with
   differing number of shares), and tried to take into account for cases that
   would raise errors in an actual stock market simulator system, such as when
   an account gets a negative balance. Similarly, in our manual testing, we have
   also taken into account similar errors, such as ensuring that the user can’t
   move to the next page if they don’t input a valid username and password, and
   ensuring that the right actions occur (or if nothing occurs at all) when a
   user presses on a box, inputs to the keyboard (or just presses on whitespace
   in the GUI). *)

open OUnit2
open Interface
open Operations
open DataCheck
open FileWrite
open Dashboard

(** [pp_string s] pretty-prints string [s]. *)
let pp_string s = "\"" ^ s ^ "\""

(** [pp_list pp_elt lst] pretty-prints list [lst], using [pp_elt] to
    pretty-print each element of [lst]. *)
let pp_list pp_elt lst =
  let pp_elts lst =
    let rec loop n acc = function
      | [] -> acc
      | [ h ] -> acc ^ pp_elt h
      | h1 :: h2 :: t ->
          if n = 100 then acc ^ "..." (* stop printing long list *)
          else loop (n + 1) (acc ^ pp_elt h1 ^ "; ") (h2 :: t)
    in
    loop 0 "" lst
  in
  "[" ^ pp_elts lst ^ "]"

(** [pp_tuple (k,v)] pretty-prints tuple [(k,v)].*)
let pp_tuple printer1 printer2 (k, v) =
  "(" ^ printer1 k ^ ", " ^ printer2 v ^ ")"

let pp_tuple_three printer1 printer2 printer3 (k, v, l) =
  "(" ^ printer1 k ^ ", " ^ printer2 v ^ ", " ^ printer3 l ^ ")"

let data_dir_prefix = "data" ^ Filename.dir_sep
let example = Yojson.Basic.from_file (data_dir_prefix ^ "exampleData.json")
let test = Yojson.Basic.from_file (data_dir_prefix ^ "testData.json")
let test2 = Yojson.Basic.from_file (data_dir_prefix ^ "testData2.json")

(* all accounts in [exampleData.json] *)
let example_filewrite = from_json example

(* all accounts in [testData.json] *)
let test_filewrite = from_json test

(* all accounts in [testData2.json] *)
let test_filewrite2 = from_json test2

(** [clicked_test name input_x input_y input_box expected_output] constructs an
    OUnit test named [name] that asserts the quality of [expected_output] with
    [clicked x_input y_input box_input]. *)
let clicked_test (name : string) (input_x : int) (input_y : int)
    (input_box : Operations.box) (expected_output : bool) =
  name >:: fun _ ->
  assert_equal expected_output (clicked input_x input_y input_box)

(** [box_corner_test box_function input_box input_i expected_output] constructs
    an OUnit test named [name] that asserts the quality of [expected_output]
    with [box_function x_input y_input box_input]. *)
let box_corner_test (name : string) (box_function : box -> int)
    (input_box : Operations.box) (expected_output : int) =
  name >:: fun _ ->
  assert_equal expected_output (box_function input_box) ~printer:string_of_int

let operations_tests =
  let box_1 = create_box 20 25 50 100 in
  let box_2 = create_box 200 300 20 40 in
  [
    clicked_test "box1 not clicked at (2,0)" 2 0 box_1 false;
    clicked_test "box1 clicked at (40,60)" 40 60 box_1 true;
    clicked_test "box2 clicked at corner (200,300)" 200 300 box_2 true;
    box_corner_test "x of box_1 is 20" get_x box_1 20;
    box_corner_test "x of box_1 is 200" get_x box_2 200;
    box_corner_test "y of box_1 is 25" get_y box_1 25;
    box_corner_test "x of box_1 is 200" get_y box_2 300;
    box_corner_test "right corner x of box_1 is 70" get_max_x box_1 70;
    box_corner_test "right corner x of box_2 is 220" get_max_x box_2 220;
    box_corner_test "right corner y of box_1 is 125" get_max_y box_1 125;
    box_corner_test "right corner y of box_2 is 340" get_max_y box_2 340;
  ]

(** [account_name_test name input expected_output] constructs an OUnit test
    named [name] that asserts the quality of [expected_output] with
    [account_name input]. *)
let account_name_test (name : string) (input : FileWrite.t)
    (expected_output : (string * string) list) =
  name >:: fun _ ->
  assert_equal expected_output (account_name input)
    ~printer:(pp_list (pp_tuple pp_string pp_string))

(** [get_account_test name input_user input_pass input_accounts expected_output]
    constructs an OUnit test named [name] that asserts the quality of
    [expected_output] with [get_account input_user input_pass input_accounts]. *)
let get_account_test (name : string) (input_user : string) (input_pass : string)
    (input_accounts : FileWrite.t) (expected_output : FileWrite.a) =
  name >:: fun _ ->
  assert_equal expected_output
    (get_account input_user input_pass input_accounts)

(** [get_account_test_exn name input_user input_pass input_accounts] constructs
    an OUnit test named [name] that asserts the quality of [Not_found] with
    [get_account input_user input_pass input_accounts]. *)
let get_account_test_exn (name : string) (input_user : string)
    (input_pass : string) (input_accounts : FileWrite.t) =
  name >:: fun _ ->
  assert_raises Not_found (fun () ->
      get_account input_user input_pass input_accounts)

let get_account_tests =
  [
    account_name_test "all accounts from test json" test_filewrite
      [ ({|"Ryan"|}, {|"password"|}) ];
    account_name_test "all accounts from test2 json" test_filewrite2
      [
        ({|"Ryan"|}, {|"password"|});
        ({|"Andrew"|}, {|"123password"|});
        ({|"Ruijie"|}, {|"456password"|});
        ({|"Clarkson"|}, {|"789password"|});
      ];
    get_account_test "get account in example json" "Andrew" "123password"
      example_filewrite
      {
        username = {|"Andrew"|};
        password = {|"123password"|};
        balance = {|"10000"|};
        investedStocks =
          [
            {
              name = {|"TSLA"|};
              price = {|"100.00"|};
              shares = {|"1"|};
              dateInvested = {|"1/1/2023"|};
            };
          ];
      };
    get_account_test "Ruijie get account in test2 json" "Ruijie" "456password"
      test_filewrite2
      {
        username = {|"Ruijie"|};
        password = {|"456password"|};
        balance = {|"5090"|};
        investedStocks =
          [
            {
              name = {|"MSFT"|};
              price = {|"100.00"|};
              shares = {|"2"|};
              dateInvested = {|"1/1/2023"|};
            };
            {
              name = {|"GOOG"|};
              price = {|"100.00"|};
              shares = {|"2"|};
              dateInvested = {|"1/1/2023"|};
            };
          ];
      };
    get_account_test "Clarkson get account in test2 json" "Clarkson"
      "789password" test_filewrite2
      {
        username = {|"Clarkson"|};
        password = {|"789password"|};
        balance = {|"999.19"|};
        investedStocks =
          [
            {
              name = {|"MSFT"|};
              price = {|"100.00"|};
              shares = {|"3"|};
              dateInvested = {|"1/1/2023"|};
            };
            {
              name = {|"GOOG"|};
              price = {|"100.00"|};
              shares = {|"3"|};
              dateInvested = {|"1/1/2023"|};
            };
          ];
      };
    get_account_test_exn "get account not in example json" "Bard" "plplp22"
      example_filewrite;
    get_account_test_exn "account not in test, but has that password" "Bruh"
      "123password" test_filewrite;
    get_account_test_exn "account not in test, but has that username" "Andrew"
      "password" test_filewrite;
  ]

(** [get_stocks_test name input_user input_pass input_accounts expected_output]
    constructs an OUnit test named [name] that asserts the quality of
    [expected_output] with [get_stocks input_user input_pass input_accounts]. *)
let get_stocks_test (name : string) (input_user : string) (input_pass : string)
    (input_accounts : FileWrite.t)
    (expected_output : (string * string * string) list) =
  name >:: fun _ ->
  assert_equal expected_output
    (get_stocks input_user input_pass input_accounts)
    ~printer:(pp_list (pp_tuple_three pp_string pp_string pp_string))

(** [check_stock_test name input_user input_pass input_accounts input_s expected_output]
    constructs an OUnit test named [name] that asserts the quality of
    [expected_output] with
    [check_stock input_user input_pass input_accounts input_s]. *)
let check_stock_test (name : string) (input_user : string) (input_pass : string)
    (input_accounts : FileWrite.t) (input_s : string)
    (expected_output : s option) =
  name >:: fun _ ->
  assert_equal expected_output
    (check_stock input_user input_pass input_accounts input_s)

let stocks_tests =
  [
    get_stocks_test "get stocks in example json from Ryan" "Ryan" "password"
      example_filewrite
      [
        ({|"AAPL"|}, {|"2"|}, {|"100.00"|}); ({|"SPG"|}, {|"1"|}, {|"100.00"|});
      ];
    get_stocks_test "get stocks in test2 json from ruijie" "Ruijie"
      "456password" test_filewrite2
      [
        ({|"MSFT"|}, {|"2"|}, {|"100.00"|}); ({|"GOOG"|}, {|"2"|}, {|"100.00"|});
      ];
    get_stocks_test "get stocks in test2 json from Clarkson" "Clarkson"
      "789password" test_filewrite2
      [
        ({|"MSFT"|}, {|"3"|}, {|"100.00"|}); ({|"GOOG"|}, {|"3"|}, {|"100.00"|});
      ];
    check_stock_test "checks if AAPL is in Ryan's invested in example json"
      "Ryan" "password" example_filewrite "AAPL"
      (Some
         {
           name = {|"AAPL"|};
           price = {|"100.00"|};
           shares = {|"2"|};
           dateInvested = {|"1/1/2023"|};
         });
    check_stock_test "checks if GOOG is in Clarkson's invested in test2 json"
      "Clarkson" "789password" test_filewrite2 "GOOG"
      (Some
         {
           name = {|"GOOG"|};
           price = {|"100.00"|};
           shares = {|"3"|};
           dateInvested = {|"1/1/2023"|};
         });
    check_stock_test
      "checks for POST in Ryan's invested in example json (not there)" "Ryan"
      "password" example_filewrite "POST" None;
    check_stock_test "checks AAPL in Andrew's, but actually in Ryan's in test2 "
      "Andrew" "123password" test_filewrite2 "AAPL" None;
  ]

(** [get_balance_test name input_user input_pass input_accounts expected_output]
    constructs an OUnit test named [name] that asserts the quality of
    [expected_output] with [get_balance input_user input_pass input_accounts]. *)
let get_balance_test (name : string) (input_user : string) (input_pass : string)
    (input_accounts : FileWrite.t) (expected_output : string) =
  name >:: fun _ ->
  assert_equal expected_output
    (get_balance input_user input_pass input_accounts)
    ~printer:pp_string

(** [update_balance_test name input_balance input_price expected_output]
    constructs an OUnit test named [name] that asserts the quality of
    [expected_output] with
    [update_balance input_user input_pass input_accounts]. *)
let update_balance_test (name : string) (input_balance : string)
    (input_price : string) (expected_output : string) =
  name >:: fun _ ->
  assert_equal expected_output
    (update_balance input_balance input_price)
    ~printer:pp_string

(** [update_balance_test name input_balance input_price expected_output]
    constructs an OUnit test named [name] that asserts the quality of
    [expected_output] with
    [update_balance input_user input_pass input_accounts]. *)
let update_balance_test_exn (name : string) (input_balance : string)
    (input_price : string) (exceeded_output : string) =
  name >:: fun _ ->
  assert_raises
    (NegativeBalance ("exceeds balance: " ^ exceeded_output))
    (fun () -> update_balance input_balance input_price)

let balance_tests =
  [
    get_balance_test "gets Ryan's balance in example json" "Ryan" "password"
      example_filewrite {|"10000"|};
    get_balance_test "gets Ruijie's balance in test json (diff number)" "Ruijie"
      "456password" test_filewrite2 {|"5090"|};
    get_balance_test "gets Clarkson's balance in test json (decimals)"
      "Clarkson" "789password" test_filewrite2 {|"999.19"|};
    update_balance_test "updates balance 10000 from 100 price" {|"10000"|} "100"
      {|"9900.00"|};
    update_balance_test "increasing a balance" {|"10000"|} "-1000"
      {|"11000.00"|};
    update_balance_test "balance remains the same" {|"10000"|} "0"
      {|"10000.00"|};
    update_balance_test "0 balance" {|"10000"|} "10000" {|"0.00"|};
    update_balance_test_exn "exceeds balance by 100" {|"10000"|} "10100"
      {|"-100.00"|};
    update_balance_test_exn "exceeds balance by 0.01" {|"10000"|} "10000.01"
      {|"-0.01"|};
    update_balance_test_exn "exceeds balance by 10.01" {|"10000"|} "10010.01"
      {|"-10.01"|};
  ]

(** [time_str_test name input_tm expected_output] constructs an OUnit test named
    [name] that asserts the quality of [expected_output] with
    [time_str_test input_tm]. *)
let time_str_test (name : string) (input_tm : Unix.tm)
    (expected_output : string) =
  name >:: fun _ ->
  assert_equal expected_output (time_to_string input_tm) ~printer:pp_string

(* 5/11/2023 *)
let tm1 =
  {
    Unix.tm_sec = 11;
    tm_min = 35;
    tm_hour = 3;
    tm_mday = 11;
    tm_mon = 4;
    tm_year = 123;
    tm_wday = 4;
    tm_yday = 130;
    tm_isdst = true;
  }

(* 2/28/2000 *)
let tm2 = { tm1 with tm_mday = 29; tm_mon = 1; tm_year = 104 }

(* 6/30/2024 *)
let tm3 = { tm1 with tm_mday = 30; tm_mon = 5; tm_year = 124 }

(* 8/31/2023 *)
let tm4 = { tm1 with tm_mday = 31; tm_mon = 7 }

let time_tests =
  [
    time_str_test "output 5/11/2023" tm1 {|"5/11/2023"|};
    time_str_test "output 2/29/2004, leap year" tm2 {|"2/29/2004"|};
    time_str_test "output 6/30/2024, 30-day month" tm3 {|"6/30/2024"|};
    time_str_test "output 8/31/2023, 31-day month" tm4 {|"8/31/2023"|};
  ]

(** [sell_share_test test name username password account_lst stock_name expected output]
    onstructs an OUnit test named [name] that asserts the quality of adding a
    stock to an account and length of the list [expected_output] *)
let sell_share_test (name : string) (username : string) (password : string)
    (account_lst : FileWrite.t) (stock_name : string) (expected_output : int) =
  name >:: fun _ ->
  let new_lst = sell_share username password account_lst stock_name in
  assert_equal expected_output (List.length new_lst) ~printer:string_of_int

let sell_share_tests =
  [
    sell_share_test
      "account 1 selling a share of SPG in example (stock gets deleted)" "Ryan"
      "password" example_filewrite "SPG" 1;
    sell_share_test
      "account 1 selling a share of AAPL in example (share subtracted)" "Ryan"
      "password" example_filewrite "AAPL" 2;
    sell_share_test "account 1 selling a share not in account" "Ryan" "password"
      example_filewrite "NA" 2;
    sell_share_test "account 2 selling a share of TSLA in example" "Andrew"
      "123password" example_filewrite "TSLA" 0;
    sell_share_test "account 2 selling a share not in account" "Andrew"
      "123password" example_filewrite "ROP" 1;
  ]

(** [add_share_length test name username password account_lst stock_name price shares expected output]
    onstructs an OUnit test named [name] that asserts the quality of adding a
    stock to an account and length of the list [expected_output] *)
let add_share_length_test (name : string) (username : string)
    (password : string) (account_lst : FileWrite.t) (stock_name : string)
    (price : string) (shares : string) (expected_output : int) =
  name >:: fun _ ->
  let new_lst =
    edit_accounts username password account_lst stock_name price shares
  in
  let account = get_account username password new_lst in
  assert_equal expected_output
    (List.length account.investedStocks)
    ~printer:string_of_int

(** [add_share_length test name username password account_lst stock_name price shares expected output]
    onstructs an OUnit test named [name] that asserts the quality of adding a
    stock to an account and stock_atributes [expected_output] *)
let add_share_stock_test (name : string) (username : string) (password : string)
    (account_lst : FileWrite.t) (stock_name : string) (price : string)
    (shares : string) (expected_output : string list) =
  name >:: fun _ ->
  let new_lst =
    edit_accounts username password account_lst stock_name price shares
  in
  let stock = check_stock username password new_lst stock_name in
  match stock with
  | None -> assert_equal expected_output [ "None" ] ~printer:(pp_list pp_string)
  | Some s ->
      assert_equal expected_output
        [ s.name; s.price; s.shares ]
        ~printer:(pp_list pp_string)

let add_share_tests =
  [
    add_share_length_test "adding a stock to user Ryan" "Ryan" "password"
      example_filewrite "SPG" "110.0" "3" 3;
    add_share_length_test "adding a stock to user Andrew" "Andrew" "123password"
      example_filewrite "AAPL" "200.0" "7" 2;
    add_share_stock_test "adding Google stock to Ryan" "Ryan" "password"
      example_filewrite "GOOG" "150.0" "7"
      [ {|"GOOG"|}; {|"150.0"|}; {|"7"|} ];
    add_share_stock_test "adding Google stock to Andrew" "Andrew" "123password"
      example_filewrite "Goog" "150.0" "7"
      [ {|"Goog"|}; {|"150.0"|}; {|"7"|} ];
    add_share_stock_test "adding 7 AAPL stocka to Ruijie" "Ruijie" "456password"
      test_filewrite2 "AAPL" "150.0" "7"
      [ {|"AAPL"|}; {|"150.0"|}; {|"7"|} ];
    add_share_stock_test "adding 0 AAPL stock to Clarkson" "Clarkson"
      "789password" test_filewrite2 "AAPL" "150.0" "0"
      [ {|"AAPL"|}; {|"150.0"|}; {|"0"|} ];
  ]

(** [delete_test name username password lst expected_output] constructs an OUnit
    test named [name] that asserts the quality of [expected_output], which is
    the length of all accounts after deleting account with username [username]
    and password [password] from [lst]. *)
let delete_test (name : string) (username : string) (password : string)
    (lst : FileWrite.t) (expected_output : int) =
  name >:: fun _ ->
  assert_equal expected_output
    (delete_account username password lst |> List.length)
    ~printer:string_of_int

let delete_account_tests =
  [
    delete_test "delete 1 account in list" "Ryan" "password" example_filewrite 2;
    delete_test "delete 2 accounts in list" "Ryan" "password"
      (delete_account "Andrew" "123password" example_filewrite)
      1;
    delete_test "delete all accounts in list" "Ryan" "password"
      (delete_account "Andrew" "123password" example_filewrite
      |> delete_account "Ruijie" "456password")
      0;
    delete_test "delete account with password invalid" "Ryan" "1234565"
      example_filewrite 3;
    delete_test "delete account with username invalid" "123" "password"
      example_filewrite 3;
  ]

(** [add_account_test name username password lst expected_output] constructs an
    OUnit test named [name] that asserts the quality of [expected_output], which
    is the length of all accounts after adding account with username [username]
    and password [password] from [lst]. *)
let add_account_test (name : string) (username : string) (password : string)
    (lst : FileWrite.a list) (expected_output : int) =
  name >:: fun _ ->
  assert_equal expected_output
    (make_new_account username password lst |> List.length)
    ~printer:string_of_int

let add_account_tests =
  [
    add_account_test "adding one account to example_filewrite" "John" "Cena"
      example_filewrite 4;
    add_account_test "adding two accounts to example_filewrite" "John" "Cena"
      (example_filewrite |> make_new_account "Hi" "pass")
      5;
    add_account_test "adding multiple accounts to example_filewrite" "John"
      "Cena"
      (example_filewrite
      |> make_new_account "Hi" "pass"
      |> make_new_account "Hello" "123"
      |> make_new_account "Dexter" "Kozen"
      |> make_new_account "Albert" "Albert")
      8;
  ]

(** [net_gain_test name username password lst expected_output] constructs an
    OUnit test named [name] that asserts the quality of [expected_output], which
    is the length of all accounts after adding account with username [username]
    and password [password] from [lst]. *)
let net_gain_test (name : string)
    (lst_input : (string * string * string * string) list)
    (expected_output : float) =
  name >:: fun _ ->
  assert_equal expected_output (net_gain lst_input) ~printer:string_of_float

let net_gain_tests =
  [
    net_gain_test "net gain with one stock one share"
      [ ("AAPL", "120", "1", "110") ]
      10.;
    net_gain_test "net gain with one stock two shares"
      [ ("GOOG", "230", "2", "229") ]
      2.;
    net_gain_test "net gain with two stocks"
      [ ("GOOG", "230", "2", "229"); ("MSFT", "309", "3", "203") ]
      320.;
    net_gain_test "net gain negative" [ ("TSLA", "109", "3", "302") ] ~-.579.;
  ]

let suite =
  "test suite"
  >::: List.flatten
         [
           operations_tests;
           time_tests;
           get_account_tests;
           stocks_tests;
           balance_tests;
           sell_share_tests;
           add_share_tests;
           delete_account_tests;
           add_account_tests;
           net_gain_tests;
         ]

let _ = run_test_tt_main suite
