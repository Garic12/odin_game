package game

import rl "vendor:raylib"

Player :: struct {
	pos:         rl.Vector2,
	vel:         rl.Vector2,
	speed:       f32,
	is_grounded: bool,
}

Platform :: struct {
	rec:         rl.Rectangle,
	walkthrough: bool,
}

Level :: struct {
	platforms: [dynamic]Platform,
}

tile_rect :: proc(x, y, width, height: f32) -> rl.Rectangle {
	return {x * TILE_SIZE, y * TILE_SIZE, width * TILE_SIZE, height * TILE_SIZE}
}

player_rect :: proc(player: Player) -> rl.Rectangle {
	return {player.pos.x, player.pos.y, PLAYER_SIZE, PLAYER_SIZE}
}

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
	rl.SetTargetFPS(TARGET_FPS)

	// Create level
	level: Level
	append(&level.platforms, Platform{rec = tile_rect(5, 0, 5, 1), walkthrough = true})
	append(&level.platforms, Platform{rec = tile_rect(10, 2, 5, 3), walkthrough = true})

	player := Player {
		pos         = {5 * TILE_SIZE, -1 * TILE_SIZE},
		speed       = 60,
		is_grounded = true,
	}

	camera := rl.Camera2D {
		target   = player.pos,
		offset   = {WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2},
		rotation = 0.0,
		zoom     = 2.0,
	}

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		// Input
		dx: f32
		if rl.IsKeyDown(.A) {
			dx = -player.speed * dt
		} else if rl.IsKeyDown(.D) {
			dx = player.speed * dt
		}

		// Horizontal movement and collision
		if dx != 0 {
			player.pos.x += dx
			for platform in level.platforms {
				if !rl.CheckCollisionRecs(player_rect(player), platform.rec) do continue
				player.pos.x =
					dx > 0 ? platform.rec.x - PLAYER_SIZE : platform.rec.x + platform.rec.width
			}
		}

		// Horizontal movement and collision
		player.vel.y += GRAVITY * dt
		if player.is_grounded && rl.IsKeyPressed(.SPACE) {
			player.vel.y = -JUMP_SPEED
		}
		player.pos.y += player.vel.y * dt
		for platform in level.platforms {
			if !rl.CheckCollisionRecs(player_rect(player), platform.rec) do continue
			if player.vel.y > 0 {
				player.pos.y = platform.rec.y - PLAYER_SIZE
			} else if player.vel.y < 0 {
				player.pos.y = platform.rec.y + platform.rec.height
			}
			player.vel.y = 0
		}

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)
		rl.BeginMode2D(camera)
		// Draw level and player
		for platform in level.platforms {
			rl.DrawRectangleRec(platform.rec, rl.GRAY)
		}
		rl.DrawRectangleRec(player_rect(player), rl.GREEN)

		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}

