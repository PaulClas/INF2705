void afficherModele4()
{
    static float rtri = 0, rquad = 0;
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

    glLoadIdentity( );

    glTranslatef( -1.5, 0.0, -6.0 );
    glRotatef( rtri, 0.0, 1.0, 0.0 );

    glBegin( GL_TRIANGLES );
      glColor3f( 1.0, 0.0, 0.0 );
      glVertex3f( 0.0, 1.0, 0.0 );
      glColor3f( 0.0, 1.0, 0.0 );
      glVertex3f( -1.0, -1.0, 1.0 );
      glColor3f( 0.0, 0.0, 1.0 );
      glVertex3f( 1.0, -1.0, 1.0 );
      glColor3f( 1.0, 0.0, 0.0 );
      glVertex3f( 0.0, 1.0, 0.0 );
      glColor3f( 0.0, 0.0, 1.0 );
      glVertex3f( 1.0, -1.0, 1.0 );
      glColor3f( 0.0, 1.0, 0.0 );
      glVertex3f( 1.0, -1.0, -1.0 );
      glColor3f( 1.0, 0.0, 0.0 );
      glVertex3f( 0.0, 1.0, 0.0 );
      glColor3f( 0.0, 1.0, 0.0 );
      glVertex3f( 1.0, -1.0, -1.0 );
      glColor3f( 0.0, 0.0, 1.0 );
      glVertex3f( -1.0, -1.0, -1.0 );
      glColor3f( 1.0, 0.0, 0.0 );
      glVertex3f( 0.0, 1.0, 0.0 );
      glColor3f( 0.0, 0.0, 1.0 );
      glVertex3f( -1.0, -1.0, -1.0 );
      glColor3f( 0.0, 1.0, 0.0 );
      glVertex3f( -1.0, -1.0, 1.0 );
    glEnd( );

    glLoadIdentity( );
    glTranslatef( 1.5, 0.0, -7.0 );
    glRotatef( rquad, 1.0, 1.0, 1.0 );

    glBegin( GL_QUADS );
      glColor3f( 0.0, 1.0, 0.0 );
      glVertex3f( 1.0, 1.0, -1.0 );
      glVertex3f( -1.0, 1.0, -1.0 );
      glVertex3f( -1.0, 1.0, 1.0 );
      glVertex3f( 1.0, 1.0, 1.0 );
      glColor3f( 1.0, 0.5, 0.0 );
      glVertex3f( 1.0, -1.0, 1.0 );
      glVertex3f( -1.0, -1.0, 1.0 );
      glVertex3f( -1.0, -1.0, -1.0 );
      glVertex3f( 1.0, -1.0, -1.0 );
      glColor3f( 1.0, 0.0, 0.0 );
      glVertex3f( 1.0, 1.0, 1.0 );
      glVertex3f( -1.0, 1.0, 1.0 );
      glVertex3f( -1.0, -1.0, 1.0 );
      glVertex3f( 1.0, -1.0, 1.0 );
      glColor3f( 1.0, 1.0, 0.0 );
      glVertex3f( 1.0, -1.0, -1.0 );
      glVertex3f( -1.0, -1.0, -1.0 );
      glVertex3f( -1.0, 1.0, -1.0 );
      glVertex3f( 1.0, 1.0, -1.0 );
      glColor3f( 0.0, 0.0, 1.0 );
      glVertex3f( -1.0, 1.0, 1.0 );
      glVertex3f( -1.0, 1.0, -1.0 );
      glVertex3f( -1.0, -1.0, -1.0 );
      glVertex3f( -1.0, -1.0, 1.0 );
      glColor3f( 1.0, 0.0, 1.0 );
      glVertex3f( 1.0, 1.0, -1.0 );
      glVertex3f( 1.0, 1.0, 1.0 );
      glVertex3f( 1.0, -1.0, 1.0 );
      glVertex3f( 1.0, -1.0, -1.0 );
    glEnd( );

    if ( Etat::enmouvement )
    {
        rtri += 0.2 * 5;
        rquad -= 0.15 * 5;
    }
}
