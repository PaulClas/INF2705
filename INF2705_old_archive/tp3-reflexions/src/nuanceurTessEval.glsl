#version 410

layout(quads) in;

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
AttribsOut;

uniform mat4 matrVisu;
uniform mat4 matrProj;

vec2 interpole(vec2 v0, vec2 v1, vec2 v2, vec2 v3) {
  // mix( x, y, f ) = x * (1-f) + y * f.
  vec2 v01 = mix(v0, v1, gl_TessCoord.x);
  vec2 v32 = mix(v3, v2, gl_TessCoord.x);
  return mix(v01, v32, gl_TessCoord.y);
}
vec3 interpole(vec3 v0, vec3 v1, vec3 v2, vec3 v3) {
  // mix( x, y, f ) = x * (1-f) + y * f.
  vec3 v01 = mix(v0, v1, gl_TessCoord.x);
  vec3 v32 = mix(v3, v2, gl_TessCoord.x);
  return mix(v01, v32, gl_TessCoord.y);
}
vec4 interpole(vec4 v0, vec4 v1, vec4 v2, vec4 v3) {
  // mix( x, y, f ) = x * (1-f) + y * f.
  vec4 v01 = mix(v0, v1, gl_TessCoord.x);
  vec4 v32 = mix(v3, v2, gl_TessCoord.x);
  return mix(v01, v32, gl_TessCoord.y);
}

// À cause de l'ordre de lecture des sommets pour la tesselation en quads, on doit inverser les 2 derniers sommets
    /*         +Y                    */
    /*   3+-----------+2             */
    /*    |\          |\             */
    /*    | \         | \            */
    /*    |  \        |  \           */
    /*    |  7+-----------+6         */
    /*    |   |       |   |          */
    /*    |   |       |   |          */
    /*   0+---|-------+1  |          */
    /*     \  |        \  |     +X   */
    /*      \ |         \ |          */
    /*       \|          \|          */
    /*       4+-----------+5         */
    /*             +Z                */
// On doit lire 7-6-2-3, mais la lecture de base fait 7-6-3-2 (pour les triangle strips)

void main() {
  // Position
  vec4 p0 = gl_in[0].gl_Position;
  vec4 p1 = gl_in[1].gl_Position;
  vec4 p3 = gl_in[2].gl_Position;
  vec4 p2 = gl_in[3].gl_Position;
  gl_Position = matrProj * matrVisu * (interpole(p0, p1, p2, p3));

  // Attribs
  AttribsOut.normale =
      normalize(interpole(AttribsIn[0].normale, AttribsIn[1].normale,
                          AttribsIn[3].normale, AttribsIn[2].normale));
  for (int i = 0; i < 3; i++) {
    AttribsOut.lumiDir[i] =
        interpole(AttribsIn[0].lumiDir[i], AttribsIn[1].lumiDir[i],
                  AttribsIn[3].lumiDir[i], AttribsIn[2].lumiDir[i]);
  }
  AttribsOut.obsVec = interpole(AttribsIn[0].obsVec, AttribsIn[1].obsVec,
                                AttribsIn[3].obsVec, AttribsIn[2].obsVec);
  AttribsOut.texCoord = interpole(AttribsIn[0].texCoord, AttribsIn[1].texCoord,
                                  AttribsIn[3].texCoord, AttribsIn[2].texCoord);
  if (any(lessThan(gl_TessCoord, vec3(0.001)))) {
    AttribsOut.couleur = interpole(AttribsIn[0].couleur, AttribsIn[1].couleur,
                                   AttribsIn[3].couleur, AttribsIn[2].couleur);
  } else { AttribsOut.couleur = vec4(1.0); }
}