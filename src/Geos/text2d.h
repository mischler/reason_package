/*-----------------------------------------------------------------
LOG
    GEM - Graphics Environment for Multimedia

    A text2d

    Copyright (c) 1997-1999 Mark Danks. mark@danks.org
    Copyright (c) G�nther Geiger. geiger@epy.co.at
    Copyright (c) 2001-2002 IOhannes m zmoelnig. forum::f�r::uml�ute. IEM. zmoelnig@iem.kug.ac.at
    Copyright (c) 2005 Georg Holzmann <grh@mur.at>
    For information on usage and redistribution, and for a DISCLAIMER OF ALL
    WARRANTIES, see the file, "GEM.LICENSE.TERMS" in this distribution.

-----------------------------------------------------------------*/

#ifndef INCLUDE_TEXT2D_H_
#define INCLUDE_TEXT2D_H_

#include "Base/TextBase.h"

/*-----------------------------------------------------------------
-------------------------------------------------------------------
CLASS
    text2d
    
    Creates a text2d string

DESCRIPTION

-----------------------------------------------------------------*/
class GEM_EXTERN text2d : public TextBase
{
    CPPEXTERN_HEADER(text2d, TextBase)

    public:

  /////////
		// Constructor
    	text2d(int argc, t_atom *argv);
    	
    protected:
    	
    	//////////
    	// Destructor
    	virtual ~text2d();

   	//////////
    	// Do the rendering
    	virtual void 	render(GemState *state);

	//////
	// anti aliasing (aka: pixmap instead of bitmap)
	int m_antialias;
  void aliasMess(int io);

#ifdef FTGL
	void            setFontSize(t_float size);

	virtual FTFont*	makeFont(const char*fontname);
	FTFont                  *m_afont;
#endif

 private:

  //////////
  // callbacks
  static void  aliasMessCallback(void *data, t_floatarg io);
};

#endif	// for header file