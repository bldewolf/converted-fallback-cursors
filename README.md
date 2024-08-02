# x11-fallback-cursors

## to install

1. extract release tarball to `~/.icons/`
2. change to cursor theme in window manager/etc

## why

I don't know how common an experience this is, but in the recent years I've
started to have odd experiences with my cursors on my Linux desktop.  The last
straw was when Firefox inexplicably stopped changing the cursor over links.  I
was hoping the next update would fix it, but no, I broke it, and I'm now having
to fix it.

It all stems from my inexplicable attachment to the built-in x11 fallback
cursors.  They're not good; I love them.  A while ago, I set up the standard
workaround of making a blank ~/.icons/default` theme to prevent any of the
modern, tasteful themes from loading.  This method no longer appears to be
foolproof, as GTK now uses cursor names that don't map to fallback cursors
(such as the one used for hovering over links in Firefox).

To resolve this, I looked around for a conversion of the old cursors so I could
make the appropriate symlinks.  I didn't find any, so here's my attempt at
doing so.

## resources

In no particular order

### https://tldp.org/HOWTO/X-Big-Cursor.html

See! People change fonts all the time!

### https://gitlab.freedesktop.org/xorg/xserver dix/glyphcurs.c:63

Insight into how the server uses the existing font as cursors

### https://gitlab.freedesktop.org/xorg/font/cursor-misc cursor.bdf

Cursor data reproduced in this repo

### https://github.com/charakterziffer/cursor-toolbox

More inspiration

### https://gitlab.gnome.org/GNOME/gtk/-/blob/main/gdk/x11/gdkcursor-x11.c#L104

This table reproduced as `gtk-table` to generate symlinks (although modified to
not use hand1, I mean, who uses hand1?)

### https://www.gnome-look.org/p/999853/

INCREDIBLY helpful cursor theme for realizing what cursors are missing

### https://www.x.org/docs/BDF/bdf.pdf

Fantastic documentation of the BDF format. A+ thanks a lot wish everything had a doc like this
