#version 410

layout(vertices = 4) out;

uniform float TessLevelInner;
uniform float TessLevelOuter;

in Attribs {
  vec4 couleur;
  vec3 normale;
  vec3 lumiDir[3];
  vec3 obsVec;
  vec2 texCoord;
}
AttribsIn[];

out Attribs {
  vec4 couleur;
  vec3 normale;
  vec3 lumiDir[3];
  vec3 obsVec;
  vec2 texCoord;
}
AttribsOut[];

void main() {
  gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

  if (gl_InvocationID == 0) {
        gl_TessLevelInner[0] = TessLevelInner;
        gl_TessLevelInner[1] = TessLevelInner;
        gl_TessLevelOuter[0] = TessLevelOuter;
        gl_TessLevelOuter[1] = TessLevelOuter;
        gl_TessLevelOuter[2] = TessLevelOuter;
        gl_TessLevelOuter[3] = TessLevelOuter;
  } 
  // Normale à conserver intacte? Normalement oui pour un cube?
  AttribsOut[gl_InvocationID].couleur = AttribsIn[gl_InvocationID].couleur;
  AttribsOut[gl_InvocationID].normale = AttribsIn[gl_InvocationID].normale;
  for (int i = 0; i < 3; i++) { AttribsOut[gl_InvocationID].lumiDir[i] = AttribsIn[gl_InvocationID].lumiDir[i]; }
  AttribsOut[gl_InvocationID].obsVec = AttribsIn[gl_InvocationID].obsVec;
  AttribsOut[gl_InvocationID].texCoord = AttribsIn[gl_InvocationID].texCoord;
}