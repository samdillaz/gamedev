extern "C" {
    #include <tinyPTC/incl/tinyptc.h>
}
#include <cstdint>
#include <iostream>
#include <memory>

uint32_t* screen {nullptr};

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

constexpr int kSCRWIDTH {640};
constexpr int kSCRHEIGHT {480};

void execute() {
    ptc_open("window", kSCRWIDTH, kSCRHEIGHT);

    auto screen = std::make_unique<uint32_t[]>(kSCRWIDTH * kSCRHEIGHT);

    while(!ptc_process_events()){
        for(uint32_t i = 0; i < kSCRWIDTH * kSCRHEIGHT; ++i)
            screen[i] = kR;

        uint32_t *pscr = screen.get();
        const uint32_t *psp = sprite;
        
        for(uint32_t i = 0; i < 8; ++i){
            for(uint32_t j = 0; j < 8; j++){
                *pscr = *psp;
                ++pscr;
                ++psp;
            }
            pscr += kSCRWIDTH - 8;
        }

        ptc_update(screen.get());
    }

    ptc_close();
}


int main(){
    try {
        execute();
    } catch(...) {
        std::cout << "Capturada\n";
    }

    return 0;
}