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
}

Platform :: struct {
	pos: rl.Vector2,
	size: rl.Vector2,
}

level_draw :: proc(level: ^Level) {
	for platform in level.platforms {
		rl.DrawRectangle(i32(platform.pos.x * TILE_SIZE), i32(platform.pos.y * TILE_SIZE), i32(platform.size.x * TILE_SIZE), i32(platform.size.y * TILE_SIZE), rl.GRAY)
	}
}

level_fabric :: proc() -> Level {
	level: Level

	append(&level.platforms, Platform{pos = {5, 0}, size = {5, 1}})

	return level
}

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)

	player := Player{pos = {5,1}}
	level := level_fabric()
	camera := rl.Camera2D{target = player.pos * TILE_SIZE, offset = {WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2}, rotation = 0.0, zoom = 1.0}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})

		rl.BeginMode2D(camera)
		level_draw(&level)
		rl.EndMode2D()

		rl.EndDrawing()
	}

	rl.CloseWindow()
}