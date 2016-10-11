
#ifndef  _REMOTE_CONFIG_H
#define  _REMOTE_CONFIG_H

#include <asm/ioctl.h>
#define   REMOTE_IOC_UNFCODE_CONFIG              _IOW_BAD('I',12,sizeof(short))
#define   REMOTE_IOC_INFCODE_CONFIG              _IOW_BAD('I',13,sizeof(short))
#define   REMOTE_IOC_RESET_KEY_MAPPING	    _IOW_BAD('I',3,sizeof(short))
#define   REMOTE_IOC_SET_KEY_MAPPING		    _IOW_BAD('I',4,sizeof(short))
#define   REMOTE_IOC_SET_MOUSE_MAPPING	    _IOW_BAD('I',5,sizeof(short))
#define   REMOTE_IOC_SET_REPEAT_DELAY		    _IOW_BAD('I',6,sizeof(short))
#define   REMOTE_IOC_SET_REPEAT_PERIOD	    _IOW_BAD('I',7,sizeof(short))

#define   REMOTE_IOC_SET_REPEAT_ENABLE		_IOW_BAD('I',8,sizeof(short))
#define	REMOTE_IOC_SET_DEBUG_ENABLE			_IOW_BAD('I',9,sizeof(short)) 
#define	REMOTE_IOC_SET_MODE					_IOW_BAD('I',10,sizeof(short)) 
#define	REMOTE_IOC_SET_MOUSE_SPEED			_IOW_BAD('I',11,sizeof(short))

#define	REMOTE_IOC_SET_REPEAT_KEY_MAPPING       _IOW_BAD('I',20,sizeof(short))
#define   REMOTE_IOC_SET_RELEASE_FDELAY		_IOW_BAD('I',97,sizeof(short))
#define   REMOTE_IOC_SET_RELEASE_SDELAY		_IOW_BAD('I',98,sizeof(short))
#define   REMOTE_IOC_SET_RELEASE_DELAY		_IOW_BAD('I',99,sizeof(short))
#define   REMOTE_IOC_SET_CUSTOMCODE   			_IOW_BAD('I',100,sizeof(short))
//reg
#define   REMOTE_IOC_SET_REG_BASE_GEN			_IOW_BAD('I',101,sizeof(short))
#define   REMOTE_IOC_SET_REG_CONTROL			_IOW_BAD('I',102,sizeof(short))
#define   REMOTE_IOC_SET_REG_LEADER_ACT 		_IOW_BAD('I',103,sizeof(short))
#define   REMOTE_IOC_SET_REG_LEADER_IDLE 		_IOW_BAD('I',104,sizeof(short))
#define   REMOTE_IOC_SET_REG_REPEAT_LEADER 	_IOW_BAD('I',105,sizeof(short))
#define   REMOTE_IOC_SET_REG_BIT0_TIME		 _IOW_BAD('I',106,sizeof(short))

//sw
#define   REMOTE_IOC_SET_BIT_COUNT			 	_IOW_BAD('I',107,sizeof(short))
#define   REMOTE_IOC_SET_TW_LEADER_ACT		_IOW_BAD('I',108,sizeof(short))
#define   REMOTE_IOC_SET_TW_BIT0_TIME			_IOW_BAD('I',109,sizeof(short))
#define   REMOTE_IOC_SET_TW_BIT1_TIME			_IOW_BAD('I',110,sizeof(short))
#define   REMOTE_IOC_SET_TW_REPEATE_LEADER	_IOW_BAD('I',111,sizeof(short))

#define   REMOTE_IOC_GET_TW_LEADER_ACT		_IOR_BAD('I',112,sizeof(short))
#define   REMOTE_IOC_GET_TW_BIT0_TIME			_IOR_BAD('I',113,sizeof(short))
#define   REMOTE_IOC_GET_TW_BIT1_TIME			_IOR_BAD('I',114,sizeof(short))
#define   REMOTE_IOC_GET_TW_REPEATE_LEADER	_IOR_BAD('I',115,sizeof(short))


#define   REMOTE_IOC_GET_REG_BASE_GEN			_IOR_BAD('I',121,sizeof(short))
#define   REMOTE_IOC_GET_REG_CONTROL			_IOR_BAD('I',122,sizeof(short))
#define   REMOTE_IOC_GET_REG_LEADER_ACT 		_IOR_BAD('I',123,sizeof(short))
#define   REMOTE_IOC_GET_REG_LEADER_IDLE 		_IOR_BAD('I',124,sizeof(short))
#define   REMOTE_IOC_GET_REG_REPEAT_LEADER 	_IOR_BAD('I',125,sizeof(short))
#define   REMOTE_IOC_GET_REG_BIT0_TIME		 	_IOR_BAD('I',126,sizeof(short))
#define   REMOTE_IOC_GET_REG_FRAME_DATA		_IOR_BAD('I',127,sizeof(short))
#define   REMOTE_IOC_GET_REG_FRAME_STATUS	_IOR_BAD('I',128,sizeof(short))

#define   REMOTE_IOC_SET_FN_KEY_SCANCODE     _IOW_BAD('I', 131, sizeof(short)) 
#define   REMOTE_IOC_SET_LEFT_KEY_SCANCODE   _IOW_BAD('I', 132, sizeof(short))
#define   REMOTE_IOC_SET_RIGHT_KEY_SCANCODE  _IOW_BAD('I', 133, sizeof(short))
#define   REMOTE_IOC_SET_UP_KEY_SCANCODE     _IOW_BAD('I', 134, sizeof(short))
#define   REMOTE_IOC_SET_DOWN_KEY_SCANCODE   _IOW_BAD('I', 135, sizeof(short))
#define   REMOTE_IOC_SET_OK_KEY_SCANCODE     _IOW_BAD('I', 136, sizeof(short))
#define   REMOTE_IOC_SET_PAGEUP_KEY_SCANCODE _IOW_BAD('I', 137, sizeof(short))
#define   REMOTE_IOC_SET_PAGEDOWN_KEY_SCANCODE _IOW_BAD('I', 138, sizeof(short))

#define   REMOTE_IOC_SET_TW_BIT2_TIME			_IOW_BAD('I',129,sizeof(short))
#define   REMOTE_IOC_SET_TW_BIT3_TIME			_IOW_BAD('I',130,sizeof(short))
#define   REMOTE_IOC_SET_FACTORY_CUSTOMCODE     _IOW_BAD('I',139,sizeof(short))
#define   ADC_KP_MAGIC 'P'
#define   KEY_IOC_SET_MOVE_MAP        		_IOW_BAD(ADC_KP_MAGIC,0X02,int)
#define   KEY_IOC_SET_MOVE_ENABLE		  	_IOW_BAD(ADC_KP_MAGIC,0X03,int)

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

#define   MAX_FACT_CUST_CODES                   20
#define   MAX_KEY_CODES                         256
#define   MAX_MOUSE_CODES                       4
#define   MAX_ADC_CODES                         2

typedef   struct{
       unsigned short *key_map;
       unsigned short *repeat_key_map;
       unsigned short *mouse_map;
       unsigned int *factory_customercode_map;
       unsigned int repeat_delay;
       unsigned int repeat_peroid;
       unsigned int work_mode;
       unsigned int mouse_speed;
       unsigned int repeat_enable;
       unsigned int factory_infcode;
       unsigned int factory_unfcode;
       unsigned int factory_code;
       unsigned int release_delay;
       unsigned int release_fdelay;
       unsigned int release_sdelay;
       unsigned int debug_enable;
//sw
       unsigned int bit_count;
       unsigned int tw_leader_act;
       unsigned int tw_bit0;
       unsigned int tw_bit1;
       unsigned int tw_bit2;
       unsigned int tw_bit3;
       unsigned int tw_repeat_leader;
//reg
       unsigned int reg_base_gen;
       unsigned int reg_control;
       unsigned int reg_leader_act;
       unsigned int reg_leader_idle;
       unsigned int reg_repeat_leader;
       unsigned int reg_bit0_time;

       unsigned int fn_key_scancode;
       unsigned int left_key_scancode;
       unsigned int right_key_scancode;
       unsigned int up_key_scancode;
       unsigned int down_key_scancode;
       unsigned int ok_key_scancode;
       unsigned int pageup_key_scancode;
       unsigned int pagedown_key_scancode;
}remote_config_t;

//these string must in this order and sync with struct remote_config_t
static char*  config_item[33]={
    "repeat_delay",
    "repeat_peroid",
    "work_mode",
    "mouse_speed",
    "repeat_enable",
    "factory_infcode",
    "factory_unfcode",
    "factory_code",
    "release_delay",
    "release_fdelay",
    "release_sdelay",
    "debug_enable",
//sw
    "bit_count",
    "tw_leader_act",
    "tw_bit0",
    "tw_bit1",
    "tw_bit2",
    "tw_bit3",
    "tw_repeat_leader",
//reg
    "reg_base_gen",
    "reg_control",
    "reg_leader_act",
    "reg_leader_idle",
    "reg_repeat_leader",
    "reg_bit0_time",

    "fn_key_scancode",
    "left_key_scancode",
    "right_key_scancode",
    "up_key_scancode",
    "down_key_scancode",
    "ok_key_scancode",
    "pageup_key_scancode",
    "pagedown_key_scancode",
};

static int remote_ioc_table[33]={
    REMOTE_IOC_SET_REPEAT_DELAY,          //  0
    REMOTE_IOC_SET_REPEAT_PERIOD,         //  1
    REMOTE_IOC_SET_MODE,                  //  2
    REMOTE_IOC_SET_MOUSE_SPEED,           //  3
    REMOTE_IOC_SET_REPEAT_ENABLE,         //  4
    REMOTE_IOC_INFCODE_CONFIG,            //  5
    REMOTE_IOC_UNFCODE_CONFIG,            //  6
    REMOTE_IOC_SET_CUSTOMCODE,            //  7
    REMOTE_IOC_SET_RELEASE_DELAY,         //  8
    REMOTE_IOC_SET_RELEASE_FDELAY,        //  9
    REMOTE_IOC_SET_RELEASE_SDELAY,        // 10
    REMOTE_IOC_SET_DEBUG_ENABLE,          // 11
//sw
    REMOTE_IOC_SET_BIT_COUNT,             // 12
    REMOTE_IOC_SET_TW_LEADER_ACT,         // 13
    REMOTE_IOC_SET_TW_BIT0_TIME,          // 14
    REMOTE_IOC_SET_TW_BIT1_TIME,          // 15
    REMOTE_IOC_SET_TW_BIT2_TIME,          // 16
    REMOTE_IOC_SET_TW_BIT3_TIME,          // 17
    REMOTE_IOC_SET_TW_REPEATE_LEADER,     // 18
//reg
    REMOTE_IOC_SET_REG_BASE_GEN,          // 19
    REMOTE_IOC_SET_REG_CONTROL,           // 20
    REMOTE_IOC_SET_REG_LEADER_ACT,        // 21
    REMOTE_IOC_SET_REG_LEADER_IDLE,       // 22
    REMOTE_IOC_SET_REG_REPEAT_LEADER,     // 23
    REMOTE_IOC_SET_REG_BIT0_TIME,         // 24

    REMOTE_IOC_SET_FN_KEY_SCANCODE,       // 25
    REMOTE_IOC_SET_LEFT_KEY_SCANCODE,     // 26
    REMOTE_IOC_SET_RIGHT_KEY_SCANCODE,    // 27
    REMOTE_IOC_SET_UP_KEY_SCANCODE,       // 28
    REMOTE_IOC_SET_DOWN_KEY_SCANCODE,     // 29
    REMOTE_IOC_SET_OK_KEY_SCANCODE,       // 30
    REMOTE_IOC_SET_PAGEUP_KEY_SCANCODE,   // 31
    REMOTE_IOC_SET_PAGEDOWN_KEY_SCANCODE, // 32
};

extern int set_config(remote_config_t *remote, int device_fd);
extern int get_config_from_file(FILE *fp, remote_config_t *remote);

#endif
