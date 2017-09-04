/*
 * hw_address.h
 *
 *  Created on: Sep 3, 2017
 *      Author: root
 */

#ifndef SRC_HW_ADDRESS_H_
#define SRC_HW_ADDRESS_H_

#define BASE_ADDRESS 0xC0000000

//INPUT
#define SET (BASE_ADDRESS + 0x0008)
#define GET (BASE_ADDRESS + 0x0030)
#define IN0 (BASE_ADDRESS + 0x0014)
#define IN1 (BASE_ADDRESS + 0x0018)

#define SEL (BASE_ADDRESS + 0x0038)
#define START (BASE_ADDRESS + 0x003C)

//OUTPUT

#define DONE_MULT (BASE_ADDRESS + 0x0114)
#define DONE_RED (BASE_ADDRESS + 0x0118)
#define OUT (BASE_ADDRESS + 0x0110)

#endif /* SRC_HW_ADDRESS_H_ */
