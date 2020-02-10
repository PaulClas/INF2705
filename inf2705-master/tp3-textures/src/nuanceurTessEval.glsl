#version 410

layout(quads) in;

in Attribs {
    vec3 lumiDir[3];
    vec3 normale, obsVec;
    vec4 couleur;
    vec2 texCoord;
} AttribsIn[];

out Attribs {
    vec3 lumiDir[3];
    vec3 normale, obsVec;
    vec4 couleur;
    vec2 texCoord;
} AttribsOut;

float interpole( float v0, float v1, float v2, float v3 )
{
    // mix( x, y, f ) = x * (1-f) + y * f.
    float v01 = mix( v0, v1, gl_TessCoord.x );
    float v32 = mix( v3, v2, gl_TessCoord.x );
    return mix( v01, v32, gl_TessCoord.y );
}
vec2 interpole( vec2 v0, vec2 v1, vec2 v2, vec2 v3 )
{
    // mix( x, y, f ) = x * (1-f) + y * f.
    vec2 v01 = mix( v0, v1, gl_TessCoord.x );
    vec2 v32 = mix( v3, v2, gl_TessCoord.x );
    return mix( v01, v32, gl_TessCoord.y );
}
vec3 interpole( vec3 v0, vec3 v1, vec3 v2, vec3 v3 )
{
    // mix( x, y, f ) = x * (1-f) + y * f.
    vec3 v01 = mix( v0, v1, gl_TessCoord.x );
    vec3 v32 = mix( v3, v2, gl_TessCoord.x );
    return mix( v01, v32, gl_TessCoord.y );
}
vec4 interpole( vec4 v0, vec4 v1, vec4 v2, vec4 v3 )
{
    // mix( x, y, f ) = x * (1-f) + y * f.
    vec4 v01 = mix( v0, v1, gl_TessCoord.x );
    vec4 v32 = mix( v3, v2, gl_TessCoord.x );
    return mix( v01, v32, gl_TessCoord.y );
}

void main()
{
    gl_Position = interpole( gl_in[0].gl_Position, gl_in[1].gl_Position, gl_in[3].gl_Position, gl_in[2].gl_Position );

    AttribsOut.lumiDir[0] = interpole( AttribsIn[0].lumiDir[0], AttribsIn[1].lumiDir[0], AttribsIn[3].lumiDir[0], AttribsIn[2].lumiDir[0] );
    AttribsOut.lumiDir[1] = interpole( AttribsIn[0].lumiDir[1], AttribsIn[1].lumiDir[1], AttribsIn[3].lumiDir[1], AttribsIn[2].lumiDir[1] );
    AttribsOut.lumiDir[2] = interpole( AttribsIn[0].lumiDir[2], AttribsIn[1].lumiDir[2], AttribsIn[3].lumiDir[2], AttribsIn[2].lumiDir[2] );
    AttribsOut.normale = interpole( AttribsIn[0].normale, AttribsIn[1].normale, AttribsIn[3].normale, AttribsIn[2].normale );
    AttribsOut.obsVec = interpole( AttribsIn[0].obsVec, AttribsIn[1].obsVec, AttribsIn[3].obsVec, AttribsIn[2].obsVec );
    AttribsOut.couleur = interpole( AttribsIn[0].couleur, AttribsIn[1].couleur, AttribsIn[3].couleur, AttribsIn[2].couleur );
    AttribsOut.texCoord = interpole( AttribsIn[0].texCoord, AttribsIn[1].texCoord, AttribsIn[3].texCoord, AttribsIn[2].texCoord );
}