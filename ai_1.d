/*
AI file for Ludum Dare 24 started at 8:15 on 8/24/2012
Tom Kelley
Here goes nothing
*/

/*
Function AICall takes map and player pixel location
Player pixel location to be divided by 32 to get player location
assuming tiles 32 pixels wide
will assign variable for this
*/
public int[] AICall(byte[][] map, int[2] location) {
	const int tile_width = 32;
	
	int[] loc_move = doAI(map, [location[0]/tile_width, location[1]/tile_width], 0);
	return [loc_move[0], loc_move[1]];
}

private int[] doAI(in byte[][] map, int[2] location, int[2] desired_location) {
	/*Assume:
	For every byte in map, bit order goes (west), (south), (east), (north)
	Location will always be passed [x,y]
	move_score will always be positive
	*/

	int[] north = [0,0,0], east = [0,0,0], south = [0,0,0], west = [0,0,0];

	if (location[0]==desired_location[0] AND location[1]==desired_location[1]) {
		return [location[0], location[1], 0];
	}

	if (map[location[0]][location[1]]&1==1){

	}

	if (map[location[0]][location[1]]&2==2){
		
	}

	if (map[location[0]][location[1]]&4==4){
		
	}

	if (map[location[0]][location[1]]&8==8){
		
	}

}