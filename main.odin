package wordle

import "core:fmt"
import "core:reflect"
import k2 "karl2d"

Letter :: enum {
	None,
	A,
	B,
	C,
	D,
	E,
	F,
	G,
	H,
	I,
	J,
	K,
	L,
	M,
	N,
	O,
	P,
	Q,
	R,
	S,
	T,
	U,
	V,
	W,
	X,
	Y,
	Z,
}

LetterState :: enum {
	Default,
	Absent,
	Present,
	Correct,
}

Row :: struct {
	letters: [5]Letter,
}

GameBoard :: struct {
	rows:          [6]Row,
	letter_states: [Letter]LetterState,
	color_states:  [LetterState]k2.Color,
	size:          f32,
	spacing:       f32,
	active_row:    int,
}

get_active_row :: proc(game_board: ^GameBoard) -> ^Row {
	return &game_board.rows[game_board.active_row]
}

submit_active_row :: proc(game_board: ^GameBoard) {
	if game_board.active_row < len(game_board.rows) - 1 {
		game_board.active_row += 1
	}
}

main :: proc() {
	game_board := GameBoard{}
	game_board.size = 70
	game_board.spacing = 5
	game_board.color_states[.Default] = k2.DARK_GRAY
	game_board.color_states[.Absent] = k2.DARK_GRAY
	game_board.color_states[.Present] = {181, 159, 59, 255}
	game_board.color_states[.Correct] = {83, 141, 78, 255}

	init(&game_board)
	for step(&game_board) {}
	shutdown()
}

init :: proc(game_board: ^GameBoard) {
	k2.init(1280, 720, "Greetings from Karl2D!", {.Windowed_Resizable, false, false})
	k2.set_window_position(1280, 360)
}

step :: proc(game_board: ^GameBoard) -> bool {
	if !k2.update() {
		return false
	}

	// Inputs
	active_row := get_active_row(game_board)

	for event, i in k2.get_events() {
		#partial switch e in event {
		case k2.Event_Key_Went_Down:
			current_letter := keys_to_letters(e.key)

			// Fill active row.
			if current_letter != .None {
				for &letter in active_row.letters {
					if letter != Letter.None {
						continue
					}

					letter = current_letter
					break
				}
			} else if e.key == k2.Keyboard_Key.Backspace {
				// Remove last letter from active row.
				#reverse for &letter in active_row.letters {
					if letter != Letter.None {
						letter = Letter.None
						break
					}
				}
			} else if e.key == k2.Keyboard_Key.Enter {
				// submit_active_row(game_board)
			}
		}
	}


	// for key, state in k2.get_keyboard_state() {
	// 	if state == k2.KeyState.Pressed {
	// 		letter := keys_to_letters(key)

	// 		if letter == .None {
	// 			continue
	// 		}

	// 		for i, l in active_row.letters {
	// 			if l == Letter.None {
	// 				active_row.letters[i] = letter
	// 				break
	// 			}
	// 		}
	// 	}
	// } else if key == k2.Keyboard_Key.Backspace {
	// 	for i := len(active_row.letters) - 1; i >= 0; i-- {
	// 		if active_row.letters[i] != Letter.None {
	// 			active_row.letters[i] = Letter.None
	// 			break
	// 		}
	// 	}
	// } else if key == k2.Keyboard_Key.Enter {
	// 	submit_active_row(game_board)
	// }
	// }

	// Render
	k2.clear(k2.BLACK)

	render_game_board(game_board)

	k2.present()

	return true
}

shutdown :: proc() {
	k2.shutdown()
}

render_game_board :: proc(game_board: ^GameBoard) {
	board_width: f32 = game_board.size * 5 + game_board.spacing * 4
	screen_size := k2.get_screen_size()

	x: f32 = (screen_size.x - board_width) * 0.5
	y: f32 = game_board.spacing

	for row, _ in game_board.rows {
		x = (screen_size.x - board_width) * 0.5
		for letter, _ in row.letters {
			state := game_board.letter_states[letter]

			switch state {
			case LetterState.Default:
				k2.draw_rect_outline(
					{x, y, game_board.size, game_board.size},
					2,
					game_board.color_states[state],
				)
			case LetterState.Absent:
				k2.draw_rect(
					{x, y, game_board.size, game_board.size},
					game_board.color_states[state],
				)
			case LetterState.Present:
				k2.draw_rect(
					{x, y, game_board.size, game_board.size},
					game_board.color_states[state],
				)
			case LetterState.Correct:
				k2.draw_rect(
					{x, y, game_board.size, game_board.size},
					game_board.color_states[state],
				)
			}

			if letter != Letter.None {
				text := reflect.enum_string(letter)
				text_size := k2.measure_text(text, game_board.size)
				text_centered_x := x + (game_board.size - text_size.x) * 0.5
				text_centered_y := y + (game_board.size - text_size.y) * 0.5

				k2.draw_text(text, {text_centered_x, text_centered_y}, game_board.size, k2.WHITE)
			}

			x += game_board.size + game_board.spacing
		}

		y += game_board.size + game_board.spacing
	}
}

keys_to_letters :: proc(key: k2.Keyboard_Key) -> Letter {
	#partial switch key {
	case .A:
		return Letter.A
	case .B:
		return Letter.B
	case .C:
		return Letter.C
	case .D:
		return Letter.D
	case .E:
		return Letter.E
	case .F:
		return Letter.F
	case .G:
		return Letter.G
	case .H:
		return Letter.H
	case .I:
		return Letter.I
	case .J:
		return Letter.J
	case .K:
		return Letter.K
	case .L:
		return Letter.L
	case .M:
		return Letter.M
	case .N:
		return Letter.N
	case .O:
		return Letter.O
	case .P:
		return Letter.P
	case .Q:
		return Letter.Q
	case .R:
		return Letter.R
	case .S:
		return Letter.S
	case .T:
		return Letter.T
	case .U:
		return Letter.U
	case .V:
		return Letter.V
	case .W:
		return Letter.W
	case .X:
		return Letter.X
	case .Y:
		return Letter.Y
	case .Z:
		return Letter.Z
	}

	return .None
}
