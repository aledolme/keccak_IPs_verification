/*
                              *******************
******************************* H SOURCE FILE *******************************
**                            *******************                          **
**                                                                         **
** project  : x-heep                                                       **
** filename : power_manager_structs.h                                 **
** date     : 14/05/2024                                                      **
**                                                                         **
*****************************************************************************
**                                                                         **
**                                                                         **
*****************************************************************************

*/

/**
* @file   power_manager_structs.h
* @date   14/05/2024
* @brief  Contains structs for every register
*
* This file contains the structs of the registes of the peripheral.
* Each structure has the various bit fields that can be accessed
* independently.
* 
*/

#ifndef _POWER_MANAGER_STRUCTS_H
#define POWER_MANAGER_STRUCTS

/****************************************************************************/
/**                                                                        **/
/**                            MODULES USED                                **/
/**                                                                        **/
/****************************************************************************/

#include <inttypes.h>
#include "core_v_mini_mcu.h"

/****************************************************************************/
/**                                                                        **/
/**                       DEFINITIONS AND MACROS                           **/
/**                                                                        **/
/****************************************************************************/

#define power_manager_peri ((volatile power_manager *) POWER_MANAGER_START_ADDRESS)

/****************************************************************************/
/**                                                                        **/
/**                       TYPEDEFS AND STRUCTURES                          **/
/**                                                                        **/
/****************************************************************************/



typedef struct {

  uint32_t WAKEUP_STATE;                          /*!< Wake-up state of the system*/

  uint32_t RESTORE_ADDRESS;                       /*!< Restore xddress value*/

  uint32_t EN_WAIT_FOR_INTR;                      /*!< Enable wait for interrupt*/

  uint32_t INTR_STATE;                            /*!< Interrupt state*/

  uint32_t POWER_GATE_CORE;                       /*!< Used to power gate core*/

  uint32_t POWER_GATE_CORE_ACK;                   /*!< Used by the core switch to ack the power manager*/

  uint32_t CPU_RESET_ASSERT_COUNTER;              /*!< Counter before resetting the CPU domain*/

  uint32_t CPU_RESET_DEASSERT_COUNTER;            /*!< Counter before unreset the CPU domain*/

  uint32_t CPU_SWITCH_OFF_COUNTER;                /*!< Counter before switching off the CPU domain*/

  uint32_t CPU_SWITCH_ON_COUNTER;                 /*!< Counter before switching on the CPU domain*/

  uint32_t CPU_WAIT_ACK_SWITCH_ON_COUNTER;        /*!< Bit to set whether to further wait for the ACK from the core switch after the counter expired*/

  uint32_t CPU_ISO_OFF_COUNTER;                   /*!< Counter before setting off the isolation of the CPU domain*/

  uint32_t CPU_ISO_ON_COUNTER;                    /*!< Counter before setting on the isolation of the CPU domain*/

  uint32_t CPU_COUNTERS_STOP;                     /*!< Bits to stop the counters keeping the done_o signal high*/

  uint32_t POWER_GATE_PERIPH_ACK;                 /*!< Used by the periph switch to ack the power manager*/

  uint32_t PERIPH_RESET;                          /*!< Reset the PERIPH domain*/

  uint32_t PERIPH_SWITCH;                         /*!< Switch off the PERIPH domain*/

  uint32_t PERIPH_WAIT_ACK_SWITCH_ON;             /*!< Wait for the PERIPH domain switch ack*/

  uint32_t PERIPH_ISO;                            /*!< Set on the isolation of the PERIPH domain*/

  uint32_t PERIPH_CLK_GATE;                       /*!< Clock-gates the PERIPH domain*/

  uint32_t RAM_0_CLK_GATE;                        /*!< Clock-gates the RAM_0 domain*/

  uint32_t POWER_GATE_RAM_BLOCK_0_ACK;            /*!< Used by the ram 0 switch to ack the power manager*/

  uint32_t RAM_0_SWITCH;                          /*!< Switch off the RAM_0 domain*/

  uint32_t RAM_0_WAIT_ACK_SWITCH_ON;              /*!< Wait for the RAM_0 domain switch ack*/

  uint32_t RAM_0_ISO;                             /*!< Set on the isolation of the RAM_0 domain*/

  uint32_t RAM_0_RETENTIVE;                       /*!< Set on retentive mode for the RAM_0 domain*/

  uint32_t RAM_1_CLK_GATE;                        /*!< Clock-gates the RAM_1 domain*/

  uint32_t POWER_GATE_RAM_BLOCK_1_ACK;            /*!< Used by the ram 1 switch to ack the power manager*/

  uint32_t RAM_1_SWITCH;                          /*!< Switch off the RAM_1 domain*/

  uint32_t RAM_1_WAIT_ACK_SWITCH_ON;              /*!< Wait for the RAM_1 domain switch ack*/

  uint32_t RAM_1_ISO;                             /*!< Set on the isolation of the RAM_1 domain*/

  uint32_t RAM_1_RETENTIVE;                       /*!< Set on retentive mode for the RAM_1 domain*/

  uint32_t RAM_2_CLK_GATE;                        /*!< Clock-gates the RAM_2 domain*/

  uint32_t POWER_GATE_RAM_BLOCK_2_ACK;            /*!< Used by the ram 2 switch to ack the power manager*/

  uint32_t RAM_2_SWITCH;                          /*!< Switch off the RAM_2 domain*/

  uint32_t RAM_2_WAIT_ACK_SWITCH_ON;              /*!< Wait for the RAM_2 domain switch ack*/

  uint32_t RAM_2_ISO;                             /*!< Set on the isolation of the RAM_2 domain*/

  uint32_t RAM_2_RETENTIVE;                       /*!< Set on retentive mode for the RAM_2 domain*/

  uint32_t RAM_3_CLK_GATE;                        /*!< Clock-gates the RAM_3 domain*/

  uint32_t POWER_GATE_RAM_BLOCK_3_ACK;            /*!< Used by the ram 3 switch to ack the power manager*/

  uint32_t RAM_3_SWITCH;                          /*!< Switch off the RAM_3 domain*/

  uint32_t RAM_3_WAIT_ACK_SWITCH_ON;              /*!< Wait for the RAM_3 domain switch ack*/

  uint32_t RAM_3_ISO;                             /*!< Set on the isolation of the RAM_3 domain*/

  uint32_t RAM_3_RETENTIVE;                       /*!< Set on retentive mode for the RAM_3 domain*/

  uint32_t RAM_4_CLK_GATE;                        /*!< Clock-gates the RAM_4 domain*/

  uint32_t POWER_GATE_RAM_BLOCK_4_ACK;            /*!< Used by the ram 4 switch to ack the power manager*/

  uint32_t RAM_4_SWITCH;                          /*!< Switch off the RAM_4 domain*/

  uint32_t RAM_4_WAIT_ACK_SWITCH_ON;              /*!< Wait for the RAM_4 domain switch ack*/

  uint32_t RAM_4_ISO;                             /*!< Set on the isolation of the RAM_4 domain*/

  uint32_t RAM_4_RETENTIVE;                       /*!< Set on retentive mode for the RAM_4 domain*/

  uint32_t RAM_5_CLK_GATE;                        /*!< Clock-gates the RAM_5 domain*/

  uint32_t POWER_GATE_RAM_BLOCK_5_ACK;            /*!< Used by the ram 5 switch to ack the power manager*/

  uint32_t RAM_5_SWITCH;                          /*!< Switch off the RAM_5 domain*/

  uint32_t RAM_5_WAIT_ACK_SWITCH_ON;              /*!< Wait for the RAM_5 domain switch ack*/

  uint32_t RAM_5_ISO;                             /*!< Set on the isolation of the RAM_5 domain*/

  uint32_t RAM_5_RETENTIVE;                       /*!< Set on retentive mode for the RAM_5 domain*/

  uint32_t RAM_6_CLK_GATE;                        /*!< Clock-gates the RAM_6 domain*/

  uint32_t POWER_GATE_RAM_BLOCK_6_ACK;            /*!< Used by the ram 6 switch to ack the power manager*/

  uint32_t RAM_6_SWITCH;                          /*!< Switch off the RAM_6 domain*/

  uint32_t RAM_6_WAIT_ACK_SWITCH_ON;              /*!< Wait for the RAM_6 domain switch ack*/

  uint32_t RAM_6_ISO;                             /*!< Set on the isolation of the RAM_6 domain*/

  uint32_t RAM_6_RETENTIVE;                       /*!< Set on retentive mode for the RAM_6 domain*/

  uint32_t RAM_7_CLK_GATE;                        /*!< Clock-gates the RAM_7 domain*/

  uint32_t POWER_GATE_RAM_BLOCK_7_ACK;            /*!< Used by the ram 7 switch to ack the power manager*/

  uint32_t RAM_7_SWITCH;                          /*!< Switch off the RAM_7 domain*/

  uint32_t RAM_7_WAIT_ACK_SWITCH_ON;              /*!< Wait for the RAM_7 domain switch ack*/

  uint32_t RAM_7_ISO;                             /*!< Set on the isolation of the RAM_7 domain*/

  uint32_t RAM_7_RETENTIVE;                       /*!< Set on retentive mode for the RAM_7 domain*/

  uint32_t RAM_8_CLK_GATE;                        /*!< Clock-gates the RAM_8 domain*/

  uint32_t POWER_GATE_RAM_BLOCK_8_ACK;            /*!< Used by the ram 8 switch to ack the power manager*/

  uint32_t RAM_8_SWITCH;                          /*!< Switch off the RAM_8 domain*/

  uint32_t RAM_8_WAIT_ACK_SWITCH_ON;              /*!< Wait for the RAM_8 domain switch ack*/

  uint32_t RAM_8_ISO;                             /*!< Set on the isolation of the RAM_8 domain*/

  uint32_t RAM_8_RETENTIVE;                       /*!< Set on retentive mode for the RAM_8 domain*/

  uint32_t RAM_9_CLK_GATE;                        /*!< Clock-gates the RAM_9 domain*/

  uint32_t POWER_GATE_RAM_BLOCK_9_ACK;            /*!< Used by the ram 9 switch to ack the power manager*/

  uint32_t RAM_9_SWITCH;                          /*!< Switch off the RAM_9 domain*/

  uint32_t RAM_9_WAIT_ACK_SWITCH_ON;              /*!< Wait for the RAM_9 domain switch ack*/

  uint32_t RAM_9_ISO;                             /*!< Set on the isolation of the RAM_9 domain*/

  uint32_t RAM_9_RETENTIVE;                       /*!< Set on retentive mode for the RAM_9 domain*/

  uint32_t RAM_10_CLK_GATE;                       /*!< Clock-gates the RAM_10 domain*/

  uint32_t POWER_GATE_RAM_BLOCK_10_ACK;           /*!< Used by the ram 10 switch to ack the power manager*/

  uint32_t RAM_10_SWITCH;                         /*!< Switch off the RAM_10 domain*/

  uint32_t RAM_10_WAIT_ACK_SWITCH_ON;             /*!< Wait for the RAM_10 domain switch ack*/

  uint32_t RAM_10_ISO;                            /*!< Set on the isolation of the RAM_10 domain*/

  uint32_t RAM_10_RETENTIVE;                      /*!< Set on retentive mode for the RAM_10 domain*/

  uint32_t RAM_11_CLK_GATE;                       /*!< Clock-gates the RAM_11 domain*/

  uint32_t POWER_GATE_RAM_BLOCK_11_ACK;           /*!< Used by the ram 11 switch to ack the power manager*/

  uint32_t RAM_11_SWITCH;                         /*!< Switch off the RAM_11 domain*/

  uint32_t RAM_11_WAIT_ACK_SWITCH_ON;             /*!< Wait for the RAM_11 domain switch ack*/

  uint32_t RAM_11_ISO;                            /*!< Set on the isolation of the RAM_11 domain*/

  uint32_t RAM_11_RETENTIVE;                      /*!< Set on retentive mode for the RAM_11 domain*/

  uint32_t POWER_GATE_EXTERNAL_0_ACK;             /*!< Used by the external 0 switch to ack the power manager*/

  uint32_t EXTERNAL_0_RESET;                      /*!< Reset the EXTERNAL_0 domain*/

  uint32_t EXTERNAL_0_SWITCH;                     /*!< Switch off the EXTERNAL_0 domain*/

  uint32_t EXTERNAL_0_WAIT_ACK_SWITCH_ON;         /*!< Wait for the EXTERNAL_0 domain switch ack*/

  uint32_t EXTERNAL_0_ISO;                        /*!< Set on the isolation of the EXTERNAL_0 domain*/

  uint32_t EXTERNAL_RAM_0_RETENTIVE;              /*!< Set on retentive mode for external RAM_0 domain*/

  uint32_t MONITOR_POWER_GATE_CORE;               /*!< Used to monitor the signals to power gate core*/

  uint32_t MONITOR_POWER_GATE_PERIPH;             /*!< Used to monitor the signals to power gate periph*/

  uint32_t MONITOR_POWER_GATE_RAM_BLOCK_0;        /*!< Used to monitor the signals to power gate ram block 0*/

  uint32_t MONITOR_POWER_GATE_RAM_BLOCK_1;        /*!< Used to monitor the signals to power gate ram block 1*/

  uint32_t MONITOR_POWER_GATE_RAM_BLOCK_2;        /*!< Used to monitor the signals to power gate ram block 2*/

  uint32_t MONITOR_POWER_GATE_RAM_BLOCK_3;        /*!< Used to monitor the signals to power gate ram block 3*/

  uint32_t MONITOR_POWER_GATE_RAM_BLOCK_4;        /*!< Used to monitor the signals to power gate ram block 4*/

  uint32_t MONITOR_POWER_GATE_RAM_BLOCK_5;        /*!< Used to monitor the signals to power gate ram block 5*/

  uint32_t MONITOR_POWER_GATE_RAM_BLOCK_6;        /*!< Used to monitor the signals to power gate ram block 6*/

  uint32_t MONITOR_POWER_GATE_RAM_BLOCK_7;        /*!< Used to monitor the signals to power gate ram block 7*/

  uint32_t MONITOR_POWER_GATE_RAM_BLOCK_8;        /*!< Used to monitor the signals to power gate ram block 8*/

  uint32_t MONITOR_POWER_GATE_RAM_BLOCK_9;        /*!< Used to monitor the signals to power gate ram block 9*/

  uint32_t MONITOR_POWER_GATE_RAM_BLOCK_10;       /*!< Used to monitor the signals to power gate ram block 10*/

  uint32_t MONITOR_POWER_GATE_RAM_BLOCK_11;       /*!< Used to monitor the signals to power gate ram block 11*/

  uint32_t MONITOR_POWER_GATE_EXTERNAL_0;         /*!< Used to monitor the signals to power gate external 0*/

  uint32_t MASTER_CPU_FORCE_SWITCH_OFF;           /*!< Used to force core switch off*/

  uint32_t MASTER_CPU_FORCE_SWITCH_ON;            /*!< Used to force core switch on*/

  uint32_t MASTER_CPU_FORCE_RESET_ASSERT;         /*!< Used to force core reset assert*/

  uint32_t MASTER_CPU_FORCE_RESET_DEASSERT;       /*!< Used to force core reset deassert*/

  uint32_t MASTER_CPU_FORCE_ISO_OFF;              /*!< Used to force core iso off*/

  uint32_t MASTER_CPU_FORCE_ISO_ON;               /*!< Used to force core iso on*/

} power_manager;

/****************************************************************************/
/**                                                                        **/
/**                          EXPORTED VARIABLES                            **/
/**                                                                        **/
/****************************************************************************/

#ifndef _POWER_MANAGER_STRUCTS_C_SRC



#endif  /* _POWER_MANAGER_STRUCTS_C_SRC */

/****************************************************************************/
/**                                                                        **/
/**                          EXPORTED FUNCTIONS                            **/
/**                                                                        **/
/****************************************************************************/


/****************************************************************************/
/**                                                                        **/
/**                          INLINE FUNCTIONS                              **/
/**                                                                        **/
/****************************************************************************/



#endif /* _POWER_MANAGER_STRUCTS_H */
/****************************************************************************/
/**                                                                        **/
/**                                EOF                                     **/
/**                                                                        **/
/****************************************************************************/
