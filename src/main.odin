package game

import rl "vendor:raylib"

Player :: struct {
	pos: rl.Vector2,
	vel: rl.Vector2,
}

Level :: struct {
	platforms: [dynamic]rl.Rectangle,
}

tile_rect :: proc(x, y, width, height: f32) -> rl.Rectangle {
	return {x * TILE_SIZE, y * TILE_SIZE, width * TILE_SIZE, height * TILE_SIZE}
}

player_rect :: proc(player: Player) -> rl.Rectangle {
	return {player.pos.x, player.pos.y, PLAYER_SIZE, PLAYER_SIZE}
}


main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
	rl.SetTargetFPS(TARGET_FPS);
	
	level: Level
	append(&level.platforms, rl.Rectangle(tile_rect(5, 0, 5, 1)))
	append(&level.platforms, rl.Rectangle(tile_rect(10, 2, 5, 3)))
	
	player := Player{pos = {5 * TILE_SIZE, 1 * TILE_SIZE}}

	camera := rl.Camera2D{
		target   = player.pos,
		offset   = {WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2},
		rotation = 0.0,
		zoom     = 2.0,
	}

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)
		
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)
		rl.BeginMode2D(camera)

		for platform in level.platforms {
			rl.DrawRectangleRec(platform, rl.GRAY)
		}
		rl.DrawRectangleRec(player_rect(player), rl.GREEN)

		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}