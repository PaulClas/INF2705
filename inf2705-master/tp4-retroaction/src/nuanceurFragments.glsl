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
    FragColor = AttribsIn.couleur;
    if (texnumero != 0)
    {
        vec4 couleur = texture( leLutin, AttribsIn.texCoord );
        FragColor = mix( FragColor, couleur, 0.6 );
        if ( couleur.a < 0.1 )
        {
            discard;
        }
    }
}
