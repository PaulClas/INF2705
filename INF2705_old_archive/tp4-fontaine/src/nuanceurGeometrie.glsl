#version 410

layout(points) in;
layout(triangle_strip, max_vertices = 4) out;
// layout(points, max_vertices = 1) out;

in Attribs {
  vec4 couleur;
  float tempsDeVieRestant;
  float sens; // du vol
}
AttribsIn[];

out Attribs {
  vec4 couleur;
  vec2 texCoord;
}
AttribsOut;

uniform mat4 matrProj;
uniform int texnumero;

void main() {
  vec2 coins[4];
  coins[0] = vec2(-0.5, 0.5);
  coins[1] = vec2(-0.5, -0.5);
  coins[2] = vec2(0.5, 0.5);
  coins[3] = vec2(0.5, -0.5);
  float fact = gl_in[0].gl_PointSize / 50;
  // Flocons
  if (texnumero == 1) {
    for (int i = 0; i < 4; i++) {
      float angle = 6.0 * AttribsIn[0].tempsDeVieRestant;
      mat2 rotation = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));

      vec2 decalage = rotation * coins[i];
      vec4 pos = vec4(gl_in[0].gl_Position.xy + fact * decalage,
                      gl_in[0].gl_Position.zw);
      gl_Position = matrProj * pos;
      AttribsOut.couleur = AttribsIn[0].couleur;
      // AttribsOut.texCoord = rotation * coins[i] + vec2(0.5, 0.5);
      AttribsOut.texCoord = coins[i] + vec2(0.5, 0.5);
      EmitVertex();
    }
    // Oiseaux
  } else if (texnumero == 2) {
    for (int i = 0; i < 4; i++) {
      vec2 decalage = coins[i];
      vec4 pos = vec4(gl_in[0].gl_Position.xy + fact * decalage,
                      gl_in[0].gl_Position.zw);
      gl_Position = matrProj * pos;
      AttribsOut.couleur = AttribsIn[0].couleur;
      int num = int(mod(18.0 * AttribsIn[0].tempsDeVieRestant, 16.0));
      if (AttribsIn[0].sens == -1.0) {
        AttribsOut.texCoord = (coins[i] - vec2(0.5, 0.5));
        AttribsOut.texCoord.x = -(AttribsOut.texCoord.x + num) / 16.0;
      } else {
        AttribsOut.texCoord = coins[i] + vec2(0.5, 0.5);
        AttribsOut.texCoord.x = (AttribsOut.texCoord.x + num) / 16.0;
      }
      EmitVertex();
    }
    // Sans texture (quadrilatères)
    // On aurait pu gérer les particules avec un autre shader en points (max_vertices = 1)
    // (un peu) comme dans nuanceurGeomPoints.glsl
  } else {
    for (int i = 0; i < 4; i++) {
      vec2 decalage = coins[i];
      vec4 pos = vec4(gl_in[0].gl_Position.xy + fact * decalage,
                      gl_in[0].gl_Position.zw);
      gl_Position = matrProj * pos;
      AttribsOut.couleur = AttribsIn[0].couleur;
      EmitVertex();
    }
  }
}
