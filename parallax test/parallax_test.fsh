#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_skyBoxCoord;
varying vec2 v_layer1Coord;
varying vec2 v_layer2Coord;
varying vec2 v_layer3Coord;

uniform sampler2D u_dynamicTexture;
uniform sampler2D u_staticTexture;

uniform vec3 u_nearColor;
uniform vec3 u_midColor;
uniform vec3 u_farColor;


void main( ) {
    
    vec4 finalColor;
    
    //texture lookups
	lowp vec4 sky_color = texture2D(u_staticTexture, v_skyBoxCoord);
	lowp vec4 parallax1_color = texture2D(u_dynamicTexture, v_layer1Coord) * vec4(u_nearColor, 1.0);
	lowp vec4 parallax2_color = texture2D(u_dynamicTexture, v_layer2Coord) * vec4(u_midColor, 1.0);
	lowp vec4 parallax3_color = texture2D(u_dynamicTexture, v_layer3Coord) * vec4(u_farColor, 1.0);
    
    // near layer
	finalColor = sky_color;
    // mid layer
	finalColor = vec4(parallax3_color.rgb + finalColor.rgb * (1.0 - parallax3_color.a), finalColor.a);
    // far layer
	finalColor = vec4(parallax2_color.rgb + finalColor.rgb * (1.0 - parallax2_color.a), finalColor.a);
    // background
	finalColor = vec4(parallax1_color.rgb + finalColor.rgb * (1.0 - parallax1_color.a), finalColor.a);
    
    // assign final color
    gl_FragColor = finalColor;
}