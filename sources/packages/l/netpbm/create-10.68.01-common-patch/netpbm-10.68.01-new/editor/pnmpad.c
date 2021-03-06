/* pnmpad.c - add border to sides of a portable anymap
   ** AJCD 4/9/90
 */

#include <string.h>
#include <stdio.h>

#include "pm_c_util.h"
#include "mallocvar.h"
#include "shhopt.h"
#include "pnm.h"

#define MAX_WIDTHHEIGHT INT_MAX-10

struct cmdlineInfo {
    /* All the information the user supplied in the command line,
       in a form easy for the program to use.
    */
    const char * input_filespec;  /* Filespecs of input files */
    unsigned int xsize;
    unsigned int xsizeSpec;
    unsigned int ysize;
    unsigned int ysizeSpec;
    unsigned int left;
    unsigned int right;
    unsigned int top;
    unsigned int bottom;
    unsigned int leftSpec;
    unsigned int rightSpec;
    unsigned int topSpec;
    unsigned int bottomSpec;
    float xalign;
    float yalign;
    unsigned int white;     /* >0: pad white; 0: pad black */
    unsigned int verbose;
};



static void
parseCommandLine(int argc, const char ** argv,
                 struct cmdlineInfo * const cmdlineP) {
/*----------------------------------------------------------------------------
   Note that the file spec array we return is stored in the storage that
   was passed to us as the argv array.
-----------------------------------------------------------------------------*/
    optEntry *option_def;
        /* Instructions to OptParseOptions3 on how to parse our options.
         */
    optStruct3 opt;

    unsigned int option_def_index;
    unsigned int blackOpt;
    unsigned int xalignSpec, yalignSpec;

    MALLOCARRAY_NOFAIL(option_def, 100);

    option_def_index = 0;   /* incremented by OPTENT3 */
    OPTENT3(0,   "xsize",     OPT_UINT,    &cmdlineP->xsize,
            &cmdlineP->xsizeSpec, 0);
    OPTENT3(0,   "width",     OPT_UINT,    &cmdlineP->xsize,
            &cmdlineP->xsizeSpec, 0);
    OPTENT3(0,   "ysize",     OPT_UINT,    &cmdlineP->ysize,
            &cmdlineP->ysizeSpec, 0);
    OPTENT3(0,   "height",    OPT_UINT,    &cmdlineP->ysize,
            &cmdlineP->ysizeSpec, 0);
    OPTENT3(0,   "left",      OPT_UINT,    &cmdlineP->left,
            &cmdlineP->leftSpec, 0);
    OPTENT3(0,   "right",     OPT_UINT,    &cmdlineP->right,
            &cmdlineP->rightSpec, 0);
    OPTENT3(0,   "top",       OPT_UINT,    &cmdlineP->top,
            &cmdlineP->topSpec, 0);
    OPTENT3(0,   "bottom",    OPT_UINT,    &cmdlineP->bottom,
            &cmdlineP->bottomSpec, 0);
    OPTENT3(0,   "xalign",    OPT_FLOAT,   &cmdlineP->xalign,
            &xalignSpec,           0);
    OPTENT3(0,   "halign",    OPT_FLOAT,   &cmdlineP->xalign,
            &xalignSpec,           0);
    OPTENT3(0,   "yalign",    OPT_FLOAT,   &cmdlineP->yalign,
            &yalignSpec,           0);
    OPTENT3(0,   "valign",    OPT_FLOAT,   &cmdlineP->yalign,
            &yalignSpec,           0);
    OPTENT3(0,   "black",     OPT_FLAG,    NULL,
            &blackOpt,           0);
    OPTENT3(0,   "white",     OPT_FLAG,    NULL,
            &cmdlineP->white,    0);
    OPTENT3(0,   "verbose",   OPT_FLAG,    NULL,
            &cmdlineP->verbose,  0);

    opt.opt_table = option_def;
    opt.short_allowed = FALSE;  /* We have no short (old-fashioned) options */
    opt.allowNegNum = FALSE;  /* We have no parms that are negative numbers */

    pm_optParseOptions3(&argc, (char **)argv, opt, sizeof opt, 0);
        /* Uses and sets argc, argv, and some of *cmdlineP and others. */

    if (blackOpt && cmdlineP->white)
        pm_error("You cannot specify both -black and -white");

    if (cmdlineP->topSpec > 1)
       pm_error("You can specify -top only once");

    if (cmdlineP->bottomSpec > 1)
       pm_error("You can specify -bottom only once");

    if (cmdlineP->leftSpec > 1)
       pm_error("You can specify -left only once");

    if (cmdlineP->rightSpec > 1)
       pm_error("You can specify -right only once");

    if (cmdlineP->xsizeSpec > 1)
       pm_error("You can specify -width only once");

    if (cmdlineP->ysizeSpec > 1)
       pm_error("You can specify -height only once");

    if (xalignSpec && (cmdlineP->leftSpec || cmdlineP->rightSpec))
        pm_error("You cannot specify both -xalign and -left or -right");

    if (yalignSpec && (cmdlineP->topSpec || cmdlineP->bottomSpec))
        pm_error("You cannot specify both -yalign and -top or -bottom");

    if (xalignSpec && !cmdlineP->xsizeSpec)
        pm_error("-xalign is meaningless without -width");

    if (yalignSpec && !cmdlineP->ysizeSpec)
        pm_error("-yalign is meaningless without -height");

    if (xalignSpec) {
        if (cmdlineP->xalign < 0)
            pm_error("You have specified a negative -halign value (%f)",
                     cmdlineP->xalign);
        if (cmdlineP->xalign > 1)
            pm_error("You have specified a -halign value (%f) greater than 1",
                     cmdlineP->xalign);
    } else
        cmdlineP->xalign = 0.5;

    if (yalignSpec) {
        if (cmdlineP->yalign < 0)
            pm_error("You have specified a negative -halign value (%f)",
                     cmdlineP->yalign);
        if (cmdlineP->yalign > 1)
            pm_error("You have specified a -valign value (%f) greater than 1",
                     cmdlineP->yalign);
    } else
        cmdlineP->yalign = 0.5;

    /* get optional input filename */
    if (argc-1 > 1)
        pm_error("This program takes at most 1 parameter.  You specified %d",
                 argc-1);
    else if (argc-1 == 1)
        cmdlineP->input_filespec = argv[1];
    else
        cmdlineP->input_filespec = "-";
}



static void
parseCommandLineOld(int argc, const char ** argv,
                    struct cmdlineInfo * const cmdlineP) {

    /* This syntax was abandoned in February 2002. */
    pm_message("Warning: old style options are deprecated!");

    cmdlineP->xsize = cmdlineP->ysize = 0;
    cmdlineP->left = cmdlineP->right = cmdlineP->top = cmdlineP->bottom = 0;
    cmdlineP->xalign = cmdlineP->yalign = 0.5;
    cmdlineP->white = cmdlineP->verbose = FALSE;

    while (argc >= 2 && argv[1][0] == '-') {
        if (strcmp(argv[1]+1,"black") == 0) cmdlineP->white = FALSE;
        else if (strcmp(argv[1]+1,"white") == 0) cmdlineP->white = TRUE;
        else switch (argv[1][1]) {
        case 'l':
            if (atoi(argv[1]+2) < 0)
                pm_error("left border too small");
            else if (atoi(argv[1]+2) > MAX_WIDTHHEIGHT)
                pm_error("left border too large");
            else
                cmdlineP->left = atoi(argv[1]+2);
            break;
        case 'r':
            if (atoi(argv[1]+2) < 0)
                pm_error("right border too small");
            else if (atoi(argv[1]+2) > MAX_WIDTHHEIGHT)
                pm_error("right border too large");
            else
                cmdlineP->right = atoi(argv[1]+2);
            break;
        case 'b':
            if (atoi(argv[1]+2) < 0)
                pm_error("bottom border too small");
            else if (atoi(argv[1]+2) > MAX_WIDTHHEIGHT)
                pm_error("bottom border too large");
            else
                cmdlineP->bottom = atoi(argv[1]+2);
            break;
        case 't':
            if (atoi(argv[1]+2) < 0)
                pm_error("top border too small");
            else if (atoi(argv[1]+2) > MAX_WIDTHHEIGHT)
                pm_error("top border too large");
            else
                cmdlineP->top = atoi(argv[1]+2);
            break;
        default:
            pm_usage("[-white|-black] [-l#] [-r#] [-t#] [-b#] [pnmfile]");
        }
        argc--, argv++;
    }

    cmdlineP->xsizeSpec = (cmdlineP->xsize > 0);
    cmdlineP->ysizeSpec = (cmdlineP->ysize > 0);

    if (argc > 2)
        pm_usage("[-white|-black] [-l#] [-r#] [-t#] [-b#] [pnmfile]");

    if (argc == 2)
        cmdlineP->input_filespec = argv[1];
    else
        cmdlineP->input_filespec = "-";
}



static void
validateHorizontalSize(struct cmdlineInfo const cmdline,
                       unsigned int const cols) {

    unsigned int const xsize = cmdline.xsizeSpec ? cmdline.xsize : 0;
    unsigned int const lpad  = cmdline.leftSpec  ? cmdline.left  : 0;
    unsigned int const rpad  = cmdline.rightSpec ? cmdline.right : 0;

    if (xsize > MAX_WIDTHHEIGHT)
        pm_error("The width value you specified is too large.");

    if (lpad > MAX_WIDTHHEIGHT)
        pm_error("The left padding value you specified is too large.");

    if (rpad > MAX_WIDTHHEIGHT)
        pm_error("The right padding value you specified is too large.");

    if ((double) cols + (double) lpad + (double) rpad > MAX_WIDTHHEIGHT)
        pm_error("Given padding value(s) makes output width too large.");
}



static void
computeHorizontalPadSizes(struct cmdlineInfo const cmdline,
                          unsigned int       const cols,
                          unsigned int *     const lpadP,
                          unsigned int *     const rpadP) {

    validateHorizontalSize(cmdline, cols);

    if (cmdline.xsizeSpec) {
        if (cmdline.leftSpec && cmdline.rightSpec) {
            if (cmdline.left + cols + cmdline.right < cmdline.xsize) {
                pm_error("Left padding (%u), and right "
                         "padding (%u) are insufficient to bring the "
                         "image width of %d up to %u.",
                         cmdline.left, cmdline.right, cols, cmdline.xsize);
            } else {
                *lpadP = cmdline.left;
                *rpadP = cmdline.right;
            }
        } else if (cmdline.leftSpec) {
            *lpadP = cmdline.left;
            *rpadP = MAX(cmdline.xsize, cmdline.left + cols) -
                (cmdline.left + cols);
        } else if (cmdline.rightSpec) {
            *rpadP = cmdline.right;
            *lpadP = MAX(cmdline.xsize, cols + cmdline.right) -
                (cols + cmdline.right);
        } else {
            if (cmdline.xsize > cols) {
                *lpadP = ROUNDU((cmdline.xsize - cols) * cmdline.xalign);
                *rpadP = cmdline.xsize - cols - *lpadP;
            } else {
                *lpadP = 0;
                *rpadP = 0;
            }
        }
    } else {
        *lpadP = cmdline.leftSpec  ? cmdline.left  : 0;
        *rpadP = cmdline.rightSpec ? cmdline.right : 0;
    }
}



static void
validateVerticalSize(struct cmdlineInfo const cmdline,
                     unsigned int       const rows) {

    unsigned int const ysize = cmdline.ysizeSpec  ? cmdline.ysize  : 0;
    unsigned int const tpad  = cmdline.topSpec    ? cmdline.top    : 0;
    unsigned int const bpad  = cmdline.bottomSpec ? cmdline.bottom : 0;

    if (ysize > MAX_WIDTHHEIGHT)
        pm_error("The height value you specified is too large.");

    if (tpad > MAX_WIDTHHEIGHT)
        pm_error("The top padding value you specified is too large.");

    if (bpad > MAX_WIDTHHEIGHT)
        pm_error("The bottom padding value you specified is too large.");

    if ((double) rows + (double) tpad + (double) bpad > MAX_WIDTHHEIGHT)
        pm_error("Given padding value(s) makes output height too large.");
}



static void
computeVerticalPadSizes(struct cmdlineInfo const cmdline,
                        int                const rows,
                        unsigned int *     const tpadP,
                        unsigned int *     const bpadP) {

    validateVerticalSize(cmdline, rows);

    if (cmdline.ysizeSpec) {
        if (cmdline.topSpec && cmdline.bottomSpec) {
            if (cmdline.bottom + rows + cmdline.top < cmdline.ysize) {
                pm_error("Top padding (%u), and bottom "
                         "padding (%u) are insufficient to bring the "
                         "image height of %d up to %u.",
                         cmdline.top, cmdline.bottom, rows, cmdline.ysize);
            } else {
                *tpadP = cmdline.top;
                *bpadP = cmdline.bottom;
            }
        } else if (cmdline.topSpec) {
            *tpadP = cmdline.top;
            *bpadP = MAX(cmdline.ysize, cmdline.top + rows) -
                (cmdline.top + rows);
        } else if (cmdline.bottomSpec) {
            *bpadP = cmdline.bottom;
            *tpadP = MAX(cmdline.ysize, rows + cmdline.bottom) -
                (rows + cmdline.bottom);
        } else {
            if (cmdline.ysize > rows) {
                *bpadP = ROUNDU((cmdline.ysize - rows) * cmdline.yalign);
                *tpadP = cmdline.ysize - rows - *bpadP;
            } else {
                *bpadP = 0;
                *tpadP = 0;
            }
        }
    } else {
        *bpadP = cmdline.bottomSpec ? cmdline.bottom : 0;
        *tpadP = cmdline.topSpec    ? cmdline.top    : 0;
    }
}



static void
computePadSizes(struct cmdlineInfo const cmdline,
                int                const cols,
                int                const rows,
                unsigned int *     const lpadP,
                unsigned int *     const rpadP,
                unsigned int *     const tpadP,
                unsigned int *     const bpadP) {

    computeHorizontalPadSizes(cmdline, cols, lpadP, rpadP);

    computeVerticalPadSizes(cmdline, rows, tpadP, bpadP);

    if (cmdline.verbose)
        pm_message("Padding: left: %u; right: %u; top: %u; bottom: %u",
                   *lpadP, *rpadP, *tpadP, *bpadP);
}



static void
padPbm(FILE *       const ifP,
       unsigned int const cols,
       unsigned int const rows,
       int          const format,
       unsigned int const newcols,
       unsigned int const lpad,
       unsigned int const rpad,
       unsigned int const tpad,
       unsigned int const bpad,
       bool         const colorWhite) {
/*----------------------------------------------------------------------------
  Fast padding routine for PBM
-----------------------------------------------------------------------------*/
    unsigned char * const bgrow  = pbm_allocrow_packed(newcols);
    unsigned char * const newrow = pbm_allocrow_packed(newcols);

    unsigned char const padChar =
        0xff * (colorWhite ? PBM_WHITE : PBM_BLACK);

    unsigned int const newColChars = pbm_packed_bytes(newcols);

    unsigned int row;
    unsigned int charCnt;

    /* Set up margin row, input-output buffer */
    for (charCnt = 0; charCnt < newColChars; ++charCnt)
        bgrow[charCnt] = newrow[charCnt] = padChar;

    if (newcols % 8 > 0) {
        bgrow[newColChars-1]  <<= 8 - newcols % 8;
        newrow[newColChars-1] <<= 8 - newcols % 8;
    }

    pbm_writepbminit(stdout, newcols, rows + tpad + bpad, 0);

    /* Write top margin */
    for (row = 0; row < tpad; ++row)
        pbm_writepbmrow_packed(stdout, bgrow, newcols, 0);
    
    /* Read rows, shift and write with left and right margins added */
    for (row = 0; row < rows; ++row) {
        pbm_readpbmrow_bitoffset(ifP, newrow, cols, format, lpad);
        pbm_writepbmrow_packed(stdout, newrow, newcols, 0);
    }

    pnm_freerow(newrow);

    /* Write bottom margin */
    for (row = 0; row < bpad; ++row)
        pbm_writepbmrow_packed(stdout, bgrow, newcols, 0);

    pnm_freerow(bgrow);
}


static void
padGeneral(FILE *       const ifP,
           unsigned int const cols,
           unsigned int const rows,
           xelval       const maxval,
           int          const format,
           unsigned int const newcols,
           unsigned int const lpad,
           unsigned int const rpad,
           unsigned int const tpad,
           unsigned int const bpad,
           bool         const colorWhite) {
/*----------------------------------------------------------------------------
  General padding routine (logic works for PBM)
-----------------------------------------------------------------------------*/
    xel * const bgrow  = pnm_allocrow(newcols);
    xel * const xelrow = pnm_allocrow(newcols);
    xel background;
    unsigned int row, col;

    if (colorWhite)
        background = pnm_whitexel(maxval, format);
    else
        background = pnm_blackxel(maxval, format);

    for (col = 0; col < newcols; ++col)
        xelrow[col] = bgrow[col] = background;

    pnm_writepnminit(stdout, newcols, rows + tpad + bpad, maxval, format, 0);

    for (row = 0; row < tpad; ++row)
        pnm_writepnmrow(stdout, bgrow, newcols, maxval, format, 0);

    for (row = 0; row < rows; ++row) {
        pnm_readpnmrow(ifP, &xelrow[lpad], cols, maxval, format);
        pnm_writepnmrow(stdout, xelrow, newcols, maxval, format, 0);
    }

    for (row = 0; row < bpad; ++row)
        pnm_writepnmrow(stdout, bgrow, newcols, maxval, format, 0);

    pnm_freerow(xelrow);
    pnm_freerow(bgrow);
}



int
main(int argc, const char ** argv) {

    struct cmdlineInfo cmdline;
    FILE * ifP;

    xelval maxval;
    int rows, cols, newcols, format;
    bool depr_cmd; /* use deprecated commandline interface */
    unsigned int lpad, rpad, tpad, bpad;

    pm_proginit(&argc, argv);

    /* detect deprecated options */
    depr_cmd = FALSE;  /* initial assumption */
    if (argc > 1 && argv[1][0] == '-') {
        if (argv[1][1] == 't' || argv[1][1] == 'b'
            || argv[1][1] == 'l' || argv[1][1] == 'r') {
            if (argv[1][2] >= '0' && argv[1][2] <= '9')
                depr_cmd = TRUE;
        }
    }
    if (argc > 2 && argv[2][0] == '-') {
        if (argv[2][1] == 't' || argv[2][1] == 'b'
            || argv[2][1] == 'l' || argv[2][1] == 'r') {
            if (argv[2][2] >= '0' && argv[2][2] <= '9')
                depr_cmd = TRUE;
        }
    }

    if (depr_cmd)
        parseCommandLineOld(argc, argv, &cmdline);
    else
        parseCommandLine(argc, argv, &cmdline);

    ifP = pm_openr(cmdline.input_filespec);

    pnm_readpnminit(ifP, &cols, &rows, &maxval, &format);

    if (cmdline.verbose) pm_message("image WxH = %dx%d", cols, rows);

    computePadSizes(cmdline, cols, rows, &lpad, &rpad, &tpad, &bpad);

    overflow_add(cols, lpad);
    overflow_add(cols + lpad, rpad);
    newcols = cols + lpad + rpad;

    if (PNM_FORMAT_TYPE(format) == PBM_TYPE)
        padPbm(ifP, cols, rows, format, newcols, lpad, rpad, tpad, bpad,
               !!cmdline.white);
    else
        padGeneral(ifP, cols, rows, maxval, format, 
                   newcols, lpad, rpad, tpad, bpad, !!cmdline.white);

    pm_close(ifP);

    return 0;
}
