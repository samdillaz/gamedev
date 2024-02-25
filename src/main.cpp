extern "C" {
    #include <tinyPTC/incl/tinyptc.h>
}
#include <cstdint>

using namespace std;

uint32_t screen[640 * 360];

constexpr uint32_t kR = 0x00FF0000;
constexpr uint32_t kG = 0x0000FF00;
constexpr uint32_t kB = 0x000000FF;

constexpr uint32_t sprite[8 * 8] = {
    kG,kG,kG,kG,kG,kG,kG,kG,
    kG,kB,kR,kR,kR,kR,kB,kG,
    kG,kB,kR,kG,kG,kG,kB,kG,
    kG,kB,kB,kR,kG,kG,kB,kG,
    kG,kB,kB,kB,kR,kG,kB,kG,
    kG,kB,kB,kB,kB,kR,kB,kG,
    kG,kB,kR,kR,kR,kR,kB,kG,
    kG,kG,kG,kG,kG,kG,kG,kG,
};

int main(){
    ptc_open("window", 640, 360);

    for(;;){
        for(uint32_t i = 0; i < 640 * 360; ++i)
            screen[i] = kR;

        uint32_t *pscr = screen;
        const uint32_t *psp = sprite;
        
        for(uint32_t i = 0; i < 8; ++i){
            for(uint32_t j = 0; j < 8; j++){
                *pscr = *psp;
                ++pscr;
                ++psp;
            }
            pscr += 640 - 8;
        }

        ptc_update(screen);
    }

    ptc_close();

    return 0;
}