/******************************************************************************
 *
 * Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Use of the Software is limited solely to applications:
 * (a) running on a Xilinx device, or
 * (b) that interact with a Xilinx device through a bus or interconnect.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
 * OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Except as contained in this notice, the name of the Xilinx shall not be used
 * in advertising or otherwise to promote the sale, use or other dealings in
 * this Software without prior written authorization from Xilinx.
 *
 ******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>

#include <xil_io.h>

#include <xio.h>
#include "xparameters.h"
#include "xplatform_info.h"
#include "time.h"
#include "hw_address.h"
#include "platform.h"
#include "xenv.h"
#include "xiomodule.h"

XIOModule Timer;
XIOModule System;

volatile u32 ticks = 0;

void timer_ticks(void* ref) {
	ticks++;
}

void set_data() {
	print("setting data...\n\r");
	Xil_Out32(IN0, 0x1);
	Xil_Out32(IN1, 0xB);
}

void show_result() {
	print("result data...\n\r");
}

int main() {
	int done_mult = 0;
	int done_red = 0;
	init_platform();
	//starting counter

	XIOModule_Initialize(&System, XPAR_IOMODULE_0_DEVICE_ID);
	microblaze_register_handler(XIOModule_DeviceInterruptHandler,
	XPAR_IOMODULE_0_DEVICE_ID);
	XIOModule_Start(&System);

	// Set the interval of the PIT. Default counter clock is system clock.
	//XIOModule_SetResetValue(&System, 0, 500);

	// Register interrupt handler
	//XIOModule_Connect(&System, XIN_IOMODULE_PIT_1_INTERRUPT_INTR, timer_ticks,
	//NULL);

	// Enable interrupts
	//XIOModule_Enable(&System, XIN_IOMODULE_PIT_1_INTERRUPT_INTR);

	// Specify PIT is to automatically reload. Without this, ISR runs once
	//XIOModule_Timer_SetOptions(&System, 0, XTC_AUTO_RELOAD_OPTION);

	set_data();
	//XIOModule_Timer_Start(&System, 0);

	microblaze_enable_interrupts();

	//stop counter
	//t = clock() - t;
	while(done_mult == 0){
		done_mult = Xil_In32(DONE_MULT);
	}
	while(done_red == 0){
		done_red = Xil_In32(DONE_RED);
		}

	xil_printf("Ticks: %i", ticks);
	show_result();

	//printf("fun() took %f seconds to execute \n", time_taken);

	cleanup_platform();
	return 0;
}
