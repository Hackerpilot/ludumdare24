import std.string;
import derelict.sdl2.sdl;

void main() {
	DerelictSDL2.load("./SDL2.dll");
	SDL_Init(SDL_INIT_VIDEO);
	scope(exit) SDL_Quit();
	
	SDL_Window* window = SDL_CreateWindow(toStringz("Hello World"),
		SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 640, 480, SDL_WINDOW_SHOWN);
	scope(exit) SDL_DestroyWindow(window);	
		
	SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
	scope(exit) SDL_DestroyRenderer(renderer);
	
	SDL_Rect rect;
	rect.x = 0;
	rect.y = 0;
	rect.w = 100;
	rect.h = 100;
	SDL_RenderClear(renderer);
	SDL_SetRenderDrawColor(renderer, 0, 0, 255, 128);
	SDL_RenderFillRect(renderer, &rect);
	SDL_RenderPresent(renderer);
	
	SDL_Delay(3000);
}