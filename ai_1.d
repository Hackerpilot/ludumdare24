import std.algorithm;

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
public int[] AICall(byte[][] map, int[2] location, int[2] desired_location) {
	const int tile_width = 32;

	bool[][] have_been;
	foreach (int i; 0 .. have_been[0].length-1) {
		have_been[i].length = map[0].length;
	}
	have_been[location[0]][location[1]] = true;
	int[] loc_move = doAI(map, [location[0]/tile_width, location[1]/tile_width], desired_location, have_been);
	return [loc_move[0], loc_move[1]];
}

private int[] doAI(in byte[][] map, int[2] location, int[2] desired_location, bool[][] have_been) {
	/*Assume:
	For every byte in map, bit order goes (west), (south), (east), (north)
	Map data structure will be read as map[x][y] with map[0][0] being far Northwest and map[0][n] being Southwest
	Location will always be passed [x,y]
	move_score will always be positive
	*/
	int[] north = [0,0,0], east = [0,0,0], south = [0,0,0], west = [0,0,0];
	int moves = 2147483647;

	if ((location[0] == desired_location[0]) & (location[1] == desired_location[1])) {
		return [location[0], location[1], 0];
	}

	have_been[location[0]][location[1]] = true;

	if ((map[location[0]][location[1]]&1)==1) {
		north = tryMove(map, location, have_been, [0,1]);
	}

	if ((map[location[0]][location[1]]&2)==2) {
		east = tryMove(map, location, have_been, [1,0]);	
	}

	if ((map[location[0]][location[1]]&4)==4) {
		south = tryMove(map, location, have_been, [0,-1]);
	}

	if ((map[location[0]][location[1]]&8)==8) {
		west = tryMove(map, location, have_been, [-1,0]);
	}

	moves = min(moves, north[3], east[3], south[3], west[3]);
	if(moves == 2147483647) {
		return [location[0], location[1], moves];
	}

	foreach (int[] i; [north, east, south, west]) {
		if (i[2]==moves) {
			return i;
		}
	}
	return [0];
}

private int[] tryMove(in byte[][] map, int[] location, in bool[][] have_been, int[] direction) {

	return [0];
}