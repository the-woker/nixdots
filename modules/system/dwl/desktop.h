/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }
/* appearance */
static const int sloppyfocus               = 1;  /* focus follows mouse */
static const int bypass_surface_visibility = 0;  /* 1 means idle inhibitors will disable idle tracking even if it's surface isn't visible  */
static const unsigned int borderpx         = 1;  /* border pixel of windows */
static const unsigned int snap             = 32; /* snap pixel */
static const float rootcolor[]             = COLOR(0x222222ff);
static const float bordercolor[]           = COLOR(0x444444ff);
static const float focuscolor[]            = COLOR(0x005577ff);
static const float urgentcolor[]           = COLOR(0xff0000ff);
/* This conforms to the xdg-protocol. Set the alpha to zero to restore the old behavior */
static const float fullscreen_bg[]         = {0.0f, 0.0f, 0.0f, 1.0f}; /* You can also use glsl colors */

/* tagging - TAGCOUNT must be no greater than 31 */
#define TAGCOUNT (9)

/* logging */
static int log_level = WLR_ERROR;

static const char *const autostart[] = {
	"waybar", NULL,
	"awww-daemon", NULL,
	"mpris-proxy", NULL,
	NULL /* terminate */
};

static const Rule rules[] = {
	/* app_id             title       tags mask     isfloating   monitor */
	{ "Gimp_EXAMPLE",     NULL,       0,            1,           -1 }, /* Start on currently visible tags floating, not tiled */
	{ "firefox_EXAMPLE",  NULL,       1 << 8,       0,           -1 }, /* Start on ONLY tag "9" */
    /* default/example rule: can be changed but cannot be eliminated; at least one rule must exist */
};

/* layout(s) */
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* monitors */
/* (x=-1, y=-1) is reserved as an "autoconfigure" monitor position indicator
 * WARNING: negative values other than (-1, -1) cause problems with Xwayland clients
 * due to https://gitlab.freedesktop.org/xorg/xserver/-/issues/899 */
static const MonitorRule monrules[] = {
	/* name       mfact  nmaster scale layout       rotate/reflect              x   y   resx resy rate    mode adaptive */
	{ "HDMI-A-1",       0.55f, 1,      1,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL, -1, -1, 1920,   1080,   10.0f,   0,   1 },
};

/* keyboard */
static const struct xkb_rule_names xkb_rules = {
	/* can specify fields: rules, model, layout, variant, options */
	/* example:
	.options = "ctrl:nocaps",
	*/
	.options = NULL,
};

static const int repeat_rate = 35;
static const int repeat_delay = 200;

/* Trackpad */
static const int tap_to_click = 1;
static const int tap_and_drag = 1;
static const int drag_lock = 1;
static const int natural_scrolling = 0;
static const int disable_while_typing = 1;
static const int left_handed = 0;
static const int middle_button_emulation = 0;
/* You can choose between:
LIBINPUT_CONFIG_SCROLL_NO_SCROLL
LIBINPUT_CONFIG_SCROLL_2FG
LIBINPUT_CONFIG_SCROLL_EDGE
LIBINPUT_CONFIG_SCROLL_ON_BUTTON_DOWN
*/
static const enum libinput_config_scroll_method scroll_method = LIBINPUT_CONFIG_SCROLL_2FG;

/* You can choose between:
LIBINPUT_CONFIG_CLICK_METHOD_NONE
LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS
LIBINPUT_CONFIG_CLICK_METHOD_CLICKFINGER
*/
static const enum libinput_config_click_method click_method = LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS;

/* You can choose between:
LIBINPUT_CONFIG_SEND_EVENTS_ENABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED_ON_EXTERNAL_MOUSE
*/
static const uint32_t send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;

/* You can choose between:
LIBINPUT_CONFIG_ACCEL_PROFILE_FLAT
LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE
*/
static const enum libinput_config_accel_profile accel_profile = LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
static const double accel_speed = 0.0;

/* You can choose between:
LIBINPUT_CONFIG_TAP_MAP_LRM -- 1/2/3 finger tap maps to left/right/middle
LIBINPUT_CONFIG_TAP_MAP_LMR -- 1/2/3 finger tap maps to left/middle/right
*/
static const enum libinput_config_tap_button_map button_map = LIBINPUT_CONFIG_TAP_MAP_LRM;

/* If you want to use the windows key for MODKEY, use WLR_MODIFIER_LOGO */
#define MODKEY WLR_MODIFIER_LOGO

#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                    KEY,            view,            {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL,  KEY,            toggleview,      {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_SHIFT, KEY,            tag,             {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT,KEY,toggletag,  {.ui = 1 << TAG} }

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *termcmd[]    = { "ghostty", NULL };
static const char *menucmd[]    = { "/bin/sh", "-c", "pkill -x wofi || wofi --show drun", NULL };
static const char *browsercmd[] = { "zen", NULL };
static const char *wallcmd[]    = { "matuwall", NULL };

static const char *upvol[]      = { "wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "2%+", NULL };
static const char *downvol[]    = { "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "2%-", NULL };
static const char *mutevol[]    = { "wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle", NULL };
static const char *mutemic[]    = { "wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle", NULL };

static const char *prev[]      = { "playerctl", "previous", NULL};
static const char *play_pause[]      = { "playerctl", "play-pause", NULL};
static const char *next[]      = { "playerctl", "next", NULL};
static const Key keys[] = {
	/* Note that Shift changes certain key codes: 2 -> at, etc. */
	/* modifier                  key                               function          argument */
	{ 0,                         XKB_KEY_XF86AudioRaiseVolume,     spawn,            {.v = upvol} },
	{ 0,                         XKB_KEY_XF86AudioLowerVolume,     spawn,            {.v = downvol} },
	{ 0,                         XKB_KEY_XF86AudioMute,            spawn,            {.v = mutevol} },
	{ 0,                         XKB_KEY_XF86AudioMicMute,         spawn,            {.v = mutemic} },
	{ 0,                         XKB_KEY_XF86AudioPrev,            spawn,            {.v = prev} },
	{ 0,                         XKB_KEY_XF86AudioPlay,            spawn,            {.v = play_pause} },
	{ 0,                         XKB_KEY_XF86AudioNext,            spawn,            {.v = next} },
	{ MODKEY,                    XKB_KEY_space,                    spawn,            {.v = menucmd} },
	{ MODKEY,                    XKB_KEY_w,                        spawn,            {.v = wallcmd} },
	{ MODKEY,                    XKB_KEY_Return,                   spawn,            {.v = termcmd} },
	{ MODKEY,                    XKB_KEY_b,                        spawn,            {.v = browsercmd} },
	{ MODKEY,                    XKB_KEY_j,                        focusstack,       {.i = +1} },
	{ MODKEY,                    XKB_KEY_k,                        focusstack,       {.i = -1} },
	{ MODKEY,                    XKB_KEY_i,                        incnmaster,       {.i = +1} },
	{ MODKEY,                    XKB_KEY_d,                        incnmaster,       {.i = -1} },
	{ MODKEY,                    XKB_KEY_h,                        setmfact,         {.f = -0.05f} },
	{ MODKEY,                    XKB_KEY_l,                        setmfact,         {.f = +0.05f} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Return,                   zoom,             {0} },
	{ MODKEY,                    XKB_KEY_Tab,                      view,             {0} },
	{ MODKEY,                    XKB_KEY_q,                        killclient,       {0} },
	{ MODKEY,                    XKB_KEY_t,                        setlayout,        {.v = &layouts[0]} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_f,                        setlayout,        {.v = &layouts[1]} },
	{ MODKEY,                    XKB_KEY_m,                        setlayout,        {.v = &layouts[2]} },
	{ MODKEY,                    XKB_KEY_n,                        setlayout,        {0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_n,                        togglefloating,   {0} },
	{ MODKEY,                    XKB_KEY_f,                        togglefullscreen, {0} },
	{ MODKEY,                    XKB_KEY_0,                        view,             {.ui = ~0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_0,                        tag,              {.ui = ~0} },
	{ MODKEY,                    XKB_KEY_o,          winview,        {0} },
	{ MODKEY,                    XKB_KEY_comma,                    focusmon,         {.i = WLR_DIRECTION_LEFT} },
	{ MODKEY,                    XKB_KEY_period,                   focusmon,         {.i = WLR_DIRECTION_RIGHT} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_comma,                    tagmon,           {.i = WLR_DIRECTION_LEFT} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_period,                   tagmon,           {.i = WLR_DIRECTION_RIGHT} },
	TAGKEYS(          XKB_KEY_1, 0),
	TAGKEYS(          XKB_KEY_2, 1),
	TAGKEYS(          XKB_KEY_3, 2),
	TAGKEYS(          XKB_KEY_4, 3),
	TAGKEYS(          XKB_KEY_5, 4),
	TAGKEYS(          XKB_KEY_6, 5),
	TAGKEYS(          XKB_KEY_7, 6),
	TAGKEYS(          XKB_KEY_8, 7),
	TAGKEYS(          XKB_KEY_9, 8),
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_q,                        quit,             {0} },

	/* Ctrl-Alt-Backspace and Ctrl-Alt-Fx used to be handled by X server */
	{ WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_BackSpace,        quit,             {0} },
	/* Ctrl-Alt-Fx is used to switch to another VT, if you don't know what a VT is
	 * do not remove them.
	 */
#define CHVT(n) { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_F##n, chvt, {.ui = (n)} }
	CHVT(1),
	CHVT(2),
	CHVT(3),
	CHVT(4),
	CHVT(5),
	CHVT(6),
	CHVT(7),
	CHVT(8),
	CHVT(9),
	CHVT(10),
	CHVT(11),
	CHVT(12),
};

static const Button buttons[] = {
	{ MODKEY, BTN_LEFT,   moveresize,     {.ui = CurMove} },
	{ MODKEY, BTN_MIDDLE, togglefloating, {0} },
	{ MODKEY, BTN_RIGHT,  moveresize,     {.ui = CurResize} },
};

static const Axis axes[] = {
	/* example of volume control:
	{ MODKEY, AxisUp,   spawn, SHCMD("volume-up_EXAMPLE") },
	{ MODKEY, AxisDown, spawn, SHCMD("volume-down_EXAMPLE") }, */
	{ 0, 0, NULL, {0} },
	/* does nothing, but the array cannot be empty */
};
