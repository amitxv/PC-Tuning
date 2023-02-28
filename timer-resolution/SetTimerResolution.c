#include <windows.h>
#define printf __builtin_printf

#define PROCESS_POWER_THROTTLING_CURRENT_VERSION 1
#define PROCESS_POWER_THROTTLING_IGNORE_TIMER_RESOLUTION 0x4

LONG NtQueryTimerResolution(PULONG MinimumResolution, PULONG MaximumResolution, PULONG CurrentResolution);
LONG NtSetTimerResolution(ULONG DesiredResolution, BOOL SetResolution, PULONG CurrentResolution);

typedef struct _PROCESS_POWER_THROTTLING_STATE {
    ULONG Version;
    ULONG ControlMask;
    ULONG StateMask;
} PROCESS_POWER_THROTTLING_STATE, *PPROCESS_POWER_THROTTLING_STATE;

int main() {
    LONG min_res, max_res, current_res;
    PROCESS_POWER_THROTTLING_STATE PowerThrottling;

    RtlZeroMemory(&PowerThrottling, sizeof(PowerThrottling));
    PowerThrottling.Version = PROCESS_POWER_THROTTLING_CURRENT_VERSION;

    PowerThrottling.ControlMask = PROCESS_POWER_THROTTLING_IGNORE_TIMER_RESOLUTION;
    PowerThrottling.StateMask = 0;

    SetProcessInformation(GetCurrentProcess(),
                          ProcessPowerThrottling,
                          &PowerThrottling,
                          sizeof(PowerThrottling));

    NtQueryTimerResolution(&max_res, &min_res, &current_res);

    LONG err = NtSetTimerResolution(5000, 1, &current_res);

    if (err != 0) {
        MessageBox(
            NULL,
            "NtSetTimerResolution failed",
            "SetTimerResolution",
            MB_ICONWARNING);
        return 1;
    }

    printf("Resolution set to: %lums", current_res);
    Sleep(INFINITE);
}
