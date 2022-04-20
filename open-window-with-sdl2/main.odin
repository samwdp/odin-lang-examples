package main

import "core:fmt"
import SDL "vendor:sdl2"

SdlContext :: struct {
    window:   ^SDL.Window,
    renderer: ^SDL.Renderer,
    close:    bool,
}

ctx := SdlContext{}

r, g, b: u8 = 0, 0, 0

process_input_sdl :: proc() {
    event: SDL.Event

    for SDL.PollEvent(&event) != 0 {
        #partial switch event.type {
        case .KEYDOWN:
            #partial switch event.key.keysym.sym {
            case .ESCAPE:
                ctx.close = true
                break
            case .R:
                r += 1
                break
            case .G:
                g += 1
                break
            case .B:
                b += 1
                break
            }
        case .QUIT:
            ctx.close = true
            break
        }
    }
}

draw_sdl :: proc() {
    SDL.SetRenderDrawColor(ctx.renderer, r, g, b, 0xff)
    SDL.RenderClear(ctx.renderer)
    fmt.println("red", r, "green", g, "blue", b)
    SDL.RenderPresent(ctx.renderer)
}

cleanup_sdl :: proc() {
    SDL.DestroyRenderer(ctx.renderer)
    SDL.DestroyWindow(ctx.window)
}

setup_window_sdl :: proc(WINDOW_TITLE: cstring, width, height: i32) -> bool {
    window_flags := SDL.WindowFlags{.SHOWN, .OPENGL}
    ctx.window = SDL.CreateWindow(
        WINDOW_TITLE,
        SDL.WINDOWPOS_UNDEFINED,
        SDL.WINDOWPOS_UNDEFINED,
        width,
        height,
        window_flags,
    )
    if ctx.window == nil {
        fmt.eprint("%v was unable to be created \n", ctx.window)
        return false
    }

    render_flags := SDL.RendererFlags{.ACCELERATED, .PRESENTVSYNC}
    ctx.renderer = SDL.CreateRenderer(ctx.window, -1, render_flags)
    if ctx.window == nil {
        fmt.eprint("%v was unable to be created \n", ctx.renderer)
        return false
    }
    return true
}

main_loop_sdl :: proc() {
    for !ctx.close {
        process_input_sdl()
        draw_sdl()
    }
}

main :: proc() {
    if !setup_window_sdl("Test title", 1920, 1080) {
        fmt.eprintln("Unable to initialise window")
    }
    defer cleanup_sdl()
    main_loop_sdl()
}
