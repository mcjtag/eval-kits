/*****************************************************************************

	Платформо-зависимая библиотека функций для 
	конфигурации АЦП ADC5101HB015 через интерфейс SPI.
	
	Содержит реализацию функций для работы с SPI


*****************************************************************************/


#include "core_utils.h"
#include "5101HB015.h"
#include "5101HB015_SPI_1967VC3.h"


static ADC5101HB015_hw_config_t hwcfg;
static struct {
	uint32_t core_cycles_per_half_period;
	uint32_t core_cycles_init;
	uint32_t core_cycles_reset;
	uint32_t core_cycles_calibrate;
} delays;



// Инициализация SPI
void ADC5101HB015_SPI_init(void *hw_config)
{
	hwcfg.port = ((ADC5101HB015_hw_config_t *)hw_config)->port;
	hwcfg.cs_bit = ((ADC5101HB015_hw_config_t *)hw_config)->cs_bit;
	hwcfg.clk_bit = ((ADC5101HB015_hw_config_t *)hw_config)->clk_bit;
	hwcfg.mosi_bit = ((ADC5101HB015_hw_config_t *)hw_config)->mosi_bit;
	hwcfg.miso_bit = ((ADC5101HB015_hw_config_t *)hw_config)->miso_bit;
	hwcfg.power_down_bit = ((ADC5101HB015_hw_config_t *)hw_config)->power_down_bit;
	hwcfg.core_freq_khz = ((ADC5101HB015_hw_config_t *)hw_config)->core_freq_khz;
	
	// Set initial output
	hwcfg.port->port.set = hwcfg.cs_bit;
	hwcfg.port->port.clr = hwcfg.clk_bit | hwcfg.mosi_bit | hwcfg.power_down_bit;
	
	// Setup GPIO
	hwcfg.port->ddr.clr = hwcfg.miso_bit;
	hwcfg.port->ddr.set = hwcfg.cs_bit | hwcfg.clk_bit | hwcfg.mosi_bit | hwcfg.power_down_bit;
	hwcfg.port->alt.clr = hwcfg.cs_bit | hwcfg.clk_bit | hwcfg.mosi_bit | hwcfg.miso_bit | hwcfg.power_down_bit;
	
	// Calculate core cycles for delays
	delays.core_cycles_per_half_period = ADC5101HB015_SPI_PERIOD_NS * hwcfg.core_freq_khz / (2*1000000);
	delays.core_cycles_init = ADC5101HB015_INIT_DELAY_US * hwcfg.core_freq_khz / 1000;
	delays.core_cycles_reset = ADC5101HB015_RESET_DELAY_US * hwcfg.core_freq_khz / 1000;
	delays.core_cycles_calibrate = ADC5101HB015_CALIB_DELAY_US * hwcfg.core_freq_khz / 1000;
}


// Передача 16 бит данных
uint16_t ADC5101HB015_SPI_write(uint16_t data)
{
	uint32_t i;
	uint32_t read_data = 0;
	hwcfg.port->port.clr = hwcfg.cs_bit;
	wait_cycles(delays.core_cycles_per_half_period);
	for(i=0x8000; i!=0; i>>=1)
	{
		if (data & i)
			hwcfg.port->port.set = hwcfg.mosi_bit;
		else
			hwcfg.port->port.clr = hwcfg.mosi_bit;
		wait_cycles(delays.core_cycles_per_half_period);	
		if (hwcfg.port->pin & hwcfg.miso_bit)
			read_data |= i;
		hwcfg.port->port.set = hwcfg.clk_bit;
		wait_cycles(delays.core_cycles_per_half_period);
		hwcfg.port->port.clr = hwcfg.clk_bit;
	}
	hwcfg.port->port.clr = hwcfg.mosi_bit;
	wait_cycles(delays.core_cycles_per_half_period);
	hwcfg.port->port.set = hwcfg.cs_bit;
	
	//hwcfg.port->port.set = hwcfg.clk_bit;
	
	read_data &= 0xFF;
	return read_data;
}


// Калибровка АЦП. Запускается специальным состоянием линий SPI
void ADC5101HB015_SPI_calibrate(void)
{
	hwcfg.port->port.set = hwcfg.cs_bit;
	hwcfg.port->port.clr = hwcfg.mosi_bit;
	wait_cycles(delays.core_cycles_per_half_period);
	hwcfg.port->port.set = hwcfg.mosi_bit;
	wait_cycles(delays.core_cycles_per_half_period);
	hwcfg.port->port.set = hwcfg.clk_bit;
	wait_cycles(delays.core_cycles_per_half_period);
	hwcfg.port->port.clr = hwcfg.mosi_bit;
	wait_cycles(delays.core_cycles_per_half_period);
	hwcfg.port->port.clr = hwcfg.clk_bit;
	wait_cycles(delays.core_cycles_per_half_period);
}


// Задержка для соблюдения таймингов АЦП. Типы задержек перечислены в файле ADC5101HB015.h
void ADC5101HB015_delay(uint8_t delay_type)
{
	switch (delay_type)
	{
		case ADC5101HB015_DELAY_INIT:
			wait_cycles(delays.core_cycles_init);
			break;
		case ADC5101HB015_DELAY_RESET:
			wait_cycles(delays.core_cycles_reset);
			break;
		case ADC5101HB015_DELAY_CALIBRATE:
			wait_cycles(delays.core_cycles_calibrate);
			break;
	}
}




