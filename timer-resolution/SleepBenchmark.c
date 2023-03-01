#include <time.h>
#include <windows.h>
#define printf __builtin_printf

LONG NtQueryTimerResolution(PULONG MinimumResolution, PULONG MaximumResolution, PULONG CurrentResolution);

int main() {
    LONG min_res, max_res, current_res;
    LARGE_INTEGER start, end, elapsed, freq;

    QueryPerformanceFrequency(&freq);

    for (;;) {
        // get current resolution
        if (NtQueryTimerResolution(&max_res, &min_res, &current_res) != 0) {
            printf("NtQueryTimerResolution failed");
            return 1;
        }

        // benchmark Sleep(1)
        QueryPerformanceCounter(&start);
        Sleep(1);
        QueryPerformanceCounter(&end);

        double delta_s = (double)(end.QuadPart - start.QuadPart) / freq.QuadPart;
        double delta_ms = delta_s * 1000;

        printf("Resolution: %lfms, Sleep(1) slept %lfms (delta: %lf)\n",
               current_res / 10000.0, delta_ms, delta_ms - 1);

        Sleep(1000); // pause for a second between iterations
    }
}