//attribute vec4 cc_Position;
//attribute vec2 cc_TexCoord1;

varying mediump vec2 v_skyBoxCoord;
varying mediump vec2 v_layer1Coord;
varying mediump vec2 v_layer2Coord;
varying mediump vec2 v_layer3Coord;

uniform vec2 u_layer1Coord; // the position in the sampled texture to return for layer1
uniform vec2 u_layer2Coord; // the position in the sampled texture to return for layer2
uniform vec2 u_layer3Coord; // the position in the sampled texture to return for layer3
uniform highp vec2 u_scaleRatio; // used to return the correct x,y for textures of mismatched size

void main() {
    
    gl_Position = cc_Position; // positions the quad
	v_skyBoxCoord = cc_TexCoord1; // pass thru

	vec2 norm_texCoord = cc_TexCoord1 * u_scaleRatio;
	
	v_layer1Coord = vec2( norm_texCoord.x + u_layer1Coord.x , norm_texCoord.y - u_layer1Coord.y );
	v_layer2Coord = vec2( norm_texCoord.x + u_layer2Coord.x , norm_texCoord.y - u_layer2Coord.y );
	v_layer3Coord = vec2( norm_texCoord.x + u_layer3Coord.x , norm_texCoord.y - u_layer3Coord.y );
}