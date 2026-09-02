package game

import rl "vendor:raylib"

Player :: struct {
	pos: rl.Vector2,
	vel: rl.Vector2,

	speed: f32,

	state: Player_State,

	on_ground: bool,
}

Player_State :: enum {
	Idle,
	Running,
	Jumping,
}

Level :: struct {
	platforms: [dynamic]Platform,
	tile_size: i32,
}

Platform :: struct {
	pos: rl.Vector2,
	size: rl.Vector2,
}

level_draw :: proc() {

}

level_fabric :: proc() -> Level {
	level := Level{tile_size = 32}

	append(&level.platforms, Platform{rect = {0, 2, 4, 5}})
	platform1 := Platform{rl.Rectangle{}}
}

camera: rl.Camera2D

main :: proc() {
	rl.InitWindow(1280, 720, "My Odin + Raylib game")

	level := level_fabric()

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})
		rl.EndDrawing()
	}

	rl.CloseWindow()
}