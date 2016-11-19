/*
 * xf86Aiptek
 *
 * This driver assumes Linux USB/HID support, available for USB devices.
 * 
 * Version 0.0, 1-Jan-2003, Bryan W. Headley
 *
 * Version 1.0 10-jan-2008, Rene van Paassen
 *  * This version is based on the Xorg driver 1.0.1 version, with 
 *    fixes based on the version developed at aiptektablet.sourceforge.net
 *    fixes include - correction of the button status calculation
 *                    (buttons were never released) 
 *                  - use stylus as default, because reading the
 *                    tablet before X start gives no hint as to what device
 *                    it is producing
 *                  - correction of the proximity bit detection
 *                  - although tablet may produce relative (x, y), the z and 
 *                    tilt values are always absolute, corrected that
 *                  - relative x and y may be negative sometimes! removed 
 *                    clipping there
 *                  - filtering out events only if ALL values are equal to 
 *                    the, previous not when only one or more is equal + 
 *                    combined filtering with threshold.
 *                  
 * 
 * Copyright 2003 by Bryan W. Headley. <bwheadley@earthlink.net>
 *
 * Lineage: This driver is based on both the xf86HyperPen and xf86Wacom tablet
 *          drivers.
 *
 *      xf86HyperPen -- modified from xf86Summa (c) 1996 Steven Lang
 *          (c) 2000 Roland Jansen
 *          (c) 2000 Christian Herzog (button & 19200 baud support)
 *
 *      xf86Wacom -- (c) 1995-2001 Frederic Lepied
 *
 *
 * Permission to use, copy, modify, distribute, and sell this software and its
 * documentation for any purpose is hereby granted without fee, provided that
 * the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation, and that the name of Bryan W. Headley not be used in 
 * advertising or publicity pertaining to distribution of the software 
 * without specific, written prior permission.  Bryan W. Headley makes no 
 * representations about the suitability of this software for any purpose.  
 * It is provided "as is" without express or implied warranty.
 *
 * BRYAN W. HEADLEY DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
 * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
 * EVENT SHALL BRYAN W. HEADLEY BE LIABLE FOR ANY SPECIAL, INDIRECT OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
 * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
 * TORTIOUS ACTIONS, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */

/*
 *
 * Section "InputDevice"
 *      Identifier  "stylus"
 *      Driver      "aiptek"
 *      Option      "Device"        "pathname" {/dev/input/event0}
 *      Option      "Type"          "string" {stylus|cursor|eraser}
 *      Option      "Mode"          "string" {absolute|relative}
 *      Option      "Cursor"        "string" {stylus|puck}
 *      Option      "USB"           "bool"   {on|off}
 *      Option      "ScreenNo"      "int"
 *      Option      "KeepShape"     "bool"   {on|off}
 *
 *      # The tablet reports top-right as 0 for the given coordinate
 *      # to bottom-left as num (value dependent on tablet.)
 *      # If you choose to invert X, Y or both, the bottom-left coordinate
 *      # is reported as 0.
 *      Option      "InvX"          "bool"   {on|off}
 *      Option      "InvY"          "bool"   {on|off}
 *
 *      # XSize/YSize/XOffset/YOffset allow you to specify an active
 *      # area within yout tablet.
 *
 *      Option      "XSize"         "int"
 *      Option      "YSize"         "int"
 *      
 *      Option      "XTop"          "int"
 *      Option      "YTop"          "int"
 *      Option      "XBottom"       "int"
 *      Option      "YBottom"       "int"
 *      Option      "XOffset"       "int"
 *      Option      "YOffset"       "int"
 *
 *      Option      "XMax"          "int"
 *      Option      "YMax"          "int"
 *      Option      "ZMax"          "int"
 *      Option      "ZMin"          "int"
 *
 *      Option      "XThreshold"  "int"
 *      Option      "YThreshold"  "int"
 *      Option      "ZThreshold"  "int"
 *
 *      Option      "Pressure"      "Soft|Hard|Linear"  defaults to Linear
 *
 *      Option      "alwayscore"  "bool"   {on|off}
 *      Option      "debuglevel"  "int"
 *      Option      "HistorySize" "int"
 * EndSection
 *
 *  Commentary:
 *  1.  Identifier: what you name your input device is not too
 *      significant. 
 *      but what it infers is that you can have a driver with
 *      a name of "stylus" (whose type would be 'stylus') and
 *      another one with identifier "cursor" (whose type would be
 *      'cursor') that both would be driver by the same aiptek
 *      driver. Note though that the identifier keyword has
 *      no devicetype connotations: you can identify your input
 *      device as "zzz", 
 *
 */

#include "xf86Aiptek.h"
#include <errno.h>
#include <string.h>
#include <math.h>

#include <X11/Xatom.h>
#include <xserver-properties.h>

#if GET_ABI_MAJOR(ABI_XINPUT_VERSION) < 12
#error "Need a server with input ABI 12"
#endif

static InputDriverPtr aiptekDrv;
static int debug_level = INI_DEBUG_LEVEL;

static char *default_options[] =
{
    "BaudRate",     "9600",
    "StopBits",     "1",
    "DataBits",     "8",
    "Parity",       "None",
    "VMin",         "1",
    "Vtime",        "10",
    "FlowControl",  "Xoff",
    NULL
};

_X_EXPORT InputDriverRec AIPTEK =
{
    1,                  /* driver version */
    "aiptek",           /* driver name */
    NULL,               /* identify */
    xf86AiptekInit,     /* pre-init */
    xf86AiptekUninit,   /* un-init */
    NULL,               /* module */
    default_options
};

/*
 * This is the map of Linux Event Input system keystrokes sent for
 * the macro keys. There are discrepancies in the mappings, so for example,
 * if we wanted to implement full macro key-to-string conversion in the
 * Linux driver, we'd have to accept 1-to-many keyboard events, several of
 * whom would not have the same encoding. For this reason, we're biting
 * the bullet now & implementing a simple lookup/translation scheme.
 * A simple 'KEY_F1 = XK_F1' layout wouldn't work, because X wants an
 * offset into the KeySym array above, and it'll look up that this means 
 * XK_whatever...
 */

static int linux_inputDevice_keyMap[] =
{
    KEY_F1,  KEY_F2,  KEY_F3,  KEY_F4,  KEY_F5,  KEY_F6,  KEY_F7,  KEY_F8,
    KEY_F9,  KEY_F10, KEY_F11, KEY_F12, KEY_F13, KEY_F14, KEY_F15, KEY_F16,
    KEY_F17, KEY_F18, KEY_F19, KEY_F20, KEY_F21, KEY_F22, KEY_F23, KEY_F24, 
    KEY_STOP, KEY_AGAIN, KEY_PROPS, KEY_UNDO, KEY_FRONT, KEY_COPY,
    KEY_OPEN, KEY_PASTE
};

/**********************************************************************
 * xf86AiptekSendEvents
 *  Send events according to the device state.
 */
static void
xf86AiptekSendEvents(InputInfoPtr pInfo, int r_z)
{
    AiptekDevicePtr device = (AiptekDevicePtr) pInfo->private;
    AiptekCommonPtr common = device->common;

    int bAbsolute;
    int x, y, z, xTilt, yTilt;

    if ((DEVICE_ID(device->flags) != common->currentValues.eventType))
    {
        DBG(7,"xf86AiptekSendEvents: not the same device type (%u,%u)\n",
           DEVICE_ID(device->flags), common->currentValues.eventType);
        return;
    }

    bAbsolute    = (device->flags & ABSOLUTE_FLAG);

    /*
     * Normalize X and Y coordinates. This includes dealing
     * with absolute/relative coordinate mode.
     */
    if (bAbsolute)
    {
        x = common->currentValues.x;
        y = common->currentValues.y;

        /* Translate coordinates according to Top and Bottom points.
         */
        if (x > device->xBottom) {
            x = device->xBottom;
        }

        if (y > device->yBottom) {
            y = device->yBottom;
        }

	if (device->xTop > 0) {
	    DBG(10, "Adjusting x, with xTop=%d\n", device->xTop);
	    x -= device->xTop;
	}

	if (device->yTop > 0) {
	    DBG(10, "Adjusting y, with yTop=%d\n", device->yTop);
	    y -= device->yTop;
	}

	if (x < 0) {
	    x = 0;
	}
	if (y < 0) {
	    y = 0;
	}

    }
    else
    {
        if (common->previousValues.proximity != 0)
        {
            x = common->currentValues.x - common->previousValues.x;
            y = common->currentValues.y - common->previousValues.y;
        }
        else
        {
            x = 0;
            y = 0;
        }
    }

    z = r_z;
    xTilt = common->currentValues.xTilt;
    yTilt = common->currentValues.yTilt;

    
    /* Deal with pressure min..max, which differs from threshold. */
    if (z < device->zMin) {
        z = 0;
    }

    if (z > device->zMax) {
        z = device->zMax;
    }

    /*
     * First, handle the macro keys.
     */
    if (common->currentValues.macroKey != VALUE_NA)
    {
        int i;

        /* This is a little silly, but: The Linux Event Input
         * system uses a slightly different keymap than does X 
         * (it also has more keys defined). So, we have to go
         * through a translation process. It's made sillier than
         * required because X wants an offset to it's KeySym table,
         * rather than an event key -- it'll do it's own lookup.
         * It DOES support arbitrary ordering of key events, and
         * partial keyboard matrices, so that speaks in favor of this
         * scheme.
         */
        for (i = 0; 
             i < sizeof(linux_inputDevice_keyMap)/
                 sizeof(linux_inputDevice_keyMap[0]);
             ++i)
        {
            if (linux_inputDevice_keyMap[i]==common->currentValues.macroKey)
            {
                /* First available Keycode begins at 8 => macro+8.
                 * It's pervasive throughout the Xinput drivers, and
                 * no, I don't know why they purposively waste the first 8
                 * positions of the KeySym map...
                 */

                /* Keyboard 'make' (press) event */
                xf86PostKeyEvent(pInfo->dev, i+8, TRUE
#if GET_ABI_MAJOR(ABI_XINPUT_VERSION) < 22
                                 , bAbsolute, 0, 5,
                                 x, y, common->currentValues.button, xTilt, yTilt
#endif
                );
                /* Keyboard 'break' (depress) event */
                xf86PostKeyEvent(pInfo->dev, i+8, FALSE
#if GET_ABI_MAJOR(ABI_XINPUT_VERSION) < 22
                                 , bAbsolute, 0, 5,
                                 x, y, common->currentValues.button, xTilt, yTilt
#endif
                );
                break;
            }
        }

    }

    /* As the coordinates are ready, we can send events to X */
    if (common->currentValues.proximity)
    {
        if (!common->previousValues.proximity)
                xf86PostProximityEvent(pInfo->dev, 1, 0, 5,
                    x, y, z, xTilt, yTilt);

        if ((bAbsolute &&
             (common->previousValues.x != common->currentValues.x ||
              common->previousValues.y != common->currentValues.y ||
              common->previousValues.z != common->currentValues.z)) ||
            (!bAbsolute && 
             (common->currentValues.x || common->currentValues.y)))
        {
            if (bAbsolute || common->previousValues.proximity)
            {
                xf86PostMotionEvent(pInfo->dev, bAbsolute, 0, 5,
                        x, y, z, xTilt, yTilt);
            }
        }
       
        if (common->previousValues.button != common->currentValues.button)
        {
            int delta;
            delta = common->currentValues.button ^ common->previousValues.button;
            while(delta)
            {
                int id;
                id = ffs(delta);
                delta &= ~(1 << (id-1));
                xf86PostButtonEvent(pInfo->dev, bAbsolute, id,
                        (common->currentValues.button & (1<<(id-1))), 0, 5,
                        x, y, z, xTilt, yTilt);
            }
        }
    }
    else
    {
        if (common->previousValues.proximity)
            xf86PostProximityEvent(pInfo->dev, 0, 0, 5, x, y, z,
                    xTilt, yTilt);
        common->previousValues.proximity = 0;
    }
}

/*
 ***************************************************************************
 * xf86AiptekHIDReadInput --
 *    Read the new events from the device, and enqueue them.
 */
static void
xf86AiptekHIDReadInput(InputInfoPtr pInfo)
{
    AiptekDevicePtr     device = (AiptekDevicePtr) pInfo->private;
    AiptekCommonPtr     common = device->common;

    ssize_t             len;
    int                 i;
    struct input_event* event;
    char                eventbuf[sizeof(struct input_event) * MAX_EVENTS];
    int                 eventsInMessage;
    double              d_z;
    double              d_zCapacity;

    SYSCALL(len = read(pInfo->fd, eventbuf, sizeof(eventbuf)));

    if (len <= 0)
    {
        xf86Msg(X_ERROR, "Error reading Aiptek tablet: %s\n", strerror(errno));
        return;
    }

    eventsInMessage = 0;
    for (event=(struct input_event *)(eventbuf);
         event<(struct input_event *)(eventbuf+len);
         ++event)
    {
        /*
         * Unprocessed events:
         * ABS_RZ - rotate stylus
         * ABS_DISTANCE - unknown
         * ABS_THROTTLE - unknown
         * ABS_WHEEL - we have no wheel
         * REL_WHEEL - we have no wheel
         *
         * Synthesized events
         * ABS_X_TILT - The aiptek tablet does not report these,
         * ABS_Y_TILT - but the Linux kernel driver sends synthetic values.
         */
        switch (event->type)
        {
            case EV_ABS:
            {
                switch (event->code)
                {
                    case ABS_X:
                    {
                        ++eventsInMessage;
                        common->currentValues.x = event->value;
                    }
                    break;

                    case ABS_Y:
                    {
                        ++eventsInMessage;
                        common->currentValues.y = event->value;
                    }
                    break;

                    case ABS_PRESSURE:
                    {
                        ++eventsInMessage;
                        common->currentValues.z = event->value;
                    }
                    break;

                    case ABS_TILT_X:
                    case ABS_RZ:
                    {
                        ++eventsInMessage;
                        common->currentValues.xTilt = event->value;
                    }
                    break;

                    case ABS_TILT_Y:
                    {
                        ++eventsInMessage;
                        common->currentValues.yTilt = event->value;
                    }
                    break;

                    case ABS_DISTANCE:
                    {
                        ++eventsInMessage;
                        common->currentValues.distance = event->value;
                    }
                    break;

                    case ABS_WHEEL:
                    case ABS_THROTTLE:
                    {
                        ++eventsInMessage;
                        common->currentValues.wheel = event->value;
                    }
                    break;

                    case ABS_MISC:
                    {
                        /* We have an agreement with the
                         * Linux Aiptek HID driver to send
                         * the proximity bit through ABS_MISC.
                         * We do this solely if proximity is
                         * being reported through the Stylus tool;
                         * else, if mouse, we'll get proximity through
                         * REL_MISC.
                         */
                        ++eventsInMessage;
                        common->currentValues.proximity = 
                            PROXIMITY(event->value) ? 1 : 0;
                    }
                    break;
                }
            }
            break; /* EV_ABS */

            case EV_REL:
            {
                switch (event->code)
                {
                    case REL_X:
                    {
                        /* Normalize all relative events into absolute
                         * coordinates.
                         */
                        ++eventsInMessage;
                        common->currentValues.x = 
                            common->previousValues.x + event->value;
                    }
                    break;

                    case REL_Y:
                    {
                        /* Normalize all relative events into absolute
                         * coordinates.
                         */
                        ++eventsInMessage;
                        common->currentValues.y =
                            common->previousValues.y + event->value;
                    }
                    break;

                    case REL_WHEEL:
                    {
                        /* Normalize all relative events into absolute
                         * coordinates.
                         */
                        ++eventsInMessage;
                        common->currentValues.wheel =
                            common->previousValues.wheel + event->value;
                    }

                    case REL_MISC:
                    {
                        /* We have an agreement with the
                         * Linux Aiptek HID driver to send
                         * the proximity bit through REL_MISC.
                         * We do this solely if proximity is
                         * being reported through the Mouse tool;
                         * else, if stylus, we'll get proximity through
                         * ABS_MISC.
                         */
                        ++eventsInMessage;
                        common->currentValues.proximity = 
                            PROXIMITY (event->value) ? 1 : 0;
                    }
                    break;
                }
            }
            break; /* EV_REL */

            case EV_KEY:
            {
                switch (event->code)
                {
                    /*
                     * Events begun with a BTN_TOOL_PEN, PENCIL,
                     * BRUSH or AIRBRUSH indicate that they are
                     * destined for the STYLUS device.
                     *
                     * This should probably change, and we should
                     * have devices for each type. We'll address that
                     * later.
                     */
                    case BTN_TOOL_PEN:
                    case BTN_TOOL_PENCIL:
                    case BTN_TOOL_BRUSH:
                    case BTN_TOOL_AIRBRUSH:
                    {
                        ++eventsInMessage;
                        common->currentValues.eventType = STYLUS_ID;
                    }
                    break;

                    /*
                     * Events begun with a BTN_TOOL_RUBBER indicate
                     * that they are destined for the ERASER device.
                     */
                    case BTN_TOOL_RUBBER:
                    {
                        ++eventsInMessage;
                        common->currentValues.eventType = ERASER_ID;
                    }
                    break;

                    /*
                     * A TOOL_LENS would be for a true PUCK/CURSOR.
                     * Aiptek instead gives us a mouse, that we can pretend
                     * is a puck.
                     */
                    case BTN_TOOL_MOUSE:
                    case BTN_TOOL_LENS:
                    {
                        ++eventsInMessage;
                        common->currentValues.eventType = CURSOR_ID;
                    }
                    break;

                    /*
                     * Normal button handling: TOUCH, STYLUS and
                     * STYLUS2 all buttons that we'll report to X
                     * as normal buttons.
                     */
                    case BTN_TOUCH:
                    {
                        ++eventsInMessage;
                        if (event->value)
                            common->currentValues.button |= 
			        BUTTONS_EVENT_TOUCH;
			else
			    common->currentValues.button &= 
			        ~BUTTONS_EVENT_TOUCH;
                    }
                    break;

                    case BTN_STYLUS:
                    {
                        ++eventsInMessage;
                        if (event->value)
                            common->currentValues.button |= 
			        BUTTONS_EVENT_STYLUS;
			else
			    common->currentValues.button &= 
			        ~BUTTONS_EVENT_STYLUS;
                    }
                    break;

                    case BTN_STYLUS2:
                    {
                        ++eventsInMessage;
                        if (event->value)
                            common->currentValues.button |= 
			        BUTTONS_EVENT_STYLUS2;
			else
			    common->currentValues.button &= 
			        ~BUTTONS_EVENT_STYLUS2;
                    }
                    break;

                    /*
                     * Normal Mouse button handling: LEFT, RIGHT and
                     * MIDDLE all buttons that we'll report to X
                     * as normal buttons. Note that the damned things
                     * re-use the same bitmasks as the Stylus buttons,
                     * above.
                     */
                    case BTN_LEFT:
                    {
                        ++eventsInMessage;
                        if (event->value)
                            common->currentValues.button |= 
			        BUTTONS_EVENT_MOUSE_LEFT;
			else
			    common->currentValues.button &= 
			        ~BUTTONS_EVENT_MOUSE_LEFT;
                    }
                    break;

                    case BTN_MIDDLE:
                    {
                        ++eventsInMessage;
                        if (event->value)
                            common->currentValues.button |= 
			        BUTTONS_EVENT_MOUSE_MIDDLE;
			else
			    common->currentValues.button &= 
			        ~BUTTONS_EVENT_MOUSE_MIDDLE;
                    }
                    break;

                    case BTN_RIGHT:
                    {
                        ++eventsInMessage;
                        if (event->value)
                            common->currentValues.button |= 
			        BUTTONS_EVENT_MOUSE_RIGHT;
			else
			    common->currentValues.button &= 
			        ~BUTTONS_EVENT_MOUSE_RIGHT;
                    }
                    break;

                    case BTN_SIDE:
                    {
                        ++eventsInMessage;
                        if (event->value)
                            common->currentValues.button |= 
			        BUTTONS_EVENT_SIDE_BTN;
			else
			    common->currentValues.button &= 
			        ~BUTTONS_EVENT_SIDE_BTN;
                    }
                    break;

                    case BTN_EXTRA:
                    {
                        ++eventsInMessage;
                        if (event->value)
                            common->currentValues.button |= 
			        BUTTONS_EVENT_EXTRA_BTN;
			else
			    common->currentValues.button &= 
			        ~BUTTONS_EVENT_EXTRA_BTN;
                    }
                    break;

                    /*
                     * Any other EV_KEY event is assumed to be
                     * the pressing of a macro key from the tablet.
                     */
                    default:
                    {
                        ++eventsInMessage;
                        common->currentValues.macroKey = event->code;
                    }
                    break;
                }
            }
            break; /* EV_KEY */

        } /* switch event->type */

        /* We have two potential event terminators. EV_MSC was used
         * by (unwritten) convention to indicate the end-of-report.
         * Problem is, EV_MSC is supposed to actually report data,
         * so a new event type, EV_SYN, was created in Linux 2.5.x
         * expressively for this purpose.
         *
         * Theoretically, if EV_SYN is defined, I should only terminate
         * the population of device->currentValues struct IFF I receive
         * that event. The fact of the matter is, the EV_MSC is assumed
         * to be an ugliness that will take some time to be deprecated.
         * For the nonce, we'll support both. But, if you have a tablet
         * that's actually supplying something interesting with EV_MSC,
         * this is obviously some code that requires modifications.
         */
#ifndef EV_SYN
        if (event->type != EV_MSC)
#else
        if (event->type != EV_MSC && event->type != EV_SYN)
#endif
        {
            continue;
        }

        /*
         * We've seen EV_MSCs in the incoming data trail with no
         * other message types in-between. We use 'eventsInMessage'
         * to count all 'real' messages in-between. If there were none,
         * do NOT copy common->currentValues to common->previousValues
         * (as this will make the jitter filter useless). Just go and
         * read the subsequent events.
         */
        if (eventsInMessage == 0)
        {
            continue;
        }
        eventsInMessage = 0;

        /* 
         * This filter throws out reports that do not meet minimum threshold
         * requirements for movement along that axis.
         *
         * Presently, we discard the entire report if any dimension of the
         * currentValues struct does not meet it's minimum threshold.
         *
         * Also, we only do the comparison IFF a threshold has been set
         * for that given dimension.
         */
        if (ABS(common->currentValues.x - common->previousValues.x)
                    <= device->xThreshold &&
            ABS(common->currentValues.y - common->previousValues.y)
                    <= device->yThreshold &&
            ABS(common->currentValues.z - common->previousValues.z)
                    <= device->zThreshold &&
            ABS(common->currentValues.xTilt - common->previousValues.xTilt)
                    <= device->xTiltThreshold &&
            ABS(common->currentValues.yTilt - common->previousValues.yTilt)
                    <= device->yTiltThreshold &&
	    common->currentValues.proximity == 
                    common->previousValues.proximity &&
            common->currentValues.button ==
                    common->previousValues.button &&
            common->currentValues.macroKey ==
                    common->previousValues.macroKey)
        {
            DBG(10, "Event Filtered Out by Thresholds\n");
            continue;
        }

        /*
         * We have three different methods by which we report pressure, Z.
         * One is to use linear values from 0 to common->zCapacity. The
         * other two, SOFT_SMOOTH and HARD_SMOOTH, use different
         * algorithms to 'smooth out' the values.
         */
        d_z         = (double)common->currentValues.z;
        d_zCapacity = (double)common->zCapacity;

        switch (device->zMode)
        {
            case VALUE_NA:
            case PRESSURE_MODE_LINEAR:
            {
                /* Leave Z alone. */
            }
            break;

            case PRESSURE_MODE_SOFT_SMOOTH:
            {
                d_z = (d_z * d_z / d_zCapacity)+ 0.5;
            }
            break;

            case PRESSURE_MODE_HARD_SMOOTH:
            {
                d_z = (d_zCapacity * sqrt( d_z / d_zCapacity)) + 0.5;
            }
            break;
        }

        /* Dispatch events to all of our configured devices. */
        for (i=0; i < common->numDevices; ++i)
        {
            AiptekDevicePtr dev = common->deviceArray[i]->private;
            int             id;

            id  = DEVICE_ID (dev->flags);

            /* Find the device the current events are meant for */
            if (id == common->currentValues.eventType)
            {
                /* We left 'z' alone during smoothing, so send up
                 * perturbed value outside of the struct
                 */
                xf86AiptekSendEvents(common->deviceArray[i], (int) d_z);
            }
        }

        /*
         * Copy the values just processed into the previousValues struct,
         * so we can check for 'jittering' in the subsequent report.
         */
        common->previousValues.eventType = common->currentValues.eventType;
        common->previousValues.x         = common->currentValues.x;
        common->previousValues.y         = common->currentValues.y;
        common->previousValues.z         = common->currentValues.z;
        common->previousValues.proximity = common->currentValues.proximity;
        common->previousValues.button    = common->currentValues.button;
        common->previousValues.macroKey  = common->currentValues.macroKey;
        common->previousValues.xTilt     = common->currentValues.xTilt;
        common->previousValues.yTilt     = common->currentValues.yTilt;
        common->previousValues.distance  = common->currentValues.distance;
        common->previousValues.wheel     = common->currentValues.wheel;

        common->currentValues.macroKey   = VALUE_NA;
    }
}

/*
 ***************************************************************************
 *
 * xf86AiptekHIDOpen --
 *
 ***************************************************************************
 */
static Bool
xf86AiptekHIDOpen(InputInfoPtr pInfo)
{
    AiptekDevicePtr device = (AiptekDevicePtr)pInfo->private;
    AiptekCommonPtr common = device->common;
    char            name[256] = "Unknown";
    int             abs[5];
    unsigned long   bit[EV_MAX][NBITS(KEY_MAX)];
    int             i, j;
    int             err = 0;
    int             version;

    pInfo->fd = xf86OpenSerial(pInfo->options);
    if (pInfo->fd == -1)
    {
        xf86Msg(X_ERROR, "xf86AiptekHIDOpen Error opening %s : %s\n", common->deviceName, strerror(errno));
        return !Success;
    }

    ioctl(pInfo->fd, EVIOCGNAME(sizeof(name)), name);
    xf86Msg(X_PROBED, "HID Device name: \"%s\"\n", name);

    ioctl(pInfo->fd, EVIOCGVERSION, &version);
    xf86Msg(X_PROBED, "HID Driver Version: %d.%d.%d\n",
            version>>16, (version>>8) & 0xff, version & 0xff);

    xf86Msg(X_PROBED, "HID Driver knows it has %d devices configured\n",
            common->numDevices);
    xf86Msg(X_PROBED, "HID Driver is using %d as the fd\n", pInfo->fd);

    for (i = 0; i < common->numDevices; ++i)
    {
        common->deviceArray[i]->read_input = xf86AiptekHIDReadInput;
        common->deviceArray[i]->fd = pInfo->fd;
    }
    common->open = xf86AiptekHIDOpen;

    memset(bit, 0, sizeof(bit));
    ioctl(pInfo->fd, EVIOCGBIT(0, EV_MAX), bit[0]);

    for (i = 0; i < EV_MAX; ++i)
    {
        if (TEST_BIT(i, bit[0]))
        {
            ioctl(pInfo->fd, EVIOCGBIT(i, KEY_MAX), bit[i]);
            for (j = 0; j < KEY_MAX; ++j)
            {
                if (TEST_BIT(j, bit[i]))
                {
                    if (i == EV_ABS)
                    {
                        ioctl(pInfo->fd, EVIOCGABS(j), abs);
                        switch (j) 
                        {
                            case ABS_X:
                            {
                                xf86Msg(X_ERROR, "From ioctl() xCapacity=%d\n", abs[2]);
                                common->xCapacity = abs[2];
                            }
                            break;

                            case ABS_Y:
                            {
                                xf86Msg(X_ERROR, "From ioctl() yCapacity=%d\n", abs[2]);
                                common->yCapacity = abs[2];
                            }
                            break;

                            case ABS_Z:
                            {
                                xf86Msg(X_ERROR, "From ioctl() zCapacity=%d\n", abs[2]);
                                common->zCapacity = abs[2];
                            }
                            break;
                        }
                    }
                }
            }
        }
    }

    if (err < 0)
    {
        xf86Msg(X_ERROR, "xf86AiptekHIDOpen ERROR: %d\n", err);
        SYSCALL(close(pInfo->fd));
        return !Success;
    }

    return Success;
}

/*
 * xf86AiptekControlProc
 */
static void
xf86AiptekControlProc(DeviceIntPtr device, PtrCtrl *ctrl)
{
    DBG(2, "xf86AiptekControlProc\n");
}

/*
** xf86AiptekOpen
 * Open and initialize the tablet, as well as probe for any needed data.
 * (This is TTY style open)
 */

static Bool
xf86AiptekOpen(InputInfoPtr pInfo)
{
    AiptekDevicePtr device = (AiptekDevicePtr)pInfo->private;
    AiptekCommonPtr common = device->common;
    int err, version;

    DBG(1, "Opening %s\n", common->deviceName);

    pInfo->fd = xf86OpenSerial(pInfo->options);
    if (pInfo->fd < 0)
    {
        xf86Msg(X_ERROR, "Error opening %s: %s\n", common->deviceName, strerror(errno));
        return !Success;
    }

    DBG(1, "Testing USB\n");

    SYSCALL(err = ioctl(pInfo->fd, EVIOCGVERSION, &version));
    if (!err)
    {
        int j;

        SYSCALL(close(pInfo->fd));

        for(j=0; j<common->numDevices; ++j)
        {
            common->deviceArray[j]->read_input=xf86AiptekHIDReadInput;
        }
        common->open=xf86AiptekHIDOpen;

        return xf86AiptekHIDOpen(pInfo);
    }

    /* We do not support TTY mode, so just exit angry. */
    return !Success;
}

/*
 * xf86AiptekOpenDevice
 * Opens and initializes the device driver.
 */
static int
xf86AiptekOpenDevice(DeviceIntPtr pDriver)
{
    InputInfoPtr    pInfo  = (InputInfoPtr)pDriver->public.devicePrivate;
    AiptekDevicePtr   device = pInfo->private;
    AiptekCommonPtr   common = device->common;
    double            tabletRatio, screenRatio;
    double            xFactor, yFactor;
    int               gap, loop;

    DBG(2, "In xf86AiptekOpenDevice, with fd=%d\n", pInfo->fd);

    if (pInfo->fd < 0)
    {
        if (common->initNumber > 2 ||
            device->initNumber == common->initNumber)
        {
            if (common->open(pInfo) != Success)
            {
                if (pInfo->fd >= 0)
                {
                    SYSCALL(close(pInfo->fd));
                }
                pInfo->fd = -1;
                return !Success;
            }
            else
            {
                /* Report the file descriptor to all devices */
                for (loop=0; loop < common->numDevices; ++loop)
                {
                    common->deviceArray[loop]->fd = pInfo->fd;
                }
            }
            common->initNumber++;
        }
        device->initNumber = common->initNumber;
    }

    /*
     * Check our active area parameters. We support the following
     * three sets of mutually exclusive parameter sets:
     * 1) xMax/yMax. The origin (0,0) of the active area is the origin
     *    of the physical tablet. You therefore are describing the
     *    width and height of that active area.
     * 2) xOffset/xSize,yOffset/ySize. The origin (0,0) of the active
     *    area is defined as (xOffset,yOffset) (which we'll report as
     *    (0,0)). The size of the active area in width and height are
     *    expressed in coordinates as xSize/ySize. That is to say,
     *    if xOffset=5; yOffset=5, and xSize=10; ySize=10, then we will 
     *    have an active area beginning at (5,5) and ending at (15,15).
     *    Physical coordinate (5,5) is reported as (0,0); (15,15) is 
     *    reported as (10,10). The rest of the tablet is inert, as far as
     *    drawing area goes,
     * 3) xTop/xBottom,yTop/yBottom. The difference between this and
     *    #2 above is that all four parameters are physical coordinates
     *    on the tablet. Using the example above, xTop=5; yTop=5, and
     *    xBottom=15; yBottom=15. It is inferred mathematically that
     *    the overall active area is 10x10 coordinates.
     *
     * NOTE: Mutually exclusive means just that: choose the set of
     * parameters you like, and use them throughout. If you user xSize,
     * yOffset and xBottom, we'll have NO idea what you want, and quite
     * frankly you'll have tempted Fate enough that Bad Things(tm) will
     * happen to you. Do not complain to us!
     */
    if (device->xMax != VALUE_NA ||
        device->yMax != VALUE_NA)
    {
        /* Deal with larger-than-tablet and NA values.
         */
        if (device->xMax >  common->xCapacity ||
            device->xMax == VALUE_NA)
        {
            device->xMax = common->xCapacity;
            xf86Msg(X_CONFIG, "xMax value invalid; adjusting to %d\n",
                    device->xMax);
        }
        if (device->yMax > common->yCapacity ||
            device->yMax == VALUE_NA)
        {
            device->yMax = common->yCapacity;
            xf86Msg(X_CONFIG,"yMax value invalid; adjusting to %d\n",
                    device->yMax);
        }

        /*
         * Internally we use xTop/yTop/xBottom/yBottom
         * for everything. It's the easiest for us to work
         * with, vis-a-vis filtering.
         */

        device->xTop = 0;
        device->yTop = 0;
        device->xBottom = device->xMax;
        device->yBottom = device->yMax;
    }

    /*
     * Deal with xOffset/yOffset;xSize/ySize parameters
     */
    if (device->xSize   != VALUE_NA ||
        device->ySize   != VALUE_NA ||
        device->xOffset != VALUE_NA ||
        device->yOffset != VALUE_NA)
    {
        int message = 0;
        /* Simple sanity tests: nothing larger than the
         * tablet; nothing negative, except for an NA value.
         */
        if (device->xOffset  != VALUE_NA &&
            (device->xOffset >  common->xCapacity ||
             device->xOffset <  0))
        {
            message = 1;
            device->xOffset = 0;
        }
        if (device->yOffset  != VALUE_NA &&
            (device->yOffset >  common->yCapacity ||
             device->yOffset <  0))
        {
            message = 1;
            device->yOffset = 0;
        }
        if (device->xSize  != VALUE_NA &&
            (device->xSize >  common->xCapacity ||
             device->xSize <  0))
        {
            message = 1;
            device->xSize = common->xCapacity;
        }
        if (device->ySize  != VALUE_NA &&
            (device->ySize >  common->yCapacity ||
             device->ySize <  0))
        {
            message = 1;
            device->ySize = common->yCapacity;
        }

        /*
         * If one parameter is set but not the other, we'll
         * guess at something reasonable for the missing one.
         */
        if (device->xOffset == VALUE_NA ||
            device->xSize   == VALUE_NA)
        {
            if (device->xOffset == VALUE_NA)
            {
                message = 1;
                device->xOffset = 0;
            }
            else
            {
                message = 1;
                device->xSize = common->xCapacity - device->xOffset;
            }
        }
        if (device->yOffset == VALUE_NA ||
            device->ySize   == VALUE_NA)
        {
            if (device->yOffset == VALUE_NA)
            {
                message = 1;
                device->yOffset = 0;
            }
            else
            {
                message = 1;
                device->ySize = common->yCapacity - device->yOffset;
            }
        }

        /*
         * Do not allow the active area to exceed the size of the
         * tablet. To do this, we have to consider both parameters.
         * Assumption: xOffset/yOffset is always correct; deliver less
         * of the tablet than they asked for, if they asked for too much.
         */
        if (device->xOffset + device->xSize > common->xCapacity)
        {
            message = 1;
            device->xSize = common->xCapacity - device->xOffset;
        }
        if (device->yOffset + device->ySize > common->yCapacity)
        {
            message = 1;
            device->ySize = common->yCapacity - device->yOffset;
        }

        /*
         * 'message' is used to indicate that we've changed some parameter
         * during our filtration process. It's conceivable that we may
         * have changed parameters several times, so we without commentary
         * to the very end.
         */
        if (message == 1)
        {
            xf86Msg(X_CONFIG,"xOffset/yOffset;xSize/ySize values wrong.\n");
            xf86Msg(X_CONFIG,"xOffset adjusted to %d\n", device->xOffset);
            xf86Msg(X_CONFIG,"yOffset adjusted to %d\n", device->yOffset);
            xf86Msg(X_CONFIG,"xSize adjusted to %d\n", device->xSize);
            xf86Msg(X_CONFIG,"ySize adjusted to %d\n", device->ySize);
        }

        /*
         * Internally we use xTop/yTop/xBottom/yBottom
         * for everything. It's the easiest for us to work
         * with, vis-a-vis filtering.
         */
        device->xTop    = device->xOffset;
        device->yTop    = device->yOffset;
        device->xBottom = device->xOffset + device->xSize;
        device->yBottom = device->yOffset + device->ySize;
    }

    /*
     * Third set of parameters. Because everything internally
     * is expressed as xTop/yTop, etc., I'll do tests on transformed
     * values from the other parameters as need. My last chance to do
     * so.
     */
    if (device->xTop == VALUE_NA ||
        device->xTop <  0 ||
        device->xTop >  common->xCapacity)
    {
        device->xTop = 0;
        xf86Msg(X_CONFIG,"xTop invalid; adjusted to %d\n", device->xTop);
    }
    if (device->yTop == VALUE_NA ||
        device->yTop <  0 ||
        device->yTop >  common->yCapacity)
    {
        device->yTop = 0;
        xf86Msg(X_CONFIG,"yTop invalid; adjusted to %d\n", device->yTop);
    }
    if (device->xBottom == VALUE_NA ||
        device->xBottom <  0 ||
        device->xBottom >  common->xCapacity)
    {
        device->xBottom = common->xCapacity;
        xf86Msg(X_CONFIG,"xBottom invalid; adjusted to %d\n", 
                device->xBottom);
    }
    if (device->yBottom == VALUE_NA ||
        device->yBottom <  0 ||
        device->yBottom >  common->yCapacity)
    {
        device->yBottom = common->yCapacity;
        xf86Msg(X_CONFIG,"yBottom invalid; adjusted to %d\n", 
                    device->yBottom);
    }

    /*
     * Determine the X screen we're going to be using.
     * If NA, or larger than the number of screens we
     * have, or negative, we've going for screen 0, e.g.,
     * 'default' screen.
     */
    if ( device->screenNo >= screenInfo.numScreens ||
         device->screenNo == VALUE_NA ||
         device->screenNo < 0) 
    {
        device->screenNo = 0;
        xf86Msg(X_CONFIG,"ScreenNo invalid; adjusted to %d\n", 
                device->screenNo);
    }

    /* Calculate the ratio according to KeepShape, TopX and TopY */

    if (device->flags & KEEP_SHAPE_FLAG)
    {
        int xDiff, yDiff;

        xDiff = common->xCapacity - device->xTop;
        yDiff = common->yCapacity - device->yTop;

        tabletRatio = (double) xDiff / (double) yDiff;
        screenRatio = (double) screenInfo.screens[device->screenNo]->width /
                      (double) screenInfo.screens[device->screenNo]->height;

        DBG(2, "Screen %d: screenRatio = %.3g, tabletRatio = %.3g\n",
                  device->screenNo, screenRatio, tabletRatio);

        if (screenRatio > tabletRatio)
        {
            gap = (int)((double)common->yCapacity *
                       (1.0 - tabletRatio/screenRatio));
            device->xBottom = common->xCapacity;
            device->yBottom = common->yCapacity - gap;
            DBG(2, "Screen %d: 'Y' Gap of %d computed\n",
                  device->screenNo, gap);
        }
        else
        {
            gap = (int)((double)common->xCapacity *
                       (1.0 - screenRatio/tabletRatio));
            device->xBottom = common->xCapacity - gap;
            device->yBottom = common->yCapacity;
            DBG(2, "Screen %d: 'X' Gap of %d computed\n",
                  device->screenNo, gap);
        }
    }

    xFactor = (double)screenInfo.screens[device->screenNo]->width/
        (double)(device->xBottom - device->xTop);
    yFactor = (double)screenInfo.screens[device->screenNo]->height/
        (double)(device->yBottom - device->yTop);

    /* 
     * Check threshold correctness
     */
    if (device->xThreshold > common->xCapacity ||
        device->xThreshold == VALUE_NA ||
        device->xThreshold <  0)
    {
        device->xThreshold = 0;
    }

    if (device->yThreshold > common->yCapacity ||
        device->yThreshold == VALUE_NA ||
        device->yThreshold < 0)
    {
        device->yThreshold = 0;
    }

    if (device->zThreshold > common->zCapacity ||
        device->zThreshold == VALUE_NA ||
        device->zThreshold < 0) 
    {
        device->zThreshold = 0;
    }

    /* Create axisStructs for every axis we support.
     * NOTE: min_resolution and max_resolution infers to
     * me a programmability to increase/decrease resolution.
     * We don't support that, so min & max = current_resolution.
     */
    InitValuatorAxisStruct(pDriver,                 /* X resolution */
               0,                                   /* axis_id */
               XIGetKnownProperty(AXIS_LABEL_PROP_ABS_X),
               0,                                   /* min value */
               device->xBottom - device->xTop,      /* max value */
               LPI2CPM(375),                        /* resolution */
               LPI2CPM(375),                        /* min_resolution */
               LPI2CPM(375),                        /* max_resolution */
               Absolute);

    InitValuatorAxisStruct(pDriver,                 /* Y Resolution */
               1,                                   /* axis_id */
               XIGetKnownProperty(AXIS_LABEL_PROP_ABS_Y),
               0,                                   /* min value */
               device->yBottom - device->yTop,      /* max value */
               LPI2CPM(375),                        /* resolution */
               LPI2CPM(375),                        /* min_resolution */
               LPI2CPM(375),                        /* max_resolution */
               Absolute);

    InitValuatorAxisStruct(pDriver,                 /* Pressure */
               2,                                   /* axis_id */
               XIGetKnownProperty(AXIS_LABEL_PROP_ABS_PRESSURE),
               0,                                   /* min value */
               511,                                 /* max value */
               512,                                 /* resolution */
               512,                                 /* min_resolution */
               512,                                 /* max_resolution */
               Absolute);

    InitValuatorAxisStruct(pDriver,                 /* xTilt */
               3,                                   /* axis id */
               XIGetKnownProperty(AXIS_LABEL_PROP_ABS_TILT_X),
               -128,                                /* min value */
               127,                                 /* max value */
               256,                                 /* resolution */
               256,                                 /* min_resolution */
               256,                                 /* max_resolution */
               Absolute);

    InitValuatorAxisStruct(pDriver,                 /* yTilt */
               4,                                   /* axis_id */
               XIGetKnownProperty(AXIS_LABEL_PROP_ABS_TILT_Y),
               -128,                                /* min value */
               127,                                 /* max value */
               256,                                 /* resolution */
               256,                                 /* min_resolution */
               256,                                 /* max_resolution */
               Absolute);

    /*
     * The sixth axis would be for wheel support. We do not have
     * any wheel devices. But if we did, it would be allocated
     * here.
     */
    return (pInfo->fd != -1);
}

/*
 * xf86AiptekProc
 *
 *  Call dispatcher for this driver.
 */
static int
xf86AiptekProc(DeviceIntPtr pAiptek, int requestCode)
{
    CARD8           map[512+1];
    int             numAxes = 5; /* X, Y, Z, xTilt, yTilt */
    int             numButtons = 5;
    int             loop;
    InputInfoPtr  pInfo  = (InputInfoPtr)pAiptek->public.devicePrivate;
    AiptekDevicePtr device = pInfo->private;
    Atom            btn_labels[numAxes];
    Atom            axes_labels[numButtons];

    DBG(2, "xf86AiptekProc() type=%s flags=%d request=%d\n",
              (DEVICE_ID(device->flags) == STYLUS_ID) ? "stylus" :
              (DEVICE_ID(device->flags) == CURSOR_ID) ? "cursor" : "eraser",
              device->flags, requestCode);

    switch (requestCode)
    {
        case DEVICE_INIT:
        {
            DBG(1, "xf86AiptekProc request=INIT\n");

            for(loop=1; loop<=numButtons; ++loop)
            {
                map[loop] = loop;
            }

            btn_labels[0] = XIGetKnownProperty(BTN_LABEL_PROP_BTN_LEFT);
            btn_labels[1] = XIGetKnownProperty(BTN_LABEL_PROP_BTN_MIDDLE);
            btn_labels[2] = XIGetKnownProperty(BTN_LABEL_PROP_BTN_RIGHT);
            btn_labels[3] = XIGetKnownProperty(BTN_LABEL_PROP_BTN_WHEEL_UP);
            btn_labels[4] = XIGetKnownProperty(BTN_LABEL_PROP_BTN_WHEEL_DOWN);

            memset(axes_labels, 0, sizeof(axes_labels));

            if (InitButtonClassDeviceStruct(pAiptek,numButtons,
                                            btn_labels, map) == FALSE)
            {
                xf86Msg(X_ERROR, "Unable to init Button Class Device\n");
                return !Success;
            }

            if (InitFocusClassDeviceStruct(pAiptek) == FALSE) 
            {
                xf86Msg(X_ERROR, "Unable to init Focus Class Device\n");
                return !Success;
            }

            if (InitPtrFeedbackClassDeviceStruct(pAiptek,
                        xf86AiptekControlProc) == FALSE)
            {
                xf86Msg(X_ERROR, "Unable to init Pointer Feedback Class Device\n");
                return !Success;
            }

            if (InitProximityClassDeviceStruct(pAiptek) == FALSE)
            {
                xf86Msg(X_ERROR, "Unable to init Proximity Class Device\n");
                return !Success;
            }

            /* we don't label the axes here, done later in
             * xf86AiptedOpenDevice */
            if (InitValuatorClassDeviceStruct(pAiptek, numAxes,
                                              axes_labels, GetMotionHistorySize(),
                                              ((device->flags & ABSOLUTE_FLAG) ? Absolute : Relative) | OutOfProximity ) == FALSE)
            {
                xf86Msg(X_ERROR, "Unable to allocate Valuator Class Device\n");
                return !Success;
            }

            /* Allocate the motion history buffer if needed */
            xf86MotionHistoryAllocate(pInfo);

            /* Open the device to gather information */
            xf86AiptekOpenDevice(pAiptek);
        }
        break;

        case DEVICE_ON:
        {
            DBG(1, "xf86AiptekProc request=ON\n");

            if ((pInfo->fd < 0) &&
                (!xf86AiptekOpenDevice(pAiptek)))
            {
                xf86Msg(X_ERROR, "Unable to open aiptek device\n");
                return !Success;
            }
            xf86Msg(X_INFO, "Able to open aiptek device\n");
            xf86AddEnabledDevice(pInfo);
            pAiptek->public.on = TRUE;
        }
        break;

        case DEVICE_OFF:
        {
	    DBG(1, "xf86AiptekProc request=OFF\n");
            if (pInfo->fd >= 0)
            {
                xf86RemoveEnabledDevice(pInfo);
                xf86AiptekClose(pInfo);
            }
            pAiptek->public.on = FALSE;
        }
        break;

        case DEVICE_CLOSE:
        {
	    DBG(1, "xf86AiptekProc request=CLOSE\n");
            xf86AiptekClose(pInfo);
        }
        break;

        default:
        {
            xf86Msg(X_ERROR, "xf86AiptekProc - Unsupported mode=%d\n", requestCode);
            return !Success;
        }
        break;
    }
    DBG(2, "xf86AiptekProc Success request=%d\n", requestCode );
    return Success;
}

/*
 * xf86AiptekClose
 * Perhaps this will close the device
 */
static void
xf86AiptekClose(InputInfoPtr pInfo)
{
    if (pInfo->fd >= 0)
    {
        SYSCALL(close(pInfo->fd));
    }
    pInfo->fd = -1;
}

/*
 * xf86AiptekChangeControl
 * Allow the user to change the tablet resolution -- we have an issue
 * insofar as we don't know how to write to the tablet. And furthermore,
 * even if we DID know how to write to the tablet, it doesn't support
 * a "change resolution" call. We tried to avoid this by claiming when
 * creating axisStructs that minRes = curRes = maxRes. So, we should never
 * get dispatched.
 */
static int
xf86AiptekChangeControl(InputInfoPtr pInfo, xDeviceCtl *control)
{
    xDeviceResolutionCtl    *res;
    int                     *resolutions;

    DBG(3, "xf86AiptekChangeControl() entered\n");

    res = (xDeviceResolutionCtl *)control;
    
    if ((control->control != DEVICE_RESOLUTION) ||
        (res->num_valuators < 1))
    {
        DBG(3, "xf86AiptekChangeControl abends\n");
        return (BadMatch);
    }

    resolutions = (int *)(res +1);
    
    DBG(3, "xf86AiptekChangeControl changing to res %d\n",
              resolutions[0]);

    /* We don't know how to write, yet
     *
     * sprintf(str, "SU%d\r", resolutions[0]);
     * SYSCALL(write(pInfo->fd, str, strlen(str)));
     */

    return(Success);
}

/*
 * xf86AiptekSwitchMode
 * Switches the mode. For now just absolute or relative, hopefully
 * more on the way.
 */
static int
xf86AiptekSwitchMode(ClientPtr client, DeviceIntPtr dev, int mode)
{
    InputInfoPtr  pInfo  = (InputInfoPtr)dev->public.devicePrivate;
    AiptekDevicePtr device = (AiptekDevicePtr)(pInfo->private);

    DBG(3, "xf86AiptekSwitchMode() dev=%p mode=%d\n", dev, mode);

    switch(mode)
    {
        case Absolute:
        {
            device->flags |= ABSOLUTE_FLAG;
        }
        break;

        case Relative:
        {
            device->flags &= ~ABSOLUTE_FLAG;
        }
        break;

        default:
        {
            DBG(1, "xf86AiptekSwitchMode dev=%p invalid mode=%d\n",
                   dev, mode);
            return BadMatch;
        }
        break;
    }

    return Success;
}

/*
 * xf86AiptekInitialize
 * Initializes the device structures for the Aiptek.
 */
static int
xf86AiptekAllocate(InputInfoPtr pInfo,
                   char* name,
                   int   flag)
{
    InputInfoPtr*   deviceArray;
    AiptekDevicePtr   device;
    AiptekCommonPtr   common;

    DBG(3, "xf86AiptekAllocate, with %s and %d\n", name, flag);

    device = (AiptekDevicePtr) malloc(sizeof(AiptekDeviceRec));
    if (!device)
    {
        DBG(3, "xf86AiptekAllocate failed to allocate 'device'\n");
        return BadAlloc;
    }

    common = (AiptekCommonPtr) malloc(sizeof(AiptekCommonRec));
    if (!common)
    {
        DBG(3, "xf86AiptekAllocate failed to allocate 'common'\n");
        free(device);
        return BadAlloc;
    }

    deviceArray = (InputInfoPtr*) malloc(sizeof(InputInfoPtr));
    if (!deviceArray)
    {
        DBG(3, "xf86AiptekAllocate failed to allocate 'deviceArray'\n");
        free(device);
        free(common);
        return BadAlloc;
    }

    pInfo->type_name =                  "Aiptek";
    pInfo->device_control =             xf86AiptekProc;
    pInfo->read_input =                 xf86AiptekHIDReadInput;
    pInfo->control_proc =               xf86AiptekChangeControl;
    pInfo->switch_mode =                xf86AiptekSwitchMode;

    pInfo->fd =             VALUE_NA;
    pInfo->private =        device;

    device->flags =         flag;       /* various flags (device type, 
                                         * coordinate type */
    device->xSize =         VALUE_NA; /* Active Area X */
    device->ySize =         VALUE_NA; /* Active Area Y */
    device->xOffset =       VALUE_NA; /* Active area offset X */
    device->yOffset =       VALUE_NA; /* Active area offset Y */
    device->xMax =          VALUE_NA; /* Max allowed X value */
    device->yMax =          VALUE_NA; /* Max allowed Y value */
    device->zMin =          VALUE_NA; /* Min allowed Z value */
    device->zMax =          VALUE_NA; /* Max allowed Z value */
    device->xTop =          VALUE_NA; /* Upper Left X coordinate */
    device->yTop =          VALUE_NA; /* Upper Left Y coordinate */
    device->xBottom =       VALUE_NA; /* Lower Right X coordinate */
    device->yBottom =       VALUE_NA; /* Lower Right Y coordinate */
    device->xThreshold =    VALUE_NA; /* X delta must be greater than */
    device->yThreshold =    VALUE_NA; /* Y delta must be greater than */
    device->zThreshold =    VALUE_NA; /* Z delta must be greater than */
    device->xTiltThreshold =VALUE_NA;
    device->yTiltThreshold =VALUE_NA;
    device->zMode =         VALUE_NA; /* Z: linear, soft, hard log */

    device->initNumber =    VALUE_NA; /* avoid re-init devices */
    device->screenNo =      VALUE_NA; /* Attached to X screen */

    device->common =        common;   /* Common info pointer */

    /* Record of the event currently being read of the queue */
    common->currentValues.eventType = STYLUS_ID;   
                                      /* Device event is for, e.g., */
                                      /* STYLUS, RUBBER, CURSOR */
                                      /* Starting with stylus as default */
    common->currentValues.x         = 0;   /* X coordinate */
    common->currentValues.y         = 0;   /* Y coordinate */
    common->currentValues.z         = 0;   /* Z (pressure) */
    common->currentValues.xTilt     = 0;   /* XTilt */
    common->currentValues.yTilt     = 0;   /* YTilt */
    common->currentValues.proximity = 0;   /* proximity bit */
    common->currentValues.macroKey  = VALUE_NA;   /* tablet macro key code */
    common->currentValues.button    = 0;   /* bitmask of buttons pressed */
    common->currentValues.distance  = 0;   /* currently unsupported */
    common->currentValues.wheel     = 0;   /* likewise */

    /* Record of the event previously read off of the queue */
    common->previousValues.eventType = 0;  /* Same comments as above */
    common->previousValues.x         = 0;
    common->previousValues.y         = 0;
    common->previousValues.z         = 0;
    common->previousValues.xTilt     = 0;
    common->previousValues.yTilt     = 0;
    common->previousValues.proximity = 0;
    common->previousValues.macroKey  = VALUE_NA;
    common->previousValues.button    = 0;
    common->previousValues.distance  = 0;
    common->previousValues.wheel     = 0;

    common->deviceName =    "";             /* device file name */
    common->flags =         0;              /* various flags */
    common->deviceArray =   deviceArray;    /* Array of tablets */
    common->deviceArray[0]= pInfo;          /* with pInfo as element */
    common->numDevices =    1;              /* number of devices */

    common->xCapacity =     0;              /* tablet's max X value */
    common->yCapacity =     0;              /* tablet's max Y value */
    common->zCapacity =     0;              /* tablet's max Z value */
    common->open =          xf86AiptekOpen; /* Open function */

    return Success;
}

/*
 * xf86AiptekAllocateStylus
 */
static int
xf86AiptekAllocateStylus(InputInfoPtr pInfo)
{
    int rc;

    rc = xf86AiptekAllocate(pInfo, XI_STYLUS, STYLUS_ID);
    pInfo->type_name = "Stylus";

    return rc;
}

/*
 * xf86AiptekAllocateCursor
 */
static int
xf86AiptekAllocateCursor(InputInfoPtr pInfo)
{
    int rc;

    rc = xf86AiptekAllocate(pInfo, XI_CURSOR, CURSOR_ID);
    pInfo->type_name = "Cursor";

    return rc;
}

/*
 * xf86AiptekAllocateEraser
 */
static int
xf86AiptekAllocateEraser(InputInfoPtr pInfo)
{
    int rc;

    rc = xf86AiptekAllocate(pInfo, XI_ERASER, ABSOLUTE_FLAG|ERASER_ID);
    pInfo->type_name = "Eraser";

    return rc;
}

/*
 * xf86AiptekUninit --
 *
 * called when the driver is unloaded.
 */
static void
xf86AiptekUninit(InputDriverPtr    drv,
                 InputInfoPtr    pInfo,
                 int               flags)
{
    AiptekDevicePtr device = (AiptekDevicePtr) pInfo->private;

    DBG(1, "xf86AiptekUninit\n");

    if (device)
    {
        if (device->common)
        {
            AiptekCommonPtr common = device->common;
            int i;

            common->numDevices--;

            for (i = 0; i < common->numDevices; i++)
            {
                if (common->deviceArray[i] == pInfo)
                    memmove(&common->deviceArray[i],
                            &common->deviceArray[i+1],
                            (common->numDevices - i) * sizeof(InputInfoPtr));
            }

            if (common->numDevices == 0)
                free(common);
        }
        device->common = NULL;
    }
    pInfo->private = NULL;
    xf86DeleteInput(pInfo, 0);
}

/*
 * xf86AiptekInit --
 *
 * Called when the module subsection is found in XF86Config
 */
static int
xf86AiptekInit(InputDriverPtr    drv,
               InputInfoPtr      pInfo,
               int               flags)
{
    AiptekDevicePtr   device    = NULL;
    AiptekCommonPtr   common    = NULL;
    InputInfoPtr    pInfos;
    char*             s;
    int               shared;
    int               rc = BadValue;

    aiptekDrv = drv;

    xf86Msg(X_INFO, "xf86AiptekInit(): begins\n");

/* Type */
    s = xf86FindOptionValue(pInfo->options, "Type");
    if (s && (xf86NameCmp(s, "stylus") == 0))
    {
        rc = xf86AiptekAllocateStylus(pInfo);
    }
    else if (s && (xf86NameCmp(s, "cursor") == 0))
    {
        rc = xf86AiptekAllocateCursor(pInfo);
    }
    else if (s && (xf86NameCmp(s, "eraser") == 0))
    {
        rc = xf86AiptekAllocateEraser(pInfo);
    }
    else
    {
        xf86Msg(X_ERROR, "%s: No type or invalid type specified.\n"
                  "Must be one of 'stylus', 'cursor', or 'eraser'\n",
                  pInfo->name);
    }

    if(rc != Success)
        return rc;

    device = (AiptekDevicePtr) pInfo->private;

    common              = device->common;

/* Device */
/* (mandatory) */
    common->deviceName = xf86FindOptionValue(pInfo->options, "Device");
    if(!common->deviceName)
    {
        xf86Msg(X_ERROR, "%s: No Device specified.\n", pInfo->name);
        goto SetupProc_fail;
    }

    /*
     * Lookup to see if there is another aiptek device sharing the
     * same device.
     */

    shared = 0;
    for (pInfos = xf86FirstLocalDevice();
         pInfos != NULL;
         pInfos = pInfos->next)
    {
        if((pInfo != pInfos) &&
           (pInfos->device_control == xf86AiptekProc) &&
           (strcmp(((AiptekDevicePtr)pInfos->private)->common->deviceName,
                    common->deviceName) == 0))
        {
            xf86Msg(X_CONFIG,
                    "xf86AiptekConfig: device shared between %s and %s\n",
                    pInfo->name,
                    pInfos->name);

            shared = 1;

            free(common->deviceArray);
            free(common);

            common = device->common =
                ((AiptekDevicePtr) pInfos->private)->common;
            common->numDevices++;
            common->deviceArray = (InputInfoPtr*)realloc(common->deviceArray,
                    sizeof(InputInfoPtr)*common->numDevices);
            common->deviceArray[common->numDevices-1] = pInfo;
            break;
        }
        else
        {
            xf86Msg(X_CONFIG, 
                    "xf86AiptekConfig: device not shared btw %s and %s\n",
                    pInfo->name, pInfos->name);
        }
    }

    /* Process the common options */
    xf86ProcessCommonOptions(pInfo, pInfo->options);

    /* If this is the first device using the aiptek driver, let's open
     * the interface so as to obtain legit values for xCapacity and yCapacity
     * (and then quickly close it). Yes, the word for this is "kludge".
     * I am sufficiently ashamed :-) TODO kludge alert!
     */
    if ( shared == 0)
    {
        xf86AiptekHIDOpen(pInfo);
        close(pInfo->fd);
        pInfo->fd=-1;
    }

    /* Optional configuration */
    xf86Msg(X_CONFIG, "%s device is %s\n", pInfo->name,
            common->deviceName);

/* DebugLevel */
    debug_level = xf86SetIntOption(pInfo->options, "DebugLevel", debug_level);
    if ( debug_level > 0)
    {
        xf86Msg(X_CONFIG, "Debug level set to %d\n", debug_level);
    }

/* zMode */
    s = xf86FindOptionValue(pInfo->options, "Pressure");
    if ( s && (xf86NameCmp(s, "hard") == 0))
    {
        device->zMode = PRESSURE_MODE_HARD_SMOOTH;
    }
    else if ( s && (xf86NameCmp(s, "soft") == 0))
    {
        device->zMode = PRESSURE_MODE_SOFT_SMOOTH;
    }
    else if (s && (xf86NameCmp(s, "normal") == 0))
    {
        device->zMode = PRESSURE_MODE_LINEAR;
    }
    else if (s)
    {
        xf86Msg(X_ERROR, "%s: invalid Mode ('normal', 'soft' or 'hard').\n",
            pInfo->name);
    }

/* Mode */
    s = xf86FindOptionValue(pInfo->options, "Mode");
    if (s && (xf86NameCmp(s, "absolute") == 0))
    {
        device->flags |= ABSOLUTE_FLAG;
    }
    else if (s && (xf86NameCmp(s, "relative") == 0)) 
    {
        device->flags &= ~ABSOLUTE_FLAG;
    }
    else if (s)
    {
        xf86Msg(X_ERROR, "%s: invalid Mode ('absolute' or 'relative').\n",
            pInfo->name);
        device->flags |= ABSOLUTE_FLAG;
    }
    xf86Msg(X_CONFIG, "%s is in %s mode\n", pInfo->name,
        (device->flags & ABSOLUTE_FLAG) ? "absolute" : "relative");

#ifdef HAVE_LINUX_INPUT_H
    /* The define-name is accurate; the XFree86 keyword is not. We are
     * reading from a Linux kernel "Input" device. The Input device
     * layer generally supports mice, joysticks, and keyboards. As
     * an extension, the Input device layer also supports HID devices.
     * HID is a standard specified by the USB Implementors Forum. Ergo,
     * 99.9% of HID devices are USB devices.
     *
     * This option is misnamed, misunderstood, misanthrope. Maybe.
     */
    if (xf86SetBoolOption(pInfo->options, "USB",
                          (common->open == xf86AiptekHIDOpen)))
    {
        pInfo->read_input=xf86AiptekHIDReadInput;
        common->open=xf86AiptekHIDOpen;
        xf86Msg(X_CONFIG, "%s: reading USB link\n", pInfo->name);
    }
#else
    if (xf86SetBoolOption(pInfo->options, "USB", 0))
    {
        xf86Msg(X_ERROR, "The Aiptek USB driver isn't available for your platform.\n");
        goto SetupProc_fail;
    }
#endif

/* ScreenNo */
    device->screenNo = xf86SetIntOption(pInfo->options, "ScreenNo", VALUE_NA);
    if (device->screenNo != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: attached to screen number %d\n",
                pInfo->name, device->screenNo);
    }

/* KeepShape */
    if (xf86SetBoolOption(pInfo->options, "KeepShape", 0))
    {
        device->flags |= KEEP_SHAPE_FLAG;
        xf86Msg(X_CONFIG, "%s: keeps shape\n", pInfo->name);
    }

/* XSize */
    device->xSize = xf86SetIntOption(pInfo->options, "XSize", device->xSize);
    device->xSize = xf86SetIntOption(pInfo->options, "SizeX", device->xSize);
    if (device->xSize != VALUE_NA) 
    {
        xf86Msg(X_CONFIG, "%s: XSize/SizeX = %d\n", pInfo->name,
                device->xSize);
    }

/* YSize */
    device->ySize = xf86SetIntOption(pInfo->options, "YSize", device->ySize);
    device->ySize = xf86SetIntOption(pInfo->options, "SizeY", device->ySize);
    if (device->ySize != VALUE_NA) 
    {
        xf86Msg(X_CONFIG, "%s: YSize/SizeY = %d\n", pInfo->name,
                device->ySize);
    }

/* XOffset */
    device->xOffset = xf86SetIntOption(pInfo->options, "XOffset",
            device->xOffset);
    device->xOffset = xf86SetIntOption(pInfo->options, "OffsetX",
            device->xOffset);
    if (device->xOffset != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: XOffset/OffsetX = %d\n", pInfo->name,
                device->xOffset);
    }

/* YOffset */
    device->yOffset = xf86SetIntOption(pInfo->options, "YOffset",
            device->yOffset);
    device->yOffset = xf86SetIntOption(pInfo->options, "OffsetY",
            device->yOffset);
    if (device->yOffset != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: YOffset/OffsetY = %d\n", pInfo->name,
                device->yOffset);
    }

/* XThreshold */
    device->xThreshold = xf86SetIntOption(pInfo->options, "XThreshold",
            device->xThreshold);
    device->xThreshold = xf86SetIntOption(pInfo->options, "ThresholdX",
            device->xThreshold);
    if (device->xThreshold != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: XThreshold/ThresholdX = %d\n",
                pInfo->name, device->xThreshold);
    }

/* YThreshold */
    device->yThreshold = xf86SetIntOption(pInfo->options, "YThreshold",
            device->yThreshold);
    device->yThreshold = xf86SetIntOption(pInfo->options, "ThresholdY",
            device->yThreshold);
    if (device->yThreshold != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: YThreshold/ThresholdY = %d\n",
                pInfo->name, device->yThreshold);
    }

/* ZThreshold */
    device->zThreshold = xf86SetIntOption(pInfo->options, "ZThreshold",
            device->zThreshold);
    device->zThreshold = xf86SetIntOption(pInfo->options, "ThresholdZ",
            device->zThreshold);
    if (device->zThreshold != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: ZThreshold/ThresholdZ = %d\n",
                pInfo->name, device->zThreshold);
    }

/* XTiltThreshold */
    device->xTiltThreshold = xf86SetIntOption(pInfo->options, "XTiltThreshold",
            device->xTiltThreshold);
    device->xTiltThreshold = xf86SetIntOption(pInfo->options, "ThresholdXTilt",
            device->xTiltThreshold);
    if (device->xTiltThreshold != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: XTiltThreshold = %d\n",
                pInfo->name, device->xTiltThreshold);
    }

/* YTiltThreshold */
    device->yTiltThreshold = xf86SetIntOption(pInfo->options, "YTiltThreshold",
            device->yTiltThreshold);
    device->yTiltThreshold = xf86SetIntOption(pInfo->options, "ThresholdYTilt",
            device->yTiltThreshold);
    if (device->yTiltThreshold != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: YTiltThreshold = %d\n",
                pInfo->name, device->yTiltThreshold);
    }

/* XMax */
    device->xMax = xf86SetIntOption(pInfo->options, "XMax", device->xMax);
    device->xMax = xf86SetIntOption(pInfo->options, "MaxX", device->xMax);
    if (device->xMax != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: XMax/MaxX = %d\n", pInfo->name,
                device->xMax);
    }

/* YMax */
    device->yMax = xf86SetIntOption(pInfo->options, "YMax", device->yMax);
    device->yMax = xf86SetIntOption(pInfo->options, "MaxY", device->yMax);
    if (device->yMax != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: YMax/MaxY = %d\n", pInfo->name,
                device->yMax);
    }

/* ZMax */
    device->zMax = xf86SetIntOption(pInfo->options, "ZMax", device->zMax);
    device->zMax = xf86SetIntOption(pInfo->options, "MaxZ", device->zMax);
    if (device->zMax != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: ZMax/MaxZ = %d\n", pInfo->name,
                device->zMax);
    }

/* ZMin */
    device->zMin = xf86SetIntOption(pInfo->options, "ZMin", device->zMin);
    device->zMin = xf86SetIntOption(pInfo->options, "MinZ", device->zMin);
    if (device->zMin != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: ZMin/MinZ = %d\n", pInfo->name,
                device->zMin);
    }

/* TopX */
    device->xTop = xf86SetIntOption(pInfo->options, "TopX", device->xTop);
    device->xTop = xf86SetIntOption(pInfo->options, "XTop", device->xTop);
    if (device->xTop != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: TopX/XTop = %d\n", pInfo->name,
                device->xTop);
    }

/* TopY */
    device->yTop = xf86SetIntOption(pInfo->options, "TopY", device->yTop);
    device->yTop = xf86SetIntOption(pInfo->options, "YTop", device->yTop);
    if (device->yTop != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: TopY/YTop = %d\n", pInfo->name,
                device->yTop);
    }

/* BottomX */
    device->xBottom = xf86SetIntOption(pInfo->options, "BottomX",
            device->xBottom);
    device->xBottom = xf86SetIntOption(pInfo->options, "XBottom",
            device->xBottom);
    if (device->xBottom != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: BottomX/XBottom = %d\n", pInfo->name,
                device->xBottom);
    }

/* BottomY */
    device->yBottom = xf86SetIntOption(pInfo->options, "BottomY",
            device->yBottom);
    device->yBottom = xf86SetIntOption(pInfo->options, "YBottom",
            device->yBottom);
    if (device->yBottom != VALUE_NA)
    {
        xf86Msg(X_CONFIG, "%s: BottomY/YBottom = %d\n", pInfo->name,
                device->yBottom);
    }

/* InvX */
    if (xf86SetBoolOption(pInfo->options, "InvX", FALSE))
    {
        device->flags |= INVX_FLAG;
        xf86Msg(X_CONFIG, "%s: InvX\n", pInfo->name);
    }

/* InvY */
    if (xf86SetBoolOption(pInfo->options, "InvY", FALSE))
    {
        device->flags |= INVY_FLAG;
        xf86Msg(X_CONFIG, "%s: InvY\n", pInfo->name);
    }

/* BaudRate */
    {
        int val;
        val = xf86SetIntOption(pInfo->options, "BaudRate", 0);

        switch(val)
        {
            case 19200:
                break;
            case 9600:
                break;
            default:
                xf86Msg(X_ERROR, "%s: Illegal BaudRate (9600 or 19200).",
                        pInfo->name);
                break;
        }
        xf86Msg(X_CONFIG, "%s: BaudRate %u\n", pInfo->name, val);
    }
    xf86Msg(X_CONFIG, "%s: xf86AiptekInit() finished\n", pInfo->name);

    return Success;

SetupProc_fail:
    if (common)
        free(common);
    if (device)
        free(device);
    if (pInfo)
        free(pInfo);
    return BadValue;
}

/*
 ***************************************************************************
 *
 * Dynamic loading functions
 *
 ***************************************************************************
 */
/*
 * xf86AiptekUnplug --
 *
 * called when the module subsection is found in XF86Config
 */
static void
xf86AiptekUnplug(pointer p)
{
    DBG(1, "xf86AiptekUnplug\n");
}

/*
 * xf86AiptekPlug --
 *
 * called when the module subsection is found in XF86Config
 */
static pointer
xf86AiptekPlug(pointer    module,
               pointer    options,
               int*       errmaj,
               int*       errmin)
{
    DBG(1, "xf86AiptekPlug\n");

    xf86AddInputDriver(&AIPTEK, module, 0);

    return module;
}

static XF86ModuleVersionInfo xf86AiptekVersionRec =
{
    "aiptek",
    MODULEVENDORSTRING,
    MODINFOSTRING1,
    MODINFOSTRING2,
    XORG_VERSION_CURRENT,
    PACKAGE_VERSION_MAJOR, PACKAGE_VERSION_MINOR, PACKAGE_VERSION_PATCHLEVEL,
    ABI_CLASS_XINPUT,
    ABI_XINPUT_VERSION,
    MOD_CLASS_XINPUT,
    {0, 0, 0, 0}        /* signature, to be patched into the file by
                         * a tool
                         * */
};

_X_EXPORT XF86ModuleData aiptekModuleData =
{
    &xf86AiptekVersionRec,
    xf86AiptekPlug,
    xf86AiptekUnplug
};

/* end of xf86Aiptek.c */
