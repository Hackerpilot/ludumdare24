module main;

import std.string;
import std.stdio;
import std.json;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import map;


immutable int SCREEN_WIDTH = 800;
immutable int SCREEN_HEIGHT = 600;

void main(string[] args)
{
	version (linux)
	{
		DerelictSDL2.load("./libSDL2.so");
		DerelictSDL2Image.load("./libSDL2_image.so");
	}
	else version(Win32)
	{
		DerelictSDL2.load();
		DerelictSDL2Image.load();
	}

	scope(exit) SDL_Quit();
	SDL_Init(SDL_INIT_VIDEO|SDL_INIT_NO_PARACHUTE|SDL_INIT_TIMER);

	SDL_Window* window = SDL_CreateWindow(toStringz("Test Window"),
		SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, SCREEN_WIDTH,
		SCREEN_HEIGHT, 0);
	scope(exit) SDL_DestroyWindow(window);

	SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

	TileMap* map;
	try
	{
		map = loadTileMap("maps/map1.json", renderer);
	}
	catch (Exception e)
	{
		writeln(e.msg);
	}


	SDL_Event event;
	bool quit = false;
	SDL_Rect camera;
	camera.x = 0;
	camera.y = 0;
	camera.w = SCREEN_WIDTH;
	camera.h = SCREEN_HEIGHT;

	SDL_Rect playerRect;
	playerRect.x = 32;
	playerRect.y = 64;
	playerRect.w = 22;
	playerRect.h = 50;


	bool[4] arrowKeys;

	while (!quit)
	{


		while(SDL_PollEvent(&event))
		{
			switch (event.type)
			{
			case SDL_KEYDOWN:
				switch (event.key.keysym.sym)
				{
				case SDLK_ESCAPE:
					quit = true;
					break;
				case SDLK_UP:
					arrowKeys[0] = true;
					break;
				case SDLK_RIGHT:
					arrowKeys[1] = true;
					break;
				case SDLK_DOWN:
					arrowKeys[2] = true;
					break;
				case SDLK_LEFT:
					arrowKeys[3] = true;
					break;
				default:
					break;
				}
				break;
			case SDL_KEYUP:
				switch (event.key.keysym.sym)
				{
				case SDLK_UP:
					arrowKeys[0] = false;
					break;
				case SDLK_RIGHT:
					arrowKeys[1] = false;
					break;
				case SDLK_DOWN:
					arrowKeys[2] = false;
					break;
				case SDLK_LEFT:
					arrowKeys[3] = false;
					break;
				default:
					break;
				}
				break;
			default:
				break;
			}
		}

		int playerXVel;
		int playerYVel;


		if (arrowKeys[0]) playerYVel = -4;
		if (arrowKeys[2]) playerYVel = 4;
		if (arrowKeys[1]) playerXVel = 4;
		if (arrowKeys[3]) playerXVel = -4;

		playerRect.x += playerXVel;
		playerRect.y += playerYVel;

		checkCollision(playerRect, map, playerXVel,
			playerYVel) ;

		SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
		SDL_RenderClear(renderer);
		map.draw(camera, renderer, true);
		SDL_SetRenderDrawColor(renderer, 0, 0, 255, 255);
		SDL_RenderFillRect(renderer, &playerRect);
		SDL_RenderPresent(renderer);

		SDL_Delay(16);
	}
}
