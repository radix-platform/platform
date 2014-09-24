/*   B B A N  -  A Better Banner Program  -  Apr84 IBM-PC version   */
/*  The vax version will not work directly on the PC, because the
**  UNIX shell metacharacter interpretation caused strings like
**  'one two three' to be passed as a single command line arg, while
**  under DOS, it becomes three: "'one", "two", and "three'"
**  So, we need a scheme for embedding spaces in arguments.
**  One: choose some other character like underscore '_' and after
**  command line argument passing, translate it into a space.
**  Two: alter the program logic to treat single and double
**  quotes as delimiters, and keep concatenating DOS-passed arguments
**  until the closing delimiter is detected.
**  Two is more elegant, but One is easier.
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#if defined(__STDC__) || defined(__cplusplus)
# define P_(s) s
#else
# define P_(s) ()
#endif


/* banner.c */
extern int main P_((int argc, char **argv));
static void doline P_((void));
static int aqarg P_((void));
static int redarg P_((void));
static int gint P_((char **pp));

#undef P_

/*   table of character translation patterns   */
char            ctbl[128][7] =
{				/*  stolen from banner  */
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /*below 040*/
    { 0, 000, 000, 000, 000, 000, 000 },            /* */
    { 034, 034, 034, 010, 0, 034, 034 },            /*!*/
    { 0167, 0167, 042, 0, 0, 0, 0 },                /*"*/
    { 024, 024, 0177, 024, 0177, 024, 024 },        /*#*/
    { 076, 0111, 0110, 076, 011, 0111, 076 },       /*$*/
    { 0161, 0122, 0164, 010, 027, 045, 0107 },      /*%*/
    { 030, 044, 030, 070, 0105, 0102, 071 },        /*&*/
    { 034, 034, 010, 020, 0, 0, 0 },                /*'*/
    { 014, 020, 040, 040, 040, 020, 014 },          /*(*/
    { 030, 4, 2, 2, 2, 4, 030 },                    /*)*/
    { 0, 042, 024, 0177, 024, 042, 0 },             /***/
    { 0, 010, 010, 076, 010, 010, 0 },              /*+*/
    { 0, 0, 0, 034, 034, 010, 020 },                /*,*/
    { 0, 0, 0, 076, 0, 0, 0 },                      /*-*/
    { 0, 0, 0, 0, 034, 034, 034 },                  /*.*/
    { 1, 2, 4, 010, 020, 040, 0100 },               /*SLASH*/
    { 034, 042, 0101, 0101, 0101, 042, 034 },       /*0*/
    { 010, 030, 050, 010, 010, 010, 076 },          /*1*/
    { 076, 0101, 1, 076, 0100, 0100, 0177 },        /*2*/
    { 076, 0101, 1, 076, 1, 0101, 076 },            /*3*/
    { 0100, 0102, 0102, 0102, 0177, 2, 2 },         /*4*/
    { 0177, 0100, 0100, 0176, 1, 0101, 076 },       /*5*/
    { 076, 0101, 0100, 0176, 0101, 0101, 076 },     /*6*/
    { 0177, 0102, 04, 010, 020, 020, 020 },         /*7*/
    { 076, 0101, 0101, 076, 0101, 0101, 076 },      /*8*/
    { 076, 0101, 0101, 077, 1, 0101, 076 },         /*9*/
    { 010, 034, 010, 0, 010, 034, 010 },            /*:*/
    { 034, 034, 0, 034, 034, 010, 020 },            /*;*/
    { 020, 010, 4, 2, 4, 010, 020 },                /*<*/
    { 0, 0, 076, 0, 076, 0, 0 },                    /*=*/
    { 4, 010, 020, 040, 020, 010, 4 },              /*>*/
    { 076, 0101, 1, 016, 010, 0, 010 },             /*?*/
    { 076, 0101, 0135, 0135, 0136, 0100, 076 },     /*@*/
    { 010, 024, 042, 0101, 0177, 0101, 0101 },      /*A*/
    { 0176, 0101, 0101, 0176, 0101, 0101, 0176 },   /*B*/
    { 076, 0101, 0100, 0100, 0100, 0101, 076 },     /*C*/
    { 0176, 0101, 0101, 0101, 0101, 0101, 0176 },   /*D*/
    { 0177, 0100, 0100, 0174, 0100, 0100, 0177 },   /*E*/
    { 0177, 0100, 0100, 0174, 0100, 0100, 0100 },   /*F*/
    { 076, 0101, 0100, 0117, 0101, 0101, 076 },     /*G*/
    { 0101, 0101, 0101, 0177, 0101, 0101, 0101 },   /*H*/
    { 034, 010, 010, 010, 010, 010, 034 },          /*I*/
    { 1, 1, 1, 1, 0101, 0101, 076 },                /*J*/
    { 0102, 0104, 0110, 0160, 0110, 0104, 0102 },   /*K*/
    { 0100, 0100, 0100, 0100, 0100, 0100, 0177 },   /*L*/
    { 0101, 0143, 0125, 0111, 0101, 0101, 0101 },   /*M*/
    { 0101, 0141, 0121, 0111, 0105, 0103, 0101 },   /*N*/
    { 0177, 0101, 0101, 0101, 0101, 0101, 0177 },   /*O*/
    { 0176, 0101, 0101, 0176, 0100, 0100, 0100 },   /*P*/
    { 076, 0101, 0101, 0101, 0105, 0102, 075 },     /*Q*/
    { 0176, 0101, 0101, 0176, 0104, 0102, 0101 },   /*R*/
    { 076, 0101, 0100, 076, 1, 0101, 076 },         /*S*/
    { 0177, 010, 010, 010, 010, 010, 010 },         /*T*/
    { 0101, 0101, 0101, 0101, 0101, 0101, 076 },    /*U*/
    { 0101, 0101, 0101, 0101, 042, 024, 010 },      /*V*/
    { 0101, 0111, 0111, 0111, 0111, 0111, 066 },    /*W*/
    { 0101, 042, 024, 010, 024, 042, 0101 },        /*X*/
    { 0101, 042, 024, 010, 010, 010, 010 },         /*Y*/
    { 0177, 2, 4, 010, 020, 040, 0177 },            /*Z*/
    { 076, 040, 040, 040, 040, 040, 076 },          /*[*/
    { 0100, 040, 020, 010, 004, 002, 001 },         /*\*/
    { 076, 2, 2, 2, 2, 2, 076 },                    /*]*/
    { 010, 024, 042, 0, 0, 0, 0 },                  /*^*/
    { 0, 000, 000, 000, 000, 000, 0177 },           /*_*/
    { 034, 034, 010, 04, 0, 0, 0 },                 /*`*/
    { 0, 014, 022, 041, 077, 041, 041 },            /*a*/
    { 0, 076, 041, 076, 041, 041, 076 },            /*b*/
    { 0, 036, 041, 040, 040, 041, 036 },            /*c*/
    { 0, 076, 041, 041, 041, 041, 076 },            /*d*/
    { 0, 077, 040, 076, 040, 040, 077 },            /*e*/
    { 0, 077, 040, 076, 040, 040, 040 },            /*f*/
    { 0, 036, 041, 040, 047, 041, 036 },            /*g*/
    { 0, 041, 041, 077, 041, 041, 041 },            /*h*/
    { 0, 004, 004, 004, 004, 004, 004 },            /*i*/
    { 0, 001, 001, 001, 001, 041, 036 },            /*j*/
    { 0, 041, 042, 074, 044, 042, 041 },            /*k*/
    { 0, 040, 040, 040, 040, 040, 077 },            /*l*/
    { 0, 041, 063, 055, 041, 041, 041 },            /*m*/
    { 0, 041, 061, 051, 045, 043, 041 },            /*n*/
    { 0, 036, 041, 041, 041, 041, 036 },            /*o*/
    { 0, 076, 041, 041, 076, 040, 040 },            /*p*/
    { 0, 036, 041, 041, 045, 042, 035 },            /*q*/
    { 0, 076, 041, 041, 076, 042, 041 },            /*r*/
    { 0, 036, 040, 036, 001, 041, 036 },            /*s*/
    { 0, 037, 004, 004, 004, 004, 004 },            /*t*/
    { 0, 041, 041, 041, 041, 041, 036 },            /*u*/
    { 0, 041, 041, 041, 041, 022, 014 },            /*v*/
    { 0, 041, 041, 041, 055, 063, 041 },            /*w*/
    { 0, 041, 022, 014, 014, 022, 041 },            /*x*/
    { 0, 021, 012, 004, 004, 004, 004 },            /*y*/
    { 0, 077, 002, 004, 010, 020, 077 },            /*z*/
    { 034, 040, 040, 0140, 040, 040, 034 },         /*{*/
    { 010, 010, 010, 0, 010, 010, 010 },            /*|*/
    { 034, 2, 2, 3, 2, 2, 034 },                    /*}*/
    { 060, 0111, 06, 0, 0, 0, 0 },                  /*~*/
    { 0, 000, 000, 000, 000, 000, 000   },          /*DEL*/
};

/*   string sizes that fit selected printer widths:
  flag/size/-w=> 72  80  81 120 132 158 174 217 225
   -hj   8        9  10  10  15  16  19  21  27  28
   -ho   9        8   8   9  13  14  17  19  24  25
   -fj  15        4   5   5   8   8  10  11  14  15
   -fo  16        4   5   5   7   8   9  10  13  14
  note: -jn "lower case" is similar to -on "CAPS"
*/

/*   table of parameter default values   */
int             dw = 80;	/*  page width, print positions  */
int             di = 0;		/*  indent, print positions  */
int             db = 0;		/*  print <pb> blank lines before arg  */
 /*  negative numbers require use of col  */
int             dnp = 0200;	/*  contrast: 0200 -> pos, 0 -> neg  */
int             doj = 0;	/*  spacing: 0 -> open, 1 -> jammed  */
int             dclr = 8;	/*  justification: 8 -> left,
			    1 -> center, 0 -> right  */
int             dtv = 0;	/*  vert size: 0 -> normal, 7 -> double  */
int             dfh = 0;	/*  hor size: 0 -> normal, 7 -> double  */
int             dex = 1;	/*  echo: 1 -> expand, 0 -> copy thru  */
int             dau = 1;	/*  mark case: 1 -> caps, 0 -> asis  */
int             dkd = 0;	/*  mark string: 0 -> pmark, 1 -> self  */

char            dmark[31] = "";	/*  marking chars - used serially  */

/*   parameters to use for current line   */
int             pw, pi, pb, pnp, poj, pclr, ptv, pfh, pex, pau, pkd;
char           *pms, pmark[31];

/*   global variables   */
char           *arg, ioarg1[121], ioarg2[121];	/*  arg pointer, input areas  */
int             aargc;
char          **aargv;
int             vx, strl;
char           *chp, *esp, *imk, *mkp, *chh, mk;

/*   e.g:	bban -nk " BBAN "
BBANBBANBBANBBANBBANBBANBBANBBANBBANBBANBBANBBANBBANBB
BANBBANBBA      BAN      ANBBAN BANBB NBBAN BANBBANBBA
ANBBANBBAN BANBB NB ANBBA BBAN B NBBA  BANB ANBBANBBAN
NBBANBBANB ANBBA BB NBBAN BAN BAN BAN B NBB NBBANBBANB
BBANBBANBB      BBA      BAN BANBB NB AN BA BBANBBANBB
BANBBANBBA BBANB AN BANBB NB       BB NBB N BANBBANBBA
ANBBANBBAN BANBB NB ANBBA BB NBBAN BA BBAN  ANBBANBBAN
NBBANBBANB      NBB      BBA BBANB AN BANBB NBBANBBANB
BBANBBANBBANBBANBBANBBANBBANBBANBBANBBANBBANBBANBBANBB
*/

int
main (int argc, char **argv)
{
    int             firstarg, i, ival, xvx, cwd;
    char           *p, *q, ol[226], *ols;

    /*   check for proper usage   */
    if (argc < 2)
    {
	printf ("Usage: bban [-abcdefghijklmnopqrstuvwx] textarg [-] [...]\n");
	printf ("[-] interpolate from stdin into command line.\n");
	printf ("-w#   (Width) The page width is set to #.\n");
	printf ("-i#   (Indent) # extra blanks are left-inserted into each output line.\n");
	printf ("-b#   (Blank lines) # extra blank lines will be output before the text\n");
	printf ("-lrc  (Left, Right, Centered) ;justification of output\n");
	printf ("-jo   (Jammed,Open) -j) omit normal 1-space border on top & left\n");
	printf ("-tv   (Tall,Vertically normal)\n");
	printf ("-fh   (Fat,Horizontally normal) \n");
	printf ("-ms   (Mark string,Self) -m) next input arg. forms cyclic banner chars\n");
	printf ("	-s) each text argument character used in forming itself.\n");
	printf ("-kd   (marK,Default mark) use the text argument string to mark itself\n");
	printf ("-au   (Asis,Uppercase) affect marking characters from -s or -k\n");
	printf ("-pn   (Positive,Negative)\n");
	printf ("-ex   (Echo,eXpand)\n");
	printf ("-g    (Global) \n");
	printf ("-q    (Quit) \n");
	printf ("The default flag settings are: -lovhsupxw120i0b0\n");
	printf ("bban -jm # text (Gives results similar to the banner command)\n");
	printf ("bban -m \\ EST -b-8ils EST \n");
	printf ("bban -jmn NUTS <12 underscores> -tfow72 ____NUTS____ -w72 <12 more>'\n");
	printf ("bban -j LO VE | bban -j -\n");
	exit (1);
    }
    /*   make cmd line args available to other routines   */
    aargc = argc;
    aargv = argv;
    /*   set parameters to default values   */
    pw = dw;
    pi = di;
    pb = db;
    pnp = dnp;
    poj = doj;
    pclr = dclr;
    ptv = dtv;
    pfh = dfh;
    pex = dex;
    pau = dau;
    pkd = dkd;
    pms = dmark;
    imk = pms;

    /*   loop on args from cmd line or std input   */
    firstarg = 1;

    while (aqarg () != 0)
    {
	if (*arg == '-')
	{			/*  analyze flag args  */
	    p = arg;		/*  note q flag in loop condition  */
	    while (*++p != '\0' && *p != 'q' && *p != 'Q')
		switch (*p)
		{
		case 'w':
		case 'W':
		    if ((ival = gint (&p)) >= 1 && ival <= 225)
			pw = ival;
		    else
			printf ("W flag needs numeric 1:225, e.g: -w80\n");
		    break;
		case 'i':
		case 'I':
		    if ((ival = gint (&p)) >= 0)
			pi = ival;
		    else
			printf ("I flag needs numeric >= 0, e.g: -i0\n");
		    break;
		case 'b':
		case 'B':
		    pb = gint (&p);	/*  extra vertical spacing  */
		    break;
		case 'n':
		case 'N':
		    pnp = 0;	/*  contrast -> negative  */
		    break;
		case 'p':
		case 'P':
		    pnp = 0200;	/*  contrast -> positive  */
		    break;
		case 'o':
		case 'O':
		    poj = 0;	/*  spacing -> open  */
		    break;
		case 'j':
		case 'J':
		    poj = 1;	/*  spacing -> jammed  */
		    break;
		case 'c':
		case 'C':
		    pclr = 1;	/*  justification -> center  */
		    break;
		case 'l':
		case 'L':
		    pclr = 8;	/*  justification -> left  */
		    break;
		case 'r':
		case 'R':
		    pclr = 0;	/*  justification -> right  */
		    break;
		case 't':
		case 'T':
		    ptv = 7;	/*  height -> double  */
		    break;
		case 'v':
		case 'V':
		    ptv = 0;	/*  height -> normal  */
		    break;
		case 'f':
		case 'F':
		    pfh = 7;	/*  width -> double  */
		    break;
		case 'h':
		case 'H':
		    pfh = 0;	/*  width -> normal  */
		    break;
		case 'e':
		case 'E':
		    pex = 0;	/*  echo only - don't expand  */
		    break;
		case 'x':
		case 'X':
		    pex = 1;	/*  expand to banner size  */
		    break;
		case 'g':
		case 'G':
		    firstarg = 1;	/*  reset global defaults  */
		    break;
		case 'a':
		case 'A':
		    pau = 0;	/*  use chars asis for mark  */
		    break;
		case 'u':
		case 'U':
		    pau = 1;	/*  use upper case for mark  */
		    break;
		case 'k':
		case 'K':
		    pkd = 1;	/*  use string to mark itself  */
		    break;
		case 'd':
		case 'D':
		    pkd = 0;	/*  revert to default mark string  */
		    break;
		case 's':
		case 'S':
		    pmark[0] = '\0';	/*  mark with self  */
		    pms = pmark;
		    pkd = 0;
		    break;
		case 'm':
		case 'M':
		    if (aqarg () == 0)
		    {
			printf ("M flag needs mark string, e.g: -m ABC\n");
			break;
		    }
		    for (i = 0; i < 30; i++)
		    {
			if (*arg == '\0')
			    break;
			if ((pmark[i] = *arg++) <= 040 ||
			    pmark[i] == 0177)
			    i--;
		    }
		    pmark[i] = '\0';
		    pms = pmark;
		    imk = pms;
		    pkd = 0;
		    break;
		default:	/*  there ain't many left!  */
		    printf ("Illegal flag \"%c\", ignored\n", *p);
		}		/*endswitch*/

	    if (firstarg)
	    {			/*  reset defaults to first flag arg  */
		dw = pw;
		di = pi;
		db = pb;
		dnp = pnp;
		doj = poj;
		dclr = pclr;
		dtv = ptv;
		dfh = pfh;
		dex = pex;
		dau = pau;
		dkd = pkd;
		p = dmark;
		q = pmark;
		while ((*p++ = *q++) != '\0')
		    ;
		pms = dmark;
	    }
	}
	else
	{			/*  non-flag argument - print it  */
	    /*   determine string length and page positioning   */
	    cwd = (pex) ? 9 + pfh - poj : 1;
	    if (pw - pi < cwd)
	    {
		printf ("-i%d and -w%d allow inadequate space\n", pi, pw);
		continue;
	    }

	    for (i = 0; i < pb; i++)
		printf ("\n");

	    for (i = 0; i > pb; i--)
		printf ("7");	/*  esc-7  */

	    for (strl = 0; arg[strl]; strl++)
		;

	    if (strl * cwd > pw - pi)
		strl = (pw - pi) / cwd;

	    ols = ol + pi + ((pw - pi - strl * cwd) >> pclr);

	    for (p = ol; p < ols; p++)
		*p = ' ';	/*  blank l.h. margin  */

	    if (pex)
	    {			/*  expand chars to banner size  */
		if (pkd)
		{		/*  mark w/string itself  */
		    p = arg;
		    for (i = 0; i < 30; i++)
		    {
			if (*p == '\0')
			    break;

			/* patch to interpret underscores as spaces */
			if (*p == '_')
			    *p = ' ';

			pmark[i] = *p++;
			if (pmark[i] <= 040 || pmark[i] == 0177)
			    i--;
			else if (pau && pmark[i] >= 'a' && pmark[i]
				 <= 'z')
			    pmark[i] -= ('a' - 'A');
		    }
		    pmark[i] = '\0';
		    pms = pmark;
		    imk = pms;
		}
		/*   loop for each horizontal slice of chars   */
		for (vx = poj; vx <= 8; vx++)
		{
		    for (xvx = 0; xvx <= ((vx & ptv) != 0); xvx++)
		    {
			esp = ol;	/*  loc of newline  */
			chp = ols;	/*  start of 1st char  */
			doline ();	/*  format one line  */
			*esp = '\0';
			printf ("%s\n", ol);	/*  VOLA!!  */
			*esp = ' ';
			if (*imk == '\0' || *++imk == '\0')
			    imk = pms;
		    }
		}
	    }
	    else
	    {			/*  echo without expansion  */
		esp = ol;
		chp = ols;
		for (i = 0; i < strl; i++)
		{
		    *chp = arg[i];
		    if (*chp++ != ' ')
			esp = chp;
		}
		*esp = '\0';
		printf ("%s\n", ol);
	    }
	    /*   reset parms to defaults   */
	    pw = dw;
	    pi = di;
	    pb = db;
	    pnp = dnp;
	    poj = doj;
	    pclr = dclr;
	    ptv = dtv;
	    pfh = dfh;
	    pex = dex;
	    pau = dau;
	    pkd = dkd;
	    if (pms != dmark)
	    {
		pms = dmark;
		imk = pms;
	    }
	}
	firstarg = 0;
    }
    for (i = 0; i < pb; i++)
	printf ("\n");

    return (0);
}

static void
doline (void)
{
    int             cx, hx, xhx, chs;
    mkp = imk;
    for (cx = 0; cx < strl; cx++)
    {				/*  loop on chars  */
	chh = arg + cx;

	/* patch to convert underscores to spaces */
	if (*chh == '_')
	    *chh = ' ';

	chs = (vx & 7) ? ctbl[(*chh)&0x7F][vx - 1] : 0;
	/*   convert mark to upper case   */
	mk = (pau && *chh >= 'a' && *chh <= 'z') ? *chh - ('a' - 'A') : *chh;
	for (hx = poj; hx <= 8; hx++)
	{			/*  vert slice  */
	    for (xhx = 0; xhx <= ((hx & pfh) != 0); xhx++)
	    {
		if (*pms)
		{		/*  cycle mark string  */
		    mk = *mkp;
		    if (*++mkp == '\0')
			mkp = pms;
		}
		*chp = ((chs << hx & 0200) == pnp) ? mk : ' ';
		if (*chp++ != ' ')
		    esp = chp;
	    }
	}
    }
}

static int
aqarg (void)
{
    static int      dashsw = 0;
    if (--aargc > 0)
    {				/*  more cmd line args  */
	if (**++aargv != '-' || *(*aargv + 1) != '\0')
	{
	    arg = *aargv;
	    dashsw = 0;
	    return 1;
	}
	else
	{			/*  lone dash - std input  */
	    dashsw = 1;
	    if (redarg ())
		return 1;
	    printf ("EOF on std input\n");
	    return 0;
	}
    }
    else
    {				/*  read input if dash last  */
	if (dashsw)
	    return (redarg ());
	arg = ioarg1;
	ioarg1[0] = '\0';
	return 0;
    }
}

static int
redarg (void)
{
    static int      c = 1, bufsw = 1;
    register int    i;

    arg = (bufsw ^= 1) ? ioarg1 : ioarg2;
    arg[0] = '\0';

    if (c == EOF)
	return 0;

    for (i = 0; i < 120; i++)
    {
	arg[i] = (c = getchar ());
	if (c == '\n' || c == EOF)
	    break;
    }

    arg[i] = '\0';

    if (c == EOF)
	return 0;

    if (c == '\n')
	return 1;

    while ((c = getchar ()) != '\n' && c != EOF)
	;

    return 1;
}

static int
gint (char **pp)
{
    int             dsw = 0, rslt = 0;

    if (*(*pp + 1) == '-')
    {
	dsw = 1;
	(*pp)++;
    }

    while (*(*pp + 1) >= '0' && *(*pp + 1) <= '9')
    {
	(*pp)++;
	rslt = 10 * rslt + **pp - '0';
    }

    if (dsw)
	return -rslt;

    return rslt;
}
