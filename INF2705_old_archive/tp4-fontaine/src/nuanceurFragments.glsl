#version 410

uniform sampler2D leLutin;
uniform int texnumero;

in Attribs {
    vec4 couleur;
    vec2 texCoord;
} AttribsIn;

out vec4 FragColor;

void main( void )
{
    // Mettre un test bidon afin que l'optimisation du compilateur n'élimine l'attribut "couleur".
    // Vous ENLEVEREZ cet énoncé inutile!
    // if ( AttribsIn.couleur.r + texnumero + texture(leLutin,vec2(0.0)).r < 0.0 ) discard;
    vec4 couleurTexture = texture( leLutin, AttribsIn.texCoord );
    // texture et alpha transparent
    if (texnumero != 0 && couleurTexture.a < 0.1) {
        discard;
    // texture et alpha opaque
    } else if (texnumero != 0 && couleurTexture.a >= 0.1) {
        FragColor.a = AttribsIn.couleur.a;
        FragColor.rgb = mix( AttribsIn.couleur.rgb, couleurTexture.rgb, 0.6 );
    } else {
       FragColor = AttribsIn.couleur;
    }
}
