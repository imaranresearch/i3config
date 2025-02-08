#!/bin/sh

# Path to lockscreen image (change this to your desired image)
LOCK_IMAGE="$HOME/Pictures/mandalorian_.png"

# Temporary file for processed lock screen image
TMPBG="/tmp/lockscreen.png"

# Blur intensity (higher = stronger blur)
BLUR_LEVEL=8

# Colors (RGBA format: RRGGBBAA)
BLANK='#00000000'      # Fully transparent
CLEAR='#ffffff22'      # Semi-transparent white
DEFAULT='#ff00ffcc'    # Purple (ring color)
TEXT='#FFD700'       # Light purple text
WRONG='#FF4500'      # Red (wrong password)
VERIFYING='#00bb00bb'  # Green (verifying password)
INSIDE='#00000099'


# Get screen resolution
RESOLUTION=$(xdpyinfo | awk '/dimensions/{print $2}')

# Get a random quote from the file
QUOTE_FILE="$HOME/.config/i3/quotes.txt"
if [ -f "$QUOTE_FILE" ]; then
    QUOTE=$(shuf -n 1 "$QUOTE_FILE")  # Selects a random quote
else
    QUOTE="“Keep going. Everything you need will come to you at the perfect time.”"
fi 

# If lock image exists, resize it to fit the screen
if [ -f "$LOCK_IMAGE" ]; then
    convert "$LOCK_IMAGE" -resize "$RESOLUTION^" -gravity center -extent "$RESOLUTION" "$TMPBG"
else
    # Take a screenshot and blur it
    scrot "$TMPBG"
    convert "$TMPBG" -blur 0x$BLUR_LEVEL "$TMPBG"
fi

# Run i3lock-color with the resized image
i3lock -i "$TMPBG" \
--insidever-color=$CLEAR     \
--ringver-color=$VERIFYING   \
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
--inside-color=$INSIDE        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
--verif-color=$TEXT          \
--wrong-color=$TEXT          \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
--keyhl-color=$WRONG         \
--bshl-color=$WRONG          \
--screen 1                   \
--clock                      \
--indicator                  \
--time-str="%H:%M:%S"        \
--date-str="%A, %Y-%m-%d"    \
--radius 150                 \
--ring-width 10               \
--time-size=32               \
--date-size=24               \
--time-font="Ubuntu Mono"    \
--date-font="Ubuntu Mono"    \
--verif-text="Verifying..."  \
--wrong-text="Access Denied" \
--ind-pos="w/3:h/3"           \
--greeter-text="$QUOTE"      \
--greeter-color=$TEXT        \
--greeter-size=30            \
--greeter-font="Ubuntu Mono" \
--greeter-pos="w/4:h-50"    # Moves quote higher than the ring

# Cleanup temporary file
rm "$TMPBG"

