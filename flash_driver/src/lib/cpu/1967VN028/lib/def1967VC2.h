#ifndef __DEF1967VC2_H_
#define __DEF1967VC2_H_


#define SOC_FREQ_KHZ		(CORE_FREQ_KHZ / 2)

#define	DSP0			0
#define DSP1			1
#define DSP2			2
#define DSP3			3
#define	DSP4			4
#define DSP5			5
#define DSP6			6
#define DSP7			7

#define ID0				0
#define ID1				1
#define ID2				2
#define ID3				3
#define ID4				4
#define ID5				5
#define ID6				6
#define ID7				7


#define MB0_BASE 		(0x00000000)		// Internal memory block 0
#define MB2_BASE		(0x00040000)		// Internal memory block 2
#define MB4_BASE 		(0x00080000)		// Internal memory block 4
#define MB6_BASE 		(0x000C0000)		// Internal memory block 6
#define MB8_BASE 		(0x00100000)		// Internal memory block 8
#define MB10_BASE 		(0x00140000)		// Internal memory block 10


#define BROADCAST_BASE	(0x0C000000) 		// Broadcast MP memory offset
#define DSP0_BASE 		(0x10000000) 		// Processor ID0 MP memory offset
#define DSP1_BASE 		(0x14000000) 		// Processor ID1 MP memory offset
#define DSP2_BASE 		(0x18000000) 		// Processor ID2 MP memory offset
#define DSP3_BASE 		(0x1C000000) 		// Processor ID3 MP memory offset
#define DSP4_BASE 		(0x20000000) 		// Processor ID4 MP memory offset
#define DSP5_BASE 		(0x24000000) 		// Processor ID5 MP memory offset
#define DSP6_BASE 		(0x28000000) 		// Processor ID6 MP memory offset
#define DSP7_BASE 		(0x2C000000) 		// Processor ID7 MP memory offset

// DSPx_BASE = DSP0_BASE + (id << 26)




#endif
