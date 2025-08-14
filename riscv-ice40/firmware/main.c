//#include <stdint.h>
//#define LED_REG (*(volatile uint32_t*)0x1000)  // 内存映射寄存器地址
int main(void) 
{
    unsigned int counter = 0;
    for(int i = 1; i <= 100; i++) counter += i;
    return 0;
}