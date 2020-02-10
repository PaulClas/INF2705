#version 410

layout(points) in;
layout(triangle_strip, max_vertices = 4) out;

uniform int texnumero;

in Attribs {
    vec4 couleur;
    float tempsDeVieRestant;
    float sens; // du vol
} AttribsIn[];

out Attribs {
    vec4 couleur;
    vec2 texCoord;
} AttribsOut;

void main()
{
    for ( int i = 0 ; i < 4 ; ++i )
    {
        vec2 coins[4];
        coins[0] = vec2( -0.5,  0.5 );
        coins[1] = vec2( -0.5, -0.5 );
        coins[2] = vec2(  0.5,  0.5 );
        coins[3] = vec2(  0.5, -0.5 );

        float fact = gl_in[0].gl_PointSize / 50;
        vec2 decalage = coins[i];
        if (texnumero == 1)
        {
            float angle = 6.0 * AttribsIn[0].tempsDeVieRestant;
            decalage *= mat2( cos(angle), -sin(angle), sin(angle), cos(angle) );
        }
        vec4 position = vec4( gl_in[0].gl_Position.xy + fact * decalage, gl_in[0].gl_Position.zw );

        gl_Position = gl_in[0].gl_Position + position;

        AttribsOut.couleur = AttribsIn[0].couleur;
        AttribsOut.texCoord = coins[i] + vec2( 0.5, 0.5 );
        if ( texnumero == 2 || texnumero == 3 )
        {
            if ( texnumero == 2 && AttribsIn[0].sens == -1.0 )
            {
                coins[0] = vec2(  0.5,  0.5 );
                coins[1] = vec2(  0.5, -0.5 );
                coins[2] = vec2( -0.5,  0.5 );
                coins[3] = vec2( -0.5, -0.5 );
            }

            float nbImages = 16.0;
            float frequence = 18.0;
            float offset = (coins[i].x + 0.5) / 16.0;
            AttribsOut.texCoord.x = offset + (AttribsIn[0].tempsDeVieRestant * frequence - mod(AttribsIn[0].tempsDeVieRestant * frequence, 1.0)) / nbImages;
        }
        EmitVertex();
    }

}
