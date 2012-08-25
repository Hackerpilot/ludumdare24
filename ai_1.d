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
public int[] AICall(byte[][] map, int[2] location, in int[2] desired_location) {
	// Set tile width
	const int tile_width = 32;
	//Initialize have_been map
	bool[][] have_been;
	foreach (int i; 0 .. have_been[0].length) {
		have_been[i].length = map[0].length;
	}
	have_been[location[0]][location[1]] = true;
	int[] loc_move = doAI(map, [location[0]/tile_width, location[1]/tile_width], desired_location, have_been);
	return [loc_move[0], loc_move[1]];
}

private int[] doAI(in byte[][] map, int[2] location, in int[2] desired_location, bool[][] have_been) {
	/*Assume:
	For every byte in map, bit order goes (west), (south), (east), (north)
	Map data structure will be read as map[x][y] with map[0][0] being far Northwest and map[0][n] being Southwest
	Location will always be passed [x,y]
	move_score will always be positive
	*/
	// Setting a max value and the max value for moves
	int max_val = 2147483647, moves = max_val;
	// Setting min values for each direction
	int[] north = [0,0,max_val], east = [0,0,max_val], south = [0,0,max_val], west = [0,0,max_val];
	//If we're outside the map, then break the function
	if(location[0] < 0 || location[1] < 0) {
		return [0,0,max_val];
	}
	// If we're at the target, then stop
	if ((location[0] == desired_location[0]) & (location[1] == desired_location[1])) {
		return [location[0], location[1], 0];
	}
	//If we've been here before, say it's a dead end
	if (have_been[location[0]][location[1]]) {
		return [0,0,max_val];
	}
	// If we're not at the target, say that we've been here
	have_been[location[0]][location[1]] = true;

	// Try all the possible moves from this location (first north, then east, then south, then west)
	//TODO: remove redundant moves, make this work
	if ((map[location[0]][location[1]]&1)!=1) {
		int[][] north_dir;
		north_dir[0] = doAI(map, [location[0]-1,location[1]-1], desired_location, have_been);
		north_dir[1] = doAI(map, [location[0],  location[1]-1], desired_location, have_been);
		north_dir[2] = doAI(map, [location[0]+1,location[1]-1], desired_location, have_been);
		north = getShortPath(north_dir);
	}

	if ((map[location[0]][location[1]]&2)!=2) {
		int[][] east_dir;
		east_dir[0] = doAI(map, [location[0]+1,location[1]-1], desired_location, have_been);
		east_dir[1] = doAI(map, [location[0]+1,location[1]], desired_location, have_been);
		east_dir[2] = doAI(map, [location[0]+1,location[1]+1], desired_location, have_been);
		east = getShortPath(east_dir);
	}

	if ((map[location[0]][location[1]]&4)!=4) {
		int[][] south_dir;
		south_dir[0] = doAI(map, [location[0]-1,location[1]+1], desired_location, have_been);
		south_dir[1] = doAI(map, [location[0],  location[1]+1], desired_location, have_been);
		south_dir[2] = doAI(map, [location[0]+1,location[1]+1], desired_location, have_been);
		south = getShortPath(south_dir);
	}

	if ((map[location[0]][location[1]]&8)!=8) {
		int[][] west_dir;
		west_dir[0] = doAI(map, [location[0]-1,location[1]-1], desired_location, have_been);
		west_dir[1] = doAI(map, [location[0]-1,location[1]], desired_location, have_been);
		west_dir[2] = doAI(map, [location[0]-1,location[1]+1], desired_location, have_been);
		west = getShortPath(west_dir);
	}

	// Find out the fastest way to the target
	// If path dead-ends, return [0,0,max_val]
	moves = min(moves, north[3], east[3], south[3], west[3]);
	if(moves == max_val) {
		return [0,0,max_val];
	}

	return getShortPath([north, east, south, west]);
}

private int[] getShortPath(int[][] path) {
	int max_val = 2147483647, min_now = max_val;
	foreach (int[] i; path) {
		if (i[2] < min_now) {
			min_now = i[2];
		}
	}

	foreach (int[] i; path) {
		if (i[2] == min_now) {
			return i;
		}
	}
	return [0,0,max_val];
}

unittest{
	int[][] i;
	i[0] = [0,0,0];
	i[1] = [0,0,0];
	i[2] = [0,0,0];
	i[3] = [0,0,0];
	assert(getShortPath(i)==[0,0,0]);
}
