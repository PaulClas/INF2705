void afficherModele1()
{
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    glColor3f( 1.0, 1.0, 1.0 );

    glLoadIdentity( );

    glTranslatef( -1.5, 0.0, -6.0 );

    glBegin( GL_TRIANGLES );
      glVertex3f(  0.0,  1.0, 0.0 );
      glVertex3f( -1.0, -1.0, 0.0 );
      glVertex3f(  1.0, -1.0, 0.0 );
    glEnd( );

    glTranslatef( 3.0, 0.0, 0.0 );

    glBegin( GL_QUADS );
      glVertex3f( -1.0,  1.0, 0.0 );
      glVertex3f(  1.0,  1.0, 0.0 );
      glVertex3f(  1.0, -1.0, 0.0 );
      glVertex3f( -1.0, -1.0, 0.0 );
    glEnd( );
}
