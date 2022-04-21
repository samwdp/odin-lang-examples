package main

import "core:fmt"
import "vendor:glfw"
import gl "vendor:OpenGL"

Context :: struct {
    window: glfw.WindowHandle,
    close:  bool,
}

ctx := Context{}

cleanup :: proc() {
    glfw.DestroyWindow(ctx.window)
    glfw.Terminate()
}

r, g, b: f32 = 0.0, 0.0, 0.0

handle_events :: proc() {
    glfw.PollEvents()
    if glfw.GetKey(ctx.window, glfw.KEY_ESCAPE) == glfw.PRESS {
        ctx.close = true
        glfw.SetWindowShouldClose(ctx.window, true)
        glfw.Terminate()
    }

    if glfw.GetKey(ctx.window, glfw.KEY_R) == glfw.PRESS {
        r += 0.01
        if r > 1 {
            r = 0
        }
    }
    if glfw.GetKey(ctx.window, glfw.KEY_G) == glfw.PRESS {
        g += 0.01
        if g > 1 {
            g = 0
        }

    }
    if glfw.GetKey(ctx.window, glfw.KEY_B) == glfw.PRESS {
        b += 0.01
        if b > 1 {
            b = 0
        }
    }
}

draw :: proc() {
    width, height := glfw.GetFramebufferSize(ctx.window)
    fmt.println("red", r, "green", g, "blue", b)
    gl.Viewport(0, 0, width, height)
    gl.Clear(gl.COLOR_BUFFER_BIT)
    gl.ClearColor(r, g, b, 1.0)
    glfw.SwapBuffers(ctx.window)
}

loop :: proc() {
    for !ctx.close {
        draw()
        handle_events()
    }
}

setup_window :: proc() -> bool {
    glfw.Init()
    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 3)
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
    ctx.window = glfw.CreateWindow(1920, 1080, "Learn Open GL", nil, nil)
    if ctx.window == nil {
        fmt.eprintln("Unable to create window")
        return false
    }

    glfw.MakeContextCurrent(ctx.window)
    glfw.SwapInterval(1)
    set_proc_address :: proc(p: rawptr, name: cstring) {
        (cast(^rawptr)p)^ = rawptr(glfw.GetProcAddress(name))
    }
    gl.load_up_to(3, 3, set_proc_address)
    return true
}

main :: proc() {
    if !setup_window() {
        fmt.eprintln("Unable to setup window")
        glfw.Terminate()
    }
    defer cleanup()
    loop()
}
