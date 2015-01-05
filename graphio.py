# GraphIO library for Python 3
# Copyright (C) 2015 Angelo Bertolli


import pygame, sys
from pygame.locals import *

# Display settings
displaywidth = 640
displayheight = 480
colordepth = 32

# Legacy graphics support
palette = [
    (  0,  0,  0),
    (  0,  0,168),
    (  0,168,  0),
    (  0,168,168),
    (168,  0,  0),
    (168,  0,168),
    (168, 84,  0),
    (168,168,168),
    ( 84, 84, 84),
    ( 84, 84,252),
    ( 84,252, 84),
    ( 84,252,252),
    (252, 84, 84),
    (252, 84,252),
    (252,252, 84),
    (252,252,252)
]

black           =   0
blue            =   1
green           =   2
cyan            =   3
red             =   4
magenta         =   5
brown           =   6
lightgray       =   7
darkgray        =   8
lightblue       =   9
lightgreen      =   10
lightcyan       =   11
lightred        =   12
lightmagenta    =   13
yellow          =   14
white           =   15

xhome           =   10
yhome           =   10



# Global variables for maintaining settings
screen          =   pygame.display.set_mode((displaywidth, displayheight), 0, colordepth)
fgcolor         =   black
bgcolor         =   black
textsize        =   3
cursorx         =   xhome
cursory         =   yhome
fontpath        =   'fonts'
fontfile        =   'default.ttf'


def group(lst, n):
    for i in range(0, len(lst), n):
        val = lst[i:i+n]
        if len(val) == n:
            yield tuple(val)

def drawln1(beginx, beginy, filename):
    global screen
    x = beginx
    y = beginy
    with open(filename) as f:
        for line in f:
            for data in list(group(line.split(),2)):
                color = int(data[0])
                length = int(data[1])
                pygame.draw.line(screen,palette[color],(x,y),(x+length,y))
                x = x + length
            x = beginx
            y = y + 1
    pygame.display.update()


# Init
pygame.init()
screen.fill(palette[black])

drawln1(50,50,'img/thetown.ln1')

# run the game loop
while True:
    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            sys.exit()

