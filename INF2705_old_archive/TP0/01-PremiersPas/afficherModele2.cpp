void afficherModele2()
{
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    glLoadIdentity( );
    
    glTranslatef( -1.5, 0.0, -6.0 );
    
    glBegin( GL_TRIANGLES );
      glColor3f( 1.0, 0.0, 0.0 );
      glVertex3f(  0.0,  1.0, 0.0 );
      glColor3f( 0.0, 1.0, 0.0 );
      glVertex3f( -1.0, -1.0, 0.0 );
      glColor3f( 0.0, 0.0, 1.0 );
      glVertex3f(  1.0, -1.0, 0.0 );
    glEnd( );

    glTranslatef( 3.0, 0.0, 0.0 );

    glColor3f( 0.5, 0.5, 1.0 );
    glBegin( GL_QUADS );
      glVertex3f( -1.0,  1.0, 0.0 );
      glVertex3f(  1.0,  1.0, 0.0 );
      glVertex3f(  1.0, -1.0, 0.0 );
      glVertex3f( -1.0, -1.0, 0.0 );
    glEnd( );
}
