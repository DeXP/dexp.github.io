---
layout: page
subheadline: "GUI"
title:  "Nuklear — ideal GUI for tiny projects?"
teaser: "Nuklear is a library for creating immediate mode user interfaces. The library does not have any dependencies (C89 only! Only hardcore!). But also does not know how to create operating system windows or perform real rendering. Nuklear is an embedded library that provides user-friendly interfaces for rendering by implemented application. There are examples on WinAPI, X11, SDL, Allegro, GLFW, OpenGL, DirectX. The parent of the concept was the <a href='https://github.com/ocornut/imgui'>ImGUI</a> library."
categories: articles
tags:
    - articles
    - linux
    - c
    - gui
    - tiny
    - nuklear
    - opengl
image:
   thumb: "thumb/nuklear.png"
header:
    image_fullwidth: "other/nk/nuklear-header.png"
comments: true
---

[![Nuklear simpliest demo]({{ site.urlimg }}other/nk/start-demo.png "Nuklear simpliest demo"){: .left }](https://dexp.github.io/nuklear-webdemo/)

Is Nuklear something specific? It has a small size (about 15 thousand lines of code), is fully contained in one header file, was created with an emphasis on portability and ease of use. Public Domain license.

[Nuklear webdemo ›](https://dexp.github.io/nuklear-webdemo/)
{: .t30 .button .radius}


### Formulation of the problem

I often have problems for solving of which I have to write small utilities in several hundred lines of code. Usually, the result is a console application, which no one can really use except me. Can a simple GUI make these utilities more convenient?

The requirements to the result:

1. Small size, up to hundreds of kilobytes.
2. Cross-platform, to begin with, at least Windows and Linux.
3. No dependency on external libraries in Windows, everything should be in one EXE file.
4. A decent/beautiful appearance.
5. Support images in JPG and PNG formats.
6. Ease of development, the ability to develop in Windows and Linux.

Will Nuklear succeed?

![Nuklear node edit example]({{ site.urlimg }}other/nk/node-edit.png "Nuklear node edit example")


For example, let's look at the creation of the utility [dxBin2h]({{ site.url }}/tools/dxbin2h/) - it reads the file byte by byte and writes it as a C-array. The program has some sorts of "buns", such as removing unnecessary characters etc. Usually, small utilities are created for the sake of a third-party functionality... For example, dxBin2h was created for [Winter Novel]({{ site.url }}/games/winternovel/), for preprocessing ASCII files.


### Ease of development, cross-platform

![Nuklear gwen skin]({{ site.urlimg }}other/nk/gwen-skin.png "Nuklear gwen skin"){: .right }

There should not exist any problems with the simplicity of development, right? After all, the library was created with a focus on the simplicity. You can find simple example directly in Readme on GitHub. Absolutely clear and concise 20 lines of code give a beautiful and clear result.

```c
/* init gui state */
struct nk_context ctx;
nk_init_fixed(&ctx, calloc(1, MAX_MEMORY), MAX_MEMORY, &font);

enum {EASY, HARD};
int op = EASY;
float value = 0.6f;
int i =  20;

if (nk_begin(&ctx, "Show", nk_rect(50, 50, 220, 220),
    NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_CLOSABLE)) {
    /* fixed widget pixel width */
    nk_layout_row_static(&ctx, 30, 80, 1);
    if (nk_button_label(&ctx, "button")) {
        /* event handling */
    }

    /* fixed widget window ratio width */
    nk_layout_row_dynamic(&ctx, 30, 2);
    if (nk_option_label(&ctx, "easy", op == EASY)) op = EASY;
    if (nk_option_label(&ctx, "hard", op == HARD)) op = HARD;

    /* custom widget pixel width */
    nk_layout_row_begin(&ctx, NK_STATIC, 30, 2);
    {
        nk_layout_row_push(&ctx, 50);
        nk_label(&ctx, "Volume:", NK_TEXT_LEFT);
        nk_layout_row_push(&ctx, 110);
        nk_slider_float(&ctx, 0, &value, 1.0f, 0.1f);
    }
    nk_layout_row_end(&ctx);
}
nk_end(&ctx);
```

But not everything is so simple. The GUI calculation part is really simple. But there must be a renderer too. Go to the [demo](https://github.com/vurtun/nuklear/tree/master/demo) folder, choose the one you like. I'm sure it will not be exactly 20 lines, not even 200.  Moreover, all examples draw approximately the same result, but the code is significantly different because of the render.

Example of WinAPI initialization for Nuklear:

```c
static LRESULT CALLBACK
WindowProc(HWND wnd, UINT msg, WPARAM wparam, LPARAM lparam)
{
    switch (msg) {
    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;
    }
    if (nk_gdip_handle_event(wnd, msg, wparam, lparam))
        return 0;
    return DefWindowProcW(wnd, msg, wparam, lparam);
}

int main(void)
{
    GdipFont* font;
    struct nk_context *ctx;

    WNDCLASSW wc;
    RECT rect = { 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT };
    DWORD style = WS_OVERLAPPEDWINDOW;
    DWORD exstyle = WS_EX_APPWINDOW;
    HWND wnd;
    int running = 1;
    int needs_refresh = 1;

    /* Win32 */
    memset(&wc, 0, sizeof(wc));
    wc.lpfnWndProc = WindowProc;
    wc.hInstance = GetModuleHandleW(0);
    wc.hIcon = LoadIcon(NULL, IDI_APPLICATION);
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.lpszClassName = L"NuklearWindowClass";
    RegisterClassW(&wc);

    AdjustWindowRectEx(&rect, style, FALSE, exstyle);

    wnd = CreateWindowExW(exstyle, wc.lpszClassName, L"Nuklear Demo",
        style | WS_VISIBLE, CW_USEDEFAULT, CW_USEDEFAULT,
        rect.right - rect.left, rect.bottom - rect.top,
        NULL, NULL, wc.hInstance, NULL);
```

Example of SDL initialization:

```c
int
main(int argc, char* argv[])
{
    /* Platform */
    SDL_Window *win;
    SDL_GLContext glContext;
    struct nk_color background;
    int win_width, win_height;
    int running = 1;

    /* GUI */
    struct nk_context *ctx;

    /* SDL setup */
    SDL_SetHint(SDL_HINT_VIDEO_HIGHDPI_DISABLED, "0");
    SDL_Init(SDL_INIT_VIDEO);
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
    SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 8);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
    win = SDL_CreateWindow("Demo",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        WINDOW_WIDTH, WINDOW_HEIGHT, SDL_WINDOW_OPENGL
        |SDL_WINDOW_SHOWN|SDL_WINDOW_ALLOW_HIGHDPI);
    glContext = SDL_GL_CreateContext(win);
    SDL_GetWindowSize(win, &win_width, &win_height);
```

### No dependencies in Windows

Well, let's take the SDL2 with OpenGL renderer and get the resulting application for Windows, Linux, Mac OS X, Android, iOS etc! All is super. The only problem here that SDL is not presented in standard Windows. So you have to drag along with you. This violates the first requirement (small size), because the SDL itself weighs about a megabyte.

But in the examples you can see GDI+, which is in Windows starting with XP. GDI+ can TTF-fonts, PNG and JPG pictures, load resources from memory. So there will be 2 possible renderers: GDI+ for Windows and SDL for all other cases. You can place a piece of rendering-dependent code into a separate C-file ([nuklear_cross.c](https://github.com/DeXP/dxBin2h/blob/master/GUI/nuklear_cross.c)). Then the main code will not be overloaded and it will be possible to focus on the interface, which greatly simplifies development. An additional advantage is compilation acceleration - Nuklear will be compiled into a separate object file which will rarely change.

Windows, GDI+ renderer, Arial 12pt font:

![dxBin2h, Windows, GDI+ renderer, Arial 12pt]({{ site.urlimg }}other/nk/b1-win.png "dxBin2h, Windows, GDI+ renderer, Arial 12pt")

Linux, SDL2 with OpenGL renderer, default font:

![dxBin2h, Linux, SDL2 with OpenGL renderer, default font]({{ site.urlimg }}other/nk/b1-lin.png "dxBin2h, Linux, SDL2 with OpenGL renderer, default font")

The application looks very different! And the first thing that catches your eye is the font.



### Font

You need to use the same font to make the application look the same on all operating systems. It would be great to take any system font which is guaranteed to be everywhere. But there is no such font. Therefore, the font must be included in the application. Ttf-fonts usually occupy hundreds of kilobytes. But you can create subsets with the necessary symbols only. [FontSquirrel web service](https://www.fontsquirrel.com/tools/webfont-generator) is a good start. DejaVu Serif was stuck up to 40kb, although it contains Cyrillic, Polish and a whole bunch of languages.

Everything would be fine, but GDI+ driver for Nuklear could not load a font from memory, only from a file. I had [to correct](https://github.com/vurtun/nuklear/pull/318)... By the way, you can include the font into your application with the [dxBin2h]({{ site.url }}/tools/dxbin2h/).


Windows, DejaVu Serif:

![dxBin2h, Windows, DejaVu Serif]({{ site.urlimg }}other/nk/b2-win.png "dxBin2h, Windows, DejaVu Serif")


Linux, DejaVu Serif:

![dxBin2h, Linux, DejaVu Serif]({{ site.urlimg }}other/nk/b2-lin.png "dxBin2h, Linux, DejaVu Serif")

It's much better. But I do not like the look of the checkboxes. And I would like to see pictures.



### Pictures: PNG, JPG

![Nuklear displays images]({{ site.urlimg }}other/nk/nk-img.png "Nuklear displays images"){: .right }

Both SDL2 and GDI+ are able to load pictures. But there is an additional dependency for SDL when loading JPG and PNG - SDL_image. It is pretty simple to get rid of: use [stb_image.h](https://github.com/nothings/stb) if the project is compiling with SDL.

Not everything was good with GDI+ either. Namely, the GDI+ driver for Nuklear was not able to render images using GDI+. I had to implement it myself ([Pull Request](https://github.com/vurtun/nuklear/pull/316)). Now everything is fixed and the code in the official repository.

The code for loading the image via stb_image for OpenGL:

```c
struct nk_image dxNkLoadImageFromMem(const void* buf, int bufSize){
        int x,y,n;
        GLuint tex;
        unsigned char *data = stbi_load_from_memory(buf, bufSize, &x, &y, &n, 0);
        glGenTextures(1, &tex);
        glBindTexture(GL_TEXTURE_2D, tex);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR_MIPMAP_NEAREST);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, x, y, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);
        return nk_image_id((int)tex);
}
```

### Appearance of the application

There is a mechanism for setting styles in Nuklear to change the look of the check boxes. Enabled and disabled check boxes are separate PNG images. The red theme from Nuklear examples ([style.c](https://github.com/vurtun/nuklear/blob/master/demo/style.c) file) is set:

```c
    nk_image checked = dxNkLoadImageFromMem( 
                       (void*)checked_image, sizeof(checked_image) );
    nk_image unchecked = dxNkLoadImageFromMem(
                      (void*)unchecked_image, sizeof(unchecked_image) );

    set_style(ctx, THEME_RED);
    {struct nk_style_toggle *toggle;
        toggle = &ctx->style.checkbox;
        toggle->border = -2; /* cursor must overlap original image */
        toggle->normal          = nk_style_item_image(unchecked);
        toggle->hover           = nk_style_item_image(unchecked);
        toggle->active          = nk_style_item_image(unchecked);
        toggle->cursor_normal   = nk_style_item_image(checked);
        toggle->cursor_hover    = nk_style_item_image(checked);
    }
```

The application in Windows looks like this:

![dxBin2h, Windows, skinned]({{ site.urlimg }}other/nk/b3-win.png "dxBin2h, Windows, skinned")


Linux:

![dxBin2h, Linux, skinned]({{ site.urlimg }}other/nk/b3-lin.png "dxBin2h, Linux, skinned")


### What in the end?

- Windows EXE 200 kb after compiling, 90kb after UPX. The application size in Linux is 100kb larger because of the stb_image.
- Runs correctly on Windows and Linux.
- Font and pictures are stored as arrays in the application memory. No dependencies not from WinAPI in Windows.
- The engine changes the style of the application.
- PNG and JPG are loaded with GDI+ and stb_image.
- All the "dirty" platform-dependent code is in a separate file. The developer focuses on creating an application.


### Known Issues

- Different font smoothing in different operating systems
- Different checkbox sizes
- Different support for images (when using stb_image you need to avoid problematic images)
- Not full support for Unicode with a truncated font
- There is no example on the technologies of Mac OS X


### How to use this know-how

- Clone repository [https://github.com/DeXP/dxBin2h](https://github.com/DeXP/dxBin2h)
- Copy the "GUI" folder to your project
- Include "GUI/nuklear_cross.h", use functions from there
- If you need to update Nuklear files, copy them from the official repository on top of the current ones.


### Conclusion

The application looks a little different on different operating systems. However, the differences are insignificant, the result satisfied me. Nuklear is not in the category "I'm sure it will work everywhere and without testing." But it is in the category "If that is necessary - I can easily finish it".


### Useful links

- [dxBin2h]({{ site.url }}/tools/dxbin2h/) ([GitHub](https://github.com/DeXP/dxBin2h))
- [Nuklear on GitHub](https://github.com/vurtun/nuklear)
- [Nuklear webdemo](https://dexp.github.io/nuklear-webdemo/)
- [List of my edits for the correct working of the GDI+ driver](https://github.com/vurtun/nuklear/commits?author=DeXP)
- [Theme at the GameDev forum, where Nuklear was announced](https://www.gamedev.net/forums/topic/669332-immediate-mode-gui-toolkit/)
- [Discussion "Immediate GUI - yae or nay?"](https://gamedev.stackexchange.com/questions/24103/immediate-gui-yae-or-nay)
- [Example of creating applications on ImGUI](https://eliasdaler.wordpress.com/2016/05/31/imgui-sfml-tutorial-part-1/)

[This article in Russian ›](https://habrahabr.ru/post/319106/) 
{: .t30 .button .radius}


## Other Articles
{: .t60 }
{% include list-posts tag='articles' %}
