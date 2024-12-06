#include "fir11_kernel.h"

extern "C" {
    void fir(data_t* y, data_t x) {
#pragma HLS pipeline II = 1

        coef_t c[N / 2 + 1] = { 53, 0, -91, 0, 313, 500 };
        static data_t shift_reg[N];
        acc_t acc = 0;
        int i;


        for (i = N - 1; i > 0; i--) {
            shift_reg[i] = shift_reg[i - 1];
        }
        shift_reg[0] = x;  

     
        for (i = 0; i < N / 2; i++) {
            acc += c[i] * (shift_reg[i] + shift_reg[N - 1 - i]);
        }

        if (N % 2 != 0) {
            acc += c[N / 2] * shift_reg[N / 2];
        }

        *y = acc; 
    }
}
