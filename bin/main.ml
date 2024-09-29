open Raylib

let setup () =
  init_window 800 450 "raylib [core] example - basic window";
  set_target_fps 60
;;

let rec loop () =
  if window_should_close () then close_window () else begin_drawing ();
  clear_background Color.raywhite;
  draw_text "Congrats! You created your first window!!!" 190 200 20 Color.lightgray;
  end_drawing ();
  loop ()
;;

let () = setup () |> loop
