program ReadKeySDL;
{SDL implementation of the crt readkey function.}

uses
    sdl;
{
const
    validkeys=[8,13,27,32..126];
}

var
    screen          :   pSDL_Surface;
    event           :   pSDL_Event;
    key             :   char;
    keyselected     :   boolean;


BEGIN


    SDL_Init(SDL_INIT_VIDEO);
    screen:=SDL_SetVideoMode(640,480,32,SDL_SWSURFACE);
    if (screen=nil) then halt(1);

    SDL_EnableUnicode(SDL_Enable);
    new(event);
    repeat
        key:=#0;
        keyselected:=false;
        repeat
            if (SDL_WaitEvent(event) = 1) then
            begin
                if (event^.type_ = SDL_KeyDown) then
                begin
                    keyselected:=true;
                    key:=char(event^.key.keysym.unicode);
                    {if not(ord(key) in validkeys) then key:=#0;}
                    if (key = #0) then keyselected:=false;
                end;
            end;
        until((keyselected) and (event^.type_ = SDL_KeyUp));
        writeln('Your key is: ',key,' (',ord(key),')');
    until(ord(key) = 27);
    dispose(event);
    SDL_EnableUnicode(SDL_Disable);
        
    SDL_FreeSurface(screen);
    SDL_Quit;

END.
