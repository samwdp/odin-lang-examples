package main
import math "core:math"
import rl "vendor:raylib"

MAX_COLUMNS :: 20
main :: proc() {
    using rl
    InitWindow(800, 450, "raylib [core] example - basic window")
    defer CloseWindow()
    camera := Camera{}
    camera.position = Vector3{0.0, 2.0, 4.0}
    camera.target = Vector3{0.0, 2.0, 0.0} // Camera looking at point
    camera.up = Vector3{0.0, 1.0, 0.0} // Camera up vector (rotation towards target)
    camera.fovy = 60.0 // Camera field-of-view Y
    camera.projection = CameraProjection.PERSPECTIVE

    cameraMode := CameraMode.FIRST_PERSON
    heights := make([]f32, MAX_COLUMNS)
    positions := make([]Vector3, MAX_COLUMNS)
    colors := make([]Color, MAX_COLUMNS)

    for i in 0 ..< MAX_COLUMNS {
        heights[i] = f32(GetRandomValue(1, 12))
        positions[i] = Vector3 {
            f32(GetRandomValue(-15, 15)),
            f32(heights[i] / 2),
            f32(GetRandomValue(-15, 15)),
        }
        colors[i] = Color {
            u8(GetRandomValue(20, 255)),
            u8(GetRandomValue(10, 55)),
            30,
            255,
        }
    }

    DisableCursor() // Limit cursor to relative movement inside the window

    SetTargetFPS(60)
    for !WindowShouldClose() {
        if (IsKeyPressed(KeyboardKey.ONE)) {
            cameraMode = CameraMode.FREE
            camera.up = Vector3{0.0, 1.0, 0.0} // Reset roll
        }

        if (IsKeyPressed(KeyboardKey.TWO)) {
            cameraMode = CameraMode.FIRST_PERSON
            camera.up = Vector3{0.0, 1.0, 0.0} // Reset roll
        }

        if (IsKeyPressed(KeyboardKey.THREE)) {
            cameraMode = CameraMode.THIRD_PERSON
            camera.up = Vector3{0.0, 1.0, 0.0} // Reset roll
        }

        if (IsKeyPressed(KeyboardKey.FOUR)) {
            cameraMode = CameraMode.ORBITAL
            camera.up = Vector3{0.0, 1.0, 0.0} // Reset roll
        }
        if (IsKeyPressed(KeyboardKey.P)) {
            if (camera.projection == CameraProjection.PERSPECTIVE) {
                // Create isometric view
                cameraMode = CameraMode.THIRD_PERSON
                // Note: The target distance is related to the render distance in the orthographic projection
                camera.position = Vector3{0.0, 2.0, -100.0}
                camera.target = Vector3{0.0, 2.0, 0.0}
                camera.up = Vector3{0.0, 1.0, 0.0}
                camera.projection = CameraProjection.ORTHOGRAPHIC
                camera.fovy = 20.0 // near plane width in CAMERA_ORTHOGRAPHIC
                CameraYaw(&camera, -135 * DEG2RAD, true)
                CameraPitch(&camera, -45 * DEG2RAD, true, true, false)
            } else if (camera.projection == CameraProjection.ORTHOGRAPHIC) {
                // Reset to default view
                cameraMode = CameraMode.THIRD_PERSON
                camera.position = Vector3{0.0, 2.0, 10.0}
                camera.target = Vector3{0.0, 2.0, 0.0}
                camera.up = Vector3{0.0, 1.0, 0.0}
                camera.projection = CameraProjection.PERSPECTIVE
                camera.fovy = 60.0
            }
        }
        UpdateCamera(&camera, cameraMode)
        BeginDrawing()
        ClearBackground(RAYWHITE)
        BeginMode3D(camera)
        DrawPlane(Vector3{0.0, 0.0, 0.0}, Vector2{32.0, 32.0}, LIGHTGRAY) // Draw ground
        DrawCube(Vector3{-16.0, 2.5, 0.0}, 1.0, 5.0, 32.0, BLUE) // Draw a blue wal
        DrawCube(Vector3{16.0, 2.5, 0.0}, 1.0, 5.0, 32.0, LIME) // Draw a green wall
        DrawCube(Vector3{0.0, 2.5, 16.0}, 32.0, 5.0, 1.0, GOLD)
        for i in 0 ..< MAX_COLUMNS {
            DrawCube(positions[i], 2.0, heights[i], 2.0, colors[i])
            DrawCubeWires(positions[i], 2.0, heights[i], 2.0, MAROON)
        }

        // Draw player cube
        if (cameraMode == CameraMode.THIRD_PERSON) {
            DrawCube(camera.target, 0.5, 0.5, 0.5, PURPLE)
            DrawCubeWires(camera.target, 0.5, 0.5, 0.5, DARKPURPLE)
        }

        EndMode3D()
        DrawRectangle(5, 5, 330, 100, Fade(SKYBLUE, 0.5))
        DrawRectangleLines(5, 5, 330, 100, BLUE)
        DrawText("Camera controls:", 15, 15, 10, BLACK)
        DrawText(
            "- Move keys: W, A, S, D, Space, Left-Ctrl",
            15,
            30,
            10,
            BLACK,
        )
        DrawText("- Look around: arrow keys or mouse", 15, 45, 10, BLACK)
        DrawText("- Camera mode keys: 1, 2, 3, 4", 15, 60, 10, BLACK)
        DrawText(
            "- Zoom keys: num-plus, num-minus or mouse scroll",
            15,
            75,
            10,
            BLACK,
        )
        DrawText("- Camera projection key: P", 15, 90, 10, BLACK)
        DrawRectangle(600, 5, 195, 100, Fade(SKYBLUE, 0.5))
        DrawRectangleLines(600, 5, 195, 100, BLUE)

        DrawText("Camera status:", 610, 15, 10, BLACK)
        DrawText(
            TextFormat(
                "- Mode: %s",
                (cameraMode == CameraMode.FREE) \
                ? "FREE" \
                : (cameraMode == CameraMode.FIRST_PERSON) \
                ? "FIRST_PERSON" \
                : (cameraMode == CameraMode.THIRD_PERSON) \
                ? "THIRD_PERSON" \
                : (cameraMode == CameraMode.ORBITAL) ? "ORBITAL" : "CUSTOM",
            ),
            610,
            30,
            10,
            BLACK,
        )
        DrawText(
            TextFormat(
                "- Projection: %s",
                (camera.projection == CameraProjection.PERSPECTIVE) \
                ? "PERSPECTIVE" \
                : (camera.projection == CameraProjection.ORTHOGRAPHIC) \
                ? "ORTHOGRAPHIC" \
                : "CUSTOM",
            ),
            610,
            45,
            10,
            BLACK,
        )
        DrawText(
            TextFormat(
                "- Position: (%06.3f, %06.3f, %06.3f)",
                camera.position.x,
                camera.position.y,
                camera.position.z,
            ),
            610,
            60,
            10,
            BLACK,
        )
        DrawText(
            TextFormat(
                "- Target: (%06.3f, %06.3f, %06.3f)",
                camera.target.x,
                camera.target.y,
                camera.target.z,
            ),
            610,
            75,
            10,
            BLACK,
        )
        DrawText(
            TextFormat(
                "- Up: (%06.3f, %06.3f, %06.3f)",
                camera.up.x,
                camera.up.y,
                camera.up.z,
            ),
            610,
            90,
            10,
            BLACK,
        )


        EndDrawing()
    }
}

CameraPitch :: proc(
    camera: ^rl.Camera,
    angle: f32,
    lockView: bool,
    rotateAroundTarget: bool,
    rotateUp: bool,
) {
    using rl

    _angle := angle
    // Up direction
    up := GetCameraUp(camera)

    // View vector
    targetPosition := camera.target - camera.position
    // targetPosition := Vector3Subtract(camera.target, camera.position)

    if (lockView) {
        // In these camera modes we clamp the Pitch angle
        // to allow only viewing straight up or down.

        // Clamp view up
        maxAngleUp := Vector3Angle(up, targetPosition)
        maxAngleUp -= 0.001 // avoid numerical errors
        if (angle > maxAngleUp) do _angle = maxAngleUp

        // Clamp view down
        maxAngleDown := Vector3Angle(-up, targetPosition)
        maxAngleDown *= -1.0 // downwards angle is negative
        maxAngleDown += 0.001 // avoid numerical errors
        if (angle < maxAngleDown) do _angle = maxAngleDown
    }

    // Rotation axis
    right := GetCameraRight(camera)

    // Rotate view vector around right axis
    targetPosition = Vector3RotateByAxisAngle(targetPosition, right, _angle)

    if (rotateAroundTarget) {
        // Move position relative to target
        camera.position = camera.target - targetPosition
    } else // rotate around camera.position
    {
        // Move target relative to position
        camera.target = camera.position + targetPosition
    }

    if (rotateUp) {
        // Rotate up direction around right axis
        camera.up = Vector3RotateByAxisAngle(camera.up, right, _angle)
    }
}

/* This is translated from the rl camera module. 
 * This is missing from the vendor library so need to do this manually 
 */
CameraYaw :: proc(camera: ^rl.Camera, angle: f32, rotateAroundTarget: bool) {
    using rl
    up := GetCameraUp(camera)
    targetPosition := camera.target - camera.position
    targetPosition = Vector3RotateByAxisAngle(targetPosition, up, angle)
    if (rotateAroundTarget) {
        // Move position relative to target
        camera.position = camera.target - targetPosition
    } else // rotate around camera.position
    {
        // Move target relative to position
        camera.target = camera.position + targetPosition
    }
}

GetCameraUp :: proc(camera: ^rl.Camera) -> rl.Vector3 {
    return rl.Vector3Normalize(camera.up)
}

GetCameraRight :: proc(camera: ^rl.Camera) -> rl.Vector3 {
    forward := GetCameraForward(camera)
    up := GetCameraUp(camera)

    return rl.Vector3Normalize(rl.Vector3CrossProduct(forward, up))
}

GetCameraForward :: proc(camera: ^rl.Camera) -> rl.Vector3 {
    return rl.Vector3Normalize(camera.target - camera.position)
}
