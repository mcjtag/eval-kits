/**
 * @file gui.h
 * @brief GUI driver
 * @author matyunin.d
 * @date 15.08.2019
 */

#ifndef GUI_H_
#define GUI_H_

#include "xil_types.h"

struct gtable_cell {
	char txt[8];
	u32 color;
};

struct gtable {
	struct gtable_cell cell[9][13];
};

struct gosc_data {
	float *data[8];
	u8 active;
};

struct gspe_data {
	float *data[8];
	u8 active;
};

void gui_table(struct gtable *tbl);
void gui_oscil(struct gosc_data *dat);
void gui_spect(struct gspe_data *dat);

#endif /* GUI_H_ */
