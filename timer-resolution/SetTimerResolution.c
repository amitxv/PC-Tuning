/* 
Compile using GCC or your favorite compiler.
GCC: gcc SetTimerResolution.c -lntdll -o SetTimerResolution.c
*/

#include <windows.h>
#define printf __builtin_printf

#define PROCESS_POWER_THROTTLING_CURRENT_VERSION 1
#define PROCESS_POWER_THROTTLING_IGNORE_TIMER_RESOLUTION 0x4

LONG NtQueryTimerResolution(PULONG MinimumResolution, PULONG MaximumResolution, PULONG CurrentResolution);
LONG NtSetTimerResolution(ULONG DesiredResolution, BOOL SetResolution, PULONG CurrentResolution);

int main()
{
    LONG min_res, max_res, current_res;
    const struct
    {
        const ULONG
            Version,
            ControlMask,
            StateMask;
    } PowerThrottling = {
        .Version = PROCESS_POWER_THROTTLING_CURRENT_VERSION,
        .ControlMask = PROCESS_POWER_THROTTLING_IGNORE_TIMER_RESOLUTION,
        .StateMask = 0};

    // Hide Console
    // FreeConsole();

    SetProcessInformation(GetCurrentProcess(),
                          ProcessPowerThrottling,
                          &PowerThrottling,
                          sizeof(PowerThrottling));

    if (NtQueryTimerResolution(&max_res, &min_res, &current_res) ||
        NtSetTimerResolution(min_res, 1, &current_res))
    {
        printf(L"NtQueryTimerResolution failed.\n");
        return 1;
    };

    printf("Resolution set to: %lums.\n", current_res);
    Sleep(INFINITE);
    return 0;
}
