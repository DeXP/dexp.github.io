---
layout: page
subheadline: "GUI"
title:  "Nuklear+ — tiny crossplatform GUI"
teaser: 'Nuklear+ (read as "Nuklear cross") is a front-end overlay for Nuklear GUI library. Write one simple code, compile it for any supported frontend.'
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
   thumb: "thumb/nkc.png"
header:
#    image_fullwidth: "other/nk/nuklear-header.png"
    image_fullwidth: "other/nkc/nuklear-demo.png"
imgs_path: "other/nkc/"
comments: true
buttons:
    - caption: "Nuklear+ on GitHub"
      url: "https://github.com/DeXP/nuklear_cross"
      class: "warning"
    - caption: "This article in Russian"
      url: "https://habrahabr.ru/post/338106/"
      class: "info"
---

I have already written about [Nuklear GUI library]({{ site.url }}/articles/nuklear-intro/). The task was pretty simple - to make a small cross-platform utility, that will look the same way on Windows and Linux. But I have always been interested, can Nuklear make more complicated GUI or not?

[Wordlase web demo ›](https://wordlase.dexp.in/)
{: .t30 .button .radius}

That's why the [Wordlase](http://store.steampowered.com/app/602930/Wordlase/) game was made completely on Nuklear. There are no OpenGL functions used in the game. Only pure Nuklear's function set. And it does not matter for the game, which concrete renderer used in the game. The low-level rendering functions are completely hidden by Nuklear. Even background images have *nk_image* type.

In my previous article I started to work on [Nuklear+](https://github.com/DeXP/nuklear_cross), read as "Nuklear cross", means "Cross-platform Nuklear". Nuklear+ aims to hide all OS code from the programmer and give him ability to focus on GUI code. The library can load images and fonts, can manage OS window and drawing context for you. 

You can see the complete code example on GitHub [Readme file](https://github.com/DeXP/nuklear_cross). As you can see, the code is pretty simple. Also, I moved my [dxBin2h](https://github.com/DeXP/dxBin2h) and [nuklear-webdemo](https://github.com/DeXP/nuklear-webdemo) to Nuklear+ too. It was pretty simple, I just replaced all initialization with one function call *nkc_init*, events handling with *nkc_poll_events*, render with *nkc_render* and finalization with *nkc_shutdown*.

{% include image path="nuklear-demo.png" caption="Nuklear demo" link=true %}


But let's return to Wordlase. It has a [web demo](https://wordlase.dexp.in) now. I do not write any web-specific code in the game - it's C89 application, compiled with [Emscripten](https://kripken.github.io/emscripten-site/). If you follow the example (use of *nkc_set_main_loop*) than you will get web-version of your application for free.



### Backends and Frontends

The most interesting part of the Nuklear+ is supported frontends and backends. Frontend, in that case, means the part that initializes all OS-specific stuff. You can see implementation in the [nkc_frontend](https://github.com/DeXP/nuklear_cross/tree/master/nkc_frontend) folder. Currently supported: SDL, GLFW, X11, GDI+ frontends. They are not equal. For example, GDI+ uses WinAPI even for font rendering and image loading. So the resulting picture can be different. The implemented abilities are not equal too. For example, X11 frontend can't change display resolution in fullscreen mode yet (pull requests are welcome). 

How to select frontend? Define *NKCD=NKC_x* where *x* is one of: SDL, GLFW, XLIB, GDIP. For example: *gcc -DNKCD=NKC_GLFW main.c*

The backend is making an actual rendering. It is in [nuklear_drivers](https://github.com/DeXP/nuklear_cross/tree/master/nuklear_drivers) folder. The OpenGL renderers will give pretty similar picture since they use equal functions for drawing and [stb_image](https://github.com/nothings/stb) for pictures rendering. The pure X11 can't even load fonts. So do not forget to test your application for your selected frontend+backend pair.

{% include image path="wl-glfw-win32.jpg" caption="Wordlase, GLFW3, OpenGL 2, Windows" link=true %}

{% include image path="wl-sdl-linux.jpg" caption="Wordlase, SDL2, OpenGL ES, Linux" link=true %}

As you can see, the picture is the same. If there are any differences - it's just a JPEG's compression artifacts.

How to select backend? In general OpenGL 2 will be used by default. You can define *NKC_USE_OPENGL=3* for OpenGL 3, or *NKC_USE_OPENGL=NGL_ES2* for Open GL ES 2.0 if supported. Do not define *NKC_USE_OPENGL* if you want to use pure X11. OpenGL options do not affect GDI+ - it's always WinAPI only.

Let's see a GDI+ screen shoot too:

{% include image path="wl-gdip.jpg" caption="Wordlase, GDI+, no OpenGL, Windows" link=true %}

It's supports semi-transparent PNG images, the picture looks almost the same as original OpenGL render. The difference is a font: hinting, anti-aliasing, size etc. Also, GDI+ renderer is not very fast on big images.

The worst case is a pure X11 renderer (it was even unable to load images before my [pull request](https://github.com/vurtun/nuklear/pull/512)):

{% include image path="wl-xlib-pure.jpg" caption="Wordlase, X11, no OpenGL, Linux" link=true %}

There are really many differences now: logo, the lights of a sun, sharp girl's edge, font. Why? The game's background is assembled from semi-transparent PNG images. But X11 supports only bit-transparency, as in a GIF-files. Also, it is really slow on big images with alpha. The situation without alpha enabled is even worse:

{% include image path="wl-xlib-no-alpha.jpg" caption="Wordlase, X11, no OpenGL, no alpha" link=true %}


Why do we need pure Xlib and GDI+ is they are so ugly? They are bad for big semi-transparent images only. But if you are making small utility and use images for UI icons - these renderers can be a good variant since there a small amount of dependencies. Also, I used pure Xlib on a weak Linux systems with software OpenGL only. In that case, Xlib is much faster. Hint: One big non-transparent JPEG works fast and good on X11 too.

As an example of a good usage of pure X11 backend I want to show you a Wordlase's gameplay window:

{% include image path="Wordlase-x11-bad-font.png" caption="Wordlase, X11, gameplay" link=true %}

There are no big images, but a lot of simple interface icons, that not using transparency heavily.



Ok, now the renderer is selected, OS window is created. It's time to write some GUI code!



### Nuklear tricks

The first [Wordlase's](https://wordlase.dexp.in/) screen is a language select:

{% include image path="Wordlase-new-lang.jpg" alt="Wordlase language select" link=true %}

There are 2 interesting techniques on this screen: images on window's background and widgets centering. 

It's pretty easy to put images on Nuklear window's background:

```c
nk_layout_space_push(ctx, nk_rect(x, y, width, height));
nk_image(ctx, img);
```

*x* and *y* are the position, related to the window. *width* and *height* - dimensions of the image.

Centering is a more complicated task. Nuklear does not support it, so you need to calculate position by yourself:

```c
if ( nk_begin(ctx, WIN_TITLE, 
        nk_rect(0, 0, winWidth, winHeight), NK_WINDOW_NO_SCROLLBAR)
) {
    int i;
    /* 0.2 are a space skip on button's left and right, 0.6 - button */
    static const float ratio[] = {0.2f, 0.6f, 0.2f};  /* 0.2+0.6+0.2=1 */

    /* Just make vertical skip with calculated height of static row  */
    nk_layout_row_static(ctx, 
        (winHeight - (BUTTON_HEIGHT+VSPACE_SKIP)*langCount )/2, 15, 1
    );
        
    nk_layout_row(ctx, NK_DYNAMIC, BUTTON_HEIGHT, 3, ratio);
    for(i=0; i<langCount; i++){
        nk_spacing(ctx, 1); /* skip 0.2 left */
        if( nk_button_image_label(ctx, image, caption, NK_TEXT_CENTERED) 
        ){
            loadLang(nkcHandle, ctx, i);
        }
        nk_spacing(ctx, 1); /* skip 0.2 right */
    }
}
nk_end(ctx);
```

You can find funny theme selector widget in options:

{% include image path="Wordlase-theme-select.jpg" alt="Wordlase options" link=true %}

It's pretty easy to implement too:

```c
if (nk_combo_begin_color(ctx, themeColors[s.curTheme], 
    nk_vec2(nk_widget_width(ctx), (LINE_HEIGHT+5)*WTHEME_COUNT) ) 
){
    int i;
    nk_layout_row_dynamic(ctx, LINE_HEIGHT, 1);
    for(i=0; i<WTHEME_COUNT; i++)
        if( nk_button_color(ctx, themeColors[i]) ){
            nk_combo_close(ctx);
            changeGUItheme(nkcHandle, s.curTheme);
        }
    nk_combo_end(ctx);
}
```

The implementation is based on fact that combo's content is just a subwindow. You can place here anything you want.


The most complicated-looking screen is the main gameplay window:

{% include image path="Wordlase-new-game.jpg" alt="Wordlase gameplay window" link=true %}

But it's not hard to implement. It's just 4 rows on that screen:

1. Top line with level select
2. Word list (in a *nk_group_scrolled*)
3. Current word's buttons
4. Hint line

So now the only question is how to create a button of exact concrete size in a line? It's dealt with row's ratio:

```c
float ratio[] = {
    (float)BUTTON_HEIGHT/winWidth, /* square button */
    (float)BUTTON_HEIGHT/winWidth,  /* square button */
    (float)topWordSpace/winWidth, 
    (float)WORD_WIDTH/winWidth
};
nk_layout_row(ctx, NK_DYNAMIC, BUTTON_HEIGHT, 4, ratio);
```

The *BUTTON_HEIGHT* and *WORD_WIDTH* are constants in pixels, *topWordSpace* is calculated as *winWidth* minus all other elements widths.



The last complicated window is a current word's statistics:

{% include image path="Wordlase-new-stat.jpg" alt="Wordlase statistics" link=true %}

The layout is made with grouping: you can say to Nuklear, that there will be 2 widgets in the row. But the group is a widget too! Just use *nk_group_begin* and *nk_group_end* for creating a new group, then make layout inside this group in a usual way (*nk_layout_row* etc).



### Conclusion

Nuklear is already ready even for commercial games and applications. Nuklear+ can help to make them easier.



### Useful links 

- [Wordlase on Steam](http://store.steampowered.com/app/602930/Wordlase/)
- [Wordlase web demo](https://wordlase.dexp.in/)
- [Nuklear+ GitHub repo](https://github.com/DeXP/nuklear_cross)
- [Original Nuklear GitHub repo](https://github.com/vurtun/nuklear)
- [Nuklear web demo](https://dexp.github.io/nuklear-webdemo)


{% include buttons %}


## Other GUI
{: .t60 }
{% include list-posts tag='gui' %}
